defmodule Geometry.PolygonMTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{Hex, LineStringM, PointM, PolygonM}

  doctest Geometry.PolygonM, import: true

  @moduletag :polygon

  describe "from_wkb/1" do
    test "returns PolygonM (xdr)" do
      wkb = """
      00\
      40000003\
      00000001\
      00000005\
      403E0000000000004024000000000000402E000000000000\
      404400000000000040440000000000004034000000000000\
      40340000000000004044000000000000402E000000000000\
      402400000000000040340000000000004039000000000000\
      403E0000000000004024000000000000402E000000000000\
      """

      assert PolygonM.from_wkb(wkb) ==
               {:ok,
                %PolygonM{
                  rings: [
                    [
                      [30.0, 10.0, 15.0],
                      [40.0, 40.0, 20.0],
                      [20.0, 40.0, 15.0],
                      [10.0, 20.0, 25.0],
                      [30.0, 10.0, 15.0]
                    ]
                  ]
                }}
    end

    @tag :only
    test "returns PolygonM with hole and SRID (ndr) " do
      wkb = """
      01\
      03000060\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000003940\
      000000000080464000000000008046400000000000003440\
      0000000000002E4000000000000044400000000000002440\
      000000000000244000000000000034400000000000003940\
      000000000080414000000000000024400000000000003940\
      04000000\
      00000000000034400000000000003E400000000000002440\
      000000000080414000000000008041400000000000004940\
      0000000000003E4000000000000034400000000000804140\
      00000000000034400000000000003E400000000000002440\
      """

      assert PolygonM.from_wkb(wkb) ==
               {:ok,
                %PolygonM{
                  rings: [
                    [
                      [35.0, 10.0, 25.0],
                      [45.0, 45.0, 20.0],
                      [15.0, 40.0, 10.0],
                      [10.0, 20.0, 25.0],
                      [35.0, 10.0, 25.0]
                    ],
                    [
                      [20.0, 30.0, 10.0],
                      [35.0, 35.0, 50.0],
                      [30.0, 20.0, 35.0],
                      [20.0, 30.0, 10.0]
                    ]
                  ]
                }, 333}
    end
  end

  describe "to_wkb/1" do
    test "returns WKB as xdr-binary PolygonM" do
      wkb = """
      00\
      40000003\
      00000001\
      00000005\
      403E0000000000004024000000000000402E000000000000\
      404400000000000040440000000000004034000000000000\
      40340000000000004044000000000000402E000000000000\
      402400000000000040340000000000004039000000000000\
      403E0000000000004024000000000000402E000000000000\
      """

      polygon = %PolygonM{
        rings: [
          [
            [30.0, 10.0, 15.0],
            [40.0, 40.0, 20.0],
            [20.0, 40.0, 15.0],
            [10.0, 20.0, 25.0],
            [30.0, 10.0, 15.0]
          ]
        ]
      }

      assert PolygonM.to_wkb(polygon) == Hex.to_binary(wkb)
    end

    test "returns WKB as xdr-string PolygonM" do
      wkb = """
      00\
      40000003\
      00000001\
      00000005\
      403E0000000000004024000000000000402E000000000000\
      404400000000000040440000000000004034000000000000\
      40340000000000004044000000000000402E000000000000\
      402400000000000040340000000000004039000000000000\
      403E0000000000004024000000000000402E000000000000\
      """

      polygon = %PolygonM{
        rings: [
          [
            [30.0, 10.0, 15.0],
            [40.0, 40.0, 20.0],
            [20.0, 40.0, 15.0],
            [10.0, 20.0, 25.0],
            [30.0, 10.0, 15.0]
          ]
        ]
      }

      assert PolygonM.to_wkb(polygon, mode: :hex) == wkb
    end

    test "returns WKB as ndr-binary from PolygonM with hole and SRID" do
      wkb = """
      01\
      03000060\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000003940\
      000000000080464000000000008046400000000000003440\
      0000000000002E4000000000000044400000000000002440\
      000000000000244000000000000034400000000000003940\
      000000000080414000000000000024400000000000003940\
      04000000\
      00000000000034400000000000003E400000000000002440\
      000000000080414000000000008041400000000000004940\
      0000000000003E4000000000000034400000000000804140\
      00000000000034400000000000003E400000000000002440\
      """

      polygon = %PolygonM{
        rings: [
          [
            [35.0, 10.0, 25.0],
            [45.0, 45.0, 20.0],
            [15.0, 40.0, 10.0],
            [10.0, 20.0, 25.0],
            [35.0, 10.0, 25.0]
          ],
          [
            [20.0, 30.0, 10.0],
            [35.0, 35.0, 50.0],
            [30.0, 20.0, 35.0],
            [20.0, 30.0, 10.0]
          ]
        ]
      }

      assert PolygonM.to_wkb(polygon, srid: 333, endian: :ndr) == Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from PolygonM with hole and SRID" do
      wkb = """
      01\
      03000060\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000003940\
      000000000080464000000000008046400000000000003440\
      0000000000002E4000000000000044400000000000002440\
      000000000000244000000000000034400000000000003940\
      000000000080414000000000000024400000000000003940\
      04000000\
      00000000000034400000000000003E400000000000002440\
      000000000080414000000000008041400000000000004940\
      0000000000003E4000000000000034400000000000804140\
      00000000000034400000000000003E400000000000002440\
      """

      polygon = %PolygonM{
        rings: [
          [
            [35.0, 10.0, 25.0],
            [45.0, 45.0, 20.0],
            [15.0, 40.0, 10.0],
            [10.0, 20.0, 25.0],
            [35.0, 10.0, 25.0]
          ],
          [
            [20.0, 30.0, 10.0],
            [35.0, 35.0, 50.0],
            [30.0, 20.0, 35.0],
            [20.0, 30.0, 10.0]
          ]
        ]
      }

      assert PolygonM.to_wkb(polygon, srid: 333, endian: :ndr, mode: :hex) == wkb
    end
  end

  describe "from_wkb!/1" do
    test "returns PolygonM (xdr)" do
      wkb = """
      00\
      40000003\
      00000001\
      00000005\
      403E0000000000004024000000000000402E000000000000\
      404400000000000040440000000000004034000000000000\
      40340000000000004044000000000000402E000000000000\
      402400000000000040340000000000004039000000000000\
      403E0000000000004024000000000000402E000000000000\
      """

      assert PolygonM.from_wkb!(wkb) ==
               %PolygonM{
                 rings: [
                   [
                     [30.0, 10.0, 15.0],
                     [40.0, 40.0, 20.0],
                     [20.0, 40.0, 15.0],
                     [10.0, 20.0, 25.0],
                     [30.0, 10.0, 15.0]
                   ]
                 ]
               }
    end

    test "returns PolygonM with hole and SRID (ndr) " do
      wkb = """
      01\
      03000060\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000003940\
      000000000080464000000000008046400000000000003440\
      0000000000002E4000000000000044400000000000002440\
      000000000000244000000000000034400000000000003940\
      000000000080414000000000000024400000000000003940\
      04000000\
      00000000000034400000000000003E400000000000002440\
      000000000080414000000000008041400000000000004940\
      0000000000003E4000000000000034400000000000804140\
      00000000000034400000000000003E400000000000002440\
      """

      assert PolygonM.from_wkb!(wkb) ==
               {%PolygonM{
                  rings: [
                    [
                      [35.0, 10.0, 25.0],
                      [45.0, 45.0, 20.0],
                      [15.0, 40.0, 10.0],
                      [10.0, 20.0, 25.0],
                      [35.0, 10.0, 25.0]
                    ],
                    [
                      [20.0, 30.0, 10.0],
                      [35.0, 35.0, 50.0],
                      [30.0, 20.0, 35.0],
                      [20.0, 30.0, 10.0]
                    ]
                  ]
                }, 333}
    end

    test "raises an error for an invalid WKB" do
      wkb = "ABCD"
      message = "expected endian flag '00' or '01', got 'AB', at position 0"

      assert_raise Geometry.Error, message, fn ->
        PolygonM.from_wkb!(wkb)
      end
    end
  end

  describe "from_geo_json!/1" do
    test "returns PolygonM" do
      geo_json =
        Jason.decode!("""
         {
           "type": "Polygon",
           "coordinates": [
             [[35, 10, 12],
              [45, 45, 22],
              [15, 40, 33],
              [10, 20, 55],
              [35, 10, 12]]
           ]
         }
        """)

      assert PolygonM.from_geo_json!(geo_json)

      %PolygonM{
        rings: [
          [
            [35, 10, 12],
            [45, 45, 22],
            [15, 40, 33],
            [10, 20, 55],
            [35, 10, 12]
          ]
        ]
      }
    end

    test "raises an error for an invalid GeoJson" do
      geo_json = %{}
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        PolygonM.from_geo_json!(geo_json)
      end
    end
  end

  describe "from_wkt!/1" do
    test "returns a PolygonM" do
      wkt = """
        POLYGON M (
          (35 10 22, 45 45 33, 15 40 44, 10 20 66, 35 10 22),
          (20 30 55, 35 35 66, 30 20 99, 20 30 55)
        )
      """

      assert PolygonM.from_wkt!(wkt) ==
               %PolygonM{
                 rings: [
                   [
                     [35, 10, 22],
                     [45, 45, 33],
                     [15, 40, 44],
                     [10, 20, 66],
                     [35, 10, 22]
                   ],
                   [
                     [20, 30, 55],
                     [35, 35, 66],
                     [30, 20, 99],
                     [20, 30, 55]
                   ]
                 ]
               }
    end

    test "returns a PolygonM with a hole and SRID" do
      wkt = """
        SRID=789;
        POLYGON M (
          (35 10 22, 45 45 33, 15 40 44, 10 20 66, 35 10 22),
          (20 30 55, 35 35 66, 30 20 99, 20 30 55)
        )
      """

      assert PolygonM.from_wkt!(wkt) ==
               {%PolygonM{
                  rings: [
                    [
                      [35, 10, 22],
                      [45, 45, 33],
                      [15, 40, 44],
                      [10, 20, 66],
                      [35, 10, 22]
                    ],
                    [
                      [20, 30, 55],
                      [35, 35, 66],
                      [30, 20, 99],
                      [20, 30, 55]
                    ]
                  ]
                }, 789}
    end

    test "raises an error for an invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Daisy'"

      assert_raise Geometry.Error, message, fn ->
        PolygonM.from_wkt!("Daisy")
      end
    end
  end

  describe "to_wkt/2:" do
    @tag :only
    prove PolygonM.to_wkt(PolygonM.new()) == "Polygon M EMPTY"

    @tag :only
    prove PolygonM.to_wkt(PolygonM.new(), srid: 1123) == "SRID=1123;Polygon M EMPTY"
  end

  describe "to_wkt/2" do
    @tag :only
    test "returns WKT" do
      polygon =
        PolygonM.new([
          LineStringM.new([
            PointM.new(35, 10, 14),
            PointM.new(45, 45, 24),
            PointM.new(10, 20, 34),
            PointM.new(35, 10, 14)
          ]),
          LineStringM.new([
            PointM.new(20, 30, 14),
            PointM.new(35, 35, 24),
            PointM.new(30, 20, 34),
            PointM.new(20, 30, 14)
          ])
        ])

      assert PolygonM.to_wkt(polygon) == """
             Polygon M (\
             (35 10 14, 45 45 24, 10 20 34, 35 10 14), \
             (20 30 14, 35 35 24, 30 20 34, 20 30 14)\
             )\
             """
    end
  end
end
