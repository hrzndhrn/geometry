defmodule Geometry.LineStringZMTest do
  use ExUnit.Case

  import Prove

  alias Geometry.{LineStringZM, PointZM}

  doctest Geometry.LineStringZM, import: true

  @moduletag :line_string

  describe "new/0:" do
    prove LineStringZM.new() == %LineStringZM{points: []}
  end

  describe "new/1:" do
    @line_string %LineStringZM{
      points: [%PointZM{x: 1, y: 1, z: 1, m: 1}, %PointZM{x: 2, y: 2, z: 2, m: 2}]
    }

    prove LineStringZM.new([PointZM.new(1, 1, 1, 1), PointZM.new(2, 2, 2, 2)]) == @line_string
    prove LineStringZM.new([]) == %LineStringZM{points: []}
    prove LineStringZM.new() == %LineStringZM{points: []}
  end

  describe "new/1" do
    test "raises an error for an invalid list" do
      assert_raise FunctionClauseError, fn ->
        LineStringZM.new([PointZM.new(1, 1, 1, 1)])
      end
    end
  end

  describe "from_coordinates/1:" do
    @line_string %LineStringZM{
      points: [%PointZM{x: 1, y: 1, z: 1, m: 1}, %PointZM{x: 2, y: 2, z: 2, m: 2}]
    }

    prove LineStringZM.from_coordinates([{1, 1, 1, 1}, {2, 2, 2, 2}]) == @line_string
  end

  describe "to_wkt/2:" do
    @line_string LineStringZM.new([
                   PointZM.new(1.1, 1.2, 1.3, 1.4),
                   PointZM.new(2.1, 2.2, 2.3, 2.4),
                   PointZM.new(3.1, 3.2, 3.3, 3.4)
                 ])

    prove LineStringZM.to_wkt(@line_string) ==
            "LineString ZM (1.1 1.2 1.3 1.4, 2.1 2.2 2.3 2.4, 3.1 3.2 3.3 3.4)"

    prove LineStringZM.to_wkt(@line_string, srid: 678) ==
            "SRID=678;LineString ZM (1.1 1.2 1.3 1.4, 2.1 2.2 2.3 2.4, 3.1 3.2 3.3 3.4)"

    prove LineStringZM.to_wkt(LineStringZM.new()) == "LineString ZM EMPTY"
  end

  describe "from_wkt/1:" do
    prove LineStringZM.from_wkt("LineString ZM empty") == {:ok, %LineStringZM{}}

    prove LineStringZM.from_wkt("LineStringZM (5 4 6 7, 3.1 -44.5 55 -1.1)") ==
            {:ok,
             %LineStringZM{
               points: [
                 %PointZM{x: 5, y: 4, z: 6, m: 7},
                 %PointZM{x: 3.1, y: -44.5, z: 55, m: -1.1}
               ]
             }}

    prove LineStringZM.from_wkt("srid=77;LineString ZM (1.1 -2.2 3 5, 5 7 4 1.1)") ==
            {:ok,
             %LineStringZM{
               points: [
                 %PointZM{x: 1.1, y: -2.2, z: 3, m: 5},
                 %PointZM{x: 5, y: 7, z: 4, m: 1.1}
               ]
             }, 77}

    prove LineStringZM.from_wkt("Point ZM (5 6 7 8)") ==
            {:error, %{expected: LineStringZM, got: PointZM}}

    prove LineStringZM.from_wkt("SRID=55;Point ZM (4 5 6 7)") ==
            {:error, %{expected: LineStringZM, got: PointZM}}

    prove LineStringZM.from_wkt("linestring XY (5 6)") ==
            {:error, "expected LineString data", "XY (5 6)", {1, 0}, 11}
  end

  describe "from_wkt!/1:" do
    prove LineStringZM.from_wkt!("LineStringZM (5 4 6 7, 3.1 -44.5 55 -1.1)") ==
            %LineStringZM{
              points: [
                %PointZM{x: 5, y: 4, z: 6, m: 7},
                %PointZM{x: 3.1, y: -44.5, z: 55, m: -1.1}
              ]
            }

    prove LineStringZM.from_wkt!("srid=77;LineString ZM (1.1 -2.2 3 5, 5 7 4 1.1)") ==
            {%LineStringZM{
               points: [
                 %PointZM{x: 1.1, y: -2.2, z: 3, m: 5},
                 %PointZM{x: 5, y: 7, z: 4, m: 1.1}
               ]
             }, 77}

    test "raises an exception" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'foo'"

      assert_raise Geometry.Error, message, fn ->
        LineStringZM.from_wkt!("foo")
      end
    end
  end

  describe "empty?/:" do
    prove LineStringZM.empty?(LineStringZM.new()) == true

    prove LineStringZM.empty?(LineStringZM.from_coordinates([{1, 2, 1, 4}, {3, 4, 1, 5}])) ==
            false
  end

  describe "from_geo_json/1:" do
    prove LineStringZM.from_geo_json(%{}) == {:error, :type_not_found}
  end

  describe "from_geo_json/1" do
    test "with valid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2, 3, 4],[3, 4, 5, 6]]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert LineStringZM.from_geo_json(geo_json) ==
               {:ok,
                %LineStringZM{
                  points: [%PointZM{x: 1, y: 2, z: 3, m: 4}, %PointZM{x: 3, y: 4, z: 5, m: 6}]
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

      assert LineStringZM.from_geo_json(geo_json) == {:error, :invalid_data}
    end
  end

  describe "from_geo_json!/1" do
    test "with valid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "LineString",
          "coordinates": [[1, 2, 3, 4],[3, 4, 5, 6]]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert LineStringZM.from_geo_json!(geo_json) ==
               %LineStringZM{
                 points: [%PointZM{x: 1, y: 2, z: 3, m: 4}, %PointZM{x: 3, y: 4, z: 5, m: 6}]
               }
    end

    test "raises an exception" do
      geo_json = %{"type" => "foo"}
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        LineStringZM.from_geo_json!(geo_json)
      end
    end
  end

  describe "to_geo_json/1" do
    @line_string %LineStringZM{
      points: [%PointZM{x: 1, y: 2, z: 3, m: 4}, %PointZM{x: 3, y: 4, z: 5, m: 6}]
    }

    prove LineStringZM.to_geo_json(@line_string) == %{
            "coordinates" => [[1, 2, 3, 4], [3, 4, 5, 6]],
            "type" => "LineString"
          }

    prove @line_string |> LineStringZM.to_geo_json() |> GeoJsonValidator.valid?() == true
  end

  describe "from_wkb/1" do
    test "returns an ok tuple with LineStringZM" do
      wkb = """
      01\
      020000C0\
      02000000\
      9A9999999999F1BF9A999999999901C06666666666660AC09A999999999911C0\
      00000000000016406666666666661A40CDCCCCCCCCCC1E409A99999999992140\
      """

      assert LineStringZM.from_wkb(wkb) ==
               {:ok,
                %LineStringZM{
                  points: [
                    %PointZM{x: -1.1, y: -2.2, z: -3.3, m: -4.4},
                    %PointZM{x: 5.5, y: 6.6, z: 7.7, m: 8.8}
                  ]
                }}
    end

    test "returns an ok tuple with LineStringZM and SRID" do
      wkb = """
      00\
      E0000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC00A666666666666C01199999999999A\
      4016000000000000401A666666666666401ECCCCCCCCCCCD402199999999999A\
      """

      assert LineStringZM.from_wkb(wkb) ==
               {:ok,
                %LineStringZM{
                  points: [
                    %PointZM{x: -1.1, y: -2.2, z: -3.3, m: -4.4},
                    %PointZM{x: 5.5, y: 6.6, z: 7.7, m: 8.8}
                  ]
                }, 77}
    end
  end

  describe "from_wkb!/1" do
    test "returns a LineStringZM" do
      wkb = """
      01\
      020000C0\
      02000000\
      9A9999999999F1BF9A999999999901C06666666666660AC09A999999999911C0\
      00000000000016406666666666661A40CDCCCCCCCCCC1E409A99999999992140\
      """

      assert LineStringZM.from_wkb!(wkb) ==
               %LineStringZM{
                 points: [
                   %PointZM{x: -1.1, y: -2.2, z: -3.3, m: -4.4},
                   %PointZM{x: 5.5, y: 6.6, z: 7.7, m: 8.8}
                 ]
               }
    end

    test "returns a LineStringZM and SRID" do
      wkb = """
      00\
      E0000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC00A666666666666C01199999999999A\
      4016000000000000401A666666666666401ECCCCCCCCCCCD402199999999999A\
      """

      assert LineStringZM.from_wkb!(wkb) ==
               {
                 %LineStringZM{
                   points: [
                     %PointZM{x: -1.1, y: -2.2, z: -3.3, m: -4.4},
                     %PointZM{x: 5.5, y: 6.6, z: 7.7, m: 8.8}
                   ]
                 },
                 77
               }
    end

    test "raises an exception" do
      message = "expected endian flag '00' or '01', got 'AB', at position 0"

      assert_raise Geometry.Error, message, fn ->
        LineStringZM.from_wkb!("ABCDEFGH")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns WKB from LineStringZM" do
      wkb = """
      01\
      020000C0\
      02000000\
      9A9999999999F1BF9A999999999901C06666666666660AC09A999999999911C0\
      00000000000016406666666666661A40CDCCCCCCCCCC1E409A99999999992140\
      """

      assert LineStringZM.to_wkb(%LineStringZM{
               points: [
                 %PointZM{x: -1.1, y: -2.2, z: -3.3, m: -4.4},
                 %PointZM{x: 5.5, y: 6.6, z: 7.7, m: 8.8}
               ]
             }) == wkb
    end

    test "returns WKB from LineStringZM with SRID" do
      wkb = """
      00\
      E0000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC00A666666666666C01199999999999A\
      4016000000000000401A666666666666401ECCCCCCCCCCCD402199999999999A\
      """

      assert LineStringZM.to_wkb(
               %LineStringZM{
                 points: [
                   %PointZM{x: -1.1, y: -2.2, z: -3.3, m: -4.4},
                   %PointZM{x: 5.5, y: 6.6, z: 7.7, m: 8.8}
                 ]
               },
               endian: :xdr,
               srid: 77
             ) == wkb
    end
  end
end
