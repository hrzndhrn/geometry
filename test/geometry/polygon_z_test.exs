defmodule Geometry.PolygonZTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{LineStringZ, PointZ, PolygonZ}

  doctest Geometry.PolygonZ, import: true

  describe "from_wkb/1" do
    test "returns PolygonZ (xdr)" do
      wkb = """
      00\
      80000003\
      00000001\
      00000005\
      403E00000000000040240000000000004034000000000000\
      404400000000000040440000000000004024000000000000\
      403400000000000040440000000000004039000000000000\
      40240000000000004034000000000000402E000000000000\
      403E00000000000040240000000000004034000000000000\
      """

      assert PolygonZ.from_wkb(wkb) ==
               {:ok,
                %PolygonZ{
                  rings: [
                    [
                      [30.0, 10.0, 20.0],
                      [40.0, 40.0, 10.0],
                      [20.0, 40.0, 25.0],
                      [10.0, 20.0, 15.0],
                      [30.0, 10.0, 20.0]
                    ]
                  ]
                }}
    end

    @tag :only
    test "returns PolygonZ with hole and SRID (ndr) " do
      wkb = """
      01\
      030000A0\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000002E40\
      000000000080464000000000008046400000000000002440\
      0000000000002E4000000000000044400000000000003440\
      000000000000244000000000000034400000000000002E40\
      000000000080414000000000000024400000000000002E40\
      04000000\
      00000000000034400000000000003E400000000000002E40\
      000000000080414000000000008041400000000000002440\
      0000000000003E4000000000000034400000000000003940\
      00000000000034400000000000003E400000000000002E40\
      """

      assert PolygonZ.from_wkb(wkb) ==
               {:ok,
                %PolygonZ{
                  rings: [
                    [
                      [35.0, 10.0, 15.0],
                      [45.0, 45.0, 10.0],
                      [15.0, 40.0, 20.0],
                      [10.0, 20.0, 15.0],
                      [35.0, 10.0, 15.0]
                    ],
                    [
                      [20.0, 30.0, 15.0],
                      [35.0, 35.0, 10.0],
                      [30.0, 20.0, 25.0],
                      [20.0, 30.0, 15.0]
                    ]
                  ]
                }, 333}
    end
  end

  describe "to_wkb/1" do
    test "returns PolygonZ (xdr)" do
      wkb = """
      00\
      80000003\
      00000001\
      00000005\
      403E00000000000040240000000000004034000000000000\
      404400000000000040440000000000004024000000000000\
      403400000000000040440000000000004039000000000000\
      40240000000000004034000000000000402E000000000000\
      403E00000000000040240000000000004034000000000000\
      """

      polygon = %PolygonZ{
        rings: [
          [
            [30.0, 10.0, 20.0],
            [40.0, 40.0, 10.0],
            [20.0, 40.0, 25.0],
            [10.0, 20.0, 15.0],
            [30.0, 10.0, 20.0]
          ]
        ]
      }

      assert PolygonZ.to_wkb(polygon) == wkb
    end

    test "returns PolygonZ with hole and SRID (ndr) " do
      wkb = """
      01\
      030000A0\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000002E40\
      000000000080464000000000008046400000000000002440\
      0000000000002E4000000000000044400000000000003440\
      000000000000244000000000000034400000000000002E40\
      000000000080414000000000000024400000000000002E40\
      04000000\
      00000000000034400000000000003E400000000000002E40\
      000000000080414000000000008041400000000000002440\
      0000000000003E4000000000000034400000000000003940\
      00000000000034400000000000003E400000000000002E40\
      """

      polygon = %PolygonZ{
        rings: [
          [
            [35.0, 10.0, 15.0],
            [45.0, 45.0, 10.0],
            [15.0, 40.0, 20.0],
            [10.0, 20.0, 15.0],
            [35.0, 10.0, 15.0]
          ],
          [
            [20.0, 30.0, 15.0],
            [35.0, 35.0, 10.0],
            [30.0, 20.0, 25.0],
            [20.0, 30.0, 15.0]
          ]
        ]
      }

      assert PolygonZ.to_wkb(polygon, srid: 333, endian: :ndr) == wkb
    end
  end

  describe "from_wkb!/1" do
    test "returns PolygonZ (xdr)" do
      wkb = """
      00\
      80000003\
      00000001\
      00000005\
      403E00000000000040240000000000004034000000000000\
      404400000000000040440000000000004024000000000000\
      403400000000000040440000000000004039000000000000\
      40240000000000004034000000000000402E000000000000\
      403E00000000000040240000000000004034000000000000\
      """

      assert PolygonZ.from_wkb!(wkb) ==
               %PolygonZ{
                 rings: [
                   [
                     [30.0, 10.0, 20.0],
                     [40.0, 40.0, 10.0],
                     [20.0, 40.0, 25.0],
                     [10.0, 20.0, 15.0],
                     [30.0, 10.0, 20.0]
                   ]
                 ]
               }
    end

    test "returns PolygonZ with hole and SRID (ndr) " do
      wkb = """
      01\
      030000A0\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000002E40\
      000000000080464000000000008046400000000000002440\
      0000000000002E4000000000000044400000000000003440\
      000000000000244000000000000034400000000000002E40\
      000000000080414000000000000024400000000000002E40\
      04000000\
      00000000000034400000000000003E400000000000002E40\
      000000000080414000000000008041400000000000002440\
      0000000000003E4000000000000034400000000000003940\
      00000000000034400000000000003E400000000000002E40\
      """

      assert PolygonZ.from_wkb!(wkb) ==
               {%PolygonZ{
                  rings: [
                    [
                      [35.0, 10.0, 15.0],
                      [45.0, 45.0, 10.0],
                      [15.0, 40.0, 20.0],
                      [10.0, 20.0, 15.0],
                      [35.0, 10.0, 15.0]
                    ],
                    [
                      [20.0, 30.0, 15.0],
                      [35.0, 35.0, 10.0],
                      [30.0, 20.0, 25.0],
                      [20.0, 30.0, 15.0]
                    ]
                  ]
                }, 333}
    end

    test "raises an error for an invalid WKB" do
      wkb = "ABCD"
      message = "expected endian flag '00' or '01', got 'AB', at position 0"

      assert_raise Geometry.Error, message, fn ->
        PolygonZ.from_wkb!(wkb)
      end
    end
  end

  describe "from_geo_json!/1" do
    test "returns PolygonZ" do
      geo_json =
        Jason.decode!("""
         {
           "type": "Polygon",
           "coordinates": [
             [[35, 10, 11],
              [45, 45, 21],
              [15, 40, 31],
              [10, 20, 11],
              [35, 10, 11]]
           ]
         }
        """)

      assert PolygonZ.from_geo_json!(geo_json)

      %PolygonZ{
        rings: [
          [
            [35, 10, 11],
            [45, 45, 21],
            [15, 40, 31],
            [10, 20, 11],
            [35, 10, 11]
          ]
        ]
      }
    end

    test "raises an error for an invalid GeoJson" do
      geo_json = %{}
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        PolygonZ.from_geo_json!(geo_json)
      end
    end
  end

  describe "from_wkt!/1" do
    test "returns a PolygonZ" do
      wkt = """
        POLYGON Z (
          (35 10 11, 45 45 22, 15 40 33, 10 20 55, 35 10 11),
          (20 30 22, 35 35 33, 30 20 88, 20 30 22)
        )
      """

      assert PolygonZ.from_wkt!(wkt) ==
               %PolygonZ{
                 rings: [
                   [
                     [35, 10, 11],
                     [45, 45, 22],
                     [15, 40, 33],
                     [10, 20, 55],
                     [35, 10, 11]
                   ],
                   [
                     [20, 30, 22],
                     [35, 35, 33],
                     [30, 20, 88],
                     [20, 30, 22]
                   ]
                 ]
               }
    end

    test "returns a PolygonZ with a hole and SRID" do
      wkt = """
        SRID=789;
        POLYGON Z (
          (35 10 11, 45 45 22, 15 40 33, 10 20 55, 35 10 11),
          (20 30 22, 35 35 33, 30 20 88, 20 30 22)
        )
      """

      assert PolygonZ.from_wkt!(wkt) ==
               {%PolygonZ{
                  rings: [
                    [
                      [35, 10, 11],
                      [45, 45, 22],
                      [15, 40, 33],
                      [10, 20, 55],
                      [35, 10, 11]
                    ],
                    [
                      [20, 30, 22],
                      [35, 35, 33],
                      [30, 20, 88],
                      [20, 30, 22]
                    ]
                  ]
                }, 789}
    end

    test "raises an error for an invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Daisy'"

      assert_raise Geometry.Error, message, fn ->
        PolygonZ.from_wkt!("Daisy")
      end
    end
  end

  describe "to_wkt/2:" do
    @tag :only
    prove PolygonZ.to_wkt(PolygonZ.new()) == "Polygon Z EMPTY"

    @tag :only
    prove PolygonZ.to_wkt(PolygonZ.new(), srid: 1123) == "SRID=1123;Polygon Z EMPTY"
  end

  describe "to_wkt/2" do
    @tag :only
    test "returns WKT" do
      polygon =
        PolygonZ.new([
          LineStringZ.new([
            PointZ.new(35, 10, 13),
            PointZ.new(45, 45, 23),
            PointZ.new(10, 20, 33),
            PointZ.new(35, 10, 13)
          ]),
          LineStringZ.new([
            PointZ.new(20, 30, 13),
            PointZ.new(35, 35, 23),
            PointZ.new(30, 20, 33),
            PointZ.new(20, 30, 13)
          ])
        ])

      assert PolygonZ.to_wkt(polygon) == """
             Polygon Z (\
             (35 10 13, 45 45 23, 10 20 33, 35 10 13), \
             (20 30 13, 35 35 23, 30 20 33, 20 30 13)\
             )\
             """
    end
  end
end
