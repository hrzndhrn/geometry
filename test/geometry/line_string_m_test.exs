defmodule Geometry.LineStringMTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{Hex, LineStringM, PointM}

  doctest Geometry.LineStringM, import: true

  @moduletag :line_string

  describe "new/0:" do
    prove LineStringM.new() == %LineStringM{points: []}
  end

  describe "new/1:" do
    prove LineStringM.new([PointM.new(1, 1, 1), PointM.new(2, 2, 2)]) == %LineStringM{
            points: [[1, 1, 1], [2, 2, 2]]
          }

    prove LineStringM.new([]) == %LineStringM{points: []}
    prove LineStringM.new() == %LineStringM{points: []}
  end

  describe "new/1" do
    test "raises an error for an invalid list" do
      assert_raise FunctionClauseError, fn ->
        LineStringM.new([PointM.new(1, 1, 1)])
      end
    end
  end

  describe "from_coordinates/1:" do
    prove LineStringM.from_coordinates([[1, 1, 1], [2, 2, 2]]) == %LineStringM{
            points: [[1, 1, 1], [2, 2, 2]]
          }
  end

  describe "to_wkt/2:" do
    @line_string LineStringM.new([
                   PointM.new(1.1, 1.2, 1.4),
                   PointM.new(2.1, 2.2, 2.4),
                   PointM.new(3.1, 3.2, 3.4)
                 ])

    prove LineStringM.to_wkt(@line_string) ==
            "LineString M (1.1 1.2 1.4, 2.1 2.2 2.4, 3.1 3.2 3.4)"

    prove LineStringM.to_wkt(@line_string, srid: 678) ==
            "SRID=678;LineString M (1.1 1.2 1.4, 2.1 2.2 2.4, 3.1 3.2 3.4)"

    prove LineStringM.to_wkt(LineStringM.new()) == "LineString M EMPTY"
  end

  describe "from_wkt/1:" do
    prove LineStringM.from_wkt("LineString M empty") == {:ok, %LineStringM{}}

    prove LineStringM.from_wkt("LineStringM (5 4 7, 3.1 -44.5 -1.1)") ==
            {:ok,
             %LineStringM{
               points: [
                 [5, 4, 7],
                 [3.1, -44.5, -1.1]
               ]
             }}

    prove LineStringM.from_wkt("srid=77;LineString M (1.1 -2.2 5, 5 7 1.1)") ==
            {:ok,
             {
               %LineStringM{
                 points: [
                   [1.1, -2.2, 5],
                   [5, 7, 1.1]
                 ]
               },
               77
             }}

    prove LineStringM.from_wkt("Point M (5 6 8)") ==
            {:error, %{expected: LineStringM, got: PointM}}

    prove LineStringM.from_wkt("SRID=55;Point M (4 5 7)") ==
            {:error, %{expected: LineStringM, got: PointM}}

    prove LineStringM.from_wkt("linestring XY (5 6)") ==
            {:error, "expected LineString data", "XY (5 6)", {1, 0}, 11}
  end

  describe "from_wkt!/1:" do
    prove LineStringM.from_wkt!("LineStringM (5 4 7, 3.1 -44.5 -1.1)") ==
            %LineStringM{
              points: [
                [5, 4, 7],
                [3.1, -44.5, -1.1]
              ]
            }

    prove LineStringM.from_wkt!("srid=77;LineString M (1.1 -2.2 5, 5 7 1.1)") ==
            {%LineStringM{
               points: [
                 [1.1, -2.2, 5],
                 [5, 7, 1.1]
               ]
             }, 77}
  end

  describe "from_wkt!/1" do
    test "raises an exception" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "foo")

      assert_raise Geometry.Error, message, fn ->
        LineStringM.from_wkt!("foo")
      end
    end
  end

  describe "empty?/:" do
    prove LineStringM.empty?(LineStringM.new()) == true

    prove LineStringM.empty?(LineStringM.new([PointM.new(1, 2, 4), PointM.new(1, 2, 4)])) == false
  end

  describe "from_geo_json/1:" do
    prove LineStringM.from_geo_json(%{}) == {:error, :type_not_found}
  end

  describe "from_geo_json/1" do
    test "with valid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2, 4],[3, 4, 6]]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert LineStringM.from_geo_json(geo_json) ==
               {:ok,
                %LineStringM{
                  points: [[1, 2, 4], [3, 4, 6]]
                }}
    end
  end

  describe "from_geo_json!/1" do
    test "with valid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2, 4],[3, 4, 6]]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert LineStringM.from_geo_json!(geo_json) ==
               %LineStringM{
                 points: [[1, 2, 4], [3, 4, 6]]
               }
    end

    test "raises an exception" do
      geo_json = %{"type" => "foo"}
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        LineStringM.from_geo_json!(geo_json)
      end
    end
  end

  describe "to_geo_json/1" do
    test "returns GeoJson-term from LineStringM" do
      line_string = LineStringM.new([PointM.new(1, 2, 4), PointM.new(3, 4, 6)])

      assert result =
               %{"coordinates" => [[1, 2, 4], [3, 4, 6]], "type" => "LineString"} =
               LineStringM.to_geo_json(line_string)

      assert GeoJsonValidator.valid?(result)
    end
  end

  describe "from_wkb/2" do
    test "returns ok tuple with LineStringM from ndr-binary" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert wkb
             |> Hex.to_binary()
             |> LineStringM.from_wkb() ==
               {:ok,
                %LineStringM{
                  points: [
                    [-1.1, -2.2, -4.4],
                    [5.5, 6.6, 8.8]
                  ]
                }}
    end

    test "returns ok tuple with LineStringM from ndr-string" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert LineStringM.from_wkb(wkb, :hex) ==
               {:ok,
                %LineStringM{
                  points: [
                    [-1.1, -2.2, -4.4],
                    [5.5, 6.6, 8.8]
                  ]
                }}
    end

    test "returns an ok tuple with LineStringM and SRID from xdr-string" do
      wkb = """
      00\
      60000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC01199999999999A\
      4016000000000000401A666666666666402199999999999A\
      """

      assert LineStringM.from_wkb(wkb, :hex) ==
               {:ok,
                {
                  %LineStringM{
                    points: [
                      [-1.1, -2.2, -4.4],
                      [5.5, 6.6, 8.8]
                    ]
                  },
                  77
                }}
    end

    test "returns an ok tuple with LineStringM and SRID from xdr-binary" do
      wkb = """
      00\
      60000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC01199999999999A\
      4016000000000000401A666666666666402199999999999A\
      """

      assert wkb |> Hex.to_binary() |> LineStringM.from_wkb() ==
               {:ok,
                {
                  %LineStringM{
                    points: [
                      [-1.1, -2.2, -4.4],
                      [5.5, 6.6, 8.8]
                    ]
                  },
                  77
                }}
    end
  end

  describe "from_wkb!/2" do
    test "returns a LineStringM from ndr-string" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert LineStringM.from_wkb!(wkb, :hex) ==
               %LineStringM{
                 points: [
                   [-1.1, -2.2, -4.4],
                   [5.5, 6.6, 8.8]
                 ]
               }
    end

    test "returns a LineStringM from ndr-binary" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert wkb |> Hex.to_binary() |> LineStringM.from_wkb!() ==
               %LineStringM{
                 points: [
                   [-1.1, -2.2, -4.4],
                   [5.5, 6.6, 8.8]
                 ]
               }
    end

    test "returns a LineStringM and SRID from xdr-string" do
      wkb = """
      00\
      60000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC01199999999999A\
      4016000000000000401A666666666666402199999999999A\
      """

      assert LineStringM.from_wkb!(wkb, :hex) ==
               {
                 %LineStringM{
                   points: [
                     [-1.1, -2.2, -4.4],
                     [5.5, 6.6, 8.8]
                   ]
                 },
                 77
               }
    end

    test "returns a LineStringM and SRID from xdr-binary" do
      wkb = """
      00\
      60000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC01199999999999A\
      4016000000000000401A666666666666402199999999999A\
      """

      assert wkb |> Hex.to_binary() |> LineStringM.from_wkb!() ==
               {
                 %LineStringM{
                   points: [
                     [-1.1, -2.2, -4.4],
                     [5.5, 6.6, 8.8]
                   ]
                 },
                 77
               }
    end

    test "raises an exception for invalid string" do
      message = ~s(expected endian flag "00" or "01", got "AB", at position 0)

      assert_raise Geometry.Error, message, fn ->
        LineStringM.from_wkb!("ABCDEFGH", :hex)
      end
    end

    test "raises an exception for invalid binary" do
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        LineStringM.from_wkb!("ABCDEFGH")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns WKB as ndr-string from LineStringM" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert LineStringM.to_wkb(
               %LineStringM{
                 points: [
                   [-1.1, -2.2, -4.4],
                   [5.5, 6.6, 8.8]
                 ]
               },
               endian: :ndr,
               mode: :hex
             ) == wkb
    end

    test "returns WKB as ndr-binary from LineStringM" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert LineStringM.to_wkb(
               %LineStringM{
                 points: [
                   [-1.1, -2.2, -4.4],
                   [5.5, 6.6, 8.8]
                 ]
               },
               endian: :ndr
             ) == Hex.to_binary(wkb)
    end

    test "returns WKB as xdr-string from LineStringM with SRID" do
      wkb = """
      00\
      60000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC01199999999999A\
      4016000000000000401A666666666666402199999999999A\
      """

      assert LineStringM.to_wkb(
               %LineStringM{
                 points: [
                   [-1.1, -2.2, -4.4],
                   [5.5, 6.6, 8.8]
                 ]
               },
               srid: 77,
               mode: :hex
             ) == wkb
    end

    test "returns WKB as xdr-binary from LineStringM with SRID" do
      wkb = """
      00\
      60000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC01199999999999A\
      4016000000000000401A666666666666402199999999999A\
      """

      assert LineStringM.to_wkb(
               %LineStringM{
                 points: [
                   [-1.1, -2.2, -4.4],
                   [5.5, 6.6, 8.8]
                 ]
               },
               srid: 77
             ) == Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from LineStringM with SRID" do
      wkb = """
      01\
      02000060\
      67120000\
      02000000\
      CB49287D21C451C0F0BF95ECD82445409A9999999999F13F\
      E5D022DBF93E24C0CDCCCCCCCC0C24409A99999999990140\
      """

      line_string =
        LineStringM.new([
          PointM.new(-71.064544, 42.28787, 1.1),
          PointM.new(-10.123, 10.025, 2.2)
        ])

      srid = 4711

      assert LineStringM.to_wkb(line_string, srid: srid, endian: :ndr, mode: :hex) == wkb
    end

    test "returns WKB as ndr-binary from LineStringM with SRID" do
      wkb = """
      01\
      02000060\
      67120000\
      02000000\
      CB49287D21C451C0F0BF95ECD82445409A9999999999F13F\
      E5D022DBF93E24C0CDCCCCCCCC0C24409A99999999990140\
      """

      line_string =
        LineStringM.new([
          PointM.new(-71.064544, 42.28787, 1.1),
          PointM.new(-10.123, 10.025, 2.2)
        ])

      srid = 4711

      assert LineStringM.to_wkb(line_string, srid: srid, endian: :ndr) == Hex.to_binary(wkb)
    end
  end
end
