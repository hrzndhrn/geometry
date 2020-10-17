defmodule GeometryTest do
  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{
    Feature,
    FeatureCollection,
    GeometryCollection,
    GeometryCollectionM,
    GeometryCollectionZ,
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

  doctest Geometry, import: true

  describe "from_wkt/1:" do
    prove Geometry.from_wkt("Point (4 5)") == {:ok, %Point{x: 4, y: 5}}
    prove Geometry.from_wkt("Point (4 5) \n") == {:ok, %Point{x: 4, y: 5}}
    prove Geometry.from_wkt("Point Z (4 5 9)") == {:ok, %PointZ{x: 4, y: 5, z: 9}}
    prove Geometry.from_wkt("Point M (4 6 7)") == {:ok, %PointM{x: 4, y: 6, m: 7}}
    prove Geometry.from_wkt("Point ZM (5 4 1 3)") == {:ok, %PointZM{x: 5, y: 4, z: 1, m: 3}}
    prove Geometry.from_wkt("SRID=44;Point (4 5)") == {:ok, %Point{x: 4, y: 5}, 44}
  end

  describe "from_wkt/1" do
    test "returns an error tuple for an invalid coordiante" do
      assert Geometry.from_wkt("Point (x 5)") ==
               {:error, "expected Point data", "(x 5)", {1, 0}, 6}
    end
  end

  describe "from_wkt!/2" do
    test "returns an exception for an invalid coordiante in Point" do
      message = "expected Point data at 2:2, got: '(7 X)\n'"

      assert_raise Geometry.Error, message, fn ->
        Geometry.from_wkt!("""
        Point
          (7 X)
        """)
      end
    end

    test "returns an exception for an invalid coordiante in LineString" do
      message = "expected LineString data at 1:10, got: '(x 1, 2 2...'"

      assert_raise Geometry.Error, message, fn ->
        Geometry.from_wkt!("LineString(x 1, 2 2, 3 3, 4 4, 5 5, 6 6, 7 7)")
      end
    end
  end

  describe "from_wkt!/2:" do
    prove Geometry.from_wkt!("Point (4 5)") == %Point{x: 4, y: 5}
    prove Geometry.from_wkt!("Point Z (4 5 9)") == %PointZ{x: 4, y: 5, z: 9}
    prove Geometry.from_wkt!("Point M (4 6 7)") == %PointM{x: 4, y: 6, m: 7}
    prove Geometry.from_wkt!("Point ZM (5 4 1 3)") == %PointZM{x: 5, y: 4, z: 1, m: 3}
    prove Geometry.from_wkt!("SRID=44;Point (4 5)") == {%Point{x: 4, y: 5}, 44}
  end

  describe "to_wkt/2:" do
    prove Geometry.to_wkt(Point.new(1, 2)) == "Point (1 2)"
    prove Geometry.to_wkt(Point.new(1, 2), srid: 42) == "SRID=42;Point (1 2)"
  end

  describe "empty?/1:" do
    prove Geometry.empty?(Point.new()) == true
    prove Geometry.empty?(PointM.new()) == true
    prove Geometry.empty?(PointZ.new()) == true
    prove Geometry.empty?(PointZM.new()) == true

    prove Geometry.empty?(LineString.new()) == true
    prove Geometry.empty?(LineStringM.new()) == true
    prove Geometry.empty?(LineStringZ.new()) == true
    prove Geometry.empty?(LineStringZM.new()) == true

    prove Geometry.empty?(Polygon.new()) == true
    prove Geometry.empty?(PolygonM.new()) == true
    prove Geometry.empty?(PolygonZ.new()) == true
    prove Geometry.empty?(PolygonZM.new()) == true

    prove Geometry.empty?(MultiPoint.new()) == true
    prove Geometry.empty?(MultiPointM.new()) == true
    prove Geometry.empty?(MultiPointZ.new()) == true
    prove Geometry.empty?(MultiPointZM.new()) == true

    prove Geometry.empty?(MultiLineString.new()) == true
    prove Geometry.empty?(MultiLineStringM.new()) == true
    prove Geometry.empty?(MultiLineStringZ.new()) == true
    prove Geometry.empty?(MultiLineStringZM.new()) == true

    prove Geometry.empty?(MultiPolygon.new()) == true
    prove Geometry.empty?(MultiPolygonM.new()) == true
    prove Geometry.empty?(MultiPolygonZ.new()) == true
    prove Geometry.empty?(MultiPolygonZM.new()) == true

    prove Geometry.empty?(GeometryCollection.new()) == true
    prove Geometry.empty?(GeometryCollectionM.new()) == true
    prove Geometry.empty?(GeometryCollectionZ.new()) == true
    prove Geometry.empty?(GeometryCollectionZM.new()) == true
  end

  describe "from_geo_json/2" do
    test "returns Point" do
      geo_json =
        Jason.decode!("""
        {"type": "Point", "coordinates": [1, 2]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json) == {:ok, %Point{x: 1, y: 2}}
    end

    test "returns PointZ" do
      geo_json =
        Jason.decode!("""
        {"type": "Point", "coordinates": [1, 2, 3]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :z) == {:ok, %PointZ{x: 1, y: 2, z: 3}}
    end

    test "returns PointM" do
      geo_json =
        Jason.decode!("""
        {"type": "Point", "coordinates": [1, 2, 3]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :m) == {:ok, %PointM{x: 1, y: 2, m: 3}}
    end

    test "returns PointZM" do
      geo_json =
        Jason.decode!("""
        {"type": "Point", "coordinates": [1, 2, 3, 4]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :zm) ==
               {:ok, %PointZM{x: 1, y: 2, z: 3, m: 4}}
    end

    test "returns LineString" do
      geo_json =
        Jason.decode!("""
        {"type": "LineString", "coordinates": [[1, 2], [3, 4]]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json) ==
               {:ok, %LineString{points: [%Point{x: 1, y: 2}, %Point{x: 3, y: 4}]}}
    end

    test "returns LineStringM" do
      geo_json =
        Jason.decode!("""
        {"type": "LineString", "coordinates": [[1, 2, 3], [3, 4, 5]]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :m) ==
               {:ok, %LineStringM{points: [%PointM{x: 1, y: 2, m: 3}, %PointM{x: 3, y: 4, m: 5}]}}
    end

    test "returns LineStringZ" do
      geo_json =
        Jason.decode!("""
        {"type": "LineString", "coordinates": [[1, 2, 3], [3, 4, 5]]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :z) ==
               {:ok, %LineStringZ{points: [%PointZ{x: 1, y: 2, z: 3}, %PointZ{x: 3, y: 4, z: 5}]}}
    end

    test "returns LineStringZM" do
      geo_json =
        Jason.decode!("""
        {"type": "LineString", "coordinates": [[1, 2, 3, 4], [3, 4, 5, 6]]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :zm) ==
               {:ok,
                %LineStringZM{
                  points: [%PointZM{x: 1, y: 2, z: 3, m: 4}, %PointZM{x: 3, y: 4, z: 5, m: 6}]
                }}
    end

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
             [35, 10]],
            [[20, 30],
             [35, 35],
             [30, 20],
             [20, 30]]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json) ==
               {:ok,
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
                }}
    end

    test "returns PolygonM" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Polygon",
          "coordinates": [
            [[35, 10, 1],
             [45, 45, 2],
             [15, 40, 1],
             [10, 20, 2],
             [35, 10, 1]],
            [[20, 30, 1],
             [35, 35, 2],
             [30, 20, 3],
             [20, 30, 1]]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :m) ==
               {:ok,
                %PolygonM{
                  exterior: [
                    %PointM{x: 35, y: 10, m: 1},
                    %PointM{x: 45, y: 45, m: 2},
                    %PointM{x: 15, y: 40, m: 1},
                    %PointM{x: 10, y: 20, m: 2},
                    %PointM{x: 35, y: 10, m: 1}
                  ],
                  interiors: [
                    [
                      %PointM{x: 20, y: 30, m: 1},
                      %PointM{x: 35, y: 35, m: 2},
                      %PointM{x: 30, y: 20, m: 3},
                      %PointM{x: 20, y: 30, m: 1}
                    ]
                  ]
                }}
    end

    test "returns PolygonZ" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Polygon",
          "coordinates": [
            [[35, 10, 1],
             [45, 45, 2],
             [15, 40, 1],
             [10, 20, 2],
             [35, 10, 1]],
            [[20, 30, 1],
             [35, 35, 2],
             [30, 20, 3],
             [20, 30, 1]]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :z) ==
               {:ok,
                %PolygonZ{
                  exterior: [
                    %PointZ{x: 35, y: 10, z: 1},
                    %PointZ{x: 45, y: 45, z: 2},
                    %PointZ{x: 15, y: 40, z: 1},
                    %PointZ{x: 10, y: 20, z: 2},
                    %PointZ{x: 35, y: 10, z: 1}
                  ],
                  interiors: [
                    [
                      %PointZ{x: 20, y: 30, z: 1},
                      %PointZ{x: 35, y: 35, z: 2},
                      %PointZ{x: 30, y: 20, z: 3},
                      %PointZ{x: 20, y: 30, z: 1}
                    ]
                  ]
                }}
    end

    test "returns PolygonZM" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Polygon",
          "coordinates": [
            [[35, 10, 1, 2],
             [45, 45, 2, 2],
             [15, 40, 1, 3],
             [10, 20, 2, 4],
             [35, 10, 1, 2]],
            [[20, 30, 1, 4],
             [35, 35, 2, 3],
             [30, 20, 3, 2],
             [20, 30, 1, 4]]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :zm) ==
               {:ok,
                %PolygonZM{
                  exterior: [
                    %PointZM{x: 35, y: 10, z: 1, m: 2},
                    %PointZM{x: 45, y: 45, z: 2, m: 2},
                    %PointZM{x: 15, y: 40, z: 1, m: 3},
                    %PointZM{x: 10, y: 20, z: 2, m: 4},
                    %PointZM{x: 35, y: 10, z: 1, m: 2}
                  ],
                  interiors: [
                    [
                      %PointZM{x: 20, y: 30, z: 1, m: 4},
                      %PointZM{x: 35, y: 35, z: 2, m: 3},
                      %PointZM{x: 30, y: 20, z: 3, m: 2},
                      %PointZM{x: 20, y: 30, z: 1, m: 4}
                    ]
                  ]
                }}
    end

    test "returns MultiPoint" do
      geo_json =
        Jason.decode!("""
        {
          "type": "MultiPoint",
          "coordinates": [
            [1.1, 1.2],
            [20.1, 20.2]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json) ==
               {:ok,
                %MultiPoint{
                  points:
                    MapSet.new([
                      %Point{x: 1.1, y: 1.2},
                      %Point{x: 20.1, y: 20.2}
                    ])
                }}
    end

    test "returns MultiPointM" do
      geo_json =
        Jason.decode!("""
        {
          "type": "MultiPoint",
          "coordinates": [
            [1.1, 1.2, 1.3],
            [20.1, 20.2, 20.3]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :m) ==
               {:ok,
                %MultiPointM{
                  points:
                    MapSet.new([
                      %PointM{x: 1.1, y: 1.2, m: 1.3},
                      %PointM{x: 20.1, y: 20.2, m: 20.3}
                    ])
                }}
    end

    test "returns MultiPointZ" do
      geo_json =
        Jason.decode!("""
        {
          "type": "MultiPoint",
          "coordinates": [
            [1.1, 1.2, 1.3],
            [20.1, 20.2, 20.3]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :z) ==
               {:ok,
                %MultiPointZ{
                  points:
                    MapSet.new([
                      %PointZ{x: 1.1, y: 1.2, z: 1.3},
                      %PointZ{x: 20.1, y: 20.2, z: 20.3}
                    ])
                }}
    end

    test "returns MultiPointZM" do
      geo_json =
        Jason.decode!("""
        {
          "type": "MultiPoint",
          "coordinates": [
            [1.1, 1.2, 1.3, 1.4],
            [20.1, 20.2, 20.3, 20.4]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :zm) ==
               {:ok,
                %MultiPointZM{
                  points:
                    MapSet.new([
                      %PointZM{x: 1.1, y: 1.2, z: 1.3, m: 1.4},
                      %PointZM{x: 20.1, y: 20.2, z: 20.3, m: 20.4}
                    ])
                }}
    end

    test "returns MultiLineStringZM" do
      geo_json =
        Jason.decode!("""
          {
            "type": "MultiLineString",
            "coordinates": [
              [[40, 30, 10, 20], [30, 30, 25, 30]]
            ]
          }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :zm) ==
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

    test "returns MultiLineStringZ" do
      geo_json =
        Jason.decode!("""
          {
            "type": "MultiLineString",
            "coordinates": [
              [[40, 30, 10], [30, 30, 25]]
            ]
          }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :z) ==
               {:ok,
                %MultiLineStringZ{
                  line_strings:
                    MapSet.new([
                      %LineStringZ{
                        points: [
                          %PointZ{x: 40, y: 30, z: 10},
                          %PointZ{x: 30, y: 30, z: 25}
                        ]
                      }
                    ])
                }}
    end

    test "returns MultiLineStringM" do
      geo_json =
        Jason.decode!("""
          {
            "type": "MultiLineString",
            "coordinates": [
              [[40, 30, 10], [30, 30, 25]]
            ]
          }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :m) ==
               {:ok,
                %MultiLineStringM{
                  line_strings:
                    MapSet.new([
                      %LineStringM{
                        points: [
                          %PointM{x: 40, y: 30, m: 10},
                          %PointM{x: 30, y: 30, m: 25}
                        ]
                      }
                    ])
                }}
    end

    test "returns MultiLineString" do
      geo_json =
        Jason.decode!("""
          {
            "type": "MultiLineString",
            "coordinates": [
              [[40, 30], [30, 30]]
            ]
          }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json) ==
               {:ok,
                %MultiLineString{
                  line_strings:
                    MapSet.new([
                      %LineString{
                        points: [
                          %Point{x: 40, y: 30},
                          %Point{x: 30, y: 30}
                        ]
                      }
                    ])
                }}
    end

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

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json) ==
               {:ok,
                %MultiPolygon{
                  polygons:
                    MapSet.new([
                      %Polygon{
                        exterior: [
                          %Point{x: 1, y: 1},
                          %Point{x: 9, y: 1},
                          %Point{x: 9, y: 8},
                          %Point{x: 1, y: 1}
                        ],
                        interiors: [
                          [
                            %Point{x: 6, y: 2},
                            %Point{x: 7, y: 2},
                            %Point{x: 7, y: 3},
                            %Point{x: 6, y: 2}
                          ]
                        ]
                      },
                      %Polygon{
                        exterior: [
                          %Point{x: 6, y: 2},
                          %Point{x: 8, y: 2},
                          %Point{x: 8, y: 4},
                          %Point{x: 6, y: 2}
                        ],
                        interiors: []
                      }
                    ])
                }}
    end

    test "returns MultiPolygonM" do
      geo_json =
        Jason.decode!("""
        {
          "type": "MultiPolygon",
          "coordinates": [
            [
              [[6, 2, 3], [8, 2, 4], [8, 4, 5], [6, 2, 3]]
            ], [
              [[1, 1, 3], [9, 1, 4], [9, 8, 5], [1, 1, 3]],
              [[6, 2, 4], [7, 2, 6], [7, 3, 3], [6, 2, 4]]
            ]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :m) ==
               {:ok,
                %MultiPolygonM{
                  polygons:
                    MapSet.new([
                      %PolygonM{
                        exterior: [
                          %PointM{x: 1, y: 1, m: 3},
                          %PointM{x: 9, y: 1, m: 4},
                          %PointM{x: 9, y: 8, m: 5},
                          %PointM{x: 1, y: 1, m: 3}
                        ],
                        interiors: [
                          [
                            %PointM{x: 6, y: 2, m: 4},
                            %PointM{x: 7, y: 2, m: 6},
                            %PointM{x: 7, y: 3, m: 3},
                            %PointM{x: 6, y: 2, m: 4}
                          ]
                        ]
                      },
                      %PolygonM{
                        exterior: [
                          %PointM{x: 6, y: 2, m: 3},
                          %PointM{x: 8, y: 2, m: 4},
                          %PointM{x: 8, y: 4, m: 5},
                          %PointM{x: 6, y: 2, m: 3}
                        ],
                        interiors: []
                      }
                    ])
                }}
    end

    test "returns MultiPolygonZ" do
      geo_json =
        Jason.decode!("""
        {
          "type": "MultiPolygon",
          "coordinates": [
            [
              [[6, 2, 3], [8, 2, 4], [8, 4, 5], [6, 2, 3]]
            ], [
              [[1, 1, 3], [9, 1, 4], [9, 8, 5], [1, 1, 3]],
              [[6, 2, 4], [7, 2, 6], [7, 3, 3], [6, 2, 4]]
            ]
          ]
        }
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :z) ==
               {:ok,
                %MultiPolygonZ{
                  polygons:
                    MapSet.new([
                      %PolygonZ{
                        exterior: [
                          %PointZ{x: 1, y: 1, z: 3},
                          %PointZ{x: 9, y: 1, z: 4},
                          %PointZ{x: 9, y: 8, z: 5},
                          %PointZ{x: 1, y: 1, z: 3}
                        ],
                        interiors: [
                          [
                            %PointZ{x: 6, y: 2, z: 4},
                            %PointZ{x: 7, y: 2, z: 6},
                            %PointZ{x: 7, y: 3, z: 3},
                            %PointZ{x: 6, y: 2, z: 4}
                          ]
                        ]
                      },
                      %PolygonZ{
                        exterior: [
                          %PointZ{x: 6, y: 2, z: 3},
                          %PointZ{x: 8, y: 2, z: 4},
                          %PointZ{x: 8, y: 4, z: 5},
                          %PointZ{x: 6, y: 2, z: 3}
                        ],
                        interiors: []
                      }
                    ])
                }}
    end

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

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json(geo_json, type: :zm) ==
               {:ok,
                %MultiPolygonZM{
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
                }}
    end

    test "returns GeometryCollectionZM" do
      geo_json =
        Jason.decode!("""
          {
            "type": "GeometryCollection",
            "geometries": [
              {"type": "Point", "coordinates": [1.1, 2.2, 3.3, 4.4]}
            ]
          }
        """)

      assert Geometry.from_geo_json(geo_json, type: :zm) ==
               {:ok,
                %GeometryCollectionZM{
                  geometries: MapSet.new([%PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}])
                }}
    end

    test "returns Feature" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Feature",
          "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
          "properties": {"facility": "Hotel"}
        }
        """)

      assert Geometry.from_geo_json(geo_json, type: :z) ==
               {:ok,
                %Feature{
                  geometry: %PointZ{x: 1, y: 2, z: 3},
                  properties: %{"facility" => "Hotel"}
                }}
    end

    test "returns FeatureCollection" do
      geo_json =
        Jason.decode!("""
        {
           "type": "FeatureCollection",
           "features": [
             {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
               "properties": {"facility": "Hotel"}
             }, {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [4, 3, 2]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      assert Geometry.from_geo_json(geo_json, type: :z) ==
               {
                 :ok,
                 %FeatureCollection{
                   features:
                     MapSet.new([
                       %Feature{
                         geometry: %Geometry.PointZ{x: 1, y: 2, z: 3},
                         properties: %{"facility" => "Hotel"}
                       },
                       %Feature{
                         geometry: %Geometry.PointZ{x: 4, y: 3, z: 2},
                         properties: %{"facility" => "School"}
                       }
                     ])
                 }
               }
    end

    test "returns an error for invalid data" do
      geo_json =
        Jason.decode!("""
          {
            "type": "GeometryCollection",
            "geometries": [
              {"type": "Point", "coordinates": ["evil", 2.2, 3.3, 4.4]}
            ]
          }
        """)

      assert Geometry.from_geo_json(geo_json, type: :zm) == {:error, :invalid_data}
    end

    test "returns an error for an invalid Polygon" do
      json =
        Jason.decode!("""
        {
          "type": "Polygon",
          "coordinates": [ [1.1, 1.2, 1.3] ]
        }
        """)

      assert Geometry.from_geo_json(json, type: :zm) == {:error, :invalid_data}
    end

    test "returns an error for an invalid MultiPoint" do
      json =
        Jason.decode!("""
        {
          "type": "MultiPoint",
          "coordinates": [
            [1.1, 1.2, 1.3],
            [20.1, 20.2, 20.3, 20.4]
          ]
        }
        """)

      assert Geometry.from_geo_json(json, type: :zm) == {:error, :invalid_data}
    end

    test "returns an error for an unknown type" do
      json =
        Jason.decode!("""
        {"type": "Spunk", "coordinates": [1, 2, 3, 4]}
        """)

      assert Geometry.from_geo_json(json, type: :m) == {:error, :unknown_type}
    end

    test "returns an error for an unknown :type" do
      json =
        Jason.decode!("""
        {"type": "Point", "coordinates": [1, 2]}
        """)

      assert Geometry.from_geo_json(json, type: :a) == {:error, :unknown_type}
    end
  end

  describe "from_geo_json!/1" do
    test "returns Point" do
      geo_json =
        Jason.decode!("""
        {"type": "Point", "coordinates": [1, 2]}
        """)

      assert GeoJsonValidator.valid?(geo_json)

      assert Geometry.from_geo_json!(geo_json) == %Point{x: 1, y: 2}
    end

    test "returns an exception for an invalid MultiPoint" do
      json =
        Jason.decode!("""
        {
          "type": "MultiPoint",
          "coordinates": [
            [1.1, 1.2, 1.3],
            [20.1, 20.2, 20.3, 20.4]
          ]
        }
        """)

      message = "invalid data"

      assert_raise Geometry.Error, message, fn ->
        Geometry.from_geo_json!(json, type: :zm)
      end
    end

    test "returns an error for an unknown type" do
      json =
        Jason.decode!("""
        {"type": "Spunk", "coordinates": [1, 2, 3, 4]}
        """)

      message = "unknown type"

      assert_raise Geometry.Error, message, fn ->
        Geometry.from_geo_json!(json, type: :m)
      end
    end
  end

  describe "from_wkb/1" do
    test "returns Point" do
      wkb = "0000000001BFF3333333333333400B333333333333"
      assert Geometry.from_wkb(wkb) == {:ok, %Point{x: -1.2, y: 3.4}}
    end

    test "returns Point from WKB with trailing whitespace" do
      wkb = "0000000001BFF3333333333333400B333333333333 \n"
      assert Geometry.from_wkb(wkb) == {:ok, %Point{x: -1.2, y: 3.4}}
    end

    test "returns Point with SRID" do
      wkb = "00200000010000014DBFF3333333333333400B333333333333"
      assert Geometry.from_wkb(wkb) == {:ok, %Point{x: -1.2, y: 3.4}, 333}
    end

    test "returns empty LineStringZM" do
      wkb = "00C000000200000000"

      assert Geometry.from_wkb(wkb) == {:ok, %LineStringZM{}}
    end

    test "returns LineStringZM (xdr)" do
      wkb = """
      00\
      C0000002\
      00000002\
      3FF0000000000000400000000000000040080000000000004010000000000000\
      40140000000000004018000000000000401C0000000000004020000000000000\
      """

      assert Geometry.from_wkb(wkb) == {
               :ok,
               %LineStringZM{
                 points: [
                   %PointZM{x: 1.0, y: 2.0, z: 3.0, m: 4.0},
                   %PointZM{x: 5.0, y: 6.0, z: 7.0, m: 8.0}
                 ]
               }
             }
    end

    test "returns LineStringZM (ndr)" do
      wkb = """
      01\
      020000C0\
      02000000\
      000000000000F03F000000000000004000000000000008400000000000001040\
      000000000000144000000000000018400000000000001C400000000000002040\
      """

      assert Geometry.from_wkb(wkb) == {
               :ok,
               %LineStringZM{
                 points: [
                   %PointZM{x: 1.0, y: 2.0, z: 3.0, m: 4.0},
                   %PointZM{x: 5.0, y: 6.0, z: 7.0, m: 8.0}
                 ]
               }
             }
    end

    test "returns LineStringZ (xdr)" do
      wkb = """
      00\
      80000002\
      00000002\
      3FF000000000000040000000000000004008000000000000\
      40140000000000004018000000000000401C000000000000\
      """

      assert Geometry.from_wkb(wkb) == {
               :ok,
               %LineStringZ{
                 points: [
                   %PointZ{x: 1.0, y: 2.0, z: 3.0},
                   %PointZ{x: 5.0, y: 6.0, z: 7.0}
                 ]
               }
             }
    end

    test "returns LineStringM (xdr)" do
      wkb = """
      00\
      40000002\
      00000002\
      3FF000000000000040000000000000004008000000000000\
      40140000000000004018000000000000401C000000000000\
      """

      assert Geometry.from_wkb(wkb) == {
               :ok,
               %LineStringM{
                 points: [
                   %PointM{x: 1.0, y: 2.0, m: 3.0},
                   %PointM{x: 5.0, y: 6.0, m: 7.0}
                 ]
               }
             }
    end

    test "returns LineStringM (ndr) with SRID" do
      wkb = """
      01\
      02000020\
      1F020000\
      02000000\
      000000000000F03F0000000000000040\
      00000000000014400000000000001840\
      """

      assert Geometry.from_wkb(wkb) == {
               :ok,
               %LineString{
                 points: [%Point{x: 1.0, y: 2.0}, %Point{x: 5.0, y: 6.0}]
               },
               543
             }
    end

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

      assert Geometry.from_wkb(wkb) ==
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

      assert Geometry.from_wkb(wkb) ==
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

    test "returns a MultiPointZM (xdr)" do
      wkb = """
      00\
      c0000004\
      00000003\
      00\
      C0000001\
      403e0000000000004024000000000000402e0000000000004024000000000000\
      00\
      c0000001\
      404400000000000040440000000000004034000000000000403E000000000000\
      00\
      C0000001\
      40340000000000004044000000000000402E0000000000004034000000000000\
      """

      assert Geometry.from_wkb(wkb) ==
               {:ok,
                %MultiPointZM{
                  points:
                    MapSet.new([
                      %PointZM{x: 30.0, y: 10.0, z: 15.0, m: 10.0},
                      %PointZM{x: 20.0, y: 40.0, z: 15.0, m: 20.0},
                      %PointZM{x: 40.0, y: 40.0, z: 20.0, m: 30.0}
                    ])
                }}
    end

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

      assert Geometry.from_wkb(wkb) == {:ok, multi_polygon}
    end

    test "returns a MultiLineStringZM (xdr)" do
      wkb = """
      00\
      C0000005\
      00000002\
      00\
      C0000002\
      00000003\
      402400000000000040240000000000004034000000000000403E000000000000\
      4034000000000000403400000000000040440000000000004049000000000000\
      4024000000000000404400000000000040240000000000004034000000000000\
      00\
      C0000002\
      00000002\
      40440000000000004044000000000000403E0000000000004034000000000000\
      403E000000000000403E00000000000040440000000000004049000000000000\
      """

      multi_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            %LineStringZM{
              points: [
                %PointZM{x: 40.0, y: 40.0, z: 30.0, m: 20.0},
                %PointZM{x: 30.0, y: 30.0, z: 40.0, m: 50.0}
              ]
            },
            %LineStringZM{
              points: [
                %PointZM{x: 10.0, y: 10.0, z: 20.0, m: 30.0},
                %PointZM{x: 20.0, y: 20.0, z: 40.0, m: 50.0},
                %PointZM{x: 10.0, y: 40.0, z: 10.0, m: 20.0}
              ]
            }
          ])
      }

      assert Geometry.from_wkb(wkb) == {:ok, multi_string}
    end

    test "returns an error tuple for an incomplete MultiPointZM (xdr)" do
      wkb = """
      00\
      C0000004\
      00000003\
      00\
      C000\
      """

      assert Geometry.from_wkb(wkb) == {:error, "expected geometry code", "C000", 20}
    end

    test "returns an error tuple for an invalid geometry in MultiPointZM (xdr)" do
      wkb = """
      00\
      C0000004\
      00000003\
      00\
      C0000002\
      """

      assert Geometry.from_wkb(wkb) ==
               {:error, "unexpected code 'C0000002' for sub-geometry", "", 20}
    end

    test "returns an error tuple for a changing endian (xdr)" do
      wkb = """
      00\
      C0000004\
      00000003\
      01\
      C0000001\
      """

      assert Geometry.from_wkb(wkb) ==
               {:error, "expected endian flag '00', got '01'", "C0000001", 18}
    end

    test "returns an error tuple for a changing endian (ndr)" do
      wkb = """
      01\
      040000C0\
      03000000\
      00\
      C0000001\
      """

      assert Geometry.from_wkb(wkb) ==
               {:error, "expected endian flag '01', got '00'", "C0000001", 18}
    end

    test "returns an error tuple for an invalid endian in sub-category (ndr)" do
      wkb = """
      01\
      040000C0\
      03000000\
      66\
      C0000001\
      """

      assert Geometry.from_wkb(wkb) ==
               {:error, "expected endian flag '01', got '66'", "C0000001", 18}
    end

    test "returns an error tuple for an invalid sub-category code (ndr)" do
      wkb = """
      01\
      040000C0\
      03000000\
      01\
      C00XXX01\
      """

      assert Geometry.from_wkb(wkb) == {:error, "invalid sub-geomtry code: C00XXX01", "", 20}
    end

    test "returns an error tuple for an unknown sub-category code (ndr)" do
      wkb = """
      01\
      040000C0\
      03000000\
      01\
      C00AAA01\
      """

      assert Geometry.from_wkb(wkb) == {:error, "unknown sub-geomtry code: C00AAA01", "", 20}
    end

    test "returns an error tuple for an unknown endian flag" do
      wkb = "11rest"

      assert Geometry.from_wkb(wkb) ==
               {:error, "expected endian flag '00' or '01', got '11'", "rest", 0}
    end

    test "returns an error tuple for an unknown geometry code" do
      wkb = "0012345678rest"

      assert Geometry.from_wkb(wkb) ==
               {:error, "unknown geomtry code: 12345678", "rest", 2}
    end

    test "returns an error tuple for an invalid geometry code" do
      wkb = "00X2345678rest"

      assert Geometry.from_wkb(wkb) ==
               {:error, "invalid geomtry code: X2345678", "rest", 2}
    end

    test "returns an error tuple for invalid coordinate" do
      wkb = "0000000001invalid.."

      assert Geometry.from_wkb(wkb) == {:error, "invalid coordiante", "invalid..", 10}
    end

    test "returns an error tuple for invalid y-coordinate in Point" do
      wkb = "0000000001BFF3333333333333400B333333333XYZ"

      assert Geometry.from_wkb(wkb) == {:error, "expected float, got '400B333333333XYZ'", "", 26}
    end

    test "returns an error tuple for invalid x-coordinate in Point" do
      wkb = "0000000001BFF333 333333333400B333333333ABC"

      assert Geometry.from_wkb(wkb) == {:error, "expected float, got 'BFF333 333333333'", "", 10}
    end

    test "returns an error tuple for invalid x-coordinate in PointZ" do
      wkb = """
      01\
      01000080\
      3333333333*3F3BF\
      3333333333330B40\
      0000000000001440\
      """

      assert Geometry.from_wkb(wkb) == {:error, "expected float, got '3333333333*3F3BF'", "", 10}
    end

    test "returns an error tuple for invalid y-coordinate in PointZ" do
      wkb = """
      01\
      01000080\
      333333333333F3BF\
      333*333333330B40\
      0000000000001440\
      """

      assert Geometry.from_wkb(wkb) == {:error, "expected float, got '333*333333330B40'", "", 26}
    end

    test "returns an error tuple for invalid z-coordinate in PointZ" do
      wkb = """
      01\
      01000080\
      333333333333F3BF\
      3333333333330B40\
      000000.000001440\
      """

      assert Geometry.from_wkb(wkb) == {:error, "expected float, got '000000.000001440'", "", 42}
    end

    test "returns an error tuple for invalid x-coordinate in PointM" do
      wkb = """
      01\
      01000040\
      3333333333*3F3BF\
      3333333333330B40\
      0000000000001440\
      """

      assert Geometry.from_wkb(wkb) == {:error, "expected float, got '3333333333*3F3BF'", "", 10}
    end

    test "returns an error tuple for invalid y-coordinate in PointM" do
      wkb = """
      01\
      01000040\
      333333333333F3BF\
      333*333333330B40\
      0000000000001440\
      """

      assert Geometry.from_wkb(wkb) == {:error, "expected float, got '333*333333330B40'", "", 26}
    end

    test "returns an error tuple for invalid m-coordinate in PointM" do
      wkb = """
      01\
      01000040\
      333333333333F3BF\
      3333333333330B40\
      000000.000001440\
      """

      assert Geometry.from_wkb(wkb) == {:error, "expected float, got '000000.000001440'", "", 42}
    end

    test "returns an error tuple for a missing SRID" do
      wkb = "01010000A05C"

      assert Geometry.from_wkb(wkb) == {:error, "expected SRID, got '5C'", "5C", 10}
    end

    test "returns an error tuple for an invalid SRID" do
      wkb = "01010000A05C.50000333"

      assert Geometry.from_wkb(wkb) == {:error, "invalid SRID '5C.50000'", "333", 10}
    end

    test "returns an error tuple for too much data" do
      wkb = "0000000001BFF3332333333333400B333333333ABC0000"

      assert Geometry.from_wkb(wkb) == {:error, "expected EOS", "0000", 42}
    end

    test "returns an error tuple for incomplete length in LineStringZM" do
      wkb = """
      01\
      020000C0\
      0200\
      """

      assert {:error, "expected length, got '0200'", "0200", 10} = Geometry.from_wkb(wkb)
    end

    test "returns an error tuple for invalid length in LineStringZM" do
      wkb = """
      01\
      020000C0\
      0200.000\
      9A9999999999F1BF\
      9A999999999901C0\
      6666666666660AC0\
      9A999999999911C0\
      0000000000001640\
      6666666666661A40\
      CDCCCCCCCCCC1E40\
      9A99999999992140\
      """

      assert {:error, "invalid length '0200.000'", _rest, 10} = Geometry.from_wkb(wkb)
    end

    test "returns an error tuple for invalid x-coordinate in LineStringZM" do
      wkb = """
      01\
      020000C0\
      02000000\
      9A99999999.9F1BF\
      9A999999999901C0\
      6666666666660AC0\
      9A999999999911C0\
      0000000000001640\
      6666666666661A40\
      CDCCCCCCCCCC1E40\
      9A99999999992140\
      """

      assert {:error, "expected float, got '9A99999999.9F1BF'", _rest, 18} =
               Geometry.from_wkb(wkb)
    end

    test "returns an error tuple for invalid y-coordinate in LineStringZM" do
      wkb = """
      01\
      020000C0\
      02000000\
      9A9999999999F1BF\
      9A99999999990.C0\
      6666666666660AC0\
      9A999999999911C0\
      0000000000001640\
      6666666666661A40\
      CDCCCCCCCCCC1E40\
      9A99999999992140\
      """

      assert {:error, "expected float, got '9A99999999990.C0'", _rest, 34} =
               Geometry.from_wkb(wkb)
    end

    test "returns an error tuple for invalid z-coordinate in LineStringZM" do
      wkb = """
      01\
      020000C0\
      02000000\
      9A9999999999F1BF\
      9A999999999901C0\
      6666666666660AC0\
      9A999999999911C0\
      0000000000001640\
      6666666666661A40\
      CDCCCCCCCCCC.E40\
      9A99999999992140\
      """

      assert {:error, "expected float, got 'CDCCCCCCCCCC.E40'", _rest, 114} =
               Geometry.from_wkb(wkb)
    end

    test "returns an error tuple for invalid m-coordinate in LineStringZM" do
      wkb = """
      01\
      020000C0\
      02000000\
      9A9999999999F1BF\
      9A999999999901C0\
      6666666666660AC0\
      9A999999999911C0\
      0000000000001640\
      6666666666661A40\
      CDCCCCCCCCCC1E40\
      9A9999999999.140\
      """

      assert {:error, "expected float, got '9A9999999999.140'", _rest, 130} =
               Geometry.from_wkb(wkb)
    end

    test "returns an error tuple for an incomplete geometry code" do
      wkb = """
      01\
      0200\
      """

      assert Geometry.from_wkb(wkb) == {:error, "expected geometry code", "0200", 2}
    end

    test "returns an error tuple for an empty string" do
      assert Geometry.from_wkb("") == {:error, "expected endian flag '00' or '01'", "", 0}
    end
  end

  describe "from_wkb!/1" do
    test "returns Point" do
      wkb = "0000000001BFF3333333333333400B333333333333"
      assert Geometry.from_wkb!(wkb) == %Point{x: -1.2, y: 3.4}
    end

    test "returns Point with SRID" do
      wkb = "00200000010000014DBFF3333333333333400B333333333333"
      assert Geometry.from_wkb!(wkb) == {%Point{x: -1.2, y: 3.4}, 333}
    end

    test "returns an exception for invalid m-coordinate in LineStringZM" do
      wkb = """
      01\
      020000C0\
      02000000\
      9A9999999999F1BF\
      9A999999999901C0\
      6666666666660AC0\
      9A999999999911C0\
      0000000000001640\
      6666666666661A40\
      CDCCCCCCCCCC1E40\
      9A9999999999.140\
      """

      message = "expected float, got '9A9999999999.140', at position 130"

      assert_raise Geometry.Error, message, fn ->
        Geometry.from_wkb!(wkb)
      end
    end
  end
end
