defmodule Geometry.MultiPointZMTest do
  use ExUnit.Case, async: true

  alias Geometry.{Hex, MultiPointZM, PointZM}

  doctest MultiPointZM, import: true

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
                 points:
                   MapSet.new([
                     [1.1, 1.2, 1.3, 1.4],
                     [20.1, 20.2, 20.3, 20.4]
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

  describe "from_wkb/2" do
    test "returns a MultiPointZM from xdr-string" do
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
        points:
          MapSet.new([
            [30.0, 10.0, 15.0, 10.0],
            [20.0, 40.0, 15.0, 20.0],
            [40.0, 40.0, 20.0, 30.0]
          ])
      }

      assert MultiPointZM.from_wkb(wkb, :hex) == {:ok, multi_point}
    end

    test "returns a MultiPointZM from xdr-binary" do
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
        points:
          MapSet.new([
            [30.0, 10.0, 15.0, 10.0],
            [20.0, 40.0, 15.0, 20.0],
            [40.0, 40.0, 20.0, 30.0]
          ])
      }

      assert wkb |> Hex.to_binary() |> MultiPointZM.from_wkb() == {:ok, multi_point}
    end

    test "returns an empty MultiPointZM from xdr-string" do
      wkb = """
      00\
      C0000004\
      00000000\
      """

      assert MultiPointZM.from_wkb(wkb, :hex) == {:ok, %MultiPointZM{}}
    end

    test "returns an empty MultiPointZM from ndr-string" do
      wkb = """
      01\
      040000C0\
      00000000\
      """

      assert MultiPointZM.from_wkb(wkb, :hex) == {:ok, %MultiPointZM{}}
    end

    test "returns an empty MultiPointZM from xdr-binary" do
      wkb = """
      00\
      C0000004\
      00000000\
      """

      assert wkb |> Hex.to_binary() |> MultiPointZM.from_wkb() == {:ok, %MultiPointZM{}}
    end

    test "returns an empty MultiPointZM ndr-binary" do
      wkb = """
      01\
      040000C0\
      00000000\
      """

      assert wkb |> Hex.to_binary() |> MultiPointZM.from_wkb() == {:ok, %MultiPointZM{}}
    end
  end

  describe "from_wkb!/2" do
    test "returns a MultiPointZM from xdr-string" do
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
        points:
          MapSet.new([
            [30.0, 10.0, 15.0, 10.0],
            [20.0, 40.0, 15.0, 20.0],
            [40.0, 40.0, 20.0, 30.0]
          ])
      }

      assert MultiPointZM.from_wkb!(wkb, :hex) == multi_point
    end

    test "returns a MultiPointZM from xdr-binary" do
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
        points:
          MapSet.new([
            [30.0, 10.0, 15.0, 10.0],
            [20.0, 40.0, 15.0, 20.0],
            [40.0, 40.0, 20.0, 30.0]
          ])
      }

      assert wkb |> Hex.to_binary() |> MultiPointZM.from_wkb!() == multi_point
    end

    test "returns a MultiPointZM with srid from ndr-string" do
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
        points: MapSet.new([[30.0, 10.0, 15.0, 10.0]])
      }

      assert MultiPointZM.from_wkb!(wkb, :hex) == {multi_point, 9999}
    end

    test "returns a MultiPointZM with srid from ndr-binary" do
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
        points: MapSet.new([[30.0, 10.0, 15.0, 10.0]])
      }

      assert wkb |> Hex.to_binary() |> MultiPointZM.from_wkb!() == {multi_point, 9999}
    end

    test "raises an error for an invalid WKB string" do
      message = ~s(expected endian flag "00" or "01", got "F0", at position 0)

      assert_raise Geometry.Error, message, fn ->
        MultiPointZM.from_wkb!("F00", :hex)
      end
    end

    test "raises an error for an invalid WKB binary" do
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiPointZM.from_wkb!("F00")
      end
    end
  end

  describe "to_wkb/1" do
    test "returns WKB as xdr-binary for MultiPointZM" do
      wkb_start = "00C00000040000000300C0000001"

      multi_point = %MultiPointZM{
        points:
          MapSet.new([
            [30.0, 10.0, 15.0, 10.0],
            [20.0, 40.0, 15.0, 20.0],
            [40.0, 40.0, 20.0, 30.0]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiPointZM.to_wkb(multi_point, endian: :xdr)
      assert String.starts_with?(result, Hex.to_binary(wkb_start))
      assert MultiPointZM.from_wkb!(result) == multi_point
    end

    test "returns WKB as xdr-string for MultiPointZM" do
      wkb_start = "00C00000040000000300C0000001"

      multi_point = %MultiPointZM{
        points:
          MapSet.new([
            [30.0, 10.0, 15.0, 10.0],
            [20.0, 40.0, 15.0, 20.0],
            [40.0, 40.0, 20.0, 30.0]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiPointZM.to_wkb(multi_point, endian: :xdr, mode: :hex)
      assert String.starts_with?(result, wkb_start)
      assert MultiPointZM.from_wkb!(result, :hex) == multi_point
    end

    test "returns WKB as ndr-binary for MultiPointZM with srid" do
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
        points: MapSet.new([[30.0, 10.0, 15.0, 10.0]])
      }

      assert MultiPointZM.to_wkb(multi_point, srid: 9999, endian: :ndr) == Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string for MultiPointZM with srid" do
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
        points: MapSet.new([[30.0, 10.0, 15.0, 10.0]])
      }

      assert MultiPointZM.to_wkb(multi_point, srid: 9999, endian: :ndr, mode: :hex) == wkb
    end

    test "returns a WKB as xdr-binary for an empty MultiPointZM" do
      wkb = """
      00\
      C0000004\
      00000000\
      """

      assert MultiPointZM.to_wkb(%MultiPointZM{}, endian: :xdr) == Hex.to_binary(wkb)
    end

    test "returns a WKB as xdr-string for an empty MultiPointZM" do
      wkb = """
      00\
      C0000004\
      00000000\
      """

      assert MultiPointZM.to_wkb(%MultiPointZM{}, endian: :xdr, mode: :hex) == wkb
    end

    test "returns a WKB as ndr-binary from an empty MultiPointZM" do
      wkb = """
      01\
      040000C0\
      00000000\
      """

      assert MultiPointZM.to_wkb(%MultiPointZM{}, endian: :ndr) == Hex.to_binary(wkb)
    end

    test "returns a WKB as ndr-string from an empty MultiPointZM" do
      wkb = """
      01\
      040000C0\
      00000000\
      """

      assert MultiPointZM.to_wkb(%MultiPointZM{}, endian: :ndr, mode: :hex) == wkb
    end

    test "returns WKB xdr-string from a MultiPointZM with SRID" do
      wkb = """
      00\
      E0000004\
      0000270F\
      00000001\
      00\
      C0000001\
      C051C4217D2849CB404524D8EC95BFF040265FB15B573EAB40149DB22D0E5604\
      """

      multi_point =
        MultiPointZM.new([
          PointZM.new(-71.064544, 42.28787, 11.1869, 5.154)
        ])

      assert MultiPointZM.to_wkb(multi_point, srid: 9999, mode: :hex) == wkb
    end

    test "returns WKB xdr-binary from a MultiPointZM with SRID" do
      wkb = """
      00\
      E0000004\
      0000270F\
      00000001\
      00\
      C0000001\
      C051C4217D2849CB404524D8EC95BFF040265FB15B573EAB40149DB22D0E5604\
      """

      multi_point =
        MultiPointZM.new([
          PointZM.new(-71.064544, 42.28787, 11.1869, 5.154)
        ])

      assert MultiPointZM.to_wkb(multi_point, srid: 9999) == Hex.to_binary(wkb)
    end
  end

  describe "from_wkt!/1" do
    test "returns a MultiPointZM" do
      assert MultiPointZM.from_wkt!("MultiPoint ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)") ==
               %MultiPointZM{
                 points:
                   MapSet.new([
                     [-5.1, 7.8, 1.1, 1],
                     [0.1, 0.2, 2.2, 2]
                   ])
               }
    end

    test "returns a MultiPointZM with an SRID" do
      assert MultiPointZM.from_wkt!("SRID=7219;MultiPoint ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)") ==
               {%MultiPointZM{
                  points:
                    MapSet.new([
                      [-5.1, 7.8, 1.1, 1],
                      [0.1, 0.2, 2.2, 2]
                    ])
                }, 7219}
    end

    test "raises an error for an invalid WKT" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "Goofy")

      assert_raise Geometry.Error, message, fn ->
        MultiPointZM.from_wkt!("Goofy")
      end
    end
  end

  test "Enum.slice/3" do
    multi_point =
      MultiPointZM.new([
        PointZM.new(-1.1, -2.2, -3.3, -4.4),
        PointZM.new(1.1, 2.2, 3.3, 4.4)
      ])

    assert [_point] = Enum.slice(multi_point, 0, 1)
  end
end
