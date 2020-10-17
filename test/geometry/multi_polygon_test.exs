defmodule Geometry.MultiPolygonTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case

  alias Geometry.{
    MultiPolygon,
    Point,
    Polygon
  }

  doctest Geometry.MultiPolygon, import: true

  @moduletag :multi_plygon

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        [
          [{6, 2}, {8, 2}, {8, 4}, {6, 2}],
          [[{60, 20}, {80, 20}, {80, 40}, {60, 20}]],
          [
            [{1, 1}, {9, 1}, {9, 8}, {1, 1}],
            [{6, 2}, {7, 2}, {7, 3}, {6, 2}]
          ]
        ]
        |> MultiPolygon.from_coordinates()
        |> MultiPolygon.to_geo_json()

      assert GeoJsonValidator.valid?(geo_json)

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiPolygon"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() ==
               [
                 [
                   [[1, 1], [9, 1], [9, 8], [1, 1]],
                   [[6, 2], [7, 2], [7, 3], [6, 2]]
                 ],
                 [
                   [[6, 2], [8, 2], [8, 4], [6, 2]]
                 ],
                 [
                   [[60, 20], [80, 20], [80, 40], [60, 20]]
                 ]
               ]
    end
  end

  describe "from_geo_json!/1" do
    test "returns MultiPolygon" do
      geo_json =
        Jason.decode!("""
         {
           "type": "MultiPolygon",
           "coordinates": [
             [
               [[6, 2], [8, 2], [8, 4], [6, 2]]
             ], [
               [[1, 1], [9, 1], [9, 8], [1, 1]],
               [[6, 2], [7, 2], [7, 3], [6, 2]]
             ]
           ]
         }
        """)

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 1, y: 1},
                %Point{x: 9, y: 1},
                %Point{x: 9, y: 8},
                %Point{x: 1, y: 1}
              ],
              interiors: [
                [
                  %Point{x: 6, y: 2},
                  %Point{x: 7, y: 2},
                  %Point{x: 7, y: 3},
                  %Point{x: 6, y: 2}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 6, y: 2},
                %Point{x: 8, y: 2},
                %Point{x: 8, y: 4},
                %Point{x: 6, y: 2}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygon.from_geo_json!(geo_json) == multi_polygon
    end

    test "raises an error for an invalid geo-json-term" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiPolygon.from_geo_json!(%{})
      end
    end
  end

  describe "from_wkt/1" do
    test "returns MultiPolygon" do
      wkt = """
      MULTIPOLYGON (
        (
           (40 40, 20 45, 45 30, 40 40)
        ), (
           (20 35, 10 30, 10 10, 30 5, 45 20, 20 35),
           (30 20, 20 15, 20 25, 30 20)
        )
      )
      """

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 20, y: 35},
                %Point{x: 10, y: 30},
                %Point{x: 10, y: 10},
                %Point{x: 30, y: 5},
                %Point{x: 45, y: 20},
                %Point{x: 20, y: 35}
              ],
              interiors: [
                [
                  %Point{x: 30, y: 20},
                  %Point{x: 20, y: 15},
                  %Point{x: 20, y: 25},
                  %Point{x: 30, y: 20}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 40, y: 40},
                %Point{x: 20, y: 45},
                %Point{x: 45, y: 30},
                %Point{x: 40, y: 40}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygon.from_wkt(wkt) == {:ok, multi_polygon}
    end
  end

  describe "from_wkt!/1" do
    test "returns MultiPolygon" do
      wkt = """
       MULTIPOLYGON (
         (
            (40 40, 20 45, 45 30, 40 40)
         ), (
            (20 35, 10 30, 10 10, 30 5, 45 20, 20 35),
            (30 20, 20 15, 20 25, 30 20)
         )
      )
      """

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 20, y: 35},
                %Point{x: 10, y: 30},
                %Point{x: 10, y: 10},
                %Point{x: 30, y: 5},
                %Point{x: 45, y: 20},
                %Point{x: 20, y: 35}
              ],
              interiors: [
                [
                  %Point{x: 30, y: 20},
                  %Point{x: 20, y: 15},
                  %Point{x: 20, y: 25},
                  %Point{x: 30, y: 20}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 40, y: 40},
                %Point{x: 20, y: 45},
                %Point{x: 45, y: 30},
                %Point{x: 40, y: 40}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygon.from_wkt!(wkt) == multi_polygon
    end

    test "returns MultiPolygon with SRID" do
      wkt = """
       SRID=1234;MULTIPOLYGON (
         (
            (40 40, 20 45, 45 30, 40 40)
         ), (
            (20 35, 10 30, 10 10, 30 5, 45 20, 20 35),
            (30 20, 20 15, 20 25, 30 20)
         )
      )
      """

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 20, y: 35},
                %Point{x: 10, y: 30},
                %Point{x: 10, y: 10},
                %Point{x: 30, y: 5},
                %Point{x: 45, y: 20},
                %Point{x: 20, y: 35}
              ],
              interiors: [
                [
                  %Point{x: 30, y: 20},
                  %Point{x: 20, y: 15},
                  %Point{x: 20, y: 25},
                  %Point{x: 30, y: 20}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 40, y: 40},
                %Point{x: 20, y: 45},
                %Point{x: 45, y: 30},
                %Point{x: 40, y: 40}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygon.from_wkt!(wkt) == {multi_polygon, 1234}
    end

    test "raises an exception for invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Pluto'"

      assert_raise Geometry.Error, message, fn ->
        MultiPolygon.from_wkt!("Pluto")
      end
    end
  end

  describe "to_wkt/2" do
    test "returns wkt-string" do
      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 20, y: 35},
                %Point{x: 10, y: 30},
                %Point{x: 10, y: 10},
                %Point{x: 30, y: 5},
                %Point{x: 45, y: 20},
                %Point{x: 20, y: 35}
              ],
              interiors: [
                [
                  %Point{x: 30, y: 20},
                  %Point{x: 20, y: 15},
                  %Point{x: 20, y: 25},
                  %Point{x: 30, y: 20}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 40, y: 40},
                %Point{x: 20, y: 45},
                %Point{x: 45, y: 30},
                %Point{x: 40, y: 40}
              ],
              interiors: []
            }
          ])
      }

      wkt = MultiPolygon.to_wkt(multi_polygon)

      assert String.starts_with?(wkt, "MultiPolygon")

      assert wkt =~
               "((20 35, 10 30, 10 10, 30 5, 45 20, 20 35)" <>
                 ", (30 20, 20 15, 20 25, 30 20))"

      assert wkt =~ "((40 40, 20 45, 45 30, 40 40))"

      wkt_srid = MultiPolygon.to_wkt(multi_polygon, srid: 478)

      assert String.starts_with?(wkt_srid, "SRID=478;MultiPolygon")

      assert wkt_srid =~
               "((20 35, 10 30, 10 10, 30 5, 45 20, 20 35)" <>
                 ", (30 20, 20 15, 20 25, 30 20))"

      assert wkt_srid =~ "((40 40, 20 45, 45 30, 40 40))"
    end
  end

  describe "from_wkb/1" do
    test "returns a MultiPolygon (ndr)" do
      wkb = """
      01\
      06000000\
      02000000\
      01\
      03000000\
      02000000\
      04000000\
      000000000000F03F000000000000F03F\
      0000000000002240000000000000F03F\
      00000000000022400000000000002040\
      000000000000F03F000000000000F03F\
      04000000\
      00000000000018400000000000000040\
      0000000000001C400000000000000040\
      0000000000001C400000000000000840\
      00000000000018400000000000000040\
      01\
      03000000\
      01000000\
      04000000\
      00000000000018400000000000000040\
      00000000000020400000000000000040\
      00000000000020400000000000001040\
      00000000000018400000000000000040\
      """

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 1.0, y: 1.0},
                %Point{x: 9.0, y: 1.0},
                %Point{x: 9.0, y: 8.0},
                %Point{x: 1.0, y: 1.0}
              ],
              interiors: [
                [
                  %Point{x: 6.0, y: 2.0},
                  %Point{x: 7.0, y: 2.0},
                  %Point{x: 7.0, y: 3.0},
                  %Point{x: 6.0, y: 2.0}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 6.0, y: 2.0},
                %Point{x: 8.0, y: 2.0},
                %Point{x: 8.0, y: 4.0},
                %Point{x: 6.0, y: 2.0}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygon.from_wkb(wkb) == {:ok, multi_polygon}
    end
  end

  describe "to_wkb/2" do
    test "returns WKB for Polygon" do
      wkb_start = "0106000000020000000103000000"

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 1.0, y: 1.0},
                %Point{x: 9.0, y: 1.0},
                %Point{x: 9.0, y: 8.0},
                %Point{x: 1.0, y: 1.0}
              ],
              interiors: [
                [
                  %Point{x: 6.0, y: 2.0},
                  %Point{x: 7.0, y: 2.0},
                  %Point{x: 7.0, y: 3.0},
                  %Point{x: 6.0, y: 2.0}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 6.0, y: 2.0},
                %Point{x: 8.0, y: 2.0},
                %Point{x: 8.0, y: 4.0},
                %Point{x: 6.0, y: 2.0}
              ],
              interiors: []
            }
          ])
      }

      assert result = MultiPolygon.to_wkb(multi_polygon)
      assert String.starts_with?(result, wkb_start)
      assert MultiPolygon.from_wkb!(result) == multi_polygon
    end
  end

  describe "from_wkb!/1" do
    test "returns a MultiPolygon (ndr)" do
      wkb = """
      01\
      06000000\
      02000000\
      01\
      03000000\
      02000000\
      04000000\
      000000000000F03F000000000000F03F\
      0000000000002240000000000000F03F\
      00000000000022400000000000002040\
      000000000000F03F000000000000F03F\
      04000000\
      00000000000018400000000000000040\
      0000000000001C400000000000000040\
      0000000000001C400000000000000840\
      00000000000018400000000000000040\
      01\
      03000000\
      01000000\
      04000000\
      00000000000018400000000000000040\
      00000000000020400000000000000040\
      00000000000020400000000000001040\
      00000000000018400000000000000040\
      """

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 1.0, y: 1.0},
                %Point{x: 9.0, y: 1.0},
                %Point{x: 9.0, y: 8.0},
                %Point{x: 1.0, y: 1.0}
              ],
              interiors: [
                [
                  %Point{x: 6.0, y: 2.0},
                  %Point{x: 7.0, y: 2.0},
                  %Point{x: 7.0, y: 3.0},
                  %Point{x: 6.0, y: 2.0}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 6.0, y: 2.0},
                %Point{x: 8.0, y: 2.0},
                %Point{x: 8.0, y: 4.0},
                %Point{x: 6.0, y: 2.0}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygon.from_wkb!(wkb) == multi_polygon
    end

    test "raises an error for an invalid WKB" do
      message = "expected endian flag '00' or '01', at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiPolygon.from_wkb!("")
      end
    end
  end
end
