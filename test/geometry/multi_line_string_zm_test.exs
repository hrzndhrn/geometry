defmodule Geometry.MultiLineStringZMTest do
  use ExUnit.Case, async: true

  alias Geometry.{Hex, LineStringZM, MultiLineStringZM, PointZM}

  doctest Geometry.MultiLineStringZM, import: true

  @moduletag :multi_line_string

  describe "to_geo_json/1" do
    test "returns geo-json-term" do
      geo_json =
        MultiLineStringZM.to_geo_json(
          MultiLineStringZM.from_coordinates([
            [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
            [[-10, 10, 10, 10], [-20, 20, 20, 20]]
          ])
        )

      assert GeoJsonValidator.valid?(geo_json)

      assert geo_json |> Map.keys() |> Enum.sort() == ["coordinates", "type"]
      assert Map.get(geo_json, "type") == "MultiLineString"

      assert geo_json |> Map.get("coordinates") |> Enum.sort() == [
               [[-10, 10, 10, 10], [-20, 20, 20, 20]],
               [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]]
             ]
    end
  end

  describe "from_geo_json!/2" do
    test "returns a MultiLineStringZM" do
      geo_json =
        Jason.decode!("""
           {
             "type": "MultiLineString",
             "coordinates": [
               [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
               [[-10, 10, 10, 10], [-20, 20, 20, 20]]
             ]
           }
        """)

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(-1, 1, 1, 1),
            PointZM.new(2, 2, 2, 2),
            PointZM.new(-3, 3, 3, 3)
          ]),
          LineStringZM.new([
            PointZM.new(-10, 10, 10, 10),
            PointZM.new(-20, 20, 20, 20)
          ])
        ])

      assert MultiLineStringZM.from_geo_json!(geo_json) == multi_line_string
    end

    test "raises an error for an invalid geo-json-term" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZM.from_geo_json!(%{})
      end
    end
  end

  describe "to_wkt/2" do
    test "returns WKT for an empty MultiLineStriingZM" do
      assert MultiLineStringZM.to_wkt(MultiLineStringZM.new()) ==
               "MultiLineString ZM EMPTY"
    end

    test "returns WKT for a MultiLineStringZM" do
      wkt =
        MultiLineStringZM.to_wkt(
          MultiLineStringZM.new([
            LineStringZM.new([PointZM.new(7.1, 8.1, 1.1, 1), PointZM.new(9.2, 5.2, 2.2, 2)]),
            LineStringZM.new([PointZM.new(5.5, 9.2, 3.1, 1), PointZM.new(1.2, 3.2, 4.2, 2)])
          ])
        )

      assert String.starts_with?(wkt, "MultiLineString ZM")
      assert wkt =~ "(5.5 9.2 3.1 1, 1.2 3.2 4.2 2)"
      assert wkt =~ "(7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"
    end

    test "returns WKT with SRID for a MultiLineStringZM" do
      wkt =
        MultiLineStringZM.to_wkt(
          MultiLineStringZM.new([
            LineStringZM.new([PointZM.new(7.1, 8.1, 1.1, 1), PointZM.new(9.2, 5.2, 2.2, 2)]),
            LineStringZM.new([PointZM.new(5.5, 9.2, 3.1, 1), PointZM.new(1.2, 3.2, 4.2, 2)])
          ]),
          srid: 555
        )

      assert String.starts_with?(wkt, "SRID=555;MultiLineString ZM")
      assert wkt =~ "(5.5 9.2 3.1 1, 1.2 3.2 4.2 2)"
      assert wkt =~ "(7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"
    end
  end

  describe "from_wkt!/1" do
    test "returns a LineStringZM" do
      wkt = """
      MultiLineString ZM (
        (10 20 10 45, 20 10 35 15, 20 40 10 15),
        (40 30 10 20, 30 30 25 30)
      )
      """

      multi_line_string = %MultiLineStringZM{
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
      }

      assert MultiLineStringZM.from_wkt!(wkt) == multi_line_string
    end

    test "returns a LineStringZM with SRID" do
      wkt = """
      SRID=1234;MultiLineString ZM (
        (10 20 10 45, 20 10 35 15, 20 40 10 15),
        (40 30 10 20, 30 30 25 30)
      )
      """

      multi_line_string = %MultiLineStringZM{
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
      }

      assert MultiLineStringZM.from_wkt!(wkt) == {multi_line_string, 1234}
    end

    test "raises an error for an invalid WKT" do
      message = ~s(expected 'SRID', 'Geometry' or 'SRID;Geometry' at 1:0, got: "Larry")

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZM.from_wkt!("Larry")
      end
    end
  end

  describe "to_wkb/2" do
    test "returns WKB as xdr-binary from a MultiLineStringZM" do
      wkb_start = "00C00000050000000200C0000002"

      multi_line_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            [
              [40.0, 40.0, 30.0, 20.0],
              [30.0, 30.0, 40.0, 50.0]
            ],
            [
              [10.0, 10.0, 20.0, 30.0],
              [20.0, 20.0, 40.0, 50.0],
              [10.0, 40.0, 10.0, 20.0]
            ]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineStringZM.to_wkb(multi_line_string, endian: :xdr)
      assert String.starts_with?(result, Hex.to_binary(wkb_start))
      assert MultiLineStringZM.from_wkb!(result) == multi_line_string
    end

    test "returns WKB as xdr-string from a MultiLineStringZM" do
      wkb_start = "00C00000050000000200C0000002"

      multi_line_string = %MultiLineStringZM{
        line_strings:
          MapSet.new([
            [
              [40.0, 40.0, 30.0, 20.0],
              [30.0, 30.0, 40.0, 50.0]
            ],
            [
              [10.0, 10.0, 20.0, 30.0],
              [20.0, 20.0, 40.0, 50.0],
              [10.0, 40.0, 10.0, 20.0]
            ]
          ])
      }

      # Because the order is not guaranteed we test here this way.

      assert result = MultiLineStringZM.to_wkb(multi_line_string, endian: :xdr, mode: :hex)
      assert String.starts_with?(result, wkb_start)
      assert MultiLineStringZM.from_wkb!(result, :hex) == multi_line_string
    end

    test "returns WKB as xdr-string from a MultiLineStringZM with an SRID" do
      wkb = """
      00\
      E0000005\
      0000028E\
      00000001\
      00\
      C0000002\
      00000002\
      3FF199999999999A3FF33333333333333FF4CCCCCCCCCCCD3FF6666666666666\
      3FF80000000000003FF999999999999A3FFB3333333333333FFCCCCCCCCCCCCD\
      """

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(1.1, 1.2, 1.3, 1.4),
            PointZM.new(1.5, 1.6, 1.7, 1.8)
          ])
        ])

      assert MultiLineStringZM.to_wkb(multi_line_string, srid: 654, mode: :hex) == wkb
    end

    test "returns WKB as xdr-binary from a MultiLineStringZM with an SRID" do
      wkb = """
      00\
      E0000005\
      0000028E\
      00000001\
      00\
      C0000002\
      00000002\
      3FF199999999999A3FF33333333333333FF4CCCCCCCCCCCD3FF6666666666666\
      3FF80000000000003FF999999999999A3FFB3333333333333FFCCCCCCCCCCCCD\
      """

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(1.1, 1.2, 1.3, 1.4),
            PointZM.new(1.5, 1.6, 1.7, 1.8)
          ])
        ])

      assert MultiLineStringZM.to_wkb(multi_line_string, srid: 654) ==
               Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from a MultiLineStringZM" do
      wkb = """
      01\
      050000C0\
      01000000\
      01\
      020000C0\
      02000000\
      9A9999999999F13F333333333333F33FCDCCCCCCCCCCF43F666666666666F63F\
      000000000000F83F9A9999999999F93F333333333333FB3FCDCCCCCCCCCCFC3F\
      """

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(1.1, 1.2, 1.3, 1.4),
            PointZM.new(1.5, 1.6, 1.7, 1.8)
          ])
        ])

      assert MultiLineStringZM.to_wkb(multi_line_string, endian: :ndr, mode: :hex) == wkb
    end

    test "returns WKB as ndr-binary from a MultiLineStringZM" do
      wkb = """
      01\
      050000C0\
      01000000\
      01\
      020000C0\
      02000000\
      9A9999999999F13F333333333333F33FCDCCCCCCCCCCF43F666666666666F63F\
      000000000000F83F9A9999999999F93F333333333333FB3FCDCCCCCCCCCCFC3F\
      """

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(1.1, 1.2, 1.3, 1.4),
            PointZM.new(1.5, 1.6, 1.7, 1.8)
          ])
        ])

      assert MultiLineStringZM.to_wkb(multi_line_string, endian: :ndr) ==
               Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string from a MultiLineStringZM with SRID" do
      wkb = """
      01\
      050000E0\
      15030000\
      01000000\
      01\
      020000C0\
      02000000\
      9A9999999999F13F333333333333F33FCDCCCCCCCCCCF43F666666666666F63F\
      000000000000F83F9A9999999999F93F333333333333FB3FCDCCCCCCCCCCFC3F\
      """

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(1.1, 1.2, 1.3, 1.4),
            PointZM.new(1.5, 1.6, 1.7, 1.8)
          ])
        ])

      assert MultiLineStringZM.to_wkb(
               multi_line_string,
               srid: 789,
               endian: :ndr,
               mode: :hex
             ) ==
               wkb
    end

    test "returns WKB as ndr-binary from a MultiLineStringZM with SRID" do
      wkb = """
      01\
      050000E0\
      15030000\
      01000000\
      01\
      020000C0\
      02000000\
      9A9999999999F13F333333333333F33FCDCCCCCCCCCCF43F666666666666F63F\
      000000000000F83F9A9999999999F93F333333333333FB3FCDCCCCCCCCCCFC3F\
      """

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(1.1, 1.2, 1.3, 1.4),
            PointZM.new(1.5, 1.6, 1.7, 1.8)
          ])
        ])

      assert MultiLineStringZM.to_wkb(
               multi_line_string,
               srid: 789,
               endian: :ndr
             ) ==
               Hex.to_binary(wkb)
    end
  end

  describe "from_wkb/2" do
    test "returns a MultiLineStringZM from xdr-string" do
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

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(40.0, 40.0, 30.0, 20.0),
            PointZM.new(30.0, 30.0, 40.0, 50.0)
          ]),
          LineStringZM.new([
            PointZM.new(10.0, 10.0, 20.0, 30.0),
            PointZM.new(20.0, 20.0, 40.0, 50.0),
            PointZM.new(10.0, 40.0, 10.0, 20.0)
          ])
        ])

      assert MultiLineStringZM.from_wkb(wkb, :hex) == {:ok, multi_line_string}
    end

    test "returns a MultiLineStringZM from xdr-binary" do
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

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(40.0, 40.0, 30.0, 20.0),
            PointZM.new(30.0, 30.0, 40.0, 50.0)
          ]),
          LineStringZM.new([
            PointZM.new(10.0, 10.0, 20.0, 30.0),
            PointZM.new(20.0, 20.0, 40.0, 50.0),
            PointZM.new(10.0, 40.0, 10.0, 20.0)
          ])
        ])

      assert wkb |> Hex.to_binary() |> MultiLineStringZM.from_wkb() == {:ok, multi_line_string}
    end
  end

  describe "from_wkb!/2" do
    test "returns a MultiLineStringZM from xdr-string" do
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

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(40.0, 40.0, 30.0, 20.0),
            PointZM.new(30.0, 30.0, 40.0, 50.0)
          ]),
          LineStringZM.new([
            PointZM.new(10.0, 10.0, 20.0, 30.0),
            PointZM.new(20.0, 20.0, 40.0, 50.0),
            PointZM.new(10.0, 40.0, 10.0, 20.0)
          ])
        ])

      assert MultiLineStringZM.from_wkb!(wkb, :hex) == multi_line_string
    end

    test "returns a MultiLineStringZM from xdr-binary" do
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

      multi_line_string =
        MultiLineStringZM.new([
          LineStringZM.new([
            PointZM.new(40.0, 40.0, 30.0, 20.0),
            PointZM.new(30.0, 30.0, 40.0, 50.0)
          ]),
          LineStringZM.new([
            PointZM.new(10.0, 10.0, 20.0, 30.0),
            PointZM.new(20.0, 20.0, 40.0, 50.0),
            PointZM.new(10.0, 40.0, 10.0, 20.0)
          ])
        ])

      assert wkb |> Hex.to_binary() |> MultiLineStringZM.from_wkb!() == multi_line_string
    end

    test "raises an error for an invalid WKB string" do
      message = ~s(expected endian flag "00" or "01", got "no", at position 0)

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZM.from_wkb!("nonono", :hex)
      end
    end

    test "raises an error for an invalid WKB binary" do
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        MultiLineStringZM.from_wkb!("nonono")
      end
    end
  end

  test "Enum.slice/3" do
    multi_line_string =
      MultiLineStringZM.new([
        LineStringZM.new([
          PointZM.new(1, 2, 3, 4),
          PointZM.new(3, 4, 5, 6)
        ]),
        LineStringZM.new([
          PointZM.new(1, 2, 3, 4),
          PointZM.new(11, 12, 13, 14),
          PointZM.new(13, 14, 15, 16)
        ])
      ])

    assert [_line_string] = Enum.slice(multi_line_string, 1, 1)
  end
end
