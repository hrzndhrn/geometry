defmodule Geometry.LineStringZTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case

  import Prove

  alias Geometry.{LineStringZ, PointZ}

  doctest Geometry.LineStringZ, import: true

  @moduletag :line_string

  describe "new/0:" do
    prove LineStringZ.new() == %LineStringZ{points: []}
  end

  describe "new/1:" do
    @line_string %LineStringZ{
      points: [%PointZ{x: 1, y: 1, z: 1}, %PointZ{x: 2, y: 2, z: 2}]
    }

    prove LineStringZ.new([PointZ.new(1, 1, 1), PointZ.new(2, 2, 2)]) == @line_string
    prove LineStringZ.new([]) == %LineStringZ{points: []}
    prove LineStringZ.new() == %LineStringZ{points: []}
  end

  describe "new/1" do
    test "raises an error for an invalid list" do
      assert_raise FunctionClauseError, fn ->
        LineStringZ.new([PointZ.new(1, 1, 1)])
      end
    end
  end

  describe "from_coordinates/1:" do
    @line_string %LineStringZ{
      points: [%PointZ{x: 1, y: 1, z: 1}, %PointZ{x: 2, y: 2, z: 2}]
    }

    prove LineStringZ.from_coordinates([{1, 1, 1}, {2, 2, 2}]) == @line_string
  end

  describe "to_wkt/2:" do
    @line_string LineStringZ.new([
                   PointZ.new(1.1, 1.2, 1.3),
                   PointZ.new(2.1, 2.2, 2.3),
                   PointZ.new(3.1, 3.2, 3.3)
                 ])

    prove LineStringZ.to_wkt(@line_string) ==
            "LineString Z (1.1 1.2 1.3, 2.1 2.2 2.3, 3.1 3.2 3.3)"

    prove LineStringZ.to_wkt(@line_string, srid: 678) ==
            "SRID=678;LineString Z (1.1 1.2 1.3, 2.1 2.2 2.3, 3.1 3.2 3.3)"

    prove LineStringZ.to_wkt(LineStringZ.new()) == "LineString Z EMPTY"
  end

  describe "from_wkt/1:" do
    prove LineStringZ.from_wkt("LineString Z empty") == {:ok, %LineStringZ{}}

    prove LineStringZ.from_wkt("LineStringZ (5 4 6, 3.1 -44.5 55)") ==
            {:ok,
             %LineStringZ{
               points: [
                 %PointZ{x: 5, y: 4, z: 6},
                 %PointZ{x: 3.1, y: -44.5, z: 55}
               ]
             }}

    prove LineStringZ.from_wkt("srid=77;LineString Z (1.1 -2.2 3, 5 7 4)") ==
            {:ok,
             %LineStringZ{
               points: [
                 %PointZ{x: 1.1, y: -2.2, z: 3},
                 %PointZ{x: 5, y: 7, z: 4}
               ]
             }, 77}

    prove LineStringZ.from_wkt("Point Z (5 6 7)") ==
            {:error, %{expected: LineStringZ, got: PointZ}}

    prove LineStringZ.from_wkt("SRID=55;Point Z (4 5 6)") ==
            {:error, %{expected: LineStringZ, got: PointZ}}

    prove LineStringZ.from_wkt("linestring XY (5 6)") ==
            {:error, "expected LineString data", "XY (5 6)", {1, 0}, 11}
  end

  describe "from_wkt!/1:" do
    prove LineStringZ.from_wkt!("LineStringZ (5 4 6, 3.1 -44.5 55)") ==
            %LineStringZ{
              points: [
                %PointZ{x: 5, y: 4, z: 6},
                %PointZ{x: 3.1, y: -44.5, z: 55}
              ]
            }

    prove LineStringZ.from_wkt!("srid=77;LineString Z (1.1 -2.2 3, 5 7 4)") ==
            {%LineStringZ{
               points: [
                 %PointZ{x: 1.1, y: -2.2, z: 3},
                 %PointZ{x: 5, y: 7, z: 4}
               ]
             }, 77}

    test "raises an exception" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'foo'"

      assert_raise Geometry.Error, message, fn ->
        LineStringZ.from_wkt!("foo")
      end
    end
  end

  describe "empty?/:" do
    prove LineStringZ.empty?(LineStringZ.new()) == true

    prove LineStringZ.empty?(LineStringZ.from_coordinates([{1, 2, 1}, {3, 4, 1}])) ==
            false
  end

  describe "from_geo_json/1:" do
    prove LineStringZ.from_geo_json(%{}) == {:error, :type_not_found}
  end

  describe "from_geo_json/1" do
    test "with valid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2, 3],[3, 4, 5]]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert LineStringZ.from_geo_json(geo_json) ==
               {:ok,
                %LineStringZ{
                  points: [%PointZ{x: 1, y: 2, z: 3}, %PointZ{x: 3, y: 4, z: 5}]
                }}
    end

    test "with invalid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2], [3, 4, 5]]
        }
        """)

      assert LineStringZ.from_geo_json(geo_json) == {:error, :invalid_data}
    end
  end

  describe "from_geo_json!/1" do
    test "with valid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2, 3],[3, 4, 5]]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert LineStringZ.from_geo_json!(geo_json) ==
               %LineStringZ{
                 points: [%PointZ{x: 1, y: 2, z: 3}, %PointZ{x: 3, y: 4, z: 5}]
               }
    end

    test "raises an exception" do
      geo_json = %{"type" => "foo"}
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        LineStringZ.from_geo_json!(geo_json)
      end
    end
  end

  describe "to_geo_json/1" do
    @line_string %LineStringZ{
      points: [%PointZ{x: 1, y: 2, z: 3}, %PointZ{x: 3, y: 4, z: 5}]
    }

    prove LineStringZ.to_geo_json(@line_string) == %{
            "coordinates" => [[1, 2, 3], [3, 4, 5]],
            "type" => "LineString"
          }

    prove @line_string |> LineStringZ.to_geo_json() |> GeoJsonValidator.valid?() == true
  end

  describe "from_wkb/1" do
    test "returns an ok tuple with LineStringZ" do
      wkb = """
      01\
      02000080\
      02000000\
      9A9999999999F1BF9A999999999901C06666666666660AC0\
      00000000000016406666666666661A40CDCCCCCCCCCC1E40\
      """

      assert LineStringZ.from_wkb(wkb) ==
               {:ok,
                %LineStringZ{
                  points: [
                    %PointZ{x: -1.1, y: -2.2, z: -3.3},
                    %PointZ{x: 5.5, y: 6.6, z: 7.7}
                  ]
                }}
    end

    test "returns an ok tuple with LineStringZ and SRID" do
      wkb = """
      00\
      A0000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC00A666666666666\
      4016000000000000401A666666666666401ECCCCCCCCCCCD\
      """

      assert LineStringZ.from_wkb(wkb) ==
               {:ok,
                %LineStringZ{
                  points: [
                    %PointZ{x: -1.1, y: -2.2, z: -3.3},
                    %PointZ{x: 5.5, y: 6.6, z: 7.7}
                  ]
                }, 77}
    end
  end

  describe "from_wkb!/1" do
    test "returns a LineStringZ" do
      wkb = """
      01\
      02000080\
      02000000\
      9A9999999999F1BF9A999999999901C06666666666660AC0\
      00000000000016406666666666661A40CDCCCCCCCCCC1E40\
      """

      assert LineStringZ.from_wkb!(wkb) ==
               %LineStringZ{
                 points: [
                   %PointZ{x: -1.1, y: -2.2, z: -3.3},
                   %PointZ{x: 5.5, y: 6.6, z: 7.7}
                 ]
               }
    end

    test "returns a LineStringZ and SRID" do
      wkb = """
      00\
      A0000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC00A666666666666\
      4016000000000000401A666666666666401ECCCCCCCCCCCD\
      """

      assert LineStringZ.from_wkb!(wkb) ==
               {
                 %LineStringZ{
                   points: [
                     %PointZ{x: -1.1, y: -2.2, z: -3.3},
                     %PointZ{x: 5.5, y: 6.6, z: 7.7}
                   ]
                 },
                 77
               }
    end

    test "raises an exception" do
      message = "expected endian flag '00' or '01', got 'AB', at position 0"

      assert_raise Geometry.Error, message, fn ->
        LineStringZ.from_wkb!("ABCDEFGH")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns WKB from LineStringZ" do
      wkb = """
      01\
      02000080\
      02000000\
      9A9999999999F1BF9A999999999901C06666666666660AC0\
      00000000000016406666666666661A40CDCCCCCCCCCC1E40\
      """

      assert LineStringZ.to_wkb(%LineStringZ{
               points: [
                 %PointZ{x: -1.1, y: -2.2, z: -3.3},
                 %PointZ{x: 5.5, y: 6.6, z: 7.7}
               ]
             }) == wkb
    end

    test "returns WKB from LineStringZ with SRID" do
      wkb = """
      00\
      A0000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC00A666666666666\
      4016000000000000401A666666666666401ECCCCCCCCCCCD\
      """

      assert LineStringZ.to_wkb(
               %LineStringZ{
                 points: [
                   %PointZ{x: -1.1, y: -2.2, z: -3.3},
                   %PointZ{x: 5.5, y: 6.6, z: 7.7}
                 ]
               },
               endian: :xdr,
               srid: 77
             ) == wkb
    end
  end
end
