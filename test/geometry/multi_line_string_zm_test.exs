defmodule Geometry.MultiLineStringZMTest do
  use ExUnit.Case, async: true

  alias Geometry.{LineStringZM, MultiLineStringZM, PointZM}

  doctest Geometry.MultiLineStringZM, import: true

  @moduletag :multi_line_string

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiLineStringZM.to_geo_json(
          MultiLineStringZM.from_coordinates([
            [{-1, 1, 1, 1}, {2, 2, 2, 2}, {-3, 3, 3, 3}],
            [{-10, 10, 10, 10}, {-20, 20, 20, 20}]
          ])
        )

      assert GeoJsonValidator.valid?(geo_json)

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiLineString"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [[-10, 10, 10, 10], [-20, 20, 20, 20]],
               [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]]
             ]
    end
  end

  describe "from_geo_json!/2" do
    test "returns a MultiLineStringZM" do
      geo_json =
        Jason.decode!("""
           {
             "type": "MultiLineString",
             "coordinates": [
               [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
               [[-10, 10, 10, 10], [-20, 20, 20, 20]]
             ]
           }
        """)

      multi_line_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            %LineStringZM{
              points: [
                %PointZM{x: -1, y: 1, z: 1, m: 1},
                %PointZM{x: 2, y: 2, z: 2, m: 2},
                %PointZM{x: -3, y: 3, z: 3, m: 3}
              ]
            },
            %LineStringZM{
              points: [
                %PointZM{x: -10, y: 10, z: 10, m: 10},
                %PointZM{x: -20, y: 20, z: 20, m: 20}
              ]
            }
          ])
      }

      assert MultiLineStringZM.from_geo_json!(geo_json) == multi_line_string
    end

    test "raises an error for an invalid geo-json-term" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZM.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiLineStriingZM" do
      assert MultiLineStringZM.to_wkt(MultiLineStringZM.new()) ==
               "MultiLineString ZM EMPTY"
    end

    test "returns WKT for a MultiLineStringZM" do
      wkt =
        MultiLineStringZM.to_wkt(
          MultiLineStringZM.new([
            [PointZM.new(7.1, 8.1, 1.1, 1), PointZM.new(9.2, 5.2, 2.2, 2)],
            [PointZM.new(5.5, 9.2, 3.1, 1), PointZM.new(1.2, 3.2, 4.2, 2)]
          ])
        )

      assert String.starts_with?(wkt, "MultiLineString ZM")
      assert wkt =~ "(5.5 9.2 3.1 1, 1.2 3.2 4.2 2)"
      assert wkt =~ "(7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"
    end

    test "returns WKT with SRID for a MultiLineStringZM" do
      wkt =
        MultiLineStringZM.to_wkt(
          MultiLineStringZM.new([
            [PointZM.new(7.1, 8.1, 1.1, 1), PointZM.new(9.2, 5.2, 2.2, 2)],
            [PointZM.new(5.5, 9.2, 3.1, 1), PointZM.new(1.2, 3.2, 4.2, 2)]
          ]),
          srid: 555
        )

      assert String.starts_with?(wkt, "SRID=555;MultiLineString ZM")
      assert wkt =~ "(5.5 9.2 3.1 1, 1.2 3.2 4.2 2)"
      assert wkt =~ "(7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"
    end
  end

  describe "from_wkt!/1" do
    test "returns a LineStringZM" do
      wkt = """
      MultiLineString ZM (
        (10 20 10 45, 20 10 35 15, 20 40 10 15),
        (40 30 10 20, 30 30 25 30)
      )
      """

      multi_line_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            %LineStringZM{
              points: [
                %PointZM{x: 40, y: 30, z: 10, m: 20},
                %PointZM{x: 30, y: 30, z: 25, m: 30}
              ]
            },
            %LineStringZM{
              points: [
                %PointZM{x: 10, y: 20, z: 10, m: 45},
                %PointZM{x: 20, y: 10, z: 35, m: 15},
                %PointZM{x: 20, y: 40, z: 10, m: 15}
              ]
            }
          ])
      }

      assert MultiLineStringZM.from_wkt!(wkt) == multi_line_string
    end

    test "returns a LineStringZM with SRID" do
      wkt = """
      SRID=1234;MultiLineString ZM (
        (10 20 10 45, 20 10 35 15, 20 40 10 15),
        (40 30 10 20, 30 30 25 30)
      )
      """

      multi_line_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            %LineStringZM{
              points: [
                %PointZM{x: 40, y: 30, z: 10, m: 20},
                %PointZM{x: 30, y: 30, z: 25, m: 30}
              ]
            },
            %LineStringZM{
              points: [
                %PointZM{x: 10, y: 20, z: 10, m: 45},
                %PointZM{x: 20, y: 10, z: 35, m: 15},
                %PointZM{x: 20, y: 40, z: 10, m: 15}
              ]
            }
          ])
      }

      assert MultiLineStringZM.from_wkt!(wkt) == {multi_line_string, 1234}
    end

    test "raises an error for an invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Larry'"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZM.from_wkt!("Larry")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns a MultiLineStringZM (xdr)" do
      wkb_start = "00C00000050000000200C0000002"

      multi_line_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            %LineStringZM{
              points: [
                %PointZM{x: 40.0, y: 40.0, z: 30.0, m: 20.0},
                %PointZM{x: 30.0, y: 30.0, z: 40.0, m: 50.0}
              ]
            },
            %LineStringZM{
              points: [
                %PointZM{x: 10.0, y: 10.0, z: 20.0, m: 30.0},
                %PointZM{x: 20.0, y: 20.0, z: 40.0, m: 50.0},
                %PointZM{x: 10.0, y: 40.0, z: 10.0, m: 20.0}
              ]
            }
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineStringZM.to_wkb(multi_line_string, endian: :xdr)
      assert String.starts_with?(result, wkb_start)
      assert MultiLineStringZM.from_wkb!(result) == multi_line_string
    end
  end

  describe "from_wkb/1" do
    test "returns a MultiLineStringZM (xdr)" do
      wkb = """
      00\
      C0000005\
      00000002\
      00\
      C0000002\
      00000003\
      402400000000000040240000000000004034000000000000403E000000000000\
      4034000000000000403400000000000040440000000000004049000000000000\
      4024000000000000404400000000000040240000000000004034000000000000\
      00\
      C0000002\
      00000002\
      40440000000000004044000000000000403E0000000000004034000000000000\
      403E000000000000403E00000000000040440000000000004049000000000000\
      """

      multi_line_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            %LineStringZM{
              points: [
                %PointZM{x: 40.0, y: 40.0, z: 30.0, m: 20.0},
                %PointZM{x: 30.0, y: 30.0, z: 40.0, m: 50.0}
              ]
            },
            %LineStringZM{
              points: [
                %PointZM{x: 10.0, y: 10.0, z: 20.0, m: 30.0},
                %PointZM{x: 20.0, y: 20.0, z: 40.0, m: 50.0},
                %PointZM{x: 10.0, y: 40.0, z: 10.0, m: 20.0}
              ]
            }
          ])
      }

      assert MultiLineStringZM.from_wkb(wkb) == {:ok, multi_line_string}
    end
  end

  describe "from_wkb!/1" do
    test "returns a MultiLineStringZM (xdr)" do
      wkb = """
      00\
      C0000005\
      00000002\
      00\
      C0000002\
      00000003\
      402400000000000040240000000000004034000000000000403E000000000000\
      4034000000000000403400000000000040440000000000004049000000000000\
      4024000000000000404400000000000040240000000000004034000000000000\
      00\
      C0000002\
      00000002\
      40440000000000004044000000000000403E0000000000004034000000000000\
      403E000000000000403E00000000000040440000000000004049000000000000\
      """

      multi_line_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            %LineStringZM{
              points: [
                %PointZM{x: 40.0, y: 40.0, z: 30.0, m: 20.0},
                %PointZM{x: 30.0, y: 30.0, z: 40.0, m: 50.0}
              ]
            },
            %LineStringZM{
              points: [
                %PointZM{x: 10.0, y: 10.0, z: 20.0, m: 30.0},
                %PointZM{x: 20.0, y: 20.0, z: 40.0, m: 50.0},
                %PointZM{x: 10.0, y: 40.0, z: 10.0, m: 20.0}
              ]
            }
          ])
      }

      assert MultiLineStringZM.from_wkb!(wkb) == multi_line_string
    end

    test "raises an error for an invalid WKB" do
      message = "expected endian flag '00' or '01', got 'no', at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZM.from_wkb!("nonono")
      end
    end
  end
end
