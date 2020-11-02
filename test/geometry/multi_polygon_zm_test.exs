defmodule Geometry.MultiPolygonZMTest do
  use ExUnit.Case, async: true

  alias Geometry.{
    Hex,
    LineStringZM,
    MultiPolygonZM,
    PointZM,
    PolygonZM
  }

  doctest Geometry.MultiPolygonZM, import: true

  @moduletag :multi_polygon

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        [
          [
            [[60, 20, 30, 40], [80, 20, 40, 50], [80, 40, 50, 60], [60, 20, 30, 40]]
          ],
          [
            [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
            [[6, 2, 4, 3], [7, 2, 6, 7], [7, 3, 3, 4], [6, 2, 4, 3]]
          ],
          [
            [[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]]
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

      multi_polygon =
        MultiPolygonZM.new([
          PolygonZM.new([
            LineStringZM.new([
              PointZM.new(1, 1, 3, 4),
              PointZM.new(9, 1, 4, 5),
              PointZM.new(9, 8, 5, 6),
              PointZM.new(1, 1, 3, 4)
            ]),
            LineStringZM.new([
              PointZM.new(6, 2, 4, 3),
              PointZM.new(7, 2, 6, 7),
              PointZM.new(7, 3, 3, 4),
              PointZM.new(6, 2, 4, 3)
            ])
          ]),
          PolygonZM.new([
            LineStringZM.new([
              PointZM.new(6, 2, 3, 4),
              PointZM.new(8, 2, 4, 5),
              PointZM.new(8, 4, 5, 6),
              PointZM.new(6, 2, 3, 4)
            ])
          ])
        ])

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
            [
              [
                [20, 35, 20, 10],
                [10, 30, 10, 20],
                [10, 10, 30, 15],
                [30, 5, 10, 15],
                [45, 20, 10, 16],
                [20, 35, 20, 10]
              ],
              [
                [30, 20, 10, 15],
                [20, 15, 20, 10],
                [20, 25, 15, 25],
                [30, 20, 10, 15]
              ]
            ],
            [
              [
                [40, 40, 10, 20],
                [20, 45, 20, 10],
                [45, 30, 15, 30],
                [40, 40, 10, 20]
              ]
            ]
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
            [
              [
                [20, 35, 20, 10],
                [10, 30, 10, 20],
                [10, 10, 30, 15],
                [30, 5, 10, 15],
                [45, 20, 10, 16],
                [20, 35, 20, 10]
              ],
              [
                [30, 20, 10, 15],
                [20, 15, 20, 10],
                [20, 25, 15, 25],
                [30, 20, 10, 15]
              ]
            ],
            [
              [
                [40, 40, 10, 20],
                [20, 45, 20, 10],
                [45, 30, 15, 30],
                [40, 40, 10, 20]
              ]
            ]
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
            [
              [
                [20, 35, 20, 10],
                [10, 30, 10, 20],
                [10, 10, 30, 15],
                [30, 5, 10, 15],
                [45, 20, 10, 16],
                [20, 35, 20, 10]
              ],
              [
                [30, 20, 10, 15],
                [20, 15, 20, 10],
                [20, 25, 15, 25],
                [30, 20, 10, 15]
              ]
            ],
            [
              [
                [40, 40, 10, 20],
                [20, 45, 20, 10],
                [45, 30, 15, 30],
                [40, 40, 10, 20]
              ]
            ]
          ])
      }

      assert MultiPolygonZM.from_wkt!(wkt) == {multi_polygon, 1234}
    end

    test "raises an exception for invalid WKT" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "Pluto")

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
            [
              [
                [20, 35, 20, 10],
                [10, 30, 10, 20],
                [10, 10, 30, 15],
                [30, 5, 10, 15],
                [45, 20, 10, 16],
                [20, 35, 20, 10]
              ],
              [
                [30, 20, 10, 15],
                [20, 15, 20, 10],
                [20, 25, 15, 25],
                [30, 20, 10, 15]
              ]
            ],
            [
              [
                [40, 40, 10, 20],
                [20, 45, 20, 10],
                [45, 30, 15, 30],
                [40, 40, 10, 20]
              ]
            ]
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

  describe "from_wkb/2" do
    test "returns a MultiPolygonZM from ndr-string" do
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
            [
              [
                [1.0, 1.0, 3.0, 4.0],
                [9.0, 1.0, 4.0, 5.0],
                [9.0, 8.0, 5.0, 6.0],
                [1.0, 1.0, 3.0, 4.0]
              ],
              [
                [6.0, 2.0, 4.0, 3.0],
                [7.0, 2.0, 6.0, 7.0],
                [7.0, 3.0, 3.0, 4.0],
                [6.0, 2.0, 4.0, 3.0]
              ]
            ],
            [
              [
                [6.0, 2.0, 3.0, 4.0],
                [8.0, 2.0, 4.0, 5.0],
                [8.0, 4.0, 5.0, 6.0],
                [6.0, 2.0, 3.0, 4.0]
              ]
            ]
          ])
      }

      assert MultiPolygonZM.from_wkb(wkb, :hex) == {:ok, multi_polygon}
    end

    test "returns a MultiPolygonZM from ndr-binary" do
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
            [
              [
                [1.0, 1.0, 3.0, 4.0],
                [9.0, 1.0, 4.0, 5.0],
                [9.0, 8.0, 5.0, 6.0],
                [1.0, 1.0, 3.0, 4.0]
              ],
              [
                [6.0, 2.0, 4.0, 3.0],
                [7.0, 2.0, 6.0, 7.0],
                [7.0, 3.0, 3.0, 4.0],
                [6.0, 2.0, 4.0, 3.0]
              ]
            ],
            [
              [
                [6.0, 2.0, 3.0, 4.0],
                [8.0, 2.0, 4.0, 5.0],
                [8.0, 4.0, 5.0, 6.0],
                [6.0, 2.0, 3.0, 4.0]
              ]
            ]
          ])
      }

      assert wkb |> Hex.to_binary() |> MultiPolygonZM.from_wkb() == {:ok, multi_polygon}
    end
  end

  describe "to_wkb/2" do
    test "returns WKB ndr-binary for MultiPolygonZM" do
      wkb_start = "01060000C00200000001030000C0"

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            [
              [
                [1.0, 1.0, 3.0, 4.0],
                [9.0, 1.0, 4.0, 5.0],
                [9.0, 8.0, 5.0, 6.0],
                [1.0, 1.0, 3.0, 4.0]
              ],
              [
                [6.0, 2.0, 4.0, 3.0],
                [7.0, 2.0, 6.0, 7.0],
                [7.0, 3.0, 3.0, 4.0],
                [6.0, 2.0, 4.0, 3.0]
              ]
            ],
            [
              [
                [6.0, 2.0, 3.0, 4.0],
                [8.0, 2.0, 4.0, 5.0],
                [8.0, 4.0, 5.0, 6.0],
                [6.0, 2.0, 3.0, 4.0]
              ]
            ]
          ])
      }

      assert result = MultiPolygonZM.to_wkb(multi_polygon, endian: :ndr)
      assert String.starts_with?(result, Hex.to_binary(wkb_start))
      assert MultiPolygonZM.from_wkb!(result) == multi_polygon
    end

    test "returns WKB as ndr-string for MultiPolygonZM" do
      wkb_start = "01060000C00200000001030000C0"

      multi_polygon = %MultiPolygonZM{
        polygons:
          MapSet.new([
            [
              [
                [1.0, 1.0, 3.0, 4.0],
                [9.0, 1.0, 4.0, 5.0],
                [9.0, 8.0, 5.0, 6.0],
                [1.0, 1.0, 3.0, 4.0]
              ],
              [
                [6.0, 2.0, 4.0, 3.0],
                [7.0, 2.0, 6.0, 7.0],
                [7.0, 3.0, 3.0, 4.0],
                [6.0, 2.0, 4.0, 3.0]
              ]
            ],
            [
              [
                [6.0, 2.0, 3.0, 4.0],
                [8.0, 2.0, 4.0, 5.0],
                [8.0, 4.0, 5.0, 6.0],
                [6.0, 2.0, 3.0, 4.0]
              ]
            ]
          ])
      }

      assert result = MultiPolygonZM.to_wkb(multi_polygon, endian: :ndr, mode: :hex)
      assert String.starts_with?(result, wkb_start)
      assert MultiPolygonZM.from_wkb!(result, :hex) == multi_polygon
    end
  end

  describe "from_wkb!/2" do
    test "returns a MultiPolygonZM from ndr-string" do
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
            [
              [
                [1.0, 1.0, 3.0, 4.0],
                [9.0, 1.0, 4.0, 5.0],
                [9.0, 8.0, 5.0, 6.0],
                [1.0, 1.0, 3.0, 4.0]
              ],
              [
                [6.0, 2.0, 4.0, 3.0],
                [7.0, 2.0, 6.0, 7.0],
                [7.0, 3.0, 3.0, 4.0],
                [6.0, 2.0, 4.0, 3.0]
              ]
            ],
            [
              [
                [6.0, 2.0, 3.0, 4.0],
                [8.0, 2.0, 4.0, 5.0],
                [8.0, 4.0, 5.0, 6.0],
                [6.0, 2.0, 3.0, 4.0]
              ]
            ]
          ])
      }

      assert MultiPolygonZM.from_wkb!(wkb, :hex) == multi_polygon
    end

    test "returns a MultiPolygonZM from ndr-binary" do
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
            [
              [
                [1.0, 1.0, 3.0, 4.0],
                [9.0, 1.0, 4.0, 5.0],
                [9.0, 8.0, 5.0, 6.0],
                [1.0, 1.0, 3.0, 4.0]
              ],
              [
                [6.0, 2.0, 4.0, 3.0],
                [7.0, 2.0, 6.0, 7.0],
                [7.0, 3.0, 3.0, 4.0],
                [6.0, 2.0, 4.0, 3.0]
              ]
            ],
            [
              [
                [6.0, 2.0, 3.0, 4.0],
                [8.0, 2.0, 4.0, 5.0],
                [8.0, 4.0, 5.0, 6.0],
                [6.0, 2.0, 3.0, 4.0]
              ]
            ]
          ])
      }

      assert wkb |> Hex.to_binary() |> MultiPolygonZM.from_wkb!() == multi_polygon
    end

    test "raises an error for an invalid WKB string" do
      message = ~s(expected endian flag "00" or "01", at position 0)

      assert_raise Geometry.Error, message, fn ->
        MultiPolygonZM.from_wkb!("", :hex)
      end
    end

    test "raises an error for an invalid WKB binary" do
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiPolygonZM.from_wkb!("")
      end
    end
  end

  test "Enum.slice/3" do
    multi_polygon =
      MultiPolygonZM.new([
        PolygonZM.new([
          LineStringZM.new([
            PointZM.new(11, 12, 13, 14),
            PointZM.new(21, 22, 23, 24),
            PointZM.new(31, 32, 33, 34),
            PointZM.new(41, 42, 43, 44)
          ])
        ])
      ])

    assert [_polygon] = Enum.slice(multi_polygon, 0, 1)
  end
end
