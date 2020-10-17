defmodule Geometry.PolygonZTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{PointZ, PolygonZ}

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
                  exterior: [
                    %PointZ{x: 30.0, y: 10.0, z: 20.0},
                    %PointZ{x: 40.0, y: 40.0, z: 10.0},
                    %PointZ{x: 20.0, y: 40.0, z: 25.0},
                    %PointZ{x: 10.0, y: 20.0, z: 15.0},
                    %PointZ{x: 30.0, y: 10.0, z: 20.0}
                  ],
                  interiors: []
                }}
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

      assert PolygonZ.from_wkb(wkb) ==
               {:ok,
                %PolygonZ{
                  exterior: [
                    %PointZ{x: 35.0, y: 10.0, z: 15.0},
                    %PointZ{x: 45.0, y: 45.0, z: 10.0},
                    %PointZ{x: 15.0, y: 40.0, z: 20.0},
                    %PointZ{x: 10.0, y: 20.0, z: 15.0},
                    %PointZ{x: 35.0, y: 10.0, z: 15.0}
                  ],
                  interiors: [
                    [
                      %PointZ{x: 20.0, y: 30.0, z: 15.0},
                      %PointZ{x: 35.0, y: 35.0, z: 10.0},
                      %PointZ{x: 30.0, y: 20.0, z: 25.0},
                      %PointZ{x: 20.0, y: 30.0, z: 15.0}
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
        exterior: [
          %PointZ{x: 30.0, y: 10.0, z: 20.0},
          %PointZ{x: 40.0, y: 40.0, z: 10.0},
          %PointZ{x: 20.0, y: 40.0, z: 25.0},
          %PointZ{x: 10.0, y: 20.0, z: 15.0},
          %PointZ{x: 30.0, y: 10.0, z: 20.0}
        ],
        interiors: []
      }

      assert PolygonZ.to_wkb(polygon, endian: :xdr) == wkb
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
        exterior: [
          %PointZ{x: 35.0, y: 10.0, z: 15.0},
          %PointZ{x: 45.0, y: 45.0, z: 10.0},
          %PointZ{x: 15.0, y: 40.0, z: 20.0},
          %PointZ{x: 10.0, y: 20.0, z: 15.0},
          %PointZ{x: 35.0, y: 10.0, z: 15.0}
        ],
        interiors: [
          [
            %PointZ{x: 20.0, y: 30.0, z: 15.0},
            %PointZ{x: 35.0, y: 35.0, z: 10.0},
            %PointZ{x: 30.0, y: 20.0, z: 25.0},
            %PointZ{x: 20.0, y: 30.0, z: 15.0}
          ]
        ]
      }

      assert PolygonZ.to_wkb(polygon, srid: 333) == wkb
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
                 exterior: [
                   %PointZ{x: 30.0, y: 10.0, z: 20.0},
                   %PointZ{x: 40.0, y: 40.0, z: 10.0},
                   %PointZ{x: 20.0, y: 40.0, z: 25.0},
                   %PointZ{x: 10.0, y: 20.0, z: 15.0},
                   %PointZ{x: 30.0, y: 10.0, z: 20.0}
                 ],
                 interiors: []
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
                  exterior: [
                    %PointZ{x: 35.0, y: 10.0, z: 15.0},
                    %PointZ{x: 45.0, y: 45.0, z: 10.0},
                    %PointZ{x: 15.0, y: 40.0, z: 20.0},
                    %PointZ{x: 10.0, y: 20.0, z: 15.0},
                    %PointZ{x: 35.0, y: 10.0, z: 15.0}
                  ],
                  interiors: [
                    [
                      %PointZ{x: 20.0, y: 30.0, z: 15.0},
                      %PointZ{x: 35.0, y: 35.0, z: 10.0},
                      %PointZ{x: 30.0, y: 20.0, z: 25.0},
                      %PointZ{x: 20.0, y: 30.0, z: 15.0}
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
        exterior: [
          %PointZ{x: 35, y: 10, z: 11},
          %PointZ{x: 45, y: 45, z: 21},
          %PointZ{x: 15, y: 40, z: 31},
          %PointZ{x: 10, y: 20, z: 11},
          %PointZ{x: 35, y: 10, z: 11}
        ],
        interiors: []
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
                 exterior: [
                   %PointZ{x: 35, y: 10, z: 11},
                   %PointZ{x: 45, y: 45, z: 22},
                   %PointZ{x: 15, y: 40, z: 33},
                   %PointZ{x: 10, y: 20, z: 55},
                   %PointZ{x: 35, y: 10, z: 11}
                 ],
                 interiors: [
                   [
                     %PointZ{x: 20, y: 30, z: 22},
                     %PointZ{x: 35, y: 35, z: 33},
                     %PointZ{x: 30, y: 20, z: 88},
                     %PointZ{x: 20, y: 30, z: 22}
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
                  exterior: [
                    %PointZ{x: 35, y: 10, z: 11},
                    %PointZ{x: 45, y: 45, z: 22},
                    %PointZ{x: 15, y: 40, z: 33},
                    %PointZ{x: 10, y: 20, z: 55},
                    %PointZ{x: 35, y: 10, z: 11}
                  ],
                  interiors: [
                    [
                      %PointZ{x: 20, y: 30, z: 22},
                      %PointZ{x: 35, y: 35, z: 33},
                      %PointZ{x: 30, y: 20, z: 88},
                      %PointZ{x: 20, y: 30, z: 22}
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
end
