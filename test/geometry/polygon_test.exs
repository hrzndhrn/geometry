defmodule Geometry.PolygonTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{Hex, LineString, Point, Polygon}

  doctest Geometry.Polygon, import: true

  @moduletag :polygon

  describe "from_wkb/2" do
    test "returns Polygon from xdr-string" do
      wkb = """
      00\
      00000003\
      00000001\
      00000005\
      403E0000000000004024000000000000\
      40440000000000004044000000000000\
      40340000000000004044000000000000\
      40240000000000004034000000000000\
      403E0000000000004024000000000000\
      """

      assert Polygon.from_wkb(wkb, :hex) ==
               {:ok,
                %Polygon{
                  rings: [
                    [
                      [30.0, 10.0],
                      [40.0, 40.0],
                      [20.0, 40.0],
                      [10.0, 20.0],
                      [30.0, 10.0]
                    ]
                  ]
                }}
    end

    test "returns Polygon from xdr-binary" do
      wkb = """
      00\
      00000003\
      00000001\
      00000005\
      403E0000000000004024000000000000\
      40440000000000004044000000000000\
      40340000000000004044000000000000\
      40240000000000004034000000000000\
      403E0000000000004024000000000000\
      """

      assert wkb |> Hex.to_binary() |> Polygon.from_wkb() ==
               {:ok,
                %Polygon{
                  rings: [
                    [
                      [30.0, 10.0],
                      [40.0, 40.0],
                      [20.0, 40.0],
                      [10.0, 20.0],
                      [30.0, 10.0]
                    ]
                  ]
                }}
    end

    test "returns Polygon with hole and SRID from ndr-string" do
      wkb = """
      01\
      03000020\
      4D010000\
      02000000\
      05000000\
      00000000008041400000000000002440\
      00000000008046400000000000804640\
      0000000000002E400000000000004440\
      00000000000024400000000000003440\
      00000000008041400000000000002440\
      04000000\
      00000000000034400000000000003E40\
      00000000008041400000000000804140\
      0000000000003E400000000000003440\
      00000000000034400000000000003E40\
      """

      assert Polygon.from_wkb(wkb, :hex) ==
               {:ok,
                {
                  %Polygon{
                    rings: [
                      [
                        [35.0, 10.0],
                        [45.0, 45.0],
                        [15.0, 40.0],
                        [10.0, 20.0],
                        [35.0, 10.0]
                      ],
                      [
                        [20.0, 30.0],
                        [35.0, 35.0],
                        [30.0, 20.0],
                        [20.0, 30.0]
                      ]
                    ]
                  },
                  333
                }}
    end

    test "returns Polygon with hole and SRID from ndr-binary" do
      wkb = """
      01\
      03000020\
      4D010000\
      02000000\
      05000000\
      00000000008041400000000000002440\
      00000000008046400000000000804640\
      0000000000002E400000000000004440\
      00000000000024400000000000003440\
      00000000008041400000000000002440\
      04000000\
      00000000000034400000000000003E40\
      00000000008041400000000000804140\
      0000000000003E400000000000003440\
      00000000000034400000000000003E40\
      """

      assert wkb |> Hex.to_binary() |> Polygon.from_wkb() ==
               {:ok,
                {
                  %Polygon{
                    rings: [
                      [
                        [35.0, 10.0],
                        [45.0, 45.0],
                        [15.0, 40.0],
                        [10.0, 20.0],
                        [35.0, 10.0]
                      ],
                      [
                        [20.0, 30.0],
                        [35.0, 35.0],
                        [30.0, 20.0],
                        [20.0, 30.0]
                      ]
                    ]
                  },
                  333
                }}
    end
  end

  describe "to_wkb/1" do
    test "returns WKB as xdr-binary Polygon" do
      wkb = """
      00\
      00000003\
      00000001\
      00000005\
      403E0000000000004024000000000000\
      40440000000000004044000000000000\
      40340000000000004044000000000000\
      40240000000000004034000000000000\
      403E0000000000004024000000000000\
      """

      polygon = %Polygon{
        rings: [
          [
            [30.0, 10.0],
            [40.0, 40.0],
            [20.0, 40.0],
            [10.0, 20.0],
            [30.0, 10.0]
          ]
        ]
      }

      assert Polygon.to_wkb(polygon) == Hex.to_binary(wkb)
    end

    test "returns WKB as xdr-string Polygon" do
      wkb = """
      00\
      00000003\
      00000001\
      00000005\
      403E0000000000004024000000000000\
      40440000000000004044000000000000\
      40340000000000004044000000000000\
      40240000000000004034000000000000\
      403E0000000000004024000000000000\
      """

      polygon = %Polygon{
        rings: [
          [
            [30.0, 10.0],
            [40.0, 40.0],
            [20.0, 40.0],
            [10.0, 20.0],
            [30.0, 10.0]
          ]
        ]
      }

      assert Polygon.to_wkb(polygon, mode: :hex) == wkb
    end

    test "returns WKB as ndr-binary from Polygon with hole and SRID" do
      wkb = """
      01\
      03000020\
      4D010000\
      02000000\
      05000000\
      00000000008041400000000000002440\
      00000000008046400000000000804640\
      0000000000002E400000000000004440\
      00000000000024400000000000003440\
      00000000008041400000000000002440\
      04000000\
      00000000000034400000000000003E40\
      00000000008041400000000000804140\
      0000000000003E400000000000003440\
      00000000000034400000000000003E40\
      """

      polygon = %Polygon{
        rings: [
          [
            [35.0, 10.0],
            [45.0, 45.0],
            [15.0, 40.0],
            [10.0, 20.0],
            [35.0, 10.0]
          ],
          [
            [20.0, 30.0],
            [35.0, 35.0],
            [30.0, 20.0],
            [20.0, 30.0]
          ]
        ]
      }

      assert Polygon.to_wkb(polygon, srid: 333, endian: :ndr) == Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from Polygon with hole and SRID" do
      wkb = """
      01\
      03000020\
      4D010000\
      02000000\
      05000000\
      00000000008041400000000000002440\
      00000000008046400000000000804640\
      0000000000002E400000000000004440\
      00000000000024400000000000003440\
      00000000008041400000000000002440\
      04000000\
      00000000000034400000000000003E40\
      00000000008041400000000000804140\
      0000000000003E400000000000003440\
      00000000000034400000000000003E40\
      """

      polygon = %Polygon{
        rings: [
          [
            [35.0, 10.0],
            [45.0, 45.0],
            [15.0, 40.0],
            [10.0, 20.0],
            [35.0, 10.0]
          ],
          [
            [20.0, 30.0],
            [35.0, 35.0],
            [30.0, 20.0],
            [20.0, 30.0]
          ]
        ]
      }

      assert Polygon.to_wkb(polygon, srid: 333, endian: :ndr, mode: :hex) == wkb
    end

    test "returns WKB xdr-string from Polygon with SRID" do
      wkb = """
      00\
      20000003\
      00001267\
      00000001\
      00000004\
      403E0000000000004024000000000000\
      40440000000000004044000000000000\
      40340000000000004044000000000000\
      403E0000000000004024000000000000\
      """

      polygon =
        Polygon.new([
          LineString.new([
            Point.new(30, 10),
            Point.new(40, 40),
            Point.new(20, 40),
            Point.new(30, 10)
          ])
        ])

      srid = 4711

      assert Polygon.to_wkb(polygon, srid: srid, mode: :hex) == wkb
    end

    test "returns WKB xdr-binary from Polygon with SRID" do
      wkb = """
      00\
      20000003\
      00001267\
      00000001\
      00000004\
      403E0000000000004024000000000000\
      40440000000000004044000000000000\
      40340000000000004044000000000000\
      403E0000000000004024000000000000\
      """

      polygon =
        Polygon.new([
          LineString.new([
            Point.new(30, 10),
            Point.new(40, 40),
            Point.new(20, 40),
            Point.new(30, 10)
          ])
        ])

      srid = 4711

      assert Polygon.to_wkb(polygon, srid: srid) == Hex.to_binary(wkb)
    end
  end

  describe "from_wkb!/2" do
    test "returns Polygon from xdr-string" do
      wkb = """
      00\
      00000003\
      00000001\
      00000005\
      403E0000000000004024000000000000\
      40440000000000004044000000000000\
      40340000000000004044000000000000\
      40240000000000004034000000000000\
      403E0000000000004024000000000000\
      """

      assert Polygon.from_wkb!(wkb, :hex) ==
               %Polygon{
                 rings: [
                   [
                     [30.0, 10.0],
                     [40.0, 40.0],
                     [20.0, 40.0],
                     [10.0, 20.0],
                     [30.0, 10.0]
                   ]
                 ]
               }
    end

    test "returns Polygon from xdr-binary" do
      wkb = """
      00\
      00000003\
      00000001\
      00000005\
      403E0000000000004024000000000000\
      40440000000000004044000000000000\
      40340000000000004044000000000000\
      40240000000000004034000000000000\
      403E0000000000004024000000000000\
      """

      assert wkb |> Hex.to_binary() |> Polygon.from_wkb!() ==
               %Polygon{
                 rings: [
                   [
                     [30.0, 10.0],
                     [40.0, 40.0],
                     [20.0, 40.0],
                     [10.0, 20.0],
                     [30.0, 10.0]
                   ]
                 ]
               }
    end

    test "returns Polygon with hole and SRID from ndr-string" do
      wkb = """
      01\
      03000020\
      4D010000\
      02000000\
      05000000\
      00000000008041400000000000002440\
      00000000008046400000000000804640\
      0000000000002E400000000000004440\
      00000000000024400000000000003440\
      00000000008041400000000000002440\
      04000000\
      00000000000034400000000000003E40\
      00000000008041400000000000804140\
      0000000000003E400000000000003440\
      00000000000034400000000000003E40\
      """

      assert Polygon.from_wkb!(wkb, :hex) ==
               {%Polygon{
                  rings: [
                    [
                      [35.0, 10.0],
                      [45.0, 45.0],
                      [15.0, 40.0],
                      [10.0, 20.0],
                      [35.0, 10.0]
                    ],
                    [
                      [20.0, 30.0],
                      [35.0, 35.0],
                      [30.0, 20.0],
                      [20.0, 30.0]
                    ]
                  ]
                }, 333}
    end

    test "returns Polygon with hole and SRID from ndr-binary" do
      wkb = """
      01\
      03000020\
      4D010000\
      02000000\
      05000000\
      00000000008041400000000000002440\
      00000000008046400000000000804640\
      0000000000002E400000000000004440\
      00000000000024400000000000003440\
      00000000008041400000000000002440\
      04000000\
      00000000000034400000000000003E40\
      00000000008041400000000000804140\
      0000000000003E400000000000003440\
      00000000000034400000000000003E40\
      """

      assert wkb |> Hex.to_binary() |> Polygon.from_wkb!() ==
               {%Polygon{
                  rings: [
                    [
                      [35.0, 10.0],
                      [45.0, 45.0],
                      [15.0, 40.0],
                      [10.0, 20.0],
                      [35.0, 10.0]
                    ],
                    [
                      [20.0, 30.0],
                      [35.0, 35.0],
                      [30.0, 20.0],
                      [20.0, 30.0]
                    ]
                  ]
                }, 333}
    end

    test "raises an error for an invalid WKB string" do
      wkb = "ABCD"
      message = ~s(expected endian flag "00" or "01", got "AB", at position 0)

      assert_raise Geometry.Error, message, fn ->
        Polygon.from_wkb!(wkb, :hex)
      end
    end

    test "raises an error for an invalid WKB binary" do
      wkb = "ABCD"
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        Polygon.from_wkb!(wkb)
      end
    end
  end

  describe "from_geo_json!/1" do
    test "returns Polygon" do
      geo_json =
        Jason.decode!("""
         {
           "type": "Polygon",
           "coordinates": [
             [[35, 10],
              [45, 45],
              [15, 40],
              [10, 20],
              [35, 10]]
           ]
         }
        """)

      assert Polygon.from_geo_json!(geo_json)

      %Polygon{
        rings: [
          [
            [35, 10],
            [45, 45],
            [15, 40],
            [10, 20],
            [35, 10]
          ]
        ]
      }
    end

    test "raises an error for an invalid GeoJson" do
      geo_json = %{}
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        Polygon.from_geo_json!(geo_json)
      end
    end
  end

  describe "from_wkt!/1" do
    test "returns a Polygon" do
      wkt = """
        POLYGON (
          (35 10, 45 45, 15 40, 10 20, 35 10),
          (20 30, 35 35, 30 20, 20 30)
        )
      """

      assert Polygon.from_wkt!(wkt) ==
               %Polygon{
                 rings: [
                   [
                     [35, 10],
                     [45, 45],
                     [15, 40],
                     [10, 20],
                     [35, 10]
                   ],
                   [
                     [20, 30],
                     [35, 35],
                     [30, 20],
                     [20, 30]
                   ]
                 ]
               }
    end

    test "returns a Polygon with a hole and SRID" do
      wkt = """
        SRID=789;
        POLYGON (
          (35 10, 45 45, 15 40, 10 20, 35 10),
          (20 30, 35 35, 30 20, 20 30)
        )
      """

      assert Polygon.from_wkt!(wkt) ==
               {%Polygon{
                  rings: [
                    [
                      [35, 10],
                      [45, 45],
                      [15, 40],
                      [10, 20],
                      [35, 10]
                    ],
                    [
                      [20, 30],
                      [35, 35],
                      [30, 20],
                      [20, 30]
                    ]
                  ]
                }, 789}
    end

    test "raises an error for an invalid WKT" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "Daisy")

      assert_raise Geometry.Error, message, fn ->
        Polygon.from_wkt!("Daisy")
      end
    end
  end

  describe "to_wkt/2:" do
    prove Polygon.to_wkt(Polygon.new()) == "Polygon EMPTY"

    prove Polygon.to_wkt(Polygon.new(), srid: 1123) == "SRID=1123;Polygon EMPTY"
  end

  describe "to_wkt/2" do
    test "returns WKT" do
      polygon =
        Polygon.new([
          LineString.new([
            Point.new(35, 10),
            Point.new(45, 45),
            Point.new(10, 20),
            Point.new(35, 10)
          ]),
          LineString.new([
            Point.new(20, 30),
            Point.new(35, 35),
            Point.new(30, 20),
            Point.new(20, 30)
          ])
        ])

      assert Polygon.to_wkt(polygon) == """
             Polygon (\
             (35 10, 45 45, 10 20, 35 10), \
             (20 30, 35 35, 30 20, 20 30)\
             )\
             """
    end
  end
end
