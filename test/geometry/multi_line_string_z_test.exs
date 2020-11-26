defmodule Geometry.MultiLineStringZTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{Hex, LineStringZ, MultiLineStringZ, PointZ}

  doctest Geometry.MultiLineStringZ, import: true

  @moduletag :multi_line_string

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiLineStringZ.to_geo_json(
          MultiLineStringZ.from_coordinates([
            [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
            [[-10, 10, 10], [-20, 20, 20]]
          ])
        )

      assert GeoJsonValidator.valid?(geo_json)

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiLineString"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [[-10, 10, 10], [-20, 20, 20]],
               [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]]
             ]
    end
  end

  describe "from_geo_json!/2" do
    test "returns a MultiLineStringZ" do
      geo_json =
        Jason.decode!("""
           {
             "type": "MultiLineString",
             "coordinates": [
               [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
               [[-10, 10, 10], [-20, 20, 20]]
             ]
           }
        """)

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(-1, 1, 1),
            PointZ.new(2, 2, 2),
            PointZ.new(-3, 3, 3)
          ]),
          LineStringZ.new([
            PointZ.new(-10, 10, 10),
            PointZ.new(-20, 20, 20)
          ])
        ])

      assert MultiLineStringZ.from_geo_json!(geo_json) == multi_line_string
    end

    test "raises an error for an invalid geo-json-term" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZ.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiLineStriingZM" do
      assert MultiLineStringZ.to_wkt(MultiLineStringZ.new()) ==
               "MultiLineString Z EMPTY"
    end

    test "returns WKT for a MultiLineStringZ" do
      wkt =
        MultiLineStringZ.to_wkt(
          MultiLineStringZ.new([
            LineStringZ.new([PointZ.new(7.1, 8.1, 1.1), PointZ.new(9.2, 5.2, 2.2)]),
            LineStringZ.new([PointZ.new(5.5, 9.2, 3.1), PointZ.new(1.2, 3.2, 4.2)])
          ])
        )

      assert String.starts_with?(wkt, "MultiLineString Z")
      assert wkt =~ "(5.5 9.2 3.1, 1.2 3.2 4.2)"
      assert wkt =~ "(7.1 8.1 1.1, 9.2 5.2 2.2)"
    end

    test "returns WKT with SRID for a MultiLineStringZ" do
      wkt =
        MultiLineStringZ.to_wkt(
          MultiLineStringZ.new([
            LineStringZ.new([PointZ.new(7.1, 8.1, 1.1), PointZ.new(9.2, 5.2, 2.2)]),
            LineStringZ.new([PointZ.new(5.5, 9.2, 3.1), PointZ.new(1.2, 3.2, 4.2)])
          ]),
          srid: 555
        )

      assert String.starts_with?(wkt, "SRID=555;MultiLineString Z")
      assert wkt =~ "(5.5 9.2 3.1, 1.2 3.2 4.2)"
      assert wkt =~ "(7.1 8.1 1.1, 9.2 5.2 2.2)"
    end
  end

  describe "from_wkt!/1" do
    test "returns a LineStringZ" do
      wkt = """
      MultiLineString Z (
        (10 20 10, 20 10 35, 20 40 10),
        (40 30 10, 30 30 25)
      )
      """

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            [
              [40, 30, 10],
              [30, 30, 25]
            ],
            [
              [10, 20, 10],
              [20, 10, 35],
              [20, 40, 10]
            ]
          ])
      }

      assert MultiLineStringZ.from_wkt!(wkt) == multi_line_string
    end

    test "returns a LineStringZ with SRID" do
      wkt = """
      SRID=1234;MultiLineString Z (
        (10 20 10, 20 10 35, 20 40 10),
        (40 30 10, 30 30 25)
      )
      """

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            [
              [40, 30, 10],
              [30, 30, 25]
            ],
            [
              [10, 20, 10],
              [20, 10, 35],
              [20, 40, 10]
            ]
          ])
      }

      assert MultiLineStringZ.from_wkt!(wkt) == {multi_line_string, 1234}
    end

    test "raises an error for an invalid WKT" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "Larry")

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZ.from_wkt!("Larry")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns WKB as xdr-binary from a MultiLineStringZ" do
      wkb_start =  "0080000005000000020080000002"

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            [
              [40.0, 40.0, 30.0],
              [30.0, 30.0, 40.0]
            ],
            [
              [10.0, 10.0, 20.0],
              [20.0, 20.0, 40.0],
              [10.0, 40.0, 10.0]
            ]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineStringZ.to_wkb(multi_line_string, endian: :xdr)
      assert String.starts_with?(result, Hex.to_binary(wkb_start))
      assert MultiLineStringZ.from_wkb!(result) == multi_line_string
    end

    test "returns WKB as xdr-string from a MultiLineStringZ" do
      wkb_start =  "0080000005000000020080000002"

      multi_line_string = %MultiLineStringZ{
        line_strings:
          MapSet.new([
            [
              [40.0, 40.0, 30.0],
              [30.0, 30.0, 40.0]
            ],
            [
              [10.0, 10.0, 20.0],
              [20.0, 20.0, 40.0],
              [10.0, 40.0, 10.0]
            ]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineStringZ.to_wkb(multi_line_string, endian: :xdr, mode: :hex)
      assert String.starts_with?(result, wkb_start)
      assert MultiLineStringZ.from_wkb!(result, :hex) == multi_line_string
    end

    test "returns WKB as xdr-string from a MultiLineStringZ with an SRID" do
      wkb = """
      00\
      A0000005\
      0000028E\
      00000001\
      00\
      80000002\
      00000002\
      3FF199999999999A3FF33333333333333FF4CCCCCCCCCCCD\
      3FF80000000000003FF999999999999A3FFB333333333333\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(1.1, 1.2, 1.3),
            PointZ.new(1.5, 1.6, 1.7)
          ])
        ])

      assert MultiLineStringZ.to_wkb(multi_line_string, srid: 654, mode: :hex) == wkb
    end

    test "returns WKB as xdr-binary from a MultiLineStringZ with an SRID" do
      wkb = """
      00\
      A0000005\
      0000028E\
      00000001\
      00\
      80000002\
      00000002\
      3FF199999999999A3FF33333333333333FF4CCCCCCCCCCCD\
      3FF80000000000003FF999999999999A3FFB333333333333\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(1.1, 1.2, 1.3),
            PointZ.new(1.5, 1.6, 1.7)
          ])
        ])

      assert MultiLineStringZ.to_wkb(multi_line_string, srid: 654) ==
               Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from a MultiLineStringZ" do
      wkb = """
      01\
      05000080\
      01000000\
      01\
      02000080\
      02000000\
      9A9999999999F13F333333333333F33FCDCCCCCCCCCCF43F\
      000000000000F83F9A9999999999F93F333333333333FB3F\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(1.1, 1.2, 1.3),
            PointZ.new(1.5, 1.6, 1.7)
          ])
        ])

      assert MultiLineStringZ.to_wkb(multi_line_string, endian: :ndr, mode: :hex) == wkb
    end

    test "returns WKB as ndr-binary from a MultiLineStringZ" do
      wkb = """
      01\
      05000080\
      01000000\
      01\
      02000080\
      02000000\
      9A9999999999F13F333333333333F33FCDCCCCCCCCCCF43F\
      000000000000F83F9A9999999999F93F333333333333FB3F\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(1.1, 1.2, 1.3),
            PointZ.new(1.5, 1.6, 1.7)
          ])
        ])

      assert MultiLineStringZ.to_wkb(multi_line_string, endian: :ndr) ==
               Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from a MultiLineStringZ with SRID" do
      wkb = """
      01\
      050000A0\
      15030000\
      01000000\
      01\
      02000080\
      02000000\
      9A9999999999F13F333333333333F33FCDCCCCCCCCCCF43F\
      000000000000F83F9A9999999999F93F333333333333FB3F\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(1.1, 1.2, 1.3),
            PointZ.new(1.5, 1.6, 1.7)
          ])
        ])

      assert MultiLineStringZ.to_wkb(
               multi_line_string,
               srid: 789,
               endian: :ndr,
               mode: :hex
             ) ==
               wkb
    end

    test "returns WKB as ndr-binary from a MultiLineStringZ with SRID" do
      wkb = """
      01\
      050000A0\
      15030000\
      01000000\
      01\
      02000080\
      02000000\
      9A9999999999F13F333333333333F33FCDCCCCCCCCCCF43F\
      000000000000F83F9A9999999999F93F333333333333FB3F\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(1.1, 1.2, 1.3),
            PointZ.new(1.5, 1.6, 1.7)
          ])
        ])

      assert MultiLineStringZ.to_wkb(
               multi_line_string,
               srid: 789,
               endian: :ndr
             ) ==
               Hex.to_binary(wkb)
    end
  end

  describe "from_wkb/2" do
    test "returns a MultiLineStringZ from xdr-string" do
      wkb = """
      00\
      80000005\
      00000002\
      00\
      80000002\
      00000003\
      402400000000000040240000000000004034000000000000\
      403400000000000040340000000000004044000000000000\
      402400000000000040440000000000004024000000000000\
      00\
      80000002\
      00000002\
      40440000000000004044000000000000403E000000000000\
      403E000000000000403E0000000000004044000000000000\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(40.0, 40.0, 30.0),
            PointZ.new(30.0, 30.0, 40.0)
          ]),
          LineStringZ.new([
            PointZ.new(10.0, 10.0, 20.0),
            PointZ.new(20.0, 20.0, 40.0),
            PointZ.new(10.0, 40.0, 10.0)
          ])
        ])

      assert MultiLineStringZ.from_wkb(wkb, :hex) == {:ok, multi_line_string}
    end

    test "returns a MultiLineStringZ from xdr-binary" do
      wkb = """
      00\
      80000005\
      00000002\
      00\
      80000002\
      00000003\
      402400000000000040240000000000004034000000000000\
      403400000000000040340000000000004044000000000000\
      402400000000000040440000000000004024000000000000\
      00\
      80000002\
      00000002\
      40440000000000004044000000000000403E000000000000\
      403E000000000000403E0000000000004044000000000000\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(40.0, 40.0, 30.0),
            PointZ.new(30.0, 30.0, 40.0)
          ]),
          LineStringZ.new([
            PointZ.new(10.0, 10.0, 20.0),
            PointZ.new(20.0, 20.0, 40.0),
            PointZ.new(10.0, 40.0, 10.0)
          ])
        ])

      assert wkb |> Hex.to_binary() |> MultiLineStringZ.from_wkb() == {:ok, multi_line_string}
    end
  end

  describe "from_wkb!/2" do
    test "returns a MultiLineStringZ from xdr-string" do
      wkb = """
      00\
      80000005\
      00000002\
      00\
      80000002\
      00000003\
      402400000000000040240000000000004034000000000000\
      403400000000000040340000000000004044000000000000\
      402400000000000040440000000000004024000000000000\
      00\
      80000002\
      00000002\
      40440000000000004044000000000000403E000000000000\
      403E000000000000403E0000000000004044000000000000\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(40.0, 40.0, 30.0),
            PointZ.new(30.0, 30.0, 40.0)
          ]),
          LineStringZ.new([
            PointZ.new(10.0, 10.0, 20.0),
            PointZ.new(20.0, 20.0, 40.0),
            PointZ.new(10.0, 40.0, 10.0)
          ])
        ])

      assert MultiLineStringZ.from_wkb!(wkb, :hex) == multi_line_string
    end

    test "returns a MultiLineStringZ from xdr-binary" do
      wkb = """
      00\
      80000005\
      00000002\
      00\
      80000002\
      00000003\
      402400000000000040240000000000004034000000000000\
      403400000000000040340000000000004044000000000000\
      402400000000000040440000000000004024000000000000\
      00\
      80000002\
      00000002\
      40440000000000004044000000000000403E000000000000\
      403E000000000000403E0000000000004044000000000000\
      """

      multi_line_string =
        MultiLineStringZ.new([
          LineStringZ.new([
            PointZ.new(40.0, 40.0, 30.0),
            PointZ.new(30.0, 30.0, 40.0)
          ]),
          LineStringZ.new([
            PointZ.new(10.0, 10.0, 20.0),
            PointZ.new(20.0, 20.0, 40.0),
            PointZ.new(10.0, 40.0, 10.0)
          ])
        ])

      assert wkb |> Hex.to_binary() |> MultiLineStringZ.from_wkb!() == multi_line_string
    end

    test "raises an error for an invalid WKB string" do
      message = ~s(expected endian flag "00" or "01", got "no", at position 0)

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZ.from_wkb!("nonono", :hex)
      end
    end

    test "raises an error for an invalid WKB binary" do
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZ.from_wkb!("nonono")
      end
    end
  end

  test "Enum.slice/3" do
    multi_line_string =
      MultiLineStringZ.new([
        LineStringZ.new([
          PointZ.new(1, 2, 3),
          PointZ.new(3, 4, 5)
        ]),
        LineStringZ.new([
          PointZ.new(1, 2, 3),
          PointZ.new(11, 12, 13),
          PointZ.new(13, 14, 15)
        ])
      ])

    assert [_line_string] = Enum.slice(multi_line_string, 1, 1)
  end
end
