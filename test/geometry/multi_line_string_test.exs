defmodule Geometry.MultiLineStringTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{LineString, MultiLineString, Point}

  doctest Geometry.MultiLineString, import: true

  @moduletag :multi_line_string

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiLineString.to_geo_json(
          MultiLineString.from_coordinates([
            [{-1, 1}, {2, 2}, {-3, 3}],
            [{-10, 10}, {-20, 20}]
          ])
        )

      assert GeoJsonValidator.valid?(geo_json)

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiLineString"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [[-10, 10], [-20, 20]],
               [[-1, 1], [2, 2], [-3, 3]]
             ]
    end
  end

  describe "from_geo_json!/2" do
    test "returns a MultiLineString" do
      geo_json =
        Jason.decode!("""
           {
             "type": "MultiLineString",
             "coordinates": [
               [[-1, 1], [2, 2], [-3, 3]],
               [[-10, 10], [-20, 20]]
             ]
           }
        """)

      multi_line_string = %MultiLineString{
        line_strings:
          MapSet.new([
            %LineString{
              points: [
                %Point{x: -1, y: 1},
                %Point{x: 2, y: 2},
                %Point{x: -3, y: 3}
              ]
            },
            %LineString{
              points: [
                %Point{x: -10, y: 10},
                %Point{x: -20, y: 20}
              ]
            }
          ])
      }

      assert MultiLineString.from_geo_json!(geo_json) == multi_line_string
    end

    test "raises an error for an invalid geo-json-term" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiLineString.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiLineStriingZM" do
      assert MultiLineString.to_wkt(MultiLineString.new()) ==
               "MultiLineString EMPTY"
    end

    test "returns WKT for a MultiLineString" do
      wkt =
        MultiLineString.to_wkt(
          MultiLineString.new([
            [Point.new(7.1, 8.1), Point.new(9.2, 5.2)],
            [Point.new(5.5, 9.2), Point.new(1.2, 3.2)]
          ])
        )

      assert String.starts_with?(wkt, "MultiLineString")
      assert wkt =~ "(5.5 9.2, 1.2 3.2)"
      assert wkt =~ "(7.1 8.1, 9.2 5.2)"
    end

    test "returns WKT with SRID for a MultiLineString" do
      wkt =
        MultiLineString.to_wkt(
          MultiLineString.new([
            [Point.new(7.1, 8.1), Point.new(9.2, 5.2)],
            [Point.new(5.5, 9.2), Point.new(1.2, 3.2)]
          ]),
          srid: 555
        )

      assert String.starts_with?(wkt, "SRID=555;MultiLineString")
      assert wkt =~ "(5.5 9.2, 1.2 3.2)"
      assert wkt =~ "(7.1 8.1, 9.2 5.2)"
    end
  end

  describe "from_wkt!/1" do
    test "returns a LineString" do
      wkt = """
      MultiLineString (
        (10 20, 20 10, 20 40),
        (40 30, 30 30)
      )
      """

      multi_line_string = %MultiLineString{
        line_strings:
          MapSet.new([
            %LineString{
              points: [
                %Point{x: 40, y: 30},
                %Point{x: 30, y: 30}
              ]
            },
            %LineString{
              points: [
                %Point{x: 10, y: 20},
                %Point{x: 20, y: 10},
                %Point{x: 20, y: 40}
              ]
            }
          ])
      }

      assert MultiLineString.from_wkt!(wkt) == multi_line_string
    end

    test "returns a LineString with SRID" do
      wkt = """
      SRID=1234;MultiLineString (
        (10 20, 20 10, 20 40),
        (40 30, 30 30)
      )
      """

      multi_line_string = %MultiLineString{
        line_strings:
          MapSet.new([
            %LineString{
              points: [
                %Point{x: 40, y: 30},
                %Point{x: 30, y: 30}
              ]
            },
            %LineString{
              points: [
                %Point{x: 10, y: 20},
                %Point{x: 20, y: 10},
                %Point{x: 20, y: 40}
              ]
            }
          ])
      }

      assert MultiLineString.from_wkt!(wkt) == {multi_line_string, 1234}
    end

    test "raises an error for an invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Larry'"

      assert_raise Geometry.Error, message, fn ->
        MultiLineString.from_wkt!("Larry")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns a MultiLineString (xdr)" do
      wkb_start = "0000000005000000020000000002"

      multi_line_string = %MultiLineString{
        line_strings:
          MapSet.new([
            %LineString{
              points: [
                %Point{x: 40.0, y: 40.0},
                %Point{x: 30.0, y: 30.0}
              ]
            },
            %LineString{
              points: [
                %Point{x: 10.0, y: 10.0},
                %Point{x: 20.0, y: 20.0},
                %Point{x: 10.0, y: 40.0}
              ]
            }
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineString.to_wkb(multi_line_string, endian: :xdr)
      assert String.starts_with?(result, wkb_start)
      assert MultiLineString.from_wkb!(result) == multi_line_string
    end
  end

  describe "from_wkb/1" do
    test "returns a MultiLineString (xdr)" do
      wkb = """
      00\
      00000005\
      00000002\
      00\
      00000002\
      00000003\
      40240000000000004024000000000000\
      40340000000000004034000000000000\
      40240000000000004044000000000000\
      00\
      00000002\
      00000002\
      40440000000000004044000000000000\
      403E000000000000403E000000000000\
      """

      multi_line_string = %MultiLineString{
        line_strings:
          MapSet.new([
            %LineString{
              points: [
                %Point{x: 40.0, y: 40.0},
                %Point{x: 30.0, y: 30.0}
              ]
            },
            %LineString{
              points: [
                %Point{x: 10.0, y: 10.0},
                %Point{x: 20.0, y: 20.0},
                %Point{x: 10.0, y: 40.0}
              ]
            }
          ])
      }

      assert MultiLineString.from_wkb(wkb) == {:ok, multi_line_string}
    end
  end

  describe "from_wkb!/1" do
    test "returns a MultiLineString (xdr)" do
      wkb = """
      00\
      00000005\
      00000002\
      00\
      00000002\
      00000003\
      40240000000000004024000000000000\
      40340000000000004034000000000000\
      40240000000000004044000000000000\
      00\
      00000002\
      00000002\
      40440000000000004044000000000000\
      403E000000000000403E000000000000\
      """

      multi_line_string = %MultiLineString{
        line_strings:
          MapSet.new([
            %LineString{
              points: [
                %Point{x: 40.0, y: 40.0},
                %Point{x: 30.0, y: 30.0}
              ]
            },
            %LineString{
              points: [
                %Point{x: 10.0, y: 10.0},
                %Point{x: 20.0, y: 20.0},
                %Point{x: 10.0, y: 40.0}
              ]
            }
          ])
      }

      assert MultiLineString.from_wkb!(wkb) == multi_line_string
    end

    test "raises an error for an invalid WKB" do
      message = "expected endian flag '00' or '01', got 'no', at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiLineString.from_wkb!("nonono")
      end
    end
  end
end
