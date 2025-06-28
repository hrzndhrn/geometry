defmodule Geometry.MultiPolygonTest do
  use ExUnit.Case, async: true

  alias Geometry.DecodeError

  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.MultiPolygon
  alias Geometry.MultiPolygonM
  alias Geometry.MultiPolygonZ
  alias Geometry.MultiPolygonZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM
  alias Geometry.Polygon
  alias Geometry.PolygonM
  alias Geometry.PolygonZ
  alias Geometry.PolygonZM

  doctest Geometry.MultiPolygon, import: true
  doctest Geometry.MultiPolygonM, import: true
  doctest Geometry.MultiPolygonZ, import: true
  doctest Geometry.MultiPolygonZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: MultiPolygon,
        text: "MultiPolygon",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000006"),
          ndr: Base.decode16!("0106000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000600001267"),
          ndr: Base.decode16!("010600002067120000")
        },
        data: %{
          term: [
            [[[1, 1], [9, 1], [9, 8], [1, 1]], [[6, 2], [7, 2], [7, 3], [6, 2]]],
            [[[6, 2], [8, 2], [8, 4], [6, 2]]],
            [[[60, 20], [80, 20], [80, 40], [60, 20]]]
          ],
          xdr:
            Base.decode16!("""
            00000003000000000300000002000000043FF00000000000003FF00000000000004022\
            0000000000003FF0000000000000402200000000000040200000000000003FF0000000\
            0000003FF00000000000000000000440180000000000004000000000000000401C0000\
            000000004000000000000000401C000000000000400800000000000040180000000000\
            0040000000000000000000000003000000010000000440180000000000004000000000\
            0000004020000000000000400000000000000040200000000000004010000000000000\
            4018000000000000400000000000000000000000030000000100000004404E00000000\
            0000403400000000000040540000000000004034000000000000405400000000000040\
            44000000000000404E0000000000004034000000000000\
            """),
          ndr:
            Base.decode16!("""
            0300000001030000000200000004000000000000000000F03F000000000000F03F0000\
            000000002240000000000000F03F000000000000224000000000000020400000000000\
            00F03F000000000000F03F040000000000000000001840000000000000004000000000\
            00001C4000000000000000400000000000001C40000000000000084000000000000018\
            4000000000000000400103000000010000000400000000000000000018400000000000\
            0000400000000000002040000000000000004000000000000020400000000000001040\
            0000000000001840000000000000004001030000000100000004000000000000000000\
            4E40000000000000344000000000000054400000000000003440000000000000544000\
            000000000044400000000000004E400000000000003440\
            """)
        }
      },
      %{
        module: MultiPolygonM,
        text: "MultiPolygon M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000006"),
          ndr: Base.decode16!("0106000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000060000002A"),
          ndr: Base.decode16!("01060000602A000000")
        },
        data: %{
          term: [
            [
              [[1, 1, 4], [9, 1, 5], [9, 8, 6], [1, 1, 4]],
              [[6, 2, 3], [7, 2, 7], [7, 3, 4], [6, 2, 3]]
            ],
            [[[6, 2, 4], [8, 2, 5], [8, 4, 6], [6, 2, 4]]],
            [[[60, 20, 40], [80, 20, 50], [80, 40, 60], [60, 20, 40]]]
          ],
          xdr:
            Base.decode16!("""
            00000003004000000300000002000000043FF00000000000003FF00000000000004010\
            00000000000040220000000000003FF000000000000040140000000000004022000000\
            000000402000000000000040180000000000003FF00000000000003FF0000000000000\
            4010000000000000000000044018000000000000400000000000000040080000000000\
            00401C0000000000004000000000000000401C000000000000401C0000000000004008\
            0000000000004010000000000000401800000000000040000000000000004008000000\
            0000000040000003000000010000000440180000000000004000000000000000401000\
            0000000000402000000000000040000000000000004014000000000000402000000000\
            0000401000000000000040180000000000004018000000000000400000000000000040\
            1000000000000000400000030000000100000004404E00000000000040340000000000\
            0040440000000000004054000000000000403400000000000040490000000000004054\
            0000000000004044000000000000404E000000000000404E0000000000004034000000\
            0000004044000000000000\
            """),
          ndr:
            Base.decode16!("""
            0300000001030000400200000004000000000000000000F03F000000000000F03F0000\
            0000000010400000000000002240000000000000F03F00000000000014400000000000\
            00224000000000000020400000000000001840000000000000F03F000000000000F03F\
            0000000000001040040000000000000000001840000000000000004000000000000008\
            400000000000001C4000000000000000400000000000001C400000000000001C400000\
            0000000008400000000000001040000000000000184000000000000000400000000000\
            0008400103000040010000000400000000000000000018400000000000000040000000\
            0000001040000000000000204000000000000000400000000000001440000000000000\
            2040000000000000104000000000000018400000000000001840000000000000004000\
            00000000001040010300004001000000040000000000000000004E4000000000000034\
            4000000000000044400000000000005440000000000000344000000000000049400000\
            00000000544000000000000044400000000000004E400000000000004E400000000000\
            0034400000000000004440\
            """)
        }
      },
      %{
        module: MultiPolygonZ,
        text: "MultiPolygon Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000006"),
          ndr: Base.decode16!("0106000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000006000004D2"),
          ndr: Base.decode16!("01060000A0D2040000")
        },
        data: %{
          term: [
            [
              [[1, 1, 4], [9, 1, 5], [9, 8, 6], [1, 1, 4]],
              [[6, 2, 3], [7, 2, 7], [7, 3, 4], [6, 2, 3]]
            ],
            [[[6, 2, 4], [8, 2, 5], [8, 4, 6], [6, 2, 4]]],
            [[[60, 20, 40], [80, 20, 50], [80, 40, 60], [60, 20, 40]]]
          ],
          xdr:
            Base.decode16!("""
            00000003008000000300000002000000043FF00000000000003FF00000000000004010\
            00000000000040220000000000003FF000000000000040140000000000004022000000\
            000000402000000000000040180000000000003FF00000000000003FF0000000000000\
            4010000000000000000000044018000000000000400000000000000040080000000000\
            00401C0000000000004000000000000000401C000000000000401C0000000000004008\
            0000000000004010000000000000401800000000000040000000000000004008000000\
            0000000080000003000000010000000440180000000000004000000000000000401000\
            0000000000402000000000000040000000000000004014000000000000402000000000\
            0000401000000000000040180000000000004018000000000000400000000000000040\
            1000000000000000800000030000000100000004404E00000000000040340000000000\
            0040440000000000004054000000000000403400000000000040490000000000004054\
            0000000000004044000000000000404E000000000000404E0000000000004034000000\
            0000004044000000000000\
            """),
          ndr:
            Base.decode16!("""
            0300000001030000800200000004000000000000000000F03F000000000000F03F0000\
            0000000010400000000000002240000000000000F03F00000000000014400000000000\
            00224000000000000020400000000000001840000000000000F03F000000000000F03F\
            0000000000001040040000000000000000001840000000000000004000000000000008\
            400000000000001C4000000000000000400000000000001C400000000000001C400000\
            0000000008400000000000001040000000000000184000000000000000400000000000\
            0008400103000080010000000400000000000000000018400000000000000040000000\
            0000001040000000000000204000000000000000400000000000001440000000000000\
            2040000000000000104000000000000018400000000000001840000000000000004000\
            00000000001040010300008001000000040000000000000000004E4000000000000034\
            4000000000000044400000000000005440000000000000344000000000000049400000\
            00000000544000000000000044400000000000004E400000000000004E400000000000\
            0034400000000000004440\
            """)
        }
      },
      %{
        module: MultiPolygonZM,
        text: "MultiPolygon ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000006"),
          ndr: Base.decode16!("01060000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000600000D7C"),
          ndr: Base.decode16!("01060000E07C0D0000")
        },
        data: %{
          term: [
            [
              [[1, 1, 4, 8], [9, 1, 5, 7], [9, 8, 6, 6], [1, 1, 4, 5]],
              [[6, 2, 3, 9], [7, 2, 7, 0], [7, 3, 4, 1], [6, 2, 3, 2]]
            ],
            [[[6, 2, 4, 6], [8, 2, 5, 5], [8, 4, 6, 4], [6, 2, 4, 3]]],
            [[[60, 20, 40, 1], [80, 20, 50, 2], [80, 40, 60, 3], [60, 20, 40, 4]]]
          ],
          xdr:
            Base.decode16!("""
            0000000300C000000300000002000000043FF00000000000003FF00000000000004010\
            000000000000402000000000000040220000000000003FF00000000000004014000000\
            000000401C000000000000402200000000000040200000000000004018000000000000\
            40180000000000003FF00000000000003FF00000000000004010000000000000401400\
            0000000000000000044018000000000000400000000000000040080000000000004022\
            000000000000401C0000000000004000000000000000401C0000000000000000000000\
            000000401C000000000000400800000000000040100000000000003FF0000000000000\
            401800000000000040000000000000004008000000000000400000000000000000C000\
            0003000000010000000440180000000000004000000000000000401000000000000040\
            1800000000000040200000000000004000000000000000401400000000000040140000\
            0000000040200000000000004010000000000000401800000000000040100000000000\
            00401800000000000040000000000000004010000000000000400800000000000000C0\
            0000030000000100000004404E00000000000040340000000000004044000000000000\
            3FF0000000000000405400000000000040340000000000004049000000000000400000\
            000000000040540000000000004044000000000000404E000000000000400800000000\
            0000404E000000000000403400000000000040440000000000004010000000000000\
            """),
          ndr:
            Base.decode16!("""
            0300000001030000C00200000004000000000000000000F03F000000000000F03F0000\
            00000000104000000000000020400000000000002240000000000000F03F0000000000\
            0014400000000000001C40000000000000224000000000000020400000000000001840\
            0000000000001840000000000000F03F000000000000F03F0000000000001040000000\
            0000001440040000000000000000001840000000000000004000000000000008400000\
            0000000022400000000000001C4000000000000000400000000000001C400000000000\
            0000000000000000001C4000000000000008400000000000001040000000000000F03F\
            0000000000001840000000000000004000000000000008400000000000000040010300\
            00C0010000000400000000000000000018400000000000000040000000000000104000\
            0000000000184000000000000020400000000000000040000000000000144000000000\
            0000144000000000000020400000000000001040000000000000184000000000000010\
            4000000000000018400000000000000040000000000000104000000000000008400103\
            0000C001000000040000000000000000004E4000000000000034400000000000004440\
            000000000000F03F000000000000544000000000000034400000000000004940000000\
            0000000040000000000000544000000000000044400000000000004E40000000000000\
            08400000000000004E40000000000000344000000000000044400000000000001040\
            """)
        }
      }
    ],
    fn %{
         module: module,
         text: text,
         data: data,
         dim: dim,
         srid: srid,
         code: code,
         code_srid: code_srid
       } ->
      describe "[#{inspect(module)}] new/0" do
        test "returns an empty multi-polygon" do
          assert unquote(module).new() == %unquote(module){polygons: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a multi-polygon" do
          polygons = polygons(unquote(data[:term]), unquote(dim))

          assert unquote(module).new(polygons) == %unquote(module){
                   polygons: unquote(data[:term])
                 }
        end

        test "returns an empty multi-polygon" do
          assert unquote(module).new([]) == %unquote(module){polygons: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if multi-polygon is empty" do
          multi_polygon = unquote(module).new()
          assert Geometry.empty?(multi_polygon) == true
        end

        test "returns false if multi-polygon is not empty" do
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))
          assert Geometry.empty?(multi_polygon) == false
        end
      end

      describe "[#{inspect(module)}] from_geo_json/2" do
        @describetag :geo_json

        test "returns multi-polygon" do
          geo_json =
            Jason.decode!("""
            {
              "type": "MultiPolygon",
              "coordinates": #{inspect(unquote(data[:term]), charlists: :as_lists)},
              "foo": "ignore"
            }
            """)

          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), 4326)

          assert GeoJsonValidator.valid?(geo_json)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) ==
                   {:ok, multi_polygon}

          if unquote(dim) == :xy do
            assert Geometry.from_geo_json(geo_json) ==
                     {:ok, multi_polygon}
          end
        end

        test "returns an error for missing coordinates" do
          geo_json = Jason.decode!(~s|{"type": "MultiPolygon"}|)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) == {
                   :error,
                   %Geometry.DecodeError{
                     from: :geo_json,
                     reason: :coordinates_not_found
                   }
                 }
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        @describetag :geo_json

        test "returns json compatible map" do
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))
          geo_json = Geometry.to_geo_json(multi_polygon)

          assert geo_json == %{
                   "type" => "MultiPolygon",
                   "coordinates" => unquote(data[:term])
                 }

          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end

        test "returns json compatible map for an empty multi-polygon" do
          multi_polygon = unquote(module).new()
          geo_json = Geometry.to_geo_json(multi_polygon)

          assert geo_json == %{"type" => "MultiPolygon", "coordinates" => []}
          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns multi-polygon from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])

          multi_polygon =
            multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_wkb(wkb) == {:ok, multi_polygon}
        end

        test "returns multi-polygon from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])

          multi_polygon =
            multi_polygon(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              0,
              true
            )

          assert Geometry.from_wkb(wkb) == {:ok, multi_polygon}
        end

        test "returns an empty multi-polygon from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          multi_polygon = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, multi_polygon}
        end

        test "returns an empty multi-polygon from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          multi_polygon = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, multi_polygon}
        end

        test "returns multi-polygon from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_polygon =
            multi_polygon(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_wkb(wkb) == {:ok, multi_polygon}
        end

        test "returns multi-polygon from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_polygon =
            multi_polygon(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_wkb(wkb) == {:ok, multi_polygon}
        end

        test "returns an error for invalid endian flag (xdr)" do
          wkb =
            unquote(code[:xdr] <> data[:xdr])
            |> Binary.replace("0000000003", "0300000003")
            |> Binary.replace("0040000003", "0300000003")
            |> Binary.replace("0080000003", "0300000003")
            |> Binary.replace("00C0000003", "0300000003")

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: 9,
                    reason: [expected_endian: :xdr]
                  }} = Geometry.from_wkb(wkb)
        end

        test "returns an error for invalid geometry code" do
          wkb =
            unquote(code_srid[:ndr] <> data[:ndr])
            |> Binary.replace("0103000000", "0108000000")
            |> Binary.replace("0103000040", "0108000040")
            |> Binary.replace("0103000080", "0108000080")
            |> Binary.replace("01030000C0", "01080000C0")

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: 14,
                    reason: :expected_geometry_code
                  }} = Geometry.from_wkb(wkb)
        end

        test "returns an error tuple for invalid length" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 8)

          assert Geometry.from_wkb(wkb) ==
                   {:error,
                    %DecodeError{
                      from: :wkb,
                      rest: <<3, 0, 0>>,
                      offset: 5,
                      reason: :invalid_length
                    }}
        end

        test "returns an error tuple for invalid length in a polygon" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 16)

          assert Geometry.from_wkb(wkb) ==
                   {:error,
                    %DecodeError{
                      from: :wkb,
                      rest: <<2, 0>>,
                      offset: 14,
                      reason: :invalid_length
                    }}
        end

        test "returns an error tuple for invalid coordinate" do
          data = unquote(code[:ndr] <> data[:ndr])
          wkb = Binary.take(data, byte_size(data) - 1)

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: rest,
                    offset: offset,
                    reason: :invalid_coordinate
                  }} = Geometry.from_wkb(wkb)

          assert offset in [292, 412, 532]

          assert rest in [
                   <<0, 0, 0, 0, 0, 0, 78, 64, 0, 0, 0, 0, 0, 0, 52>>,
                   <<0, 0, 0, 0, 0, 0, 78, 64, 0, 0, 0, 0, 0, 0, 52, 64, 0, 0, 0, 0, 0, 0, 68>>,
                   <<0, 0, 0, 0, 0, 0, 78, 64, 0, 0, 0, 0, 0, 0, 52, 64, 0, 0, 0, 0, 0, 0, 68, 64,
                     0, 0, 0, 0, 0, 0, 16>>
                 ]
        end
      end

      describe "[#{inspect(module)}] from_ewkb/1" do
        @describetag :wkb

        test "returns multi-polygon from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])

          multi_polygon =
            multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_ewkb(wkb) == {:ok, multi_polygon}
        end

        test "returns multi-polygon from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])

          multi_polygon =
            multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_ewkb(wkb) == {:ok, multi_polygon}
        end

        test "returns multi-polygon from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_polygon =
            multi_polygon(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_ewkb(wkb) == {:ok, multi_polygon}
        end

        test "returns multi-polygon from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_polygon =
            multi_polygon(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_ewkb(wkb) == {:ok, multi_polygon}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(multi_polygon, :xdr) == wkb
        end

        test "returns ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(multi_polygon) == wkb
          assert Geometry.to_wkb(multi_polygon, :ndr) == wkb
        end

        test "returns xdr binary from an empty multi-polygon" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          multi_polygon = unquote(module).new()

          assert Geometry.to_wkb(multi_polygon, :xdr) == wkb
        end

        test "returns ndr binary from an empty multi-polygon" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          multi_polygon = unquote(module).new()

          assert Geometry.to_wkb(multi_polygon) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns multi-polygon from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_polygon =
            multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(multi_polygon, :xdr) == wkb
        end

        test "returns multi-polygon from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_polygon =
            multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(multi_polygon) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns multi-polygon" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, multi_polygon}
        end

        test "returns an empty multi-polygon" do
          wkt = wkt(unquote(text))
          multi_polygon = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, multi_polygon}
        end

        test "returns multi-polygon from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_polygon =
            multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, multi_polygon}
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns multi-polygon" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, multi_polygon}
        end

        test "returns an empty multi-polygon" do
          wkt = wkt(unquote(text))
          multi_polygon = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, multi_polygon}
        end

        test "returns multi-polygon from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_polygon =
            multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, multi_polygon}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkt(multi_polygon) == wkt
        end

        test "returns wkt from an empty multi-polygon" do
          wkt = wkt(unquote(text))
          multi_polygon = unquote(module).new()

          assert Geometry.to_wkt(multi_polygon) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_polygon =
            multi_polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(multi_polygon) == wkt
        end

        test "returns ewkt from an empty multi-polygon" do
          wkt = wkt(unquote(text), [], unquote(srid))
          multi_polygon = unquote(module).new([], unquote(srid))

          assert Geometry.to_ewkt(multi_polygon) == wkt
        end
      end

      describe "[#{inspect(module)}] slice/2" do
        test "returns slice" do
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Enum.slice(multi_polygon, 1..2) == Enum.slice(unquote(data[:term]), 1..2)
        end
      end

      describe "[#{inspect(module)}] into/2" do
        test "returns multi-polygon" do
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))
          polygons = polygons(unquote(data[:term]), unquote(dim))

          assert Enum.into(polygons, unquote(module).new()) == multi_polygon
        end
      end

      describe "[#{inspect(module)}] member?/2" do
        test "returns true" do
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))
          polygons = polygons(unquote(data[:term]), unquote(dim))

          assert Enum.member?(multi_polygon, hd(polygons)) == true
        end

        test "returns false" do
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))
          polygon = empty_polygon(unquote(dim))

          assert Enum.member?(multi_polygon, polygon) == false
        end
      end

      describe "[#{inspect(module)}] map/2" do
        test "returns polygons" do
          multi_polygon = multi_polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Enum.map(multi_polygon, fn x -> x end) == unquote(data[:term])
        end
      end
    end
  )

  defp wkt(name, data \\ [], srid \\ "")

  defp wkt(name, [], ""), do: "#{name} EMPTY"

  defp wkt(name, [], srid), do: "SRID=#{srid};#{name} EMPTY"

  defp wkt(name, data, srid) do
    "#{srid(srid)}#{name} #{wkt_data(data)}"
  end

  defp wkt_data([x | _] = point) when is_number(x), do: Enum.join(point, @blank)

  defp wkt_data(data), do: data |> Enum.map_join(", ", &wkt_data/1) |> in_brackets()

  defp srid(""), do: ""

  defp srid(srid), do: "SRID=#{srid};"

  defp in_brackets(str), do: "(#{str})"

  defp multi_polygon(module, data, dim, srid \\ 0, to_float \\ false) do
    module.new(polygons(to_float(data, to_float), dim, srid), srid)
  end

  defp to_float(data, false), do: data

  defp to_float(data, true) do
    Enum.map(data, fn
      list when is_list(list) -> to_float(list, true)
      value -> value * 1.0
    end)
  end

  defp polygons(data, dim, srid \\ 0) do
    case dim do
      :xy -> Enum.map(data, fn rings -> %Polygon{rings: rings, srid: srid} end)
      :xym -> Enum.map(data, fn rings -> %PolygonM{rings: rings, srid: srid} end)
      :xyz -> Enum.map(data, fn rings -> %PolygonZ{rings: rings, srid: srid} end)
      :xyzm -> Enum.map(data, fn rings -> %PolygonZM{rings: rings, srid: srid} end)
    end
  end

  defp empty_polygon(dim, srid \\ 0) do
    case dim do
      :xy -> Polygon.new([], srid: srid)
      :xym -> PolygonM.new([], srid: srid)
      :xyz -> PolygonZ.new([], srid: srid)
      :xyzm -> PolygonZM.new([], srid: srid)
    end
  end
end
