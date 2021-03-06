defmodule Geometry.MultiPointMTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{Hex, MultiPointM, PointM}

  doctest MultiPointM, import: true

  @moduletag :multi_point

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiPointM.to_geo_json(
          MultiPointM.new([
            PointM.new(-1.1, -2.2, -4.4),
            PointM.new(1.1, 2.2, 4.4)
          ])
        )

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiPoint"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [-1.1, -2.2, -4.4],
               [1.1, 2.2, 4.4]
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
               [1.1, 1.2, 1.4],
               [20.1, 20.2, 20.4]
             ]
           }
        """)

      assert MultiPointM.from_geo_json!(geo_json) ==
               %MultiPointM{
                 points:
                   MapSet.new([
                     [1.1, 1.2, 1.4],
                     [20.1, 20.2, 20.4]
                   ])
               }
    end

    test "raises an error for an invalid geo_json" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiPointM.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiPointM" do
      assert MultiPointM.to_wkt(MultiPointM.new()) ==
               "MultiPoint M EMPTY"
    end

    test "returns wkt for a MultiPointM" do
      assert MultiPointM.to_wkt(
               MultiPointM.new([
                 PointM.new(7.1, 8.1, 1),
                 PointM.new(9.2, 5.2, 2)
               ])
             ) ==
               "MultiPoint M (7.1 8.1 1, 9.2 5.2 2)"
    end

    test "return WKT for a MultiPointM with SRID" do
      assert MultiPointM.to_wkt(
               MultiPointM.new([
                 PointM.new(7.1, 8.1, 1),
                 PointM.new(9.2, 5.2, 2)
               ]),
               srid: 123
             ) ==
               "SRID=123;MultiPoint M (7.1 8.1 1, 9.2 5.2 2)"
    end
  end

  describe "from_wkb/2" do
    test "returns a MultiPointM from xdr-string" do
      wkb = """
      00\
      40000004\
      00000003\
      00\
      40000001\
      403E00000000000040240000000000004024000000000000\
      00\
      40000001\
      40440000000000004044000000000000403E000000000000\
      00\
      40000001\
      403400000000000040440000000000004034000000000000\
      """

      multi_point = %MultiPointM{
        points:
          MapSet.new([
            [30.0, 10.0, 10.0],
            [20.0, 40.0, 20.0],
            [40.0, 40.0, 30.0]
          ])
      }

      assert MultiPointM.from_wkb(wkb, :hex) == {:ok, multi_point}
    end

    test "returns a MultiPointM from xdr-binary" do
      wkb = """
      00\
      40000004\
      00000003\
      00\
      40000001\
      403E00000000000040240000000000004024000000000000\
      00\
      40000001\
      40440000000000004044000000000000403E000000000000\
      00\
      40000001\
      403400000000000040440000000000004034000000000000\
      """

      multi_point = %MultiPointM{
        points:
          MapSet.new([
            [30.0, 10.0, 10.0],
            [20.0, 40.0, 20.0],
            [40.0, 40.0, 30.0]
          ])
      }

      assert wkb |> Hex.to_binary() |> MultiPointM.from_wkb() == {:ok, multi_point}
    end

    test "returns an empty MultiPointM from xdr-string" do
      wkb = """
      00\
      40000004\
      00000000\
      """

      assert MultiPointM.from_wkb(wkb, :hex) == {:ok, %MultiPointM{}}
    end

    test "returns an empty MultiPointM from ndr-string" do
      wkb = """
      01\
      04000040\
      00000000\
      """

      assert MultiPointM.from_wkb(wkb, :hex) == {:ok, %MultiPointM{}}
    end

    test "returns an empty MultiPointM from xdr-binary" do
      wkb = """
      00\
      40000004\
      00000000\
      """

      assert wkb |> Hex.to_binary() |> MultiPointM.from_wkb() == {:ok, %MultiPointM{}}
    end

    test "returns an empty MultiPointM ndr-binary" do
      wkb = """
      01\
      04000040\
      00000000\
      """

      assert wkb |> Hex.to_binary() |> MultiPointM.from_wkb() == {:ok, %MultiPointM{}}
    end
  end

  describe "from_wkb!/2" do
    test "returns a MultiPointM from xdr-string" do
      wkb = """
      00\
      40000004\
      00000003\
      00\
      40000001\
      403E00000000000040240000000000004024000000000000\
      00\
      40000001\
      40440000000000004044000000000000403E000000000000\
      00\
      40000001\
      403400000000000040440000000000004034000000000000\
      """

      multi_point = %MultiPointM{
        points:
          MapSet.new([
            [30.0, 10.0, 10.0],
            [20.0, 40.0, 20.0],
            [40.0, 40.0, 30.0]
          ])
      }

      assert MultiPointM.from_wkb!(wkb, :hex) == multi_point
    end

    test "returns a MultiPointM from xdr-binary" do
      wkb = """
      00\
      40000004\
      00000003\
      00\
      40000001\
      403E00000000000040240000000000004024000000000000\
      00\
      40000001\
      40440000000000004044000000000000403E000000000000\
      00\
      40000001\
      403400000000000040440000000000004034000000000000\
      """

      multi_point = %MultiPointM{
        points:
          MapSet.new([
            [30.0, 10.0, 10.0],
            [20.0, 40.0, 20.0],
            [40.0, 40.0, 30.0]
          ])
      }

      assert wkb |> Hex.to_binary() |> MultiPointM.from_wkb!() == multi_point
    end

    test "returns a MultiPointM with srid from ndr-string" do
      wkb = """
      01\
      04000060\
      0F270000\
      01000000\
      01\
      01000040\
      0000000000003E4000000000000024400000000000002440\
      """

      multi_point = %MultiPointM{
        points: MapSet.new([[30.0, 10.0, 10.0]])
      }

      assert MultiPointM.from_wkb!(wkb, :hex) == {multi_point, 9999}
    end

    test "returns a MultiPointM with srid from ndr-binary" do
      wkb = """
      01\
      04000060\
      0F270000\
      01000000\
      01\
      01000040\
      0000000000003E4000000000000024400000000000002440\
      """

      multi_point = %MultiPointM{
        points: MapSet.new([[30.0, 10.0, 10.0]])
      }

      assert wkb |> Hex.to_binary() |> MultiPointM.from_wkb!() == {multi_point, 9999}
    end

    test "raises an error for an invalid WKB string" do
      message = ~s(expected endian flag "00" or "01", got "F0", at position 0)

      assert_raise Geometry.Error, message, fn ->
        MultiPointM.from_wkb!("F00", :hex)
      end
    end

    test "raises an error for an invalid WKB binary" do
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiPointM.from_wkb!("F00")
      end
    end
  end

  describe "to_wkb/1" do
    test "returns WKB as xdr-binary for MultiPointM" do
      wkb_start = "0040000004000000030040000001"

      multi_point = %MultiPointM{
        points:
          MapSet.new([
            [30.0, 10.0, 10.0],
            [20.0, 40.0, 20.0],
            [40.0, 40.0, 30.0]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiPointM.to_wkb(multi_point, endian: :xdr)
      assert String.starts_with?(result, Hex.to_binary(wkb_start))
      assert MultiPointM.from_wkb!(result) == multi_point
    end

    test "returns WKB as xdr-string for MultiPointM" do
      wkb_start = "0040000004000000030040000001"

      multi_point = %MultiPointM{
        points:
          MapSet.new([
            [30.0, 10.0, 10.0],
            [20.0, 40.0, 20.0],
            [40.0, 40.0, 30.0]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiPointM.to_wkb(multi_point, endian: :xdr, mode: :hex)
      assert String.starts_with?(result, wkb_start)
      assert MultiPointM.from_wkb!(result, :hex) == multi_point
    end

    test "returns WKB as ndr-binary for MultiPointM with srid" do
      wkb = """
      01\
      04000060\
      0F270000\
      01000000\
      01\
      01000040\
      0000000000003E4000000000000024400000000000002440\
      """

      multi_point = %MultiPointM{
        points: MapSet.new([[30.0, 10.0, 10.0]])
      }

      assert MultiPointM.to_wkb(multi_point, srid: 9999, endian: :ndr) == Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string for MultiPointM with srid" do
      wkb = """
      01\
      04000060\
      0F270000\
      01000000\
      01\
      01000040\
      0000000000003E4000000000000024400000000000002440\
      """

      multi_point = %MultiPointM{
        points: MapSet.new([[30.0, 10.0, 10.0]])
      }

      assert MultiPointM.to_wkb(multi_point, srid: 9999, endian: :ndr, mode: :hex) == wkb
    end

    test "returns a WKB as xdr-binary for an empty MultiPointM" do
      wkb = """
      00\
      40000004\
      00000000\
      """

      assert MultiPointM.to_wkb(%MultiPointM{}, endian: :xdr) == Hex.to_binary(wkb)
    end

    test "returns a WKB as xdr-string for an empty MultiPointM" do
      wkb = """
      00\
      40000004\
      00000000\
      """

      assert MultiPointM.to_wkb(%MultiPointM{}, endian: :xdr, mode: :hex) == wkb
    end

    test "returns a WKB as ndr-binary from an empty MultiPointM" do
      wkb = """
      01\
      04000040\
      00000000\
      """

      assert MultiPointM.to_wkb(%MultiPointM{}, endian: :ndr) == Hex.to_binary(wkb)
    end

    test "returns a WKB as ndr-string from an empty MultiPointM" do
      wkb = """
      01\
      04000040\
      00000000\
      """

      assert MultiPointM.to_wkb(%MultiPointM{}, endian: :ndr, mode: :hex) == wkb
    end

    test "returns WKB xdr-string from a MultiPointM with SRID" do
      wkb = """
      00\
      60000004\
      0000270F\
      00000001\
      00\
      40000001\
      C051C4217D2849CB404524D8EC95BFF040149DB22D0E5604\
      """

      multi_point =
        MultiPointM.new([
          PointM.new(-71.064544, 42.28787, 5.154)
        ])

      assert MultiPointM.to_wkb(multi_point, srid: 9999, mode: :hex) == wkb
    end

    test "returns WKB xdr-binary from a MultiPointM with SRID" do
      wkb = """
      00\
      60000004\
      0000270F\
      00000001\
      00\
      40000001\
      C051C4217D2849CB404524D8EC95BFF040149DB22D0E5604\
      """

      multi_point =
        MultiPointM.new([
          PointM.new(-71.064544, 42.28787, 5.154)
        ])

      assert MultiPointM.to_wkb(multi_point, srid: 9999) == Hex.to_binary(wkb)
    end
  end

  describe "from_wkt!/1" do
    test "returns a MultiPointM" do
      assert MultiPointM.from_wkt!("MultiPoint M (-5.1 7.8 1, 0.1 0.2 2)") ==
               %MultiPointM{
                 points:
                   MapSet.new([
                     [-5.1, 7.8, 1],
                     [0.1, 0.2, 2]
                   ])
               }
    end

    test "returns a MultiPointM with an SRID" do
      assert MultiPointM.from_wkt!("SRID=7219;MultiPoint M (-5.1 7.8 1, 0.1 0.2 2)") ==
               {%MultiPointM{
                  points:
                    MapSet.new([
                      [-5.1, 7.8, 1],
                      [0.1, 0.2, 2]
                    ])
                }, 7219}
    end

    test "raises an error for an invalid WKT" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "Goofy")

      assert_raise Geometry.Error, message, fn ->
        MultiPointM.from_wkt!("Goofy")
      end
    end
  end

  test "Enum.slice/3" do
    multi_point =
      MultiPointM.new([
        PointM.new(-1.1, -2.2, -4.4),
        PointM.new(1.1, 2.2, 4.4)
      ])

    assert [_point] = Enum.slice(multi_point, 0, 1)
  end
end
