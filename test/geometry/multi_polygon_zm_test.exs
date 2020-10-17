defmodule Geometry.MultiPolygonZMTest do
  use ExUnit.Case

  alias Geometry.{
    MultiPolygonZM,
    PointZM,
    PolygonZM
  }

  doctest Geometry.MultiPolygonZM, import: true

  @moduletag :multi_plygon

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        [
          [{6, 2, 3, 4}, {8, 2, 4, 5}, {8, 4, 5, 6}, {6, 2, 3, 4}],
          [[{60, 20, 30, 40}, {80, 20, 40, 50}, {80, 40, 50, 60}, {60, 20, 30, 40}]],
          [
            [{1, 1, 3, 4}, {9, 1, 4, 5}, {9, 8, 5, 6}, {1, 1, 3, 4}],
            [{6, 2, 4, 3}, {7, 2, 6, 7}, {7, 3, 3, 4}, {6, 2, 4, 3}]
          ]
        ]
        |> MultiPolygonZM.from_coordinates()
        |> MultiPolygonZM.to_geo_json()

      assert GeoJsonValidator.valid?(geo_json)

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiPolygon"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() ==
               [
                 [
                   [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
                   [[6, 2, 4, 3], [7, 2, 6, 7], [7, 3, 3, 4], [6, 2, 4, 3]]
                 ],
                 [
                   [[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]]
                 ],
                 [
                   [[60, 20, 30, 40], [80, 20, 40, 50], [80, 40, 50, 60], [60, 20, 30, 40]]
                 ]
               ]
    end
  end

  describe "from_geo_json!/1" do
    test "returns MultiPolygonZM" do
      geo_json =
        Jason.decode!("""
         {
           "type": "MultiPolygon",
           "coordinates": [
             [
               [[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]]
             ], [
               [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
               [[6, 2, 4, 3], [7, 2, 6, 7], [7, 3, 3, 4], [6, 2, 4, 3]]
             ]
           ]
         }
        """)

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 1, y: 1, z: 3, m: 4},
                %PointZM{x: 9, y: 1, z: 4, m: 5},
                %PointZM{x: 9, y: 8, z: 5, m: 6},
                %PointZM{x: 1, y: 1, z: 3, m: 4}
              ],
              interiors: [
                [
                  %PointZM{x: 6, y: 2, z: 4, m: 3},
                  %PointZM{x: 7, y: 2, z: 6, m: 7},
                  %PointZM{x: 7, y: 3, z: 3, m: 4},
                  %PointZM{x: 6, y: 2, z: 4, m: 3}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 6, y: 2, z: 3, m: 4},
                %PointZM{x: 8, y: 2, z: 4, m: 5},
                %PointZM{x: 8, y: 4, z: 5, m: 6},
                %PointZM{x: 6, y: 2, z: 3, m: 4}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygonZM.from_geo_json!(geo_json) == multi_polygon
    end

    test "raises an error for an invalid geo-json-term" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiPolygonZM.from_geo_json!(%{})
      end
    end
  end

  describe "from_wkt/1" do
    test "returns MultiPolygonZM" do
      wkt = """
      MULTIPOLYGON ZM (
        (
           (40 40 10 20, 20 45 20 10, 45 30 15 30, 40 40 10 20)
        ), (
           (20 35 20 10, 10 30 10 20, 10 10 30 15, 30 5 10 15, 45 20 10 16, 20 35 20 10),
           (30 20 10 15, 20 15 20 10, 20 25 15 25, 30 20 10 15)
        )
      )
      """

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 20, y: 35, z: 20, m: 10},
                %PointZM{x: 10, y: 30, z: 10, m: 20},
                %PointZM{x: 10, y: 10, z: 30, m: 15},
                %PointZM{x: 30, y: 5, z: 10, m: 15},
                %PointZM{x: 45, y: 20, z: 10, m: 16},
                %PointZM{x: 20, y: 35, z: 20, m: 10}
              ],
              interiors: [
                [
                  %PointZM{x: 30, y: 20, z: 10, m: 15},
                  %PointZM{x: 20, y: 15, z: 20, m: 10},
                  %PointZM{x: 20, y: 25, z: 15, m: 25},
                  %PointZM{x: 30, y: 20, z: 10, m: 15}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 40, y: 40, z: 10, m: 20},
                %PointZM{x: 20, y: 45, z: 20, m: 10},
                %PointZM{x: 45, y: 30, z: 15, m: 30},
                %PointZM{x: 40, y: 40, z: 10, m: 20}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygonZM.from_wkt(wkt) == {:ok, multi_polygon}
    end
  end

  describe "from_wkt!/1" do
    test "returns MultiPolygonZM" do
      wkt = """
       MULTIPOLYGON ZM (
         (
            (40 40 10 20, 20 45 20 10, 45 30 15 30, 40 40 10 20)
         ), (
            (20 35 20 10, 10 30 10 20, 10 10 30 15, 30 5 10 15, 45 20 10 16, 20 35 20 10),
            (30 20 10 15, 20 15 20 10, 20 25 15 25, 30 20 10 15)
         )
      )
      """

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 20, y: 35, z: 20, m: 10},
                %PointZM{x: 10, y: 30, z: 10, m: 20},
                %PointZM{x: 10, y: 10, z: 30, m: 15},
                %PointZM{x: 30, y: 5, z: 10, m: 15},
                %PointZM{x: 45, y: 20, z: 10, m: 16},
                %PointZM{x: 20, y: 35, z: 20, m: 10}
              ],
              interiors: [
                [
                  %PointZM{x: 30, y: 20, z: 10, m: 15},
                  %PointZM{x: 20, y: 15, z: 20, m: 10},
                  %PointZM{x: 20, y: 25, z: 15, m: 25},
                  %PointZM{x: 30, y: 20, z: 10, m: 15}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 40, y: 40, z: 10, m: 20},
                %PointZM{x: 20, y: 45, z: 20, m: 10},
                %PointZM{x: 45, y: 30, z: 15, m: 30},
                %PointZM{x: 40, y: 40, z: 10, m: 20}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygonZM.from_wkt!(wkt) == multi_polygon
    end

    test "returns MultiPolygonZM with SRID" do
      wkt = """
       SRID=1234;MULTIPOLYGON ZM (
         (
            (40 40 10 20, 20 45 20 10, 45 30 15 30, 40 40 10 20)
         ), (
            (20 35 20 10, 10 30 10 20, 10 10 30 15, 30 5 10 15, 45 20 10 16, 20 35 20 10),
            (30 20 10 15, 20 15 20 10, 20 25 15 25, 30 20 10 15)
         )
      )
      """

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 20, y: 35, z: 20, m: 10},
                %PointZM{x: 10, y: 30, z: 10, m: 20},
                %PointZM{x: 10, y: 10, z: 30, m: 15},
                %PointZM{x: 30, y: 5, z: 10, m: 15},
                %PointZM{x: 45, y: 20, z: 10, m: 16},
                %PointZM{x: 20, y: 35, z: 20, m: 10}
              ],
              interiors: [
                [
                  %PointZM{x: 30, y: 20, z: 10, m: 15},
                  %PointZM{x: 20, y: 15, z: 20, m: 10},
                  %PointZM{x: 20, y: 25, z: 15, m: 25},
                  %PointZM{x: 30, y: 20, z: 10, m: 15}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 40, y: 40, z: 10, m: 20},
                %PointZM{x: 20, y: 45, z: 20, m: 10},
                %PointZM{x: 45, y: 30, z: 15, m: 30},
                %PointZM{x: 40, y: 40, z: 10, m: 20}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygonZM.from_wkt!(wkt) == {multi_polygon, 1234}
    end

    test "raises an exception for invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Pluto'"

      assert_raise Geometry.Error, message, fn ->
        MultiPolygonZM.from_wkt!("Pluto")
      end
    end
  end

  describe "to_wkt/2" do
    test "returns wkt-string" do
      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 20, y: 35, z: 20, m: 10},
                %PointZM{x: 10, y: 30, z: 10, m: 20},
                %PointZM{x: 10, y: 10, z: 30, m: 15},
                %PointZM{x: 30, y: 5, z: 10, m: 15},
                %PointZM{x: 45, y: 20, z: 10, m: 16},
                %PointZM{x: 20, y: 35, z: 20, m: 10}
              ],
              interiors: [
                [
                  %PointZM{x: 30, y: 20, z: 10, m: 15},
                  %PointZM{x: 20, y: 15, z: 20, m: 10},
                  %PointZM{x: 20, y: 25, z: 15, m: 25},
                  %PointZM{x: 30, y: 20, z: 10, m: 15}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 40, y: 40, z: 10, m: 20},
                %PointZM{x: 20, y: 45, z: 20, m: 10},
                %PointZM{x: 45, y: 30, z: 15, m: 30},
                %PointZM{x: 40, y: 40, z: 10, m: 20}
              ],
              interiors: []
            }
          ])
      }

      wkt = MultiPolygonZM.to_wkt(multi_polygon)

      assert String.starts_with?(wkt, "MultiPolygon ZM")

      assert wkt =~
               "((20 35 20 10, 10 30 10 20, 10 10 30 15, 30 5 10 15, 45 20 10 16, 20 35 20 10)" <>
                 ", (30 20 10 15, 20 15 20 10, 20 25 15 25, 30 20 10 15))"

      assert wkt =~ "((40 40 10 20, 20 45 20 10, 45 30 15 30, 40 40 10 20))"

      wkt_srid = MultiPolygonZM.to_wkt(multi_polygon, srid: 478)

      assert String.starts_with?(wkt_srid, "SRID=478;MultiPolygon ZM")

      assert wkt_srid =~
               "((20 35 20 10, 10 30 10 20, 10 10 30 15, 30 5 10 15, 45 20 10 16, 20 35 20 10)" <>
                 ", (30 20 10 15, 20 15 20 10, 20 25 15 25, 30 20 10 15))"

      assert wkt_srid =~ "((40 40 10 20, 20 45 20 10, 45 30 15 30, 40 40 10 20))"
    end
  end

  describe "from_wkb/1" do
    test "returns a MultiPolygonZM (ndr)" do
      wkb = """
      01\
      060000C0\
      02000000\
      01\
      030000C0\
      02000000\
      04000000\
      000000000000F03F000000000000F03F00000000000008400000000000001040\
      0000000000002240000000000000F03F00000000000010400000000000001440\
      0000000000002240000000000000204000000000000014400000000000001840\
      000000000000F03F000000000000F03F00000000000008400000000000001040\
      04000000\
      0000000000001840000000000000004000000000000010400000000000000840\
      0000000000001C40000000000000004000000000000018400000000000001C40\
      0000000000001C40000000000000084000000000000008400000000000001040\
      0000000000001840000000000000004000000000000010400000000000000840\
      01\
      030000C0\
      01000000\
      04000000\
      0000000000001840000000000000004000000000000008400000000000001040\
      0000000000002040000000000000004000000000000010400000000000001440\
      0000000000002040000000000000104000000000000014400000000000001840\
      0000000000001840000000000000004000000000000008400000000000001040\
      """

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 1.0, y: 1.0, z: 3.0, m: 4.0},
                %PointZM{x: 9.0, y: 1.0, z: 4.0, m: 5.0},
                %PointZM{x: 9.0, y: 8.0, z: 5.0, m: 6.0},
                %PointZM{x: 1.0, y: 1.0, z: 3.0, m: 4.0}
              ],
              interiors: [
                [
                  %PointZM{x: 6.0, y: 2.0, z: 4.0, m: 3.0},
                  %PointZM{x: 7.0, y: 2.0, z: 6.0, m: 7.0},
                  %PointZM{x: 7.0, y: 3.0, z: 3.0, m: 4.0},
                  %PointZM{x: 6.0, y: 2.0, z: 4.0, m: 3.0}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 6.0, y: 2.0, z: 3.0, m: 4.0},
                %PointZM{x: 8.0, y: 2.0, z: 4.0, m: 5.0},
                %PointZM{x: 8.0, y: 4.0, z: 5.0, m: 6.0},
                %PointZM{x: 6.0, y: 2.0, z: 3.0, m: 4.0}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygonZM.from_wkb(wkb) == {:ok, multi_polygon}
    end
  end

  describe "to_wkb/2" do
    test "returns WKB for PolygonZM" do
      wkb_start = "01060000C00200000001030000C0"

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 1.0, y: 1.0, z: 3.0, m: 4.0},
                %PointZM{x: 9.0, y: 1.0, z: 4.0, m: 5.0},
                %PointZM{x: 9.0, y: 8.0, z: 5.0, m: 6.0},
                %PointZM{x: 1.0, y: 1.0, z: 3.0, m: 4.0}
              ],
              interiors: [
                [
                  %PointZM{x: 6.0, y: 2.0, z: 4.0, m: 3.0},
                  %PointZM{x: 7.0, y: 2.0, z: 6.0, m: 7.0},
                  %PointZM{x: 7.0, y: 3.0, z: 3.0, m: 4.0},
                  %PointZM{x: 6.0, y: 2.0, z: 4.0, m: 3.0}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 6.0, y: 2.0, z: 3.0, m: 4.0},
                %PointZM{x: 8.0, y: 2.0, z: 4.0, m: 5.0},
                %PointZM{x: 8.0, y: 4.0, z: 5.0, m: 6.0},
                %PointZM{x: 6.0, y: 2.0, z: 3.0, m: 4.0}
              ],
              interiors: []
            }
          ])
      }

      assert result = MultiPolygonZM.to_wkb(multi_polygon)
      assert String.starts_with?(result, wkb_start)
      assert MultiPolygonZM.from_wkb!(result) == multi_polygon
    end
  end

  describe "from_wkb!/1" do
    test "returns a MultiPolygonZM (ndr)" do
      wkb = """
      01\
      060000C0\
      02000000\
      01\
      030000C0\
      02000000\
      04000000\
      000000000000F03F000000000000F03F00000000000008400000000000001040\
      0000000000002240000000000000F03F00000000000010400000000000001440\
      0000000000002240000000000000204000000000000014400000000000001840\
      000000000000F03F000000000000F03F00000000000008400000000000001040\
      04000000\
      0000000000001840000000000000004000000000000010400000000000000840\
      0000000000001C40000000000000004000000000000018400000000000001C40\
      0000000000001C40000000000000084000000000000008400000000000001040\
      0000000000001840000000000000004000000000000010400000000000000840\
      01\
      030000C0\
      01000000\
      04000000\
      0000000000001840000000000000004000000000000008400000000000001040\
      0000000000002040000000000000004000000000000010400000000000001440\
      0000000000002040000000000000104000000000000014400000000000001840\
      0000000000001840000000000000004000000000000008400000000000001040\
      """

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 1.0, y: 1.0, z: 3.0, m: 4.0},
                %PointZM{x: 9.0, y: 1.0, z: 4.0, m: 5.0},
                %PointZM{x: 9.0, y: 8.0, z: 5.0, m: 6.0},
                %PointZM{x: 1.0, y: 1.0, z: 3.0, m: 4.0}
              ],
              interiors: [
                [
                  %PointZM{x: 6.0, y: 2.0, z: 4.0, m: 3.0},
                  %PointZM{x: 7.0, y: 2.0, z: 6.0, m: 7.0},
                  %PointZM{x: 7.0, y: 3.0, z: 3.0, m: 4.0},
                  %PointZM{x: 6.0, y: 2.0, z: 4.0, m: 3.0}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 6.0, y: 2.0, z: 3.0, m: 4.0},
                %PointZM{x: 8.0, y: 2.0, z: 4.0, m: 5.0},
                %PointZM{x: 8.0, y: 4.0, z: 5.0, m: 6.0},
                %PointZM{x: 6.0, y: 2.0, z: 3.0, m: 4.0}
              ],
              interiors: []
            }
          ])
      }

      assert MultiPolygonZM.from_wkb!(wkb) == multi_polygon
    end

    test "raises an error for an invalid WKB" do
      message = "expected endian flag '00' or '01', at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiPolygonZM.from_wkb!("")
      end
    end
  end
end
