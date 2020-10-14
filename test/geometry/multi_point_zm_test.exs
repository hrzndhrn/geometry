defmodule Geometry.MultiPointZMTest do
  use ExUnit.Case

  alias Geometry.{MultiPointZM, PointZM}

  doctest Geometry.MultiPointZM, import: true

  @moduletag :multi_point

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiPointZM.to_geo_json(
          MultiPointZM.new([
            PointZM.new(-1.1, -2.2, -3.3, -4.4),
            PointZM.new(1.1, 2.2, 3.3, 4.4)
          ])
        )

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiPoint"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [-1.1, -2.2, -3.3, -4.4],
               [1.1, 2.2, 3.3, 4.4]
             ]
    end
  end

  describe "from_geo_json!/1" do
    test "returns geo-json-term" do
      geo_json =
        Jason.decode!("""
           {
             "type": "MultiPoint",
             "coordinates": [
               [1.1, 1.2, 1.3, 1.4],
               [20.1, 20.2, 20.3, 20.4]
             ]
           }
        """)

      assert MultiPointZM.from_geo_json!(geo_json) ==
               %MultiPointZM{
                 geometries:
                   MapSet.new([
                     %PointZM{x: 1.1, y: 1.2, z: 1.3, m: 1.4},
                     %PointZM{x: 20.1, y: 20.2, z: 20.3, m: 20.4}
                   ])
               }
    end

    test "raises an error for an invalid geo_json" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiPointZM.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiPointZM" do
      assert MultiPointZM.to_wkt(MultiPointZM.new()) ==
               "MultiPoint ZM EMPTY"
    end

    test "returns wkt for a MultiPointZM" do
      assert MultiPointZM.to_wkt(
               MultiPointZM.new([
                 PointZM.new(7.1, 8.1, 1.1, 1),
                 PointZM.new(9.2, 5.2, 2.2, 2)
               ])
             ) ==
               "MultiPoint ZM (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"
    end

    test "return WKT for a MultiPointZM with SRID" do
      assert MultiPointZM.to_wkt(
               MultiPointZM.new([
                 PointZM.new(7.1, 8.1, 1.1, 1),
                 PointZM.new(9.2, 5.2, 2.2, 2)
               ]),
               srid: 123
             ) ==
               "SRID=123;MultiPoint ZM (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"
    end
  end

  describe "from_wkb/1" do
    test "returns a MultiPointZM (xdr)" do
      wkb = """
      00\
      C0000004\
      00000003\
      00\
      C0000001\
      403E0000000000004024000000000000402E0000000000004024000000000000\
      00\
      C0000001\
      404400000000000040440000000000004034000000000000403E000000000000\
      00\
      C0000001\
      40340000000000004044000000000000402E0000000000004034000000000000\
      """

      multi_point = %MultiPointZM{
        geometries:
          MapSet.new([
            %PointZM{x: 30.0, y: 10.0, z: 15.0, m: 10.0},
            %PointZM{x: 20.0, y: 40.0, z: 15.0, m: 20.0},
            %PointZM{x: 40.0, y: 40.0, z: 20.0, m: 30.0}
          ])
      }

      assert MultiPointZM.from_wkb(wkb) == {:ok, multi_point}
    end

    test "returns an empty MultiPointZM (xdr)" do
      wkb = """
      00\
      C0000004\
      00000000\
      """

      assert MultiPointZM.from_wkb(wkb) == {:ok, %MultiPointZM{}}
    end

    test "returns an empty MultiPointZM (ndr)" do
      wkb = """
      01\
      040000C0\
      00000000\
      """

      assert MultiPointZM.from_wkb(wkb) == {:ok, %MultiPointZM{}}
    end
  end

  describe "from_wkb!/1" do
    test "returns a MultiPointZM (xdr)" do
      wkb = """
      00\
      C0000004\
      00000003\
      00\
      C0000001\
      403E0000000000004024000000000000402E0000000000004024000000000000\
      00\
      C0000001\
      404400000000000040440000000000004034000000000000403E000000000000\
      00\
      C0000001\
      40340000000000004044000000000000402E0000000000004034000000000000\
      """

      multi_point = %MultiPointZM{
        geometries:
          MapSet.new([
            %PointZM{x: 30.0, y: 10.0, z: 15.0, m: 10.0},
            %PointZM{x: 20.0, y: 40.0, z: 15.0, m: 20.0},
            %PointZM{x: 40.0, y: 40.0, z: 20.0, m: 30.0}
          ])
      }

      assert MultiPointZM.from_wkb!(wkb) == multi_point
    end

    test "returns a MultiPointZM with srid (ndr)" do
      wkb = """
      01\
      040000E0\
      0F270000\
      01000000\
      01\
      010000C0\
      0000000000003E4000000000000024400000000000002E400000000000002440\
      """

      multi_point = %MultiPointZM{
        geometries: MapSet.new([%PointZM{x: 30.0, y: 10.0, z: 15.0, m: 10.0}])
      }

      assert MultiPointZM.from_wkb!(wkb) == {multi_point, 9999}
    end

    test "raises an error for an invalid WKB" do
      message = "expected endian flag '00' or '01', got 'F0', at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiPointZM.from_wkb!("F00")
      end
    end
  end

  describe "to_wkb/1" do
    test "returns WKB for MultiPointZM (xdr)" do
      wkb_start = "00C00000040000000300C0000001"

      multi_point = %MultiPointZM{
        geometries:
          MapSet.new([
            %PointZM{x: 30.0, y: 10.0, z: 15.0, m: 10.0},
            %PointZM{x: 20.0, y: 40.0, z: 15.0, m: 20.0},
            %PointZM{x: 40.0, y: 40.0, z: 20.0, m: 30.0}
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiPointZM.to_wkb(multi_point, endian: :xdr)
      assert String.starts_with?(result, wkb_start)
      assert MultiPointZM.from_wkb!(result) == multi_point
    end

    test "returns WKB for MultiPointZM with srid (ndr)" do
      wkb = """
      01\
      040000E0\
      0F270000\
      01000000\
      01\
      010000C0\
      0000000000003E4000000000000024400000000000002E400000000000002440\
      """

      multi_point = %MultiPointZM{
        geometries: MapSet.new([%PointZM{x: 30.0, y: 10.0, z: 15.0, m: 10.0}])
      }

      assert MultiPointZM.to_wkb(multi_point, srid: 9999) == wkb
    end

    test "returns a WKB for an empty MultiPointZM (xdr)" do
      wkb = """
      00\
      C0000004\
      00000000\
      """

      assert MultiPointZM.to_wkb(%MultiPointZM{}, endian: :xdr) == wkb
    end

    test "returns a WKB fro an empty MultiPointZM (ndr)" do
      wkb = """
      01\
      040000C0\
      00000000\
      """

      assert MultiPointZM.to_wkb(%MultiPointZM{}) == wkb
    end
  end

  describe "from_wkt!/1" do
    test "returns a MultiPointZM" do
      assert MultiPointZM.from_wkt!("MultiPoint ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)") ==
               %MultiPointZM{
                 geometries:
                   MapSet.new([
                     %PointZM{x: -5.1, y: 7.8, z: 1.1, m: 1},
                     %PointZM{x: 0.1, y: 0.2, z: 2.2, m: 2}
                   ])
               }
    end

    test "returns a MultiPointZM with an SRID" do
      assert MultiPointZM.from_wkt!("SRID=7219;MultiPoint ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)") ==
               {%MultiPointZM{
                  geometries:
                    MapSet.new([
                      %PointZM{x: -5.1, y: 7.8, z: 1.1, m: 1},
                      %PointZM{x: 0.1, y: 0.2, z: 2.2, m: 2}
                    ])
                }, 7219}
    end

    test "raises an error for an invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Goofy'"

      assert_raise Geometry.Error, message, fn ->
        MultiPointZM.from_wkt!("Goofy")
      end
    end
  end
end
