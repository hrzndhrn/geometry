defmodule Geometry.MultiLineStringZTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{LineStringZ, MultiLineStringZ, PointZ}

  doctest Geometry.MultiLineStringZ, import: true

  @moduletag :multi_line_string

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiLineStringZ.to_geo_json(
          MultiLineStringZ.from_coordinates([
            [{-1, 1, 1}, {2, 2, 2}, {-3, 3, 3}],
            [{-10, 10, 10}, {-20, 20, 20}]
          ])
        )

      assert GeoJsonValidator.valid?(geo_json)

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiLineString"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [[-10, 10, 10], [-20, 20, 20]],
               [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]]
             ]
    end
  end

  describe "from_geo_json!/2" do
    test "returns a MultiLineStringZ" do
      geo_json =
        Jason.decode!("""
           {
             "type": "MultiLineString",
             "coordinates": [
               [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
               [[-10, 10, 10], [-20, 20, 20]]
             ]
           }
        """)

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            %LineStringZ{
              points: [
                %PointZ{x: -1, y: 1, z: 1},
                %PointZ{x: 2, y: 2, z: 2},
                %PointZ{x: -3, y: 3, z: 3}
              ]
            },
            %LineStringZ{
              points: [
                %PointZ{x: -10, y: 10, z: 10},
                %PointZ{x: -20, y: 20, z: 20}
              ]
            }
          ])
      }

      assert MultiLineStringZ.from_geo_json!(geo_json) == multi_line_string
    end

    test "raises an error for an invalid geo-json-term" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZ.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiLineStriingZM" do
      assert MultiLineStringZ.to_wkt(MultiLineStringZ.new()) ==
               "MultiLineString Z EMPTY"
    end

    test "returns WKT for a MultiLineStringZ" do
      wkt =
        MultiLineStringZ.to_wkt(
          MultiLineStringZ.new([
            [PointZ.new(7.1, 8.1, 1.1), PointZ.new(9.2, 5.2, 2.2)],
            [PointZ.new(5.5, 9.2, 3.1), PointZ.new(1.2, 3.2, 4.2)]
          ])
        )

      assert String.starts_with?(wkt, "MultiLineString Z")
      assert wkt =~ "(5.5 9.2 3.1, 1.2 3.2 4.2)"
      assert wkt =~ "(7.1 8.1 1.1, 9.2 5.2 2.2)"
    end

    test "returns WKT with SRID for a MultiLineStringZ" do
      wkt =
        MultiLineStringZ.to_wkt(
          MultiLineStringZ.new([
            [PointZ.new(7.1, 8.1, 1.1), PointZ.new(9.2, 5.2, 2.2)],
            [PointZ.new(5.5, 9.2, 3.1), PointZ.new(1.2, 3.2, 4.2)]
          ]),
          srid: 555
        )

      assert String.starts_with?(wkt, "SRID=555;MultiLineString Z")
      assert wkt =~ "(5.5 9.2 3.1, 1.2 3.2 4.2)"
      assert wkt =~ "(7.1 8.1 1.1, 9.2 5.2 2.2)"
    end
  end

  describe "from_wkt!/1" do
    test "returns a LineStringZ" do
      wkt = """
      MultiLineString Z (
        (10 20 10, 20 10 35, 20 40 10),
        (40 30 10, 30 30 25)
      )
      """

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            %LineStringZ{
              points: [
                %PointZ{x: 40, y: 30, z: 10},
                %PointZ{x: 30, y: 30, z: 25}
              ]
            },
            %LineStringZ{
              points: [
                %PointZ{x: 10, y: 20, z: 10},
                %PointZ{x: 20, y: 10, z: 35},
                %PointZ{x: 20, y: 40, z: 10}
              ]
            }
          ])
      }

      assert MultiLineStringZ.from_wkt!(wkt) == multi_line_string
    end

    test "returns a LineStringZ with SRID" do
      wkt = """
      SRID=1234;MultiLineString Z (
        (10 20 10, 20 10 35, 20 40 10),
        (40 30 10, 30 30 25)
      )
      """

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            %LineStringZ{
              points: [
                %PointZ{x: 40, y: 30, z: 10},
                %PointZ{x: 30, y: 30, z: 25}
              ]
            },
            %LineStringZ{
              points: [
                %PointZ{x: 10, y: 20, z: 10},
                %PointZ{x: 20, y: 10, z: 35},
                %PointZ{x: 20, y: 40, z: 10}
              ]
            }
          ])
      }

      assert MultiLineStringZ.from_wkt!(wkt) == {multi_line_string, 1234}
    end

    test "raises an error for an invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Larry'"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZ.from_wkt!("Larry")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns a MultiLineStringZ (xdr)" do
      wkb_start = "0080000005000000020080000002"

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            %LineStringZ{
              points: [
                %PointZ{x: 40.0, y: 40.0, z: 30.0},
                %PointZ{x: 30.0, y: 30.0, z: 40.0}
              ]
            },
            %LineStringZ{
              points: [
                %PointZ{x: 10.0, y: 10.0, z: 20.0},
                %PointZ{x: 20.0, y: 20.0, z: 40.0},
                %PointZ{x: 10.0, y: 40.0, z: 10.0}
              ]
            }
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineStringZ.to_wkb(multi_line_string, endian: :xdr)
      assert String.starts_with?(result, wkb_start)
      assert MultiLineStringZ.from_wkb!(result) == multi_line_string
    end
  end

  describe "from_wkb/1" do
    test "returns a MultiLineStringZ (xdr)" do
      wkb = """
      00\
      80000005\
      00000002\
      00\
      80000002\
      00000003\
      402400000000000040240000000000004034000000000000\
      403400000000000040340000000000004044000000000000\
      402400000000000040440000000000004024000000000000\
      00\
      80000002\
      00000002\
      40440000000000004044000000000000403E000000000000\
      403E000000000000403E0000000000004044000000000000\
      """

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            %LineStringZ{
              points: [
                %PointZ{x: 40.0, y: 40.0, z: 30.0},
                %PointZ{x: 30.0, y: 30.0, z: 40.0}
              ]
            },
            %LineStringZ{
              points: [
                %PointZ{x: 10.0, y: 10.0, z: 20.0},
                %PointZ{x: 20.0, y: 20.0, z: 40.0},
                %PointZ{x: 10.0, y: 40.0, z: 10.0}
              ]
            }
          ])
      }

      assert MultiLineStringZ.from_wkb(wkb) == {:ok, multi_line_string}
    end
  end

  describe "from_wkb!/1" do
    test "returns a MultiLineStringZ (xdr)" do
      wkb = """
      00\
      80000005\
      00000002\
      00\
      80000002\
      00000003\
      402400000000000040240000000000004034000000000000\
      403400000000000040340000000000004044000000000000\
      402400000000000040440000000000004024000000000000\
      00\
      80000002\
      00000002\
      40440000000000004044000000000000403E000000000000\
      403E000000000000403E0000000000004044000000000000\
      """

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            %LineStringZ{
              points: [
                %PointZ{x: 40.0, y: 40.0, z: 30.0},
                %PointZ{x: 30.0, y: 30.0, z: 40.0}
              ]
            },
            %LineStringZ{
              points: [
                %PointZ{x: 10.0, y: 10.0, z: 20.0},
                %PointZ{x: 20.0, y: 20.0, z: 40.0},
                %PointZ{x: 10.0, y: 40.0, z: 10.0}
              ]
            }
          ])
      }

      assert MultiLineStringZ.from_wkb!(wkb) == multi_line_string
    end

    test "raises an error for an invalid WKB" do
      message = "expected endian flag '00' or '01', got 'no', at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZ.from_wkb!("nonono")
      end
    end
  end
end
