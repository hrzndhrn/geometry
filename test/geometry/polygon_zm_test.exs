defmodule Geometry.PolygonZMTest do
  use ExUnit.Case, async: true

  alias Geometry.{PointZM, PolygonZM}

  doctest Geometry.PolygonZM, import: true

  describe "from_wkb/1" do
    test "returns PolygonZM (xdr)" do
      wkb = """
      00\
      C0000003\
      00000001\
      00000005\
      403E00000000000040240000000000004034000000000000402E000000000000\
      4044000000000000404400000000000040240000000000004034000000000000\
      403400000000000040440000000000004039000000000000402E000000000000\
      40240000000000004034000000000000402E0000000000004039000000000000\
      403E00000000000040240000000000004034000000000000402E000000000000\
      """

      assert PolygonZM.from_wkb(wkb) ==
               {:ok,
                %PolygonZM{
                  exterior: [
                    %PointZM{x: 30.0, y: 10.0, z: 20.0, m: 15.0},
                    %PointZM{x: 40.0, y: 40.0, z: 10.0, m: 20.0},
                    %PointZM{x: 20.0, y: 40.0, z: 25.0, m: 15.0},
                    %PointZM{x: 10.0, y: 20.0, z: 15.0, m: 25.0},
                    %PointZM{x: 30.0, y: 10.0, z: 20.0, m: 15.0}
                  ],
                  interiors: []
                }}
    end

    test "returns PolygonZM with hole and SRID (ndr) " do
      wkb = """
      01\
      030000E0\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000002E400000000000003940\
      0000000000804640000000000080464000000000000024400000000000003440\
      0000000000002E40000000000000444000000000000034400000000000002440\
      000000000000244000000000000034400000000000002E400000000000003940\
      000000000080414000000000000024400000000000002E400000000000003940\
      04000000\
      00000000000034400000000000003E400000000000002E400000000000002440\
      0000000000804140000000000080414000000000000024400000000000004940\
      0000000000003E40000000000000344000000000000039400000000000804140\
      00000000000034400000000000003E400000000000002E400000000000002440\
      """

      assert PolygonZM.from_wkb(wkb) ==
               {:ok,
                %PolygonZM{
                  exterior: [
                    %PointZM{x: 35.0, y: 10.0, z: 15.0, m: 25.0},
                    %PointZM{x: 45.0, y: 45.0, z: 10.0, m: 20.0},
                    %PointZM{x: 15.0, y: 40.0, z: 20.0, m: 10.0},
                    %PointZM{x: 10.0, y: 20.0, z: 15.0, m: 25.0},
                    %PointZM{x: 35.0, y: 10.0, z: 15.0, m: 25.0}
                  ],
                  interiors: [
                    [
                      %PointZM{x: 20.0, y: 30.0, z: 15.0, m: 10.0},
                      %PointZM{x: 35.0, y: 35.0, z: 10.0, m: 50.0},
                      %PointZM{x: 30.0, y: 20.0, z: 25.0, m: 35.0},
                      %PointZM{x: 20.0, y: 30.0, z: 15.0, m: 10.0}
                    ]
                  ]
                }, 333}
    end
  end

  describe "to_wkb/1" do
    test "returns PolygonZM (xdr)" do
      wkb = """
      00\
      C0000003\
      00000001\
      00000005\
      403E00000000000040240000000000004034000000000000402E000000000000\
      4044000000000000404400000000000040240000000000004034000000000000\
      403400000000000040440000000000004039000000000000402E000000000000\
      40240000000000004034000000000000402E0000000000004039000000000000\
      403E00000000000040240000000000004034000000000000402E000000000000\
      """

      polygon = %PolygonZM{
        exterior: [
          %PointZM{x: 30.0, y: 10.0, z: 20.0, m: 15.0},
          %PointZM{x: 40.0, y: 40.0, z: 10.0, m: 20.0},
          %PointZM{x: 20.0, y: 40.0, z: 25.0, m: 15.0},
          %PointZM{x: 10.0, y: 20.0, z: 15.0, m: 25.0},
          %PointZM{x: 30.0, y: 10.0, z: 20.0, m: 15.0}
        ],
        interiors: []
      }

      assert PolygonZM.to_wkb(polygon, endian: :xdr) == wkb
    end

    test "returns PolygonZM with hole and SRID (ndr) " do
      wkb = """
      01\
      030000E0\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000002E400000000000003940\
      0000000000804640000000000080464000000000000024400000000000003440\
      0000000000002E40000000000000444000000000000034400000000000002440\
      000000000000244000000000000034400000000000002E400000000000003940\
      000000000080414000000000000024400000000000002E400000000000003940\
      04000000\
      00000000000034400000000000003E400000000000002E400000000000002440\
      0000000000804140000000000080414000000000000024400000000000004940\
      0000000000003E40000000000000344000000000000039400000000000804140\
      00000000000034400000000000003E400000000000002E400000000000002440\
      """

      polygon = %PolygonZM{
        exterior: [
          %PointZM{x: 35.0, y: 10.0, z: 15.0, m: 25.0},
          %PointZM{x: 45.0, y: 45.0, z: 10.0, m: 20.0},
          %PointZM{x: 15.0, y: 40.0, z: 20.0, m: 10.0},
          %PointZM{x: 10.0, y: 20.0, z: 15.0, m: 25.0},
          %PointZM{x: 35.0, y: 10.0, z: 15.0, m: 25.0}
        ],
        interiors: [
          [
            %PointZM{x: 20.0, y: 30.0, z: 15.0, m: 10.0},
            %PointZM{x: 35.0, y: 35.0, z: 10.0, m: 50.0},
            %PointZM{x: 30.0, y: 20.0, z: 25.0, m: 35.0},
            %PointZM{x: 20.0, y: 30.0, z: 15.0, m: 10.0}
          ]
        ]
      }

      assert PolygonZM.to_wkb(polygon, srid: 333) == wkb
    end
  end

  describe "from_wkb!/1" do
    test "returns PolygonZM (xdr)" do
      wkb = """
      00\
      C0000003\
      00000001\
      00000005\
      403E00000000000040240000000000004034000000000000402E000000000000\
      4044000000000000404400000000000040240000000000004034000000000000\
      403400000000000040440000000000004039000000000000402E000000000000\
      40240000000000004034000000000000402E0000000000004039000000000000\
      403E00000000000040240000000000004034000000000000402E000000000000\
      """

      assert PolygonZM.from_wkb!(wkb) ==
               %PolygonZM{
                 exterior: [
                   %PointZM{x: 30.0, y: 10.0, z: 20.0, m: 15.0},
                   %PointZM{x: 40.0, y: 40.0, z: 10.0, m: 20.0},
                   %PointZM{x: 20.0, y: 40.0, z: 25.0, m: 15.0},
                   %PointZM{x: 10.0, y: 20.0, z: 15.0, m: 25.0},
                   %PointZM{x: 30.0, y: 10.0, z: 20.0, m: 15.0}
                 ],
                 interiors: []
               }
    end

    test "returns PolygonZM with hole and SRID (ndr) " do
      wkb = """
      01\
      030000E0\
      4D010000\
      02000000\
      05000000\
      000000000080414000000000000024400000000000002E400000000000003940\
      0000000000804640000000000080464000000000000024400000000000003440\
      0000000000002E40000000000000444000000000000034400000000000002440\
      000000000000244000000000000034400000000000002E400000000000003940\
      000000000080414000000000000024400000000000002E400000000000003940\
      04000000\
      00000000000034400000000000003E400000000000002E400000000000002440\
      0000000000804140000000000080414000000000000024400000000000004940\
      0000000000003E40000000000000344000000000000039400000000000804140\
      00000000000034400000000000003E400000000000002E400000000000002440\
      """

      assert PolygonZM.from_wkb!(wkb) ==
               {%PolygonZM{
                  exterior: [
                    %PointZM{x: 35.0, y: 10.0, z: 15.0, m: 25.0},
                    %PointZM{x: 45.0, y: 45.0, z: 10.0, m: 20.0},
                    %PointZM{x: 15.0, y: 40.0, z: 20.0, m: 10.0},
                    %PointZM{x: 10.0, y: 20.0, z: 15.0, m: 25.0},
                    %PointZM{x: 35.0, y: 10.0, z: 15.0, m: 25.0}
                  ],
                  interiors: [
                    [
                      %PointZM{x: 20.0, y: 30.0, z: 15.0, m: 10.0},
                      %PointZM{x: 35.0, y: 35.0, z: 10.0, m: 50.0},
                      %PointZM{x: 30.0, y: 20.0, z: 25.0, m: 35.0},
                      %PointZM{x: 20.0, y: 30.0, z: 15.0, m: 10.0}
                    ]
                  ]
                }, 333}
    end

    test "raises an error for an invalid WKB" do
      wkb = "ABCD"
      message = "expected endian flag '00' or '01', got 'AB', at position 0"

      assert_raise Geometry.Error, message, fn ->
        PolygonZM.from_wkb!(wkb)
      end
    end
  end

  describe "from_geo_json!/1" do
    test "returns PolygonZM" do
      geo_json =
        Jason.decode!("""
         {
           "type": "Polygon",
           "coordinates": [
             [[35, 10, 11, 12],
              [45, 45, 21, 22],
              [15, 40, 31, 33],
              [10, 20, 11, 55],
              [35, 10, 11, 12]]
           ]
         }
        """)

      assert PolygonZM.from_geo_json!(geo_json)

      %PolygonZM{
        exterior: [
          %PointZM{x: 35, y: 10, z: 11, m: 12},
          %PointZM{x: 45, y: 45, z: 21, m: 22},
          %PointZM{x: 15, y: 40, z: 31, m: 33},
          %PointZM{x: 10, y: 20, z: 11, m: 55},
          %PointZM{x: 35, y: 10, z: 11, m: 12}
        ],
        interiors: []
      }
    end

    test "raises an error for an invalid GeoJson" do
      geo_json = %{}
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        PolygonZM.from_geo_json!(geo_json)
      end
    end
  end

  describe "from_wkt!/1" do
    test "returns a PolygonZM" do
      wkt = """
        POLYGON ZM (
          (35 10 11 22, 45 45 22 33, 15 40 33 44, 10 20 55 66, 35 10 11 22),
          (20 30 22 55, 35 35 33 66, 30 20 88 99, 20 30 22 55)
        )
      """

      assert PolygonZM.from_wkt!(wkt) ==
               %PolygonZM{
                 exterior: [
                   %PointZM{x: 35, y: 10, z: 11, m: 22},
                   %PointZM{x: 45, y: 45, z: 22, m: 33},
                   %PointZM{x: 15, y: 40, z: 33, m: 44},
                   %PointZM{x: 10, y: 20, z: 55, m: 66},
                   %PointZM{x: 35, y: 10, z: 11, m: 22}
                 ],
                 interiors: [
                   [
                     %PointZM{x: 20, y: 30, z: 22, m: 55},
                     %PointZM{x: 35, y: 35, z: 33, m: 66},
                     %PointZM{x: 30, y: 20, z: 88, m: 99},
                     %PointZM{x: 20, y: 30, z: 22, m: 55}
                   ]
                 ]
               }
    end

    test "returns a PolygonZM with a hole and SRID" do
      wkt = """
        SRID=789;
        POLYGON ZM (
          (35 10 11 22, 45 45 22 33, 15 40 33 44, 10 20 55 66, 35 10 11 22),
          (20 30 22 55, 35 35 33 66, 30 20 88 99, 20 30 22 55)
        )
      """

      assert PolygonZM.from_wkt!(wkt) ==
               {%PolygonZM{
                  exterior: [
                    %PointZM{x: 35, y: 10, z: 11, m: 22},
                    %PointZM{x: 45, y: 45, z: 22, m: 33},
                    %PointZM{x: 15, y: 40, z: 33, m: 44},
                    %PointZM{x: 10, y: 20, z: 55, m: 66},
                    %PointZM{x: 35, y: 10, z: 11, m: 22}
                  ],
                  interiors: [
                    [
                      %PointZM{x: 20, y: 30, z: 22, m: 55},
                      %PointZM{x: 35, y: 35, z: 33, m: 66},
                      %PointZM{x: 30, y: 20, z: 88, m: 99},
                      %PointZM{x: 20, y: 30, z: 22, m: 55}
                    ]
                  ]
                }, 789}
    end

    test "raises an error for an invalid WKT" do
      message = "expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: 'Daisy'"

      assert_raise Geometry.Error, message, fn ->
        PolygonZM.from_wkt!("Daisy")
      end
    end
  end
end
