defmodule GeometryTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Geometry.DecodeError

  alias Geometry.GeometryCollection
  alias Geometry.LineString
  alias Geometry.MultiLineString
  alias Geometry.MultiPoint
  alias Geometry.MultiPolygon
  alias Geometry.Point
  alias Geometry.PointZ
  alias Geometry.PointZM
  alias Geometry.Polygon

  doctest Geometry, import: true

  describe "from_wkt/1" do
    @describetag :wkt
    test "LineString: geometry -> ewkt -> geometry, integer values" do
      geometry_original = %Geometry.LineString{
        path: [
          [-8, 375],
          [-8, 37],
          [-8, 375],
          [-8, 376],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 375]
        ],
        srid: 4326
      }

      ewkt = Geometry.to_ewkt(geometry_original)

      geometry_hydrated = Geometry.from_ewkt!(ewkt)

      assert geometry_original == geometry_hydrated
    end

    test "LineString: geometry -> ewkt -> geometry, all floating point" do
      geometry_original = %Geometry.LineString{
        path: [
          [-8.91605728674111, 37.004786050505705],
          [-8.916004741413165, 37.01473548835222],
          [-8.915952155261275, 37.014681049196575],
          [-8.915962095363229, 37.014641876859656],
          [-8.916008623674168, 37.01461030595236],
          [-8.916081231858929, 37.01459027129624],
          [-8.91613341474863, 37.01460551438246],
          [-8.91618086764759, 37.0146639501776],
          [-8.916191835920474, 37.01471469650441],
          [-8.91621298667903, 37.01474979186158],
          [-8.916197854221068, 37.01479683407043],
          [-8.916182273129241, 37.01480081322952],
          [-8.916135584881212, 37.01481680058167],
          [-8.916094008628827, 37.01481707489911],
          [-8.91605728674111, 37.014786050505705]
        ],
        srid: 4326
      }

      ewkt = Geometry.to_ewkt(geometry_original)

      geometry_hydrated = Geometry.from_ewkt!(ewkt)

      assert geometry_original == geometry_hydrated
    end

    test "LineString: geometry -> ewkt -> geometry, mixed integer and floating point" do
      geometry_original = %Geometry.LineString{
        path: [
          [-8, 375],
          [-8, 37],
          [-8, 375],
          [-8.915952155261275, 37.014681049196575],
          [-8.915962095363229, 37.014641876859656],
          [-8.916008623674168, 37.01461030595236],
          [-8.916081231858929, 37.01459027129624],
          [-8.91613341474863, 37.01460551438246],
          [-8.91618086764759, 37.0146639501776],
          [-8.916191835920474, 37.01471469650441],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 37],
          [-8, 375]
        ],
        srid: 4326
      }

      ewkt = Geometry.to_ewkt(geometry_original)

      geometry_hydrated = Geometry.from_ewkt!(ewkt)

      assert geometry_original == geometry_hydrated
    end

    test "MultiPolygon: geometry -> ewkt -> geometry" do
      geometry_original = %Geometry.MultiPolygon{
        polygons: [
          [
            [
              [-8.91605728674111, 37.004786050505705],
              [-8.916004741413165, 37.01473548835222],
              [-8.915952155261275, 37.014681049196575],
              [-8.915962095363229, 37.014641876859656],
              [-8.916008623674168, 37.01461030595236],
              [-8.916081231858929, 37.01459027129624],
              [-8.91613341474863, 37.01460551438246],
              [-8.91618086764759, 37.0146639501776],
              [-8.916191835920474, 37.01471469650441],
              [-8.91621298667903, 37.01474979186158],
              [-8.916197854221068, 37.01479683407043],
              [-8.916182273129241, 37.01480081322952],
              [-8.916135584881212, 37.01481680058167],
              [-8.916094008628827, 37.01481707489911],
              [-8.91605728674111, 37.014786050505705]
            ]
          ]
        ],
        srid: 4326
      }

      ewkt = Geometry.to_ewkt(geometry_original)

      geometry_hydrated = Geometry.from_ewkt!(ewkt)

      assert geometry_original == geometry_hydrated
    end

    test "returns an error tuple" do
      assert Geometry.from_wkt("Dot M (4 6 7)") == {
               :error,
               %DecodeError{
                 from: :wkt,
                 line: {1, 0},
                 message: "expected geometry name or SRID",
                 offset: 0,
                 reason: nil,
                 rest: "Dot M (4 6 7)"
               }
             }
    end

    test "returns an error tuple for an unexpected geometry in collection" do
      wkt = """
      GeometryCollection ZM (\
        LineString ZM (5 9 2 1, 7 8 4 2),
        Point Z (2 3 1),\
        Polygon ZM ((1 1 1 1, 9 1 4 2, 9 8 4 3, 1 1 1 4), (6 2 1 5, 7 2 4 6, 7 3 5 7, 6 2 1 8))\
      )
      """

      assert Geometry.from_wkt(wkt) == {
               :error,
               %DecodeError{
                 from: :wkt,
                 line: {2, 59},
                 message: "unexpected geometry in collection",
                 offset: 69,
                 reason: nil,
                 rest:
                   "(2 3 1),  Polygon ZM ((1 1 1 1, 9 1 4 2, 9 8 4 3, 1 1 1 4), (6 2 1 5, 7 2 4 6, 7 3 5 7, 6 2 1 8)))\n"
               }
             }
    end

    test "returns an error tuple for an ivalid srid in collection" do
      wkt = """
      GeometryCollection ZM (\
        LineString ZM (5 9 2 1, 7 8 4 2),
        SRID=55;Point ZM (4 2 3 1),\
        Polygon ZM ((1 1 1 1, 9 1 4 2, 9 8 4 3, 1 1 1 4), (6 2 1 5, 7 2 4 6, 7 3 5 7, 6 2 1 8))\
      )
      """

      assert Geometry.from_wkt(wkt) == {
               :error,
               %DecodeError{
                 from: :wkt,
                 line: {2, 59},
                 message: "unexpected SRID in collection",
                 offset: 78,
                 reason: nil,
                 rest:
                   "(4 2 3 1),  Polygon ZM ((1 1 1 1, 9 1 4 2, 9 8 4 3, 1 1 1 4), (6 2 1 5, 7 2 4 6, 7 3 5 7, 6 2 1 8)))\n"
               }
             }
    end
  end

  describe "from_wkt!/1" do
    @describetag :wkt

    test "returns an error" do
      wkt = "Dot M (4 6 7)"
      message = ~s|expected geometry name or SRID at 1:0, got: "Dot M (4 ..."|

      assert_fail :from_wkt!, wkt, message
    end

    test "returns an error without ..." do
      wkt = "Point M (4 6 X)"
      message = ~s|expected Point data at 1:8, got: "(4 6 X)"|

      assert_fail :from_wkt!, wkt, message
    end
  end

  describe "from_ewkt/1" do
    @describetag :wkt

    test "returns an error tuple" do
      assert Geometry.from_ewkt("Dot M (4 6 7)") == {
               :error,
               %DecodeError{
                 from: :wkt,
                 line: {1, 0},
                 message: "expected geometry name or SRID",
                 offset: 0,
                 reason: nil,
                 rest: "Dot M (4 6 7)"
               }
             }
    end
  end

  describe "from_ewkt!/1" do
    @describetag :wkt

    test "returns an error" do
      wkt = "Dot M (4 6 7)"
      message = ~s|expected geometry name or SRID at 1:0, got: "Dot M (4 ..."|

      assert_fail :from_ewkt!, wkt, message
    end
  end

  describe "from_wkb/1" do
    @describetag :wkb

    test "geometry collection supports multilinestrings" do
      data =
        <<1, 7, 0, 0, 32, 230, 16, 0, 0, 2, 0, 0, 0, 1, 5, 0, 0, 0, 2, 0, 0, 0, 1, 2, 0, 0, 0, 2,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 64, 0, 0, 0, 0, 0, 128, 86, 192, 0, 0, 0, 0, 0, 0, 62,
          64, 0, 0, 0, 0, 0, 160, 86, 192, 1, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 64, 0,
          0, 0, 0, 0, 160, 86, 192, 0, 0, 0, 0, 0, 0, 62, 64, 0, 0, 0, 0, 0, 192, 86, 192, 1, 5,
          0, 0, 0, 0, 0, 0, 0>>

      textual =
        "SRID=4326;GEOMETRYCOLLECTION(MULTILINESTRING((30 -90,30 -90.5),(30 -90.5,30 -91)),MULTILINESTRING EMPTY)"

      {:ok, expected} = Geometry.from_wkt(textual)

      {:ok, actual} = Geometry.from_wkb(data)

      assert expected == actual
    end

    test "geometry collections supports all possible nested types" do
      srid = 4326
      point = Point.new([1, 2], srid)
      linestring = LineString.new([point, point], srid)
      polygon = Polygon.new([linestring], srid)
      multilinestring = MultiLineString.new([linestring], srid)
      multipoint = MultiPoint.new([point], srid)
      multipolygon = MultiPolygon.new([polygon], srid)

      collection =
        GeometryCollection.new(
          [
            point,
            linestring,
            polygon,
            multilinestring,
            multipoint,
            multipolygon
          ],
          4326
        )

      outer = GeometryCollection.new([collection], 4326)

      ewkb = Geometry.to_ewkb(outer)

      assert {:ok, outer} == Geometry.from_ewkb(ewkb)
    end

    test "returns an error tuple for an empty binary" do
      assert Geometry.from_wkb(<<>>) == {:error, %DecodeError{from: :wkb, reason: :empty}}
    end

    test "returns an error tuple for none binary" do
      assert Geometry.from_wkb(:bin) ==
               {:error, %DecodeError{from: :wkb, reason: :no_binary, rest: :bin}}
    end

    test "returns an error tuple for an invalid endian flag" do
      wkb = Base.decode16!("5500")

      assert Geometry.from_wkb(wkb) == {
               :error,
               %DecodeError{
                 from: :wkb,
                 rest: <<85, 0>>,
                 offset: 0,
                 reason: [expected_endian: :flag]
               }
             }
    end

    test "returns an error tuple for an invalid geometry code" do
      wkb = Base.decode16!("00112233445566778899")

      assert Geometry.from_wkb(wkb) == {
               :error,
               %DecodeError{
                 from: :wkb,
                 rest: <<17, 34, 51, 68, 85, 102, 119, 136, 153>>,
                 offset: 1,
                 reason: :expected_geometry_code
               }
             }
    end

    test "returns an error for trailing whitespace" do
      wkb = Base.decode16!("0101000000000000000000F03F9A99999999990140") <> " \n "

      assert Geometry.from_wkb(wkb) == {
               :error,
               %DecodeError{
                 from: :wkb,
                 rest:
                   <<0, 0, 0, 0, 0, 0, 240, 63, 154, 153, 153, 153, 153, 153, 1, 64, 32, 10, 32>>,
                 offset: 5,
                 reason: :invalid_data
               }
             }
    end

    test "returns an error for invalid srid" do
      wkb = Base.decode16!("0020000003000012")

      assert Geometry.from_wkb(wkb) == {
               :error,
               %Geometry.DecodeError{
                 from: :wkb,
                 rest: <<0, 0, 18>>,
                 offset: 5,
                 reason: :invalid_srid
               }
             }
    end
  end

  describe "from_wkb!/1" do
    @describetag :wkb

    test "raises an error for an empty binary" do
      assert_fail :from_wkb!, <<>>, "empty binary"
    end

    test "raises an error for an invalid endian flag" do
      wkb = Base.decode16!("5500")

      assert_fail :from_wkb!, wkb, "expected endian flag at position 0, got: <<0x55, ...>>"
    end

    test "raises an error tuple for none binary" do
      assert_fail :from_wkb!, :bin, "expected binary, got: :bin"
    end

    test "raises an error for an invalid geometry code" do
      wkb = Base.decode16!("00112233445566778899")

      assert_fail :from_wkb!, wkb, """
      expected geometry code at position 1, got: <<0x11, 0x22, 0x33, 0x44, ...>>\
      """
    end

    test "raises an error for trailing whitespace" do
      wkb = Base.decode16!("0101000000000000000000F03F9A99999999990140") <> " \n "

      assert_fail :from_wkb!, wkb, """
      unexpected data at position 5, got: <<0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xF0, 0x3F, 0x9A, ...>>\
      """
    end

    test "raises an error for invalid srid" do
      wkb = Base.decode16!("0020000003000012")

      assert_fail :from_wkb!, wkb, """
      expected SRID at position 5, got: <<0x0, 0x0, 0x12>>\
      """
    end
  end

  describe "from_ewkb!/1" do
    @describetag :wkb

    test "raises an error for an empty binary" do
      assert_fail :from_ewkb!, <<>>, "empty binary"
    end

    test "raises an error for an invalid endian flag" do
      wkb = Base.decode16!("5500")

      assert_fail :from_ewkb!, wkb, "expected endian flag at position 0, got: <<0x55, ...>>"
    end

    test "raises an error tuple for none binary" do
      assert_fail :from_ewkb!, :bin, "expected binary, got: :bin"
    end

    test "raises an error for an invalid geometry code" do
      wkb = Base.decode16!("00112233445566778899")

      assert_fail :from_ewkb!, wkb, """
      expected geometry code at position 1, got: <<0x11, 0x22, 0x33, 0x44, ...>>\
      """
    end

    test "raises an error for trailing whitespace" do
      wkb = Base.decode16!("0101000000000000000000F03F9A99999999990140") <> " \n "

      assert_fail :from_ewkb!, wkb, """
      unexpected data at position 5, got: <<0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xF0, 0x3F, 0x9A, ...>>\
      """
    end

    test "raises an error for invalid srid" do
      wkb = Base.decode16!("0020000003000012")

      assert_fail :from_ewkb!, wkb, """
      expected SRID at position 5, got: <<0x0, 0x0, 0x12>>\
      """
    end
  end

  describe "from_geo_json" do
    @describetag :geo_json

    test "returns an error for an invalid geometry in collection" do
      geo_json = %{
        "geometries" => [
          %{"coordinates" => [[5, 9, 2], [7, 8, 4]], "type" => "LineString"},
          %{"coordinates" => [4, 2, 3], "type" => "Dot"},
          %{
            "coordinates" => [
              [[1, 1, 1], [9, 1, 4], [9, 8, 4], [1, 1, 1]],
              [[6, 2, 1], [7, 2, 4], [7, 3, 5], [6, 2, 1]]
            ],
            "type" => "Polygon"
          }
        ],
        "type" => "GeometryCollection"
      }

      assert Geometry.from_geo_json(geo_json) == {
               :error,
               %Geometry.DecodeError{
                 from: :geo_json,
                 reason: [unknown_type: "Dot"]
               }
             }
    end
  end
end
