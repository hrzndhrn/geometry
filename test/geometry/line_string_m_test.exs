defmodule Geometry.LineStringMTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case

  import Prove

  alias Geometry.{LineStringM, PointM}

  doctest Geometry.LineStringM, import: true

  @moduletag :line_string

  describe "new/0:" do
    prove LineStringM.new() == %LineStringM{points: []}
  end

  describe "new/1:" do
    @line_string %LineStringM{
      points: [%PointM{x: 1, y: 1, m: 1}, %PointM{x: 2, y: 2, m: 2}]
    }

    prove LineStringM.new([PointM.new(1, 1, 1), PointM.new(2, 2, 2)]) == @line_string
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
    @line_string %LineStringM{
      points: [%PointM{x: 1, y: 1, m: 1}, %PointM{x: 2, y: 2, m: 2}]
    }

    prove LineStringM.from_coordinates([{1, 1, 1}, {2, 2, 2}]) == @line_string
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
    prove LineStringM.from_wkt("LineStringM (5 4 7, 3.1 -44.5 -1.1)") ==
            {:ok,
             %LineStringM{
               points: [
                 %PointM{x: 5, y: 4, m: 7},
                 %PointM{x: 3.1, y: -44.5, m: -1.1}
               ]
             }}

    prove LineStringM.from_wkt("srid=77;LineString M (1.1 -2.2 5, 5 7 1.1)") ==
            {:ok,
             %LineStringM{
               points: [
                 %PointM{x: 1.1, y: -2.2, m: 5},
                 %PointM{x: 5, y: 7, m: 1.1}
               ]
             }, 77}

    prove LineStringM.from_wkt("Point M (5 6 8)") ==
            {:error, %{expected: LineStringM, got: PointM}}

    prove LineStringM.from_wkt("SRID=55;Point M (4 5 7)") ==
            {:error, %{expected: LineStringM, got: PointM}}

    prove LineStringM.from_wkt("linestring XY (5 6)") ==
            {:error, "expected (", "XY (5 6)", {1, 0}, 11}
  end

  describe "from_wkt!/1:" do
    prove LineStringM.from_wkt!("LineStringM (5 4 7, 3.1 -44.5 -1.1)") ==
            %LineStringM{
              points: [
                %PointM{x: 5, y: 4, m: 7},
                %PointM{x: 3.1, y: -44.5, m: -1.1}
              ]
            }

    prove LineStringM.from_wkt!("srid=77;LineString M (1.1 -2.2 5, 5 7 1.1)") ==
            {%LineStringM{
               points: [
                 %PointM{x: 1.1, y: -2.2, m: 5},
                 %PointM{x: 5, y: 7, m: 1.1}
               ]
             }, 77}

    test "raises an exception" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'foo'"

      assert_raise Geometry.Error, message, fn ->
        LineStringM.from_wkt!("foo")
      end
    end
  end

  describe "empty?/:" do
    prove LineStringM.empty?(LineStringM.new()) == true

    prove LineStringM.empty?(LineStringM.from_coordinates([{1, 2, 4}, {3, 4, 5}])) ==
            false
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
                  points: [%PointM{x: 1, y: 2, m: 4}, %PointM{x: 3, y: 4, m: 6}]
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

      assert LineStringM.from_geo_json(geo_json) == {:error, :invalid_data}
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
                 points: [%PointM{x: 1, y: 2, m: 4}, %PointM{x: 3, y: 4, m: 6}]
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
    @line_string %LineStringM{
      points: [%PointM{x: 1, y: 2, m: 4}, %PointM{x: 3, y: 4, m: 6}]
    }

    prove LineStringM.to_geo_json(@line_string) == %{
            "coordinates" => [[1, 2, 4], [3, 4, 6]],
            "type" => "LineString"
          }

    prove @line_string |> LineStringM.to_geo_json() |> GeoJsonValidator.valid?() == true
  end

  describe "from_wkb/1" do
    test "returns an ok tuple with LineStringM" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert LineStringM.from_wkb(wkb) ==
               {:ok,
                %LineStringM{
                  points: [
                    %PointM{x: -1.1, y: -2.2, m: -4.4},
                    %PointM{x: 5.5, y: 6.6, m: 8.8}
                  ]
                }}
    end

    test "returns an ok tuple with LineStringM and SRID" do
      wkb = """
      00\
      60000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC01199999999999A\
      4016000000000000401A666666666666402199999999999A\
      """

      assert LineStringM.from_wkb(wkb) ==
               {:ok,
                %LineStringM{
                  points: [
                    %PointM{x: -1.1, y: -2.2, m: -4.4},
                    %PointM{x: 5.5, y: 6.6, m: 8.8}
                  ]
                }, 77}
    end
  end

  describe "from_wkb!/1" do
    test "returns a LineStringM" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert LineStringM.from_wkb!(wkb) ==
               %LineStringM{
                 points: [
                   %PointM{x: -1.1, y: -2.2, m: -4.4},
                   %PointM{x: 5.5, y: 6.6, m: 8.8}
                 ]
               }
    end

    test "returns a LineStringM and SRID" do
      wkb = """
      00\
      60000002\
      0000004D\
      00000002\
      BFF199999999999AC00199999999999AC01199999999999A\
      4016000000000000401A666666666666402199999999999A\
      """

      assert LineStringM.from_wkb!(wkb) ==
               {
                 %LineStringM{
                   points: [
                     %PointM{x: -1.1, y: -2.2, m: -4.4},
                     %PointM{x: 5.5, y: 6.6, m: 8.8}
                   ]
                 },
                 77
               }
    end

    test "raises an exception" do
      message = "expected endian flag '00' or '01', got 'AB', at position 0"

      assert_raise Geometry.Error, message, fn ->
        LineStringM.from_wkb!("ABCDEFGH")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns WKB from LineStringM" do
      wkb = """
      01\
      02000040\
      02000000\
      9A9999999999F1BF9A999999999901C09A999999999911C0\
      00000000000016406666666666661A409A99999999992140\
      """

      assert LineStringM.to_wkb(%LineStringM{
               points: [
                 %PointM{x: -1.1, y: -2.2, m: -4.4},
                 %PointM{x: 5.5, y: 6.6, m: 8.8}
               ]
             }) == wkb
    end

    test "returns WKB from LineStringM with SRID" do
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
                   %PointM{x: -1.1, y: -2.2, m: -4.4},
                   %PointM{x: 5.5, y: 6.6, m: 8.8}
                 ]
               },
               endian: :xdr,
               srid: 77
             ) == wkb
    end
  end
end
