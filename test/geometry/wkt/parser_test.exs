defmodule Geometry.WKT.ParserTest do
  use ExUnit.Case, async: true

  import Prove

  alias Geometry.WKT.Parser

  alias Geometry.{
    LineString,
    LineStringM,
    LineStringZ,
    LineStringZM,
    MultiLineString,
    MultiLineStringM,
    MultiLineStringZ,
    MultiLineStringZM,
    MultiPoint,
    MultiPointM,
    MultiPointZ,
    MultiPointZM,
    MultiPointZM,
    MultiPolygon,
    MultiPolygonM,
    MultiPolygonZ,
    MultiPolygonZM,
    Point,
    PointM,
    PointZ,
    PointZM,
    Polygon,
    PolygonM,
    PolygonZ,
    PolygonZM
  }

  describe "Point (Z/M/ZM):" do
    prove Parser.parse("Point(1 2)") == {:ok, %Point{x: 1, y: 2}}
    prove Parser.parse("POINT ( -1.5 2.66 ) ") == {:ok, %Point{x: -1.5, y: 2.66}}
    prove Parser.parse("Point Z (1 2 3)") == {:ok, %PointZ{x: 1, y: 2, z: 3}}
    prove Parser.parse("POINTZ(1 2 3)") == {:ok, %PointZ{x: 1, y: 2, z: 3}}
    prove Parser.parse("POINT M(1 2 3)") == {:ok, %PointM{x: 1, y: 2, m: 3}}
    prove Parser.parse("point zm(1 2 3 4)   ") == {:ok, %PointZM{x: 1, y: 2, z: 3, m: 4}}
    prove Parser.parse("Point(1 2) ignore") == {:ok, %Point{x: 1, y: 2}}
    @tag :only
    prove Parser.parse("Point Z EMPTY") == {:ok, %PointZ{}}
  end

  describe "Point from EWKT:" do
    prove Parser.parse("SRID=4437;Point(1 2)") == {:ok, %Point{x: 1, y: 2}, 4437}
    prove Parser.parse(" SriD = 1 ; Point(1 2)") == {:ok, %Point{x: 1, y: 2}, 1}
  end

  describe "Point" do
    test "from multiline string" do
      wkt = """
      Point(
        1.2
        2.3
      )
      """

      assert Parser.parse(wkt) == {:ok, %Point{x: 1.2, y: 2.3}}
    end
  end

  describe "LineString (Z/M/ZM):" do
    prove Parser.parse("LineString(1 2, 3 4)") ==
            {:ok,
             %LineString{
               points: [%Point{x: 1, y: 2}, %Point{x: 3, y: 4}]
             }}

    prove Parser.parse("linestring Z(-1.9 2.9 5.1, 3.6 4.4 5.5, 1.1 2.2 3.3)") ==
            {:ok,
             %LineStringZ{
               points: [
                 %PointZ{x: -1.9, y: 2.9, z: 5.1},
                 %PointZ{x: 3.6, y: 4.4, z: 5.5},
                 %PointZ{x: 1.1, y: 2.2, z: 3.3}
               ]
             }}

    prove Parser.parse("linestringm(-1.9 2.9 5.1, 3.6 4.4 5.5, 1.1 2.2 3.3)") ==
            {:ok,
             %LineStringM{
               points: [
                 %PointM{x: -1.9, y: 2.9, m: 5.1},
                 %PointM{x: 3.6, y: 4.4, m: 5.5},
                 %PointM{x: 1.1, y: 2.2, m: 3.3}
               ]
             }}

    prove Parser.parse("LineStringZM(1 2 3 4, 5 6 7 8)") ==
            {:ok,
             %LineStringZM{
               points: [
                 %PointZM{x: 1, y: 2, z: 3, m: 4},
                 %PointZM{x: 5, y: 6, z: 7, m: 8}
               ]
             }}

    prove Parser.parse("LineString(1 2, 4 5) foo") ==
            {:ok,
             %LineString{
               points: [
                 %Point{x: 1, y: 2},
                 %Point{x: 4, y: 5}
               ]
             }}
  end

  describe "Polygon (Z/M/ZM):" do
    test "simple Polygon without holes" do
      polygon = "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %Polygon{
                   exterior: [
                     %Point{x: 30, y: 10},
                     %Point{x: 40, y: 40},
                     %Point{x: 20, y: 40},
                     %Point{x: 10, y: 20},
                     %Point{x: 30, y: 10}
                   ],
                   interiors: []
                 }
               }
    end

    test "simple PolygonM without holes" do
      polygon = "POLYGONM ((30 10 1, 40 40 2, 20 40 3, 10 20 4, 30 10 1))"

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %PolygonM{
                   exterior: [
                     %PointM{x: 30, y: 10, m: 1},
                     %PointM{x: 40, y: 40, m: 2},
                     %PointM{x: 20, y: 40, m: 3},
                     %PointM{x: 10, y: 20, m: 4},
                     %PointM{x: 30, y: 10, m: 1}
                   ],
                   interiors: []
                 }
               }
    end

    test "simple PolygonZ without holes" do
      polygon = "POLYGON z((30 10 1, 40 40 2, 20 40 3, 10 20 4, 30 10 1))"

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %PolygonZ{
                   exterior: [
                     %PointZ{x: 30, y: 10, z: 1},
                     %PointZ{x: 40, y: 40, z: 2},
                     %PointZ{x: 20, y: 40, z: 3},
                     %PointZ{x: 10, y: 20, z: 4},
                     %PointZ{x: 30, y: 10, z: 1}
                   ],
                   interiors: []
                 }
               }
    end

    test "simple PolygonZM without holes" do
      polygon = "POLYGON zm ((30 10 1 2, 40 40 2 3, 20 40 3 4, 10 20 4 5, 30 10 1 2))"

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %PolygonZM{
                   exterior: [
                     %PointZM{x: 30, y: 10, z: 1, m: 2},
                     %PointZM{x: 40, y: 40, z: 2, m: 3},
                     %PointZM{x: 20, y: 40, z: 3, m: 4},
                     %PointZM{x: 10, y: 20, z: 4, m: 5},
                     %PointZM{x: 30, y: 10, z: 1, m: 2}
                   ],
                   interiors: []
                 }
               }
    end

    test "simple Polygon with hole" do
      polygon = """
      polygon (
        (35 10, 45 45, 15 40, 10 20, 35 10),
        (20 30, 35 35, 30 20, 20 30)
      )
      """

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %Polygon{
                   exterior: [
                     %Point{x: 35, y: 10},
                     %Point{x: 45, y: 45},
                     %Point{x: 15, y: 40},
                     %Point{x: 10, y: 20},
                     %Point{x: 35, y: 10}
                   ],
                   interiors: [
                     [
                       %Point{x: 20, y: 30},
                       %Point{x: 35, y: 35},
                       %Point{x: 30, y: 20},
                       %Point{x: 20, y: 30}
                     ]
                   ]
                 }
               }
    end

    test "simple Polygon with holes" do
      polygon = """
      Polygon (
        (35 10, 45 45, 15 40, 10 20, 35 10),
        (20 30, 35 35, 30 20, 20 30),
        (35 10, 25 25, 11 30, 15 25, 30 15)
      )
      """

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %Polygon{
                   exterior: [
                     %Point{x: 35, y: 10},
                     %Point{x: 45, y: 45},
                     %Point{x: 15, y: 40},
                     %Point{x: 10, y: 20},
                     %Point{x: 35, y: 10}
                   ],
                   interiors: [
                     [
                       %Point{x: 20, y: 30},
                       %Point{x: 35, y: 35},
                       %Point{x: 30, y: 20},
                       %Point{x: 20, y: 30}
                     ],
                     [
                       %Point{x: 35, y: 10},
                       %Point{x: 25, y: 25},
                       %Point{x: 11, y: 30},
                       %Point{x: 15, y: 25},
                       %Point{x: 30, y: 15}
                     ]
                   ]
                 }
               }
    end
  end

  describe "MultiPoint (Z/M/ZM):" do
    prove Parser.parse("MultiPoint ZM ((11 12 13 14), (21 22 23 24))") ==
            {:ok,
             %MultiPointZM{
               points:
                 MapSet.new([
                   %PointZM{x: 11, y: 12, z: 13, m: 14},
                   %PointZM{x: 21, y: 22, z: 23, m: 24}
                 ])
             }}

    prove Parser.parse("MultiPointZM(11 12 13 14, 21 22 23 24)") ==
            {:ok,
             %MultiPointZM{
               points:
                 MapSet.new([
                   %PointZM{x: 11, y: 12, z: 13, m: 14},
                   %PointZM{x: 21, y: 22, z: 23, m: 24}
                 ])
             }}

    prove Parser.parse("MultiPoint M (11 12 13 , 21 22 23 )") ==
            {:ok,
             %MultiPointM{
               points:
                 MapSet.new([
                   %PointM{x: 11, y: 12, m: 13},
                   %PointM{x: 21, y: 22, m: 23}
                 ])
             }}

    prove Parser.parse("MultiPoint Z (11 12 13 , 21 22 23 )") ==
            {:ok,
             %MultiPointZ{
               points:
                 MapSet.new([
                   %PointZ{x: 11, y: 12, z: 13},
                   %PointZ{x: 21, y: 22, z: 23}
                 ])
             }}

    prove Parser.parse("MultiPoint  (11 12, 21 22)") ==
            {:ok,
             %MultiPoint{
               points:
                 MapSet.new([
                   %Point{x: 11, y: 12},
                   %Point{x: 21, y: 22}
                 ])
             }}
  end

  describe "MultiLineString (Z/M/ZM):" do
    test "simple LineStringZM with one line-strings" do
      wkt = """
      MULTILINESTRING ZM(
        (40 30 10 20, 30 30 25 30)
      )
      """

      assert Parser.parse(wkt) ==
               {:ok,
                %MultiLineStringZM{
                  line_strings:
                    MapSet.new([
                      %LineStringZM{
                        points: [
                          %PointZM{x: 40, y: 30, z: 10, m: 20},
                          %PointZM{x: 30, y: 30, z: 25, m: 30}
                        ]
                      }
                    ])
                }}
    end

    test "simple LineStringZM with two line-strings" do
      wkt = """
      MULTILINESTRING ZM(
        (10 20 10 45, 20 10 35 15, 20 40 10 15),
        (40 30 10 20, 30 30 25 30)
      )
      """

      assert Parser.parse(wkt) ==
               {:ok,
                %MultiLineStringZM{
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
                }}
    end

    test "simple LineStringZM with three line-strings" do
      wkt = """
      MULTILINESTRING ZM(
        (10 20 10 45, 20 20 30 30),
        (30 20 10 45, 30 20 30 30),
        (40 30 10 20, 30 30 25 30)
      )
      """

      assert Parser.parse(wkt) ==
               {:ok,
                %MultiLineStringZM{
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
                          %PointZM{x: 20, y: 20, z: 30, m: 30}
                        ]
                      },
                      %LineStringZM{
                        points: [
                          %PointZM{x: 30, y: 20, z: 10, m: 45},
                          %PointZM{x: 30, y: 20, z: 30, m: 30}
                        ]
                      }
                    ])
                }}
    end

    test "simple LineStringZ with two line-strings" do
      wkt = """
      MultiLineStringZ(
        (10 20 45, 20 10 15, 20 40 15),
        (40 30 20, 30 30 30)
      )
      """

      assert Parser.parse(wkt) ==
               {:ok,
                %MultiLineStringZ{
                  line_strings:
                    MapSet.new([
                      %LineStringZ{
                        points: [
                          %PointZ{x: 40, y: 30, z: 20},
                          %PointZ{x: 30, y: 30, z: 30}
                        ]
                      },
                      %LineStringZ{
                        points: [
                          %PointZ{x: 10, y: 20, z: 45},
                          %PointZ{x: 20, y: 10, z: 15},
                          %PointZ{x: 20, y: 40, z: 15}
                        ]
                      }
                    ])
                }}
    end

    test "simple LineStringM with two line-strings" do
      wkt = """
      MultiLineString m(
        (10 20 45, 20 10 15, 20 40 15),
        (40 30 20, 30 30 30)
      )
      """

      assert Parser.parse(wkt) ==
               {:ok,
                %MultiLineStringM{
                  line_strings:
                    MapSet.new([
                      %LineStringM{
                        points: [
                          %PointM{x: 40, y: 30, m: 20},
                          %PointM{x: 30, y: 30, m: 30}
                        ]
                      },
                      %LineStringM{
                        points: [
                          %PointM{x: 10, y: 20, m: 45},
                          %PointM{x: 20, y: 10, m: 15},
                          %PointM{x: 20, y: 40, m: 15}
                        ]
                      }
                    ])
                }}
    end

    test "simple MultiLineString with two line-strings" do
      wkt = """
      multilinestring (
        (10 20, 20 10, 20 40),
        (40 30, 30 30)
      )
      """

      assert Parser.parse(wkt) ==
               {:ok,
                %MultiLineString{
                  line_strings:
                    MapSet.new([
                      %LineString{
                        points: [
                          %Point{x: 40, y: 30},
                          %Point{x: 30, y: 30}
                        ]
                      },
                      %LineString{
                        points: [
                          %Point{x: 10, y: 20},
                          %Point{x: 20, y: 10},
                          %Point{x: 20, y: 40}
                        ]
                      }
                    ])
                }}
    end
  end

  describe "MultiPolygon (Z/M/ZM):" do
    test "MultPolygon with one polygon without a hohle" do
      wkt = """
      MULTIPOLYGON (
        ((30 20, 45 40, 10 40, 30 20))
      )
      """

      assert Parser.parse(wkt) ==
               {
                 :ok,
                 %MultiPolygon{
                   polygons:
                     MapSet.new([
                       %Polygon{
                         exterior: [
                           %Point{x: 30, y: 20},
                           %Point{x: 45, y: 40},
                           %Point{x: 10, y: 40},
                           %Point{x: 30, y: 20}
                         ],
                         interiors: []
                       }
                     ])
                 }
               }
    end

    test "MultPolygonZ with one polygon without a hohle" do
      wkt = """
      MULTIPOLYGONZ(
        ((30 20 10, 45 40 15, 10 40 20, 30 20 10))
      )
      """

      assert Parser.parse(wkt) ==
               {
                 :ok,
                 %MultiPolygonZ{
                   polygons:
                     MapSet.new([
                       %PolygonZ{
                         exterior: [
                           %PointZ{x: 30, y: 20, z: 10},
                           %PointZ{x: 45, y: 40, z: 15},
                           %PointZ{x: 10, y: 40, z: 20},
                           %PointZ{x: 30, y: 20, z: 10}
                         ],
                         interiors: []
                       }
                     ])
                 }
               }
    end

    test "MultPolygonM with one polygon without a hohle" do
      wkt = """
      MULTIPOLYGON m(
        ((30 20 10, 45 40 15, 10 40 20, 30 20 10))
      )
      """

      assert Parser.parse(wkt) ==
               {
                 :ok,
                 %MultiPolygonM{
                   polygons:
                     MapSet.new([
                       %PolygonM{
                         exterior: [
                           %PointM{x: 30, y: 20, m: 10},
                           %PointM{x: 45, y: 40, m: 15},
                           %PointM{x: 10, y: 40, m: 20},
                           %PointM{x: 30, y: 20, m: 10}
                         ],
                         interiors: []
                       }
                     ])
                 }
               }
    end

    test "MultPolygonZM with one polygon without a hohle" do
      wkt = """
      MULTIPOLYGON Zm(
        ((30 20 10 10, 45 40 15 15, 10 40 20 20, 30 20 10 10))
      )
      """

      assert Parser.parse(wkt) ==
               {
                 :ok,
                 %MultiPolygonZM{
                   polygons:
                     MapSet.new([
                       %PolygonZM{
                         exterior: [
                           %PointZM{x: 30, y: 20, z: 10, m: 10},
                           %PointZM{x: 45, y: 40, z: 15, m: 15},
                           %PointZM{x: 10, y: 40, z: 20, m: 20},
                           %PointZM{x: 30, y: 20, z: 10, m: 10}
                         ],
                         interiors: []
                       }
                     ])
                 }
               }
    end
  end

  describe "GeometryCollection:" do
    test "An empty collection" do
      assert Parser.parse("GeometryCollection ZM EMPTY") ==
               {:ok, %Geometry.GeometryCollectionZM{}}
    end

    test "Collection with 3 ZM geometries" do
      wkt = """
      GeometryCollection ZM (
        Point ZM (40 10 20 30),
        LineString ZM (10 10 20 15, 20 20 10 15, 10 40 20 30),
        Polygon ZM ((40 40 20 10, 20 45 15 20, 45 30 10 15, 40 40 20 10))
      )
      """

      assert Parser.parse(wkt) ==
               {:ok,
                %Geometry.GeometryCollectionZM{
                  geometries:
                    MapSet.new([
                      %Geometry.LineStringZM{
                        points: [
                          %Geometry.PointZM{x: 10, y: 10, z: 20, m: 15},
                          %Geometry.PointZM{x: 20, y: 20, z: 10, m: 15},
                          %Geometry.PointZM{x: 10, y: 40, z: 20, m: 30}
                        ]
                      },
                      %Geometry.PolygonZM{
                        exterior: [
                          %Geometry.PointZM{x: 40, y: 40, z: 20, m: 10},
                          %Geometry.PointZM{x: 20, y: 45, z: 15, m: 20},
                          %Geometry.PointZM{x: 45, y: 30, z: 10, m: 15},
                          %Geometry.PointZM{x: 40, y: 40, z: 20, m: 10}
                        ],
                        interiors: []
                      },
                      %Geometry.PointZM{x: 40, y: 10, z: 20, m: 30}
                    ])
                }}
    end
  end

  describe "Errors:" do
    test "Invalid SRID" do
      assert Parser.parse("ID=55;Point(1 2)") ==
               {
                 :error,
                 "expected 'SRID', 'Geometry' or 'SRID;Geometry'",
                 "ID=55;Point(1 2)",
                 {1, 0},
                 0
               }
    end

    test "SRID ':' instead of '='" do
      assert Parser.parse("SRID:55;Point(1 2)") ==
               {
                 :error,
                 "expected 'SRID', 'Geometry' or 'SRID;Geometry'",
                 "SRID:55;Point(1 2)",
                 {1, 0},
                 0
               }
    end

    test "Missing semicolon after SRID" do
      assert Parser.parse("SRID=55 Point(1 2)") ==
               {
                 :error,
                 "expected 'SRID', 'Geometry' or 'SRID;Geometry'",
                 "SRID=55 Point(1 2)",
                 {1, 0},
                 0
               }
    end

    test "Missing closing bracket" do
      assert Parser.parse("Point(1 2") == {:error, "expected Point data", "(1 2", {1, 0}, 5}

      assert Parser.parse("   \nPoint\n(1 2") ==
               {:error, "expected Point data", "(1 2", {3, 10}, 10}
    end

    @tag :only
    test "Mixed collection" do
      wkt = """
      GeometryCollection ZM (
        Point M (10 20 30),
        Point ZM (40 10 20 30)
      )
      """

      assert Parser.parse(wkt) ==
               {:error, "unexpected geometry in collection",
                "(10 20 30),\n  Point ZM (40 10 20 30)\n)\n", {2, 24}, 34}
    end

    test "Invalid collection" do
      wkt = """
      GeometryCollection ZM
        Point M (10 20 30),
        Point ZM (40 10 20 30)
      )
      """

      assert Parser.parse(wkt) == {
               :error,
               "expected '(', ',' ')', or 'EMPTY'",
               "Point M (10 20 30),\n  Point ZM (40 10 20 30)\n)\n",
               {2, 22},
               24
             }
    end
  end
end
