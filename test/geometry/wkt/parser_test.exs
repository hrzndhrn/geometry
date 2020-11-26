defmodule Geometry.WKT.ParserTest do
  use ExUnit.Case, async: true

  import Prove

  alias Geometry.WKT.Parser

  alias Geometry.{
    GeometryCollectionZM,
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
    prove Parser.parse("Point(1 2)") == {:ok, %Point{coordinate: [1, 2]}}
    prove Parser.parse("POINT ( -1.5 2.66 ) ") == {:ok, %Point{coordinate: [-1.5, 2.66]}}
    prove Parser.parse("Point Z (1 2 3)") == {:ok, %PointZ{coordinate: [1, 2, 3]}}
    prove Parser.parse("POINTZ(1 2 3)") == {:ok, %PointZ{coordinate: [1, 2, 3]}}
    prove Parser.parse("POINT M(1 2 3)") == {:ok, %PointM{coordinate: [1, 2, 3]}}
    prove Parser.parse("point zm(1 2 3 4)   ") == {:ok, %PointZM{coordinate: [1, 2, 3, 4]}}
    prove Parser.parse("Point(1 2) ignore") == {:ok, %Point{coordinate: [1, 2]}}
    prove Parser.parse("Point Z EMPTY") == {:ok, %PointZ{}}
  end

  describe "Point from EWKT:" do
    prove Parser.parse("SRID=4437;Point(1 2)") == {:ok, {%Point{coordinate: [1, 2]}, 4437}}
    prove Parser.parse(" SriD = 1 ; Point(1 2)") == {:ok, {%Point{coordinate: [1, 2]}, 1}}
  end

  describe "Point" do
    test "from multiline string" do
      wkt = """
      Point(
        1.2
        2.3
      )
      """

      assert Parser.parse(wkt) == {:ok, %Point{coordinate: [1.2, 2.3]}}
    end
  end

  describe "LineString (Z/M/ZM):" do
    prove Parser.parse("LineString(1 2, 3 4)") ==
            {:ok,
             %LineString{
               points: [[1, 2], [3, 4]]
             }}

    prove Parser.parse("linestring Z(-1.9 2.9 5.1, 3.6 4.4 5.5, 1.1 2.2 3.3)") ==
            {:ok,
             %LineStringZ{
               points: [
                 [-1.9, 2.9, 5.1],
                 [3.6, 4.4, 5.5],
                 [1.1, 2.2, 3.3]
               ]
             }}

    prove Parser.parse("linestringm(-1.9 2.9 5.1, 3.6 4.4 5.5, 1.1 2.2 3.3)") ==
            {:ok,
             %LineStringM{
               points: [
                 [-1.9, 2.9, 5.1],
                 [3.6, 4.4, 5.5],
                 [1.1, 2.2, 3.3]
               ]
             }}

    prove Parser.parse("LineStringZM(1 2 3 4, 5 6 7 8)") ==
            {:ok,
             %LineStringZM{
               points: [
                 [1, 2, 3, 4],
                 [5, 6, 7, 8]
               ]
             }}

    prove Parser.parse("LineString(1 2, 4 5) foo") ==
            {:ok,
             %LineString{
               points: [
                 [1, 2],
                 [4, 5]
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
                   rings: [
                     [
                       [30, 10],
                       [40, 40],
                       [20, 40],
                       [10, 20],
                       [30, 10]
                     ]
                   ]
                 }
               }
    end

    test "simple PolygonM without holes" do
      polygon = "POLYGONM ((30 10 1, 40 40 2, 20 40 3, 10 20 4, 30 10 1))"

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %PolygonM{
                   rings: [
                     [
                       [30, 10, 1],
                       [40, 40, 2],
                       [20, 40, 3],
                       [10, 20, 4],
                       [30, 10, 1]
                     ]
                   ]
                 }
               }
    end

    test "simple PolygonZ without holes" do
      polygon = "POLYGON z((30 10 1, 40 40 2, 20 40 3, 10 20 4, 30 10 1))"

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %PolygonZ{
                   rings: [
                     [
                       [30, 10, 1],
                       [40, 40, 2],
                       [20, 40, 3],
                       [10, 20, 4],
                       [30, 10, 1]
                     ]
                   ]
                 }
               }
    end

    test "simple PolygonZM without holes" do
      polygon = "POLYGON zm ((30 10 1 2, 40 40 2 3, 20 40 3 4, 10 20 4 5, 30 10 1 2))"

      assert Parser.parse(polygon) ==
               {
                 :ok,
                 %PolygonZM{
                   rings: [
                     [
                       [30, 10, 1, 2],
                       [40, 40, 2, 3],
                       [20, 40, 3, 4],
                       [10, 20, 4, 5],
                       [30, 10, 1, 2]
                     ]
                   ]
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
                     ],
                     [
                       [35, 10],
                       [25, 25],
                       [11, 30],
                       [15, 25],
                       [30, 15]
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
                   [11, 12, 13, 14],
                   [21, 22, 23, 24]
                 ])
             }}

    prove Parser.parse("MultiPointZM(11 12 13 14, 21 22 23 24)") ==
            {:ok,
             %MultiPointZM{
               points:
                 MapSet.new([
                   [11, 12, 13, 14],
                   [21, 22, 23, 24]
                 ])
             }}

    prove Parser.parse("MultiPoint M (11 12 13 , 21 22 23 )") ==
            {:ok,
             %MultiPointM{
               points:
                 MapSet.new([
                   [11, 12, 13],
                   [21, 22, 23]
                 ])
             }}

    prove Parser.parse("MultiPoint Z (11 12 13 , 21 22 23 )") ==
            {:ok,
             %MultiPointZ{
               points:
                 MapSet.new([
                   [11, 12, 13],
                   [21, 22, 23]
                 ])
             }}

    prove Parser.parse("MultiPoint  (11 12, 21 22)") ==
            {:ok,
             %MultiPoint{
               points:
                 MapSet.new([
                   [11, 12],
                   [21, 22]
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
                      [
                        [40, 30, 10, 20],
                        [30, 30, 25, 30]
                      ]
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
                      [
                        [40, 30, 10, 20],
                        [30, 30, 25, 30]
                      ],
                      [
                        [10, 20, 10, 45],
                        [20, 10, 35, 15],
                        [20, 40, 10, 15]
                      ]
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
                      [
                        [40, 30, 10, 20],
                        [30, 30, 25, 30]
                      ],
                      [
                        [10, 20, 10, 45],
                        [20, 20, 30, 30]
                      ],
                      [
                        [30, 20, 10, 45],
                        [30, 20, 30, 30]
                      ]
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
                      [
                        [40, 30, 20],
                        [30, 30, 30]
                      ],
                      [
                        [10, 20, 45],
                        [20, 10, 15],
                        [20, 40, 15]
                      ]
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
                      [
                        [40, 30, 20],
                        [30, 30, 30]
                      ],
                      [
                        [10, 20, 45],
                        [20, 10, 15],
                        [20, 40, 15]
                      ]
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
                      [
                        [40, 30],
                        [30, 30]
                      ],
                      [
                        [10, 20],
                        [20, 10],
                        [20, 40]
                      ]
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
                       [
                         [
                           [30, 20],
                           [45, 40],
                           [10, 40],
                           [30, 20]
                         ]
                       ]
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
                       [
                         [
                           [30, 20, 10],
                           [45, 40, 15],
                           [10, 40, 20],
                           [30, 20, 10]
                         ]
                       ]
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
                       [
                         [
                           [30, 20, 10],
                           [45, 40, 15],
                           [10, 40, 20],
                           [30, 20, 10]
                         ]
                       ]
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
                       [
                         [
                           [30, 20, 10, 10],
                           [45, 40, 15, 15],
                           [10, 40, 20, 20],
                           [30, 20, 10, 10]
                         ]
                       ]
                     ])
                 }
               }
    end
  end

  describe "GeometryCollection:" do
    test "An empty collection" do
      assert Parser.parse("GeometryCollection ZM EMPTY") ==
               {:ok, %GeometryCollectionZM{}}
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
                %GeometryCollectionZM{
                  geometries:
                    MapSet.new([
                      %LineStringZM{
                        points: [
                          [10, 10, 20, 15],
                          [20, 20, 10, 15],
                          [10, 40, 20, 30]
                        ]
                      },
                      %PolygonZM{
                        rings: [
                          [
                            [40, 40, 20, 10],
                            [20, 45, 15, 20],
                            [45, 30, 10, 15],
                            [40, 40, 20, 10]
                          ]
                        ]
                      },
                      %PointZM{coordinate: [40, 10, 20, 30]}
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
