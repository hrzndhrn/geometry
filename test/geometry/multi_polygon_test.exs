defmodule Geometry.MultiPolygonTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{
    Hex,
    LineString,
    MultiPolygon,
    Point,
    Polygon
  }

  doctest Geometry.MultiPolygon, import: true

  @moduletag :multi_polygon

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        [
          [
            [[60, 20], [80, 20], [80, 40], [60, 20]]
          ],
          [
            [[1, 1], [9, 1], [9, 8], [1, 1]],
            [[6, 2], [7, 2], [7, 3], [6, 2]]
          ],
          [
            [[6, 2], [8, 2], [8, 4], [6, 2]]
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

      multi_polygon =
        MultiPolygon.new([
          Polygon.new([
            LineString.new([
              Point.new(1, 1),
              Point.new(9, 1),
              Point.new(9, 8),
              Point.new(1, 1)
            ]),
            LineString.new([
              Point.new(6, 2),
              Point.new(7, 2),
              Point.new(7, 3),
              Point.new(6, 2)
            ])
          ]),
          Polygon.new([
            LineString.new([
              Point.new(6, 2),
              Point.new(8, 2),
              Point.new(8, 4),
              Point.new(6, 2)
            ])
          ])
        ])

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
            [
              [
                [20, 35],
                [10, 30],
                [10, 10],
                [30, 5],
                [45, 20],
                [20, 35]
              ],
              [
                [30, 20],
                [20, 15],
                [20, 25],
                [30, 20]
              ]
            ],
            [
              [
                [40, 40],
                [20, 45],
                [45, 30],
                [40, 40]
              ]
            ]
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
            [
              [
                [20, 35],
                [10, 30],
                [10, 10],
                [30, 5],
                [45, 20],
                [20, 35]
              ],
              [
                [30, 20],
                [20, 15],
                [20, 25],
                [30, 20]
              ]
            ],
            [
              [
                [40, 40],
                [20, 45],
                [45, 30],
                [40, 40]
              ]
            ]
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
            [
              [
                [20, 35],
                [10, 30],
                [10, 10],
                [30, 5],
                [45, 20],
                [20, 35]
              ],
              [
                [30, 20],
                [20, 15],
                [20, 25],
                [30, 20]
              ]
            ],
            [
              [
                [40, 40],
                [20, 45],
                [45, 30],
                [40, 40]
              ]
            ]
          ])
      }

      assert MultiPolygon.from_wkt!(wkt) == {multi_polygon, 1234}
    end

    test "raises an exception for invalid WKT" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "Pluto")

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
            [
              [
                [20, 35],
                [10, 30],
                [10, 10],
                [30, 5],
                [45, 20],
                [20, 35]
              ],
              [
                [30, 20],
                [20, 15],
                [20, 25],
                [30, 20]
              ]
            ],
            [
              [
                [40, 40],
                [20, 45],
                [45, 30],
                [40, 40]
              ]
            ]
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

  describe "from_wkb/2" do
    test "returns a MultiPolygon from ndr-string" do
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
            [
              [
                [1.0, 1.0],
                [9.0, 1.0],
                [9.0, 8.0],
                [1.0, 1.0]
              ],
              [
                [6.0, 2.0],
                [7.0, 2.0],
                [7.0, 3.0],
                [6.0, 2.0]
              ]
            ],
            [
              [
                [6.0, 2.0],
                [8.0, 2.0],
                [8.0, 4.0],
                [6.0, 2.0]
              ]
            ]
          ])
      }

      assert MultiPolygon.from_wkb(wkb, :hex) == {:ok, multi_polygon}
    end

    test "returns a MultiPolygon from ndr-binary" do
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
            [
              [
                [1.0, 1.0],
                [9.0, 1.0],
                [9.0, 8.0],
                [1.0, 1.0]
              ],
              [
                [6.0, 2.0],
                [7.0, 2.0],
                [7.0, 3.0],
                [6.0, 2.0]
              ]
            ],
            [
              [
                [6.0, 2.0],
                [8.0, 2.0],
                [8.0, 4.0],
                [6.0, 2.0]
              ]
            ]
          ])
      }

      assert wkb |> Hex.to_binary() |> MultiPolygon.from_wkb() == {:ok, multi_polygon}
    end
  end

  describe "to_wkb/2" do
    test "returns WKB ndr-binary for MultiPolygon" do
      wkb_start = "0106000000020000000103000000"

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            [
              [
                [1.0, 1.0],
                [9.0, 1.0],
                [9.0, 8.0],
                [1.0, 1.0]
              ],
              [
                [6.0, 2.0],
                [7.0, 2.0],
                [7.0, 3.0],
                [6.0, 2.0]
              ]
            ],
            [
              [
                [6.0, 2.0],
                [8.0, 2.0],
                [8.0, 4.0],
                [6.0, 2.0]
              ]
            ]
          ])
      }

      assert result = MultiPolygon.to_wkb(multi_polygon, endian: :ndr)
      assert String.starts_with?(result, Hex.to_binary(wkb_start))
      assert MultiPolygon.from_wkb!(result) == multi_polygon
    end

    test "returns WKB as ndr-string for MultiPolygon" do
      wkb_start = "0106000000020000000103000000"

      multi_polygon = %MultiPolygon{
        polygons:
          MapSet.new([
            [
              [
                [1.0, 1.0],
                [9.0, 1.0],
                [9.0, 8.0],
                [1.0, 1.0]
              ],
              [
                [6.0, 2.0],
                [7.0, 2.0],
                [7.0, 3.0],
                [6.0, 2.0]
              ]
            ],
            [
              [
                [6.0, 2.0],
                [8.0, 2.0],
                [8.0, 4.0],
                [6.0, 2.0]
              ]
            ]
          ])
      }

      assert result = MultiPolygon.to_wkb(multi_polygon, endian: :ndr, mode: :hex)
      assert String.starts_with?(result, wkb_start)
      assert MultiPolygon.from_wkb!(result, :hex) == multi_polygon
    end
  end

  describe "from_wkb!/2" do
    test "returns a MultiPolygon from ndr-string" do
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
            [
              [
                [1.0, 1.0],
                [9.0, 1.0],
                [9.0, 8.0],
                [1.0, 1.0]
              ],
              [
                [6.0, 2.0],
                [7.0, 2.0],
                [7.0, 3.0],
                [6.0, 2.0]
              ]
            ],
            [
              [
                [6.0, 2.0],
                [8.0, 2.0],
                [8.0, 4.0],
                [6.0, 2.0]
              ]
            ]
          ])
      }

      assert MultiPolygon.from_wkb!(wkb, :hex) == multi_polygon
    end

    test "returns a MultiPolygon from ndr-binary" do
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
            [
              [
                [1.0, 1.0],
                [9.0, 1.0],
                [9.0, 8.0],
                [1.0, 1.0]
              ],
              [
                [6.0, 2.0],
                [7.0, 2.0],
                [7.0, 3.0],
                [6.0, 2.0]
              ]
            ],
            [
              [
                [6.0, 2.0],
                [8.0, 2.0],
                [8.0, 4.0],
                [6.0, 2.0]
              ]
            ]
          ])
      }

      assert wkb |> Hex.to_binary() |> MultiPolygon.from_wkb!() == multi_polygon
    end

    test "raises an error for an invalid WKB string" do
      message = ~s(expected endian flag "00" or "01", at position 0)

      assert_raise Geometry.Error, message, fn ->
        MultiPolygon.from_wkb!("", :hex)
      end
    end

    test "raises an error for an invalid WKB binary" do
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiPolygon.from_wkb!("")
      end
    end
  end

  test "Enum.slice/3" do
    multi_polygon =
      MultiPolygon.new([
        Polygon.new([
          LineString.new([
            Point.new(11, 12),
            Point.new(21, 22),
            Point.new(31, 32),
            Point.new(41, 42)
          ])
        ])
      ])

    assert [_polygon] = Enum.slice(multi_polygon, 0, 1)
  end
end
