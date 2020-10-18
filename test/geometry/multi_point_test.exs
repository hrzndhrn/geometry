defmodule Geometry.MultiPointTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{MultiPoint, Point}

  doctest Geometry.MultiPoint, import: true

  @moduletag :multi_point

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiPoint.to_geo_json(
          MultiPoint.new([
            Point.new(-1.1, -2.2),
            Point.new(1.1, 2.2)
          ])
        )

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiPoint"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [-1.1, -2.2],
               [1.1, 2.2]
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
               [1.1, 1.2],
               [20.1, 20.2]
             ]
           }
        """)

      assert MultiPoint.from_geo_json!(geo_json) ==
               %MultiPoint{
                 points:
                   MapSet.new([
                     %Point{x: 1.1, y: 1.2},
                     %Point{x: 20.1, y: 20.2}
                   ])
               }
    end

    test "raises an error for an invalid geo_json" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiPoint.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiPoint" do
      assert MultiPoint.to_wkt(MultiPoint.new()) ==
               "MultiPoint EMPTY"
    end

    test "returns wkt for a MultiPoint" do
      assert MultiPoint.to_wkt(
               MultiPoint.new([
                 Point.new(7.1, 8.1),
                 Point.new(9.2, 5.2)
               ])
             ) ==
               "MultiPoint (7.1 8.1, 9.2 5.2)"
    end

    test "return WKT for a MultiPoint with SRID" do
      assert MultiPoint.to_wkt(
               MultiPoint.new([
                 Point.new(7.1, 8.1),
                 Point.new(9.2, 5.2)
               ]),
               srid: 123
             ) ==
               "SRID=123;MultiPoint (7.1 8.1, 9.2 5.2)"
    end
  end

  describe "from_wkb/1" do
    test "returns a MultiPoint (xdr)" do
      wkb = """
      00\
      00000004\
      00000003\
      00\
      00000001\
      403E0000000000004024000000000000\
      00\
      00000001\
      40440000000000004044000000000000\
      00\
      00000001\
      40340000000000004044000000000000\
      """

      multi_point = %MultiPoint{
        points:
          MapSet.new([
            %Point{x: 30.0, y: 10.0},
            %Point{x: 20.0, y: 40.0},
            %Point{x: 40.0, y: 40.0}
          ])
      }

      assert MultiPoint.from_wkb(wkb) == {:ok, multi_point}
    end

    test "returns an empty MultiPoint (xdr)" do
      wkb = """
      00\
      00000004\
      00000000\
      """

      assert MultiPoint.from_wkb(wkb) == {:ok, %MultiPoint{}}
    end

    test "returns an empty MultiPoint (ndr)" do
      wkb = """
      01\
      04000000\
      00000000\
      """

      assert MultiPoint.from_wkb(wkb) == {:ok, %MultiPoint{}}
    end
  end

  describe "from_wkb!/1" do
    test "returns a MultiPoint (xdr)" do
      wkb = """
      00\
      00000004\
      00000003\
      00\
      00000001\
      403E0000000000004024000000000000\
      00\
      00000001\
      40440000000000004044000000000000\
      00\
      00000001\
      40340000000000004044000000000000\
      """

      multi_point = %MultiPoint{
        points:
          MapSet.new([
            %Point{x: 30.0, y: 10.0},
            %Point{x: 20.0, y: 40.0},
            %Point{x: 40.0, y: 40.0}
          ])
      }

      assert MultiPoint.from_wkb!(wkb) == multi_point
    end

    test "returns a MultiPoint with srid (ndr)" do
      wkb = """
      01\
      04000020\
      0F270000\
      01000000\
      01\
      01000000\
      0000000000003E400000000000002440\
      """

      multi_point = %MultiPoint{
        points: MapSet.new([%Point{x: 30.0, y: 10.0}])
      }

      assert MultiPoint.from_wkb!(wkb) == {multi_point, 9999}
    end

    test "raises an error for an invalid WKB" do
      message = "expected endian flag '00' or '01', got 'F0', at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiPoint.from_wkb!("F00")
      end
    end
  end

  describe "to_wkb/1" do
    test "returns WKB for MultiPoint (xdr)" do
      wkb_start = "0000000004000000030000000001"

      multi_point = %MultiPoint{
        points:
          MapSet.new([
            %Point{x: 30.0, y: 10.0},
            %Point{x: 20.0, y: 40.0},
            %Point{x: 40.0, y: 40.0}
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiPoint.to_wkb(multi_point, endian: :xdr)
      assert String.starts_with?(result, wkb_start)
      assert MultiPoint.from_wkb!(result) == multi_point
    end

    test "returns WKB for MultiPoint with srid (ndr)" do
      wkb = """
      01\
      04000020\
      0F270000\
      01000000\
      01\
      01000000\
      0000000000003E400000000000002440\
      """

      multi_point = %MultiPoint{
        points: MapSet.new([%Point{x: 30.0, y: 10.0}])
      }

      assert MultiPoint.to_wkb(multi_point, srid: 9999) == wkb
    end

    test "returns a WKB for an empty MultiPoint (xdr)" do
      wkb = """
      00\
      00000004\
      00000000\
      """

      assert MultiPoint.to_wkb(%MultiPoint{}, endian: :xdr) == wkb
    end

    test "returns a WKB fro an empty MultiPoint (ndr)" do
      wkb = """
      01\
      04000000\
      00000000\
      """

      assert MultiPoint.to_wkb(%MultiPoint{}) == wkb
    end
  end

  describe "from_wkt!/1" do
    test "returns a MultiPoint" do
      assert MultiPoint.from_wkt!("MultiPoint (-5.1 7.8, 0.1 0.2)") ==
               %MultiPoint{
                 points:
                   MapSet.new([
                     %Point{x: -5.1, y: 7.8},
                     %Point{x: 0.1, y: 0.2}
                   ])
               }
    end

    test "returns a MultiPoint with an SRID" do
      assert MultiPoint.from_wkt!("SRID=7219;MultiPoint (-5.1 7.8, 0.1 0.2)") ==
               {%MultiPoint{
                  points:
                    MapSet.new([
                      %Point{x: -5.1, y: 7.8},
                      %Point{x: 0.1, y: 0.2}
                    ])
                }, 7219}
    end

    test "raises an error for an invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Goofy'"

      assert_raise Geometry.Error, message, fn ->
        MultiPoint.from_wkt!("Goofy")
      end
    end
  end

  test "Enum.slice/3" do
    multi_point =
      MultiPoint.new([
        Point.new(-1.1, -2.2),
        Point.new(1.1, 2.2)
      ])

    assert [%Point{}] = Enum.slice(multi_point, 0, 1)
  end
end
