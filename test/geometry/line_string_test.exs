defmodule Geometry.LineStringTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{Hex, LineString, Point}

  doctest Geometry.LineString, import: true

  @moduletag :line_string

  describe "new/0:" do
    prove LineString.new() == %LineString{points: []}
  end

  describe "new/1:" do
    prove LineString.new([Point.new(1, 1), Point.new(2, 2)]) == %LineString{
            points: [[1, 1], [2, 2]]
          }

    prove LineString.new([]) == %LineString{points: []}
    prove LineString.new() == %LineString{points: []}
  end

  describe "new/1" do
    test "raises an error for an invalid list" do
      assert_raise FunctionClauseError, fn ->
        LineString.new([Point.new(1, 1)])
      end
    end
  end

  describe "from_coordinates/1:" do
    prove LineString.from_coordinates([[1, 1], [2, 2]]) == %LineString{
            points: [[1, 1], [2, 2]]
          }
  end

  describe "to_wkt/2:" do
    @line_string LineString.new([
                   Point.new(1.1, 1.2),
                   Point.new(2.1, 2.2),
                   Point.new(3.1, 3.2)
                 ])

    prove LineString.to_wkt(@line_string) ==
            "LineString (1.1 1.2, 2.1 2.2, 3.1 3.2)"

    prove LineString.to_wkt(@line_string, srid: 678) ==
            "SRID=678;LineString (1.1 1.2, 2.1 2.2, 3.1 3.2)"

    prove LineString.to_wkt(LineString.new()) == "LineString EMPTY"
  end

  describe "from_wkt/1:" do
    prove LineString.from_wkt("LineString empty") == {:ok, %LineString{}}

    prove LineString.from_wkt("LineString (5 4, 3.1 -44.5)") ==
            {:ok,
             %LineString{
               points: [
                 [5, 4],
                 [3.1, -44.5]
               ]
             }}

    prove LineString.from_wkt("srid=77;LineString (1.1 -2.2, 5 7)") ==
            {:ok,
             %LineString{
               points: [
                 [1.1, -2.2],
                 [5, 7]
               ]
             }, 77}

    prove LineString.from_wkt("Point (5 6)") ==
            {:error, %{expected: LineString, got: Point}}

    prove LineString.from_wkt("SRID=55;Point (4 5)") ==
            {:error, %{expected: LineString, got: Point}}

    prove LineString.from_wkt("linestring XY (5 6)") ==
            {:error, "expected LineString data", "XY (5 6)", {1, 0}, 11}
  end

  describe "from_wkt!/1:" do
    prove LineString.from_wkt!("LineString (5 4, 3.1 -44.5)") ==
            %LineString{
              points: [
                [5, 4],
                [3.1, -44.5]
              ]
            }

    prove LineString.from_wkt!("srid=77;LineString (1.1 -2.2, 5 7)") ==
            {%LineString{
               points: [
                 [1.1, -2.2],
                 [5, 7]
               ]
             }, 77}
  end

  describe "from_wkt!/1" do
    test "raises an exception" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'foo'"

      assert_raise Geometry.Error, message, fn ->
        LineString.from_wkt!("foo")
      end
    end
  end

  describe "empty?/:" do
    prove LineString.empty?(LineString.new()) == true

    prove LineString.empty?(
            LineString.new([Point.new(1, 2), Point.new(1, 2)])
          ) == false
  end

  describe "from_geo_json/1:" do
    prove LineString.from_geo_json(%{}) == {:error, :type_not_found}
  end

  describe "from_geo_json/1" do
    test "with valid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2],[3, 4]]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert LineString.from_geo_json(geo_json) ==
               {:ok,
                %LineString{
                  points: [[1, 2], [3, 4]]
                }}
    end
  end

  describe "from_geo_json!/1" do
    test "with valid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2],[3, 4]]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert LineString.from_geo_json!(geo_json) ==
               %LineString{
                 points: [[1, 2], [3, 4]]
               }
    end

    test "raises an exception" do
      geo_json = %{"type" => "foo"}
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        LineString.from_geo_json!(geo_json)
      end
    end
  end

  describe "to_geo_json/1" do
    test "returns GeoJson-term from LineString" do
      line_string = LineString.new([Point.new(1, 2), Point.new(3, 4)])

      assert result =
               %{"coordinates" => [[1, 2], [3, 4]], "type" => "LineString"} =
               LineString.to_geo_json(line_string)

      assert GeoJsonValidator.valid?(result)
    end
  end

  describe "from_wkb/1" do
    test "returns an ok tuple with LineString" do
      wkb = """
      01\
      02000000\
      02000000\
      9A9999999999F1BF9A999999999901C0\
      00000000000016406666666666661A40\
      """

      assert LineString.from_wkb(wkb) ==
               {:ok,
                %LineString{
                  points: [
                    [-1.1, -2.2],
                    [5.5, 6.6]
                  ]
                }}
    end

    test "returns an ok tuple with LineString and SRID" do
      wkb = """
      00\
      20000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999A\
      4016000000000000401A666666666666\
      """

      assert LineString.from_wkb(wkb) ==
               {:ok,
                %LineString{
                  points: [
                    [-1.1, -2.2],
                    [5.5, 6.6]
                  ]
                }, 77}
    end
  end

  describe "from_wkb!/1" do
    test "returns a LineString" do
      wkb = """
      01\
      02000000\
      02000000\
      9A9999999999F1BF9A999999999901C0\
      00000000000016406666666666661A40\
      """

      assert LineString.from_wkb!(wkb) ==
               %LineString{
                 points: [
                   [-1.1, -2.2],
                   [5.5, 6.6]
                 ]
               }
    end

    test "returns a LineString and SRID" do
      wkb = """
      00\
      20000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999A\
      4016000000000000401A666666666666\
      """

      assert LineString.from_wkb!(wkb) ==
               {
                 %LineString{
                   points: [
                     [-1.1, -2.2],
                     [5.5, 6.6]
                   ]
                 },
                 77
               }
    end

    test "raises an exception" do
      message = "expected endian flag '00' or '01', got 'AB', at position 0"

      assert_raise Geometry.Error, message, fn ->
        LineString.from_wkb!("ABCDEFGH")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns WKB as ndr-string from LineString" do
      wkb = """
      01\
      02000000\
      02000000\
      9A9999999999F1BF9A999999999901C0\
      00000000000016406666666666661A40\
      """

      assert LineString.to_wkb(
               %LineString{
                 points: [
                   [-1.1, -2.2],
                   [5.5, 6.6]
                 ]
               },
               endian: :ndr,
               mode: :hex
             ) == wkb
    end

    test "returns WKB as ndr-binary from LineString" do
      wkb = """
      01\
      02000000\
      02000000\
      9A9999999999F1BF9A999999999901C0\
      00000000000016406666666666661A40\
      """

      assert LineString.to_wkb(
               %LineString{
                 points: [
                   [-1.1, -2.2],
                   [5.5, 6.6]
                 ]
               },
               endian: :ndr
             ) == Hex.to_binary(wkb)
    end

    test "returns WKB as xdr-string from LineString with SRID" do
      wkb = """
      00\
      20000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999A\
      4016000000000000401A666666666666\
      """

      assert LineString.to_wkb(
               %LineString{
                 points: [
                   [-1.1, -2.2],
                   [5.5, 6.6]
                 ]
               },
               srid: 77,
               mode: :hex
             ) == wkb
    end

    test "returns WKB as xdr-binary from LineString with SRID" do
      wkb = """
      00\
      20000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999A\
      4016000000000000401A666666666666\
      """

      assert LineString.to_wkb(
               %LineString{
                 points: [
                   [-1.1, -2.2],
                   [5.5, 6.6]
                 ]
               },
               srid: 77
             ) == Hex.to_binary(wkb)
    end
  end
end
