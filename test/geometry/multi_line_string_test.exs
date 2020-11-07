defmodule Geometry.MultiLineStringTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{Hex, LineString, MultiLineString, Point}

  doctest Geometry.MultiLineString, import: true

  @moduletag :multi_line_string

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiLineString.to_geo_json(
          MultiLineString.from_coordinates([
            [[-1, 1], [2, 2], [-3, 3]],
            [[-10, 10], [-20, 20]]
          ])
        )

      assert GeoJsonValidator.valid?(geo_json)

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiLineString"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [[-10, 10], [-20, 20]],
               [[-1, 1], [2, 2], [-3, 3]]
             ]
    end
  end

  describe "from_geo_json!/2" do
    test "returns a MultiLineString" do
      geo_json =
        Jason.decode!("""
           {
             "type": "MultiLineString",
             "coordinates": [
               [[-1, 1], [2, 2], [-3, 3]],
               [[-10, 10], [-20, 20]]
             ]
           }
        """)

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(-1, 1),
            Point.new(2, 2),
            Point.new(-3, 3)
          ]),
          LineString.new([
            Point.new(-10, 10),
            Point.new(-20, 20)
          ])
        ])

      assert MultiLineString.from_geo_json!(geo_json) == multi_line_string
    end

    test "raises an error for an invalid geo-json-term" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiLineString.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiLineStriingZM" do
      assert MultiLineString.to_wkt(MultiLineString.new()) ==
               "MultiLineString EMPTY"
    end

    test "returns WKT for a MultiLineString" do
      wkt =
        MultiLineString.to_wkt(
          MultiLineString.new([
            LineString.new([Point.new(7.1, 8.1), Point.new(9.2, 5.2)]),
            LineString.new([Point.new(5.5, 9.2), Point.new(1.2, 3.2)])
          ])
        )

      assert String.starts_with?(wkt, "MultiLineString")
      assert wkt =~ "(5.5 9.2, 1.2 3.2)"
      assert wkt =~ "(7.1 8.1, 9.2 5.2)"
    end

    test "returns WKT with SRID for a MultiLineString" do
      wkt =
        MultiLineString.to_wkt(
          MultiLineString.new([
            LineString.new([Point.new(7.1, 8.1), Point.new(9.2, 5.2)]),
            LineString.new([Point.new(5.5, 9.2), Point.new(1.2, 3.2)])
          ]),
          srid: 555
        )

      assert String.starts_with?(wkt, "SRID=555;MultiLineString")
      assert wkt =~ "(5.5 9.2, 1.2 3.2)"
      assert wkt =~ "(7.1 8.1, 9.2 5.2)"
    end
  end

  describe "from_wkt!/1" do
    test "returns a LineString" do
      wkt = """
      MultiLineString (
        (10 20, 20 10, 20 40),
        (40 30, 30 30)
      )
      """

      multi_line_string = %MultiLineString{
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
      }

      assert MultiLineString.from_wkt!(wkt) == multi_line_string
    end

    test "returns a LineString with SRID" do
      wkt = """
      SRID=1234;MultiLineString (
        (10 20, 20 10, 20 40),
        (40 30, 30 30)
      )
      """

      multi_line_string = %MultiLineString{
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
      }

      assert MultiLineString.from_wkt!(wkt) == {multi_line_string, 1234}
    end

    test "raises an error for an invalid WKT" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "Larry")

      assert_raise Geometry.Error, message, fn ->
        MultiLineString.from_wkt!("Larry")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns WKB as xdr-binary from a MultiLineString" do
      wkb_start = "0000000005000000020000000002"

      multi_line_string = %MultiLineString{
        line_strings:
          MapSet.new([
            [
              [40.0, 40.0],
              [30.0, 30.0]
            ],
            [
              [10.0, 10.0],
              [20.0, 20.0],
              [10.0, 40.0]
            ]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineString.to_wkb(multi_line_string, endian: :xdr)
      assert String.starts_with?(result, Hex.to_binary(wkb_start))
      assert MultiLineString.from_wkb!(result) == multi_line_string
    end

    test "returns WKB as xdr-string from a MultiLineString" do
      wkb_start = "0000000005000000020000000002"

      multi_line_string = %MultiLineString{
        line_strings:
          MapSet.new([
            [
              [40.0, 40.0],
              [30.0, 30.0]
            ],
            [
              [10.0, 10.0],
              [20.0, 20.0],
              [10.0, 40.0]
            ]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineString.to_wkb(multi_line_string, endian: :xdr, mode: :hex)
      assert String.starts_with?(result, wkb_start)
      assert MultiLineString.from_wkb!(result, :hex) == multi_line_string
    end

    test "returns WKB as xdr-string from a MultiLineString with an SRID" do
      wkb = """
      00\
      20000005\
      0000028E\
      00000001\
      00\
      00000002\
      00000002\
      3FF199999999999A3FF3333333333333\
      3FF80000000000003FF999999999999A\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(1.1, 1.2),
            Point.new(1.5, 1.6)
          ])
        ])

      assert MultiLineString.to_wkb(multi_line_string, srid: 654, mode: :hex) == wkb
    end

    test "returns WKB as xdr-binary from a MultiLineString with an SRID" do
      wkb = """
      00\
      20000005\
      0000028E\
      00000001\
      00\
      00000002\
      00000002\
      3FF199999999999A3FF3333333333333\
      3FF80000000000003FF999999999999A\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(1.1, 1.2),
            Point.new(1.5, 1.6)
          ])
        ])

      assert MultiLineString.to_wkb(multi_line_string, srid: 654) ==
               Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from a MultiLineString" do
      wkb = """
      01\
      05000000\
      01000000\
      01\
      02000000\
      02000000\
      9A9999999999F13F333333333333F33F\
      000000000000F83F9A9999999999F93F\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(1.1, 1.2),
            Point.new(1.5, 1.6)
          ])
        ])

      assert MultiLineString.to_wkb(multi_line_string, endian: :ndr, mode: :hex) == wkb
    end

    test "returns WKB as ndr-binary from a MultiLineString" do
      wkb = """
      01\
      05000000\
      01000000\
      01\
      02000000\
      02000000\
      9A9999999999F13F333333333333F33F\
      000000000000F83F9A9999999999F93F\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(1.1, 1.2),
            Point.new(1.5, 1.6)
          ])
        ])

      assert MultiLineString.to_wkb(multi_line_string, endian: :ndr) ==
               Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from a MultiLineString with SRID" do
      wkb = """
      01\
      05000020\
      15030000\
      01000000\
      01\
      02000000\
      02000000\
      9A9999999999F13F333333333333F33F\
      000000000000F83F9A9999999999F93F\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(1.1, 1.2),
            Point.new(1.5, 1.6)
          ])
        ])

      assert MultiLineString.to_wkb(
               multi_line_string,
               srid: 789,
               endian: :ndr,
               mode: :hex
             ) ==
               wkb
    end

    test "returns WKB as ndr-binary from a MultiLineString with SRID" do
      wkb = """
      01\
      05000020\
      15030000\
      01000000\
      01\
      02000000\
      02000000\
      9A9999999999F13F333333333333F33F\
      000000000000F83F9A9999999999F93F\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(1.1, 1.2),
            Point.new(1.5, 1.6)
          ])
        ])

      assert MultiLineString.to_wkb(
               multi_line_string,
               srid: 789,
               endian: :ndr
             ) ==
               Hex.to_binary(wkb)
    end
  end

  describe "from_wkb/2" do
    test "returns a MultiLineString from xdr-string" do
      wkb = """
      00\
      00000005\
      00000002\
      00\
      00000002\
      00000003\
      40240000000000004024000000000000\
      40340000000000004034000000000000\
      40240000000000004044000000000000\
      00\
      00000002\
      00000002\
      40440000000000004044000000000000\
      403E000000000000403E000000000000\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(40.0, 40.0),
            Point.new(30.0, 30.0)
          ]),
          LineString.new([
            Point.new(10.0, 10.0),
            Point.new(20.0, 20.0),
            Point.new(10.0, 40.0)
          ])
        ])

      assert MultiLineString.from_wkb(wkb, :hex) == {:ok, multi_line_string}
    end

    test "returns a MultiLineString from xdr-binary" do
      wkb = """
      00\
      00000005\
      00000002\
      00\
      00000002\
      00000003\
      40240000000000004024000000000000\
      40340000000000004034000000000000\
      40240000000000004044000000000000\
      00\
      00000002\
      00000002\
      40440000000000004044000000000000\
      403E000000000000403E000000000000\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(40.0, 40.0),
            Point.new(30.0, 30.0)
          ]),
          LineString.new([
            Point.new(10.0, 10.0),
            Point.new(20.0, 20.0),
            Point.new(10.0, 40.0)
          ])
        ])

      assert wkb |> Hex.to_binary() |> MultiLineString.from_wkb() == {:ok, multi_line_string}
    end
  end

  describe "from_wkb!/2" do
    test "returns a MultiLineString from xdr-string" do
      wkb = """
      00\
      00000005\
      00000002\
      00\
      00000002\
      00000003\
      40240000000000004024000000000000\
      40340000000000004034000000000000\
      40240000000000004044000000000000\
      00\
      00000002\
      00000002\
      40440000000000004044000000000000\
      403E000000000000403E000000000000\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(40.0, 40.0),
            Point.new(30.0, 30.0)
          ]),
          LineString.new([
            Point.new(10.0, 10.0),
            Point.new(20.0, 20.0),
            Point.new(10.0, 40.0)
          ])
        ])

      assert MultiLineString.from_wkb!(wkb, :hex) == multi_line_string
    end

    test "returns a MultiLineString from xdr-binary" do
      wkb = """
      00\
      00000005\
      00000002\
      00\
      00000002\
      00000003\
      40240000000000004024000000000000\
      40340000000000004034000000000000\
      40240000000000004044000000000000\
      00\
      00000002\
      00000002\
      40440000000000004044000000000000\
      403E000000000000403E000000000000\
      """

      multi_line_string =
        MultiLineString.new([
          LineString.new([
            Point.new(40.0, 40.0),
            Point.new(30.0, 30.0)
          ]),
          LineString.new([
            Point.new(10.0, 10.0),
            Point.new(20.0, 20.0),
            Point.new(10.0, 40.0)
          ])
        ])

      assert wkb |> Hex.to_binary() |> MultiLineString.from_wkb!() == multi_line_string
    end

    test "raises an error for an invalid WKB string" do
      message = ~s(expected endian flag "00" or "01", got "no", at position 0)

      assert_raise Geometry.Error, message, fn ->
        MultiLineString.from_wkb!("nonono", :hex)
      end
    end

    test "raises an error for an invalid WKB binary" do
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiLineString.from_wkb!("nonono")
      end
    end
  end

  test "Enum.slice/3" do
    multi_line_string =
      MultiLineString.new([
        LineString.new([
          Point.new(1, 2),
          Point.new(3, 4)
        ]),
        LineString.new([
          Point.new(1, 2),
          Point.new(11, 12),
          Point.new(13, 14)
        ])
      ])

    assert [_line_string] = Enum.slice(multi_line_string, 1, 1)
  end
end
