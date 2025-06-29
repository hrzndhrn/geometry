defmodule Geometry.GeometryCollectionTest do
  use ExUnit.Case, async: true

  alias Geometry.DecodeError

  alias Geometry.GeometryCollection
  alias Geometry.GeometryCollectionM
  alias Geometry.GeometryCollectionZ
  alias Geometry.GeometryCollectionZM
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM
  alias Geometry.Polygon
  alias Geometry.PolygonM
  alias Geometry.PolygonZ
  alias Geometry.PolygonZM

  doctest Geometry.GeometryCollection, import: true
  doctest Geometry.GeometryCollectionM, import: true
  doctest Geometry.GeometryCollectionZ, import: true
  doctest Geometry.GeometryCollectionZM, import: true

  Enum.each(
    [
      %{
        module: GeometryCollection,
        text: "GeometryCollection",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000007"),
          ndr: Base.decode16!("0107000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000700001267"),
          ndr: Base.decode16!("010700002067120000")
        },
        data: %{
          term: [
            line_string: [[5, 9], [7, 8]],
            polygon: [[[1, 1], [9, 1], [9, 8], [1, 1]], [[6, 2], [7, 2], [7, 3], [6, 2]]],
            point: [4, 2]
          ],
          xdr:
            Base.decode16!("""
            0000000400000000017FF80000000000007FF800000000000000000000014010000000\
            0000004000000000000000000000000200000002401400000000000040220000000000\
            00401C0000000000004020000000000000000000000300000002000000043FF0000000\
            0000003FF000000000000040220000000000003FF00000000000004022000000000000\
            40200000000000003FF00000000000003FF00000000000000000000440180000000000\
            004000000000000000401C0000000000004000000000000000401C0000000000004008\
            00000000000040180000000000004000000000000000\
            """),
          ndr:
            Base.decode16!("""
            040000000101000000000000000000F87F000000000000F87F01010000000000000000\
            0010400000000000000040010200000002000000000000000000144000000000000022\
            400000000000001C400000000000002040010300000002000000040000000000000000\
            00F03F000000000000F03F0000000000002240000000000000F03F0000000000002240\
            0000000000002040000000000000F03F000000000000F03F0400000000000000000018\
            4000000000000000400000000000001C4000000000000000400000000000001C400000\
            00000000084000000000000018400000000000000040\
            """)
        }
      },
      %{
        module: GeometryCollectionM,
        text: "GeometryCollection M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000007"),
          ndr: Base.decode16!("0107000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000070000002A"),
          ndr: Base.decode16!("01070000602A000000")
        },
        data: %{
          term: [
            polygon: [
              [[1, 1, 1], [9, 1, 4], [9, 8, 4], [1, 1, 1]],
              [[6, 2, 1], [7, 2, 4], [7, 3, 5], [6, 2, 1]]
            ],
            line_string: [[5, 9, 2], [7, 8, 4]],
            point: [4, 2, 3]
          ],
          xdr:
            Base.decode16!("""
            0000000400400000017FF80000000000007FF80000000000007FF80000000000000040\
            0000014010000000000000400000000000000040080000000000000040000002000000\
            02401400000000000040220000000000004000000000000000401C0000000000004020\
            0000000000004010000000000000004000000300000002000000043FF0000000000000\
            3FF00000000000003FF000000000000040220000000000003FF0000000000000401000\
            00000000004022000000000000402000000000000040100000000000003FF000000000\
            00003FF00000000000003FF00000000000000000000440180000000000004000000000\
            0000003FF0000000000000401C00000000000040000000000000004010000000000000\
            401C000000000000400800000000000040140000000000004018000000000000400000\
            00000000003FF0000000000000\
            """),
          ndr:
            Base.decode16!("""
            040000000101000040000000000000F87F000000000000F87F000000000000F87F0101\
            0000400000000000001040000000000000004000000000000008400102000040020000\
            000000000000001440000000000000224000000000000000400000000000001C400000\
            000000002040000000000000104001030000400200000004000000000000000000F03F\
            000000000000F03F000000000000F03F0000000000002240000000000000F03F000000\
            0000001040000000000000224000000000000020400000000000001040000000000000\
            F03F000000000000F03F000000000000F03F0400000000000000000018400000000000\
            000040000000000000F03F0000000000001C4000000000000000400000000000001040\
            0000000000001C40000000000000084000000000000014400000000000001840000000\
            0000000040000000000000F03F\
            """)
        }
      },
      %{
        module: GeometryCollectionZ,
        text: "GeometryCollection Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000007"),
          ndr: Base.decode16!("0107000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000007000004D2"),
          ndr: Base.decode16!("01070000A0D2040000")
        },
        data: %{
          term: [
            polygon: [
              [[1, 1, 1], [9, 1, 4], [9, 8, 4], [1, 1, 1]],
              [[6, 2, 1], [7, 2, 4], [7, 3, 5], [6, 2, 1]]
            ],
            point: [4, 2, 3],
            line_string: [[5, 9, 2], [7, 8, 4]]
          ],
          xdr:
            Base.decode16!("""
            0000000400800000017FF80000000000007FF80000000000007FF80000000000000080\
            0000014010000000000000400000000000000040080000000000000080000002000000\
            02401400000000000040220000000000004000000000000000401C0000000000004020\
            0000000000004010000000000000008000000300000002000000043FF0000000000000\
            3FF00000000000003FF000000000000040220000000000003FF0000000000000401000\
            00000000004022000000000000402000000000000040100000000000003FF000000000\
            00003FF00000000000003FF00000000000000000000440180000000000004000000000\
            0000003FF0000000000000401C00000000000040000000000000004010000000000000\
            401C000000000000400800000000000040140000000000004018000000000000400000\
            00000000003FF0000000000000\
            """),
          ndr:
            Base.decode16!("""
            040000000101000080000000000000F87F000000000000F87F000000000000F87F0101\
            0000800000000000001040000000000000004000000000000008400102000080020000\
            000000000000001440000000000000224000000000000000400000000000001C400000\
            000000002040000000000000104001030000800200000004000000000000000000F03F\
            000000000000F03F000000000000F03F0000000000002240000000000000F03F000000\
            0000001040000000000000224000000000000020400000000000001040000000000000\
            F03F000000000000F03F000000000000F03F0400000000000000000018400000000000\
            000040000000000000F03F0000000000001C4000000000000000400000000000001040\
            0000000000001C40000000000000084000000000000014400000000000001840000000\
            0000000040000000000000F03F\
            """)
        }
      },
      %{
        module: GeometryCollectionZM,
        text: "GeometryCollection ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000007"),
          ndr: Base.decode16!("01070000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000700000D7C"),
          ndr: Base.decode16!("01070000E07C0D0000")
        },
        data: %{
          term: [
            polygon: [
              [[1, 1, 1, 1], [9, 1, 4, 2], [9, 8, 4, 3], [1, 1, 1, 4]],
              [[6, 2, 1, 5], [7, 2, 4, 6], [7, 3, 5, 7], [6, 2, 1, 8]]
            ],
            point: [4, 2, 3, 1],
            line_string: [[5, 9, 2, 1], [7, 8, 4, 2]]
          ],
          xdr:
            Base.decode16!("""
            0000000400C00000017FF80000000000007FF80000000000007FF80000000000007FF8\
            00000000000000C0000001401000000000000040000000000000004008000000000000\
            3FF000000000000000C000000200000002401400000000000040220000000000004000\
            0000000000003FF0000000000000401C00000000000040200000000000004010000000\
            000000400000000000000000C000000300000002000000043FF00000000000003FF000\
            00000000003FF00000000000003FF000000000000040220000000000003FF000000000\
            0000401000000000000040000000000000004022000000000000402000000000000040\
            1000000000000040080000000000003FF00000000000003FF00000000000003FF00000\
            00000000401000000000000000000004401800000000000040000000000000003FF000\
            00000000004014000000000000401C0000000000004000000000000000401000000000\
            00004018000000000000401C0000000000004008000000000000401400000000000040\
            1C000000000000401800000000000040000000000000003FF000000000000040200000\
            00000000\
            """),
          ndr:
            Base.decode16!("""
            0400000001010000C0000000000000F87F000000000000F87F000000000000F87F0000\
            00000000F87F01010000C0000000000000104000000000000000400000000000000840\
            000000000000F03F01020000C002000000000000000000144000000000000022400000\
            000000000040000000000000F03F0000000000001C4000000000000020400000000000\
            001040000000000000004001030000C00200000004000000000000000000F03F000000\
            000000F03F000000000000F03F000000000000F03F0000000000002240000000000000\
            F03F000000000000104000000000000000400000000000002240000000000000204000\
            000000000010400000000000000840000000000000F03F000000000000F03F00000000\
            0000F03F00000000000010400400000000000000000018400000000000000040000000\
            000000F03F00000000000014400000000000001C400000000000000040000000000000\
            104000000000000018400000000000001C400000000000000840000000000000144000\
            00000000001C4000000000000018400000000000000040000000000000F03F00000000\
            00002040\
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
        test "returns an empty geometry-collection" do
          assert unquote(module).new() == %unquote(module){geometries: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a geometry-collection" do
          geometries = geometries(unquote(data[:term]), unquote(dim), unquote(srid))
          geometry_collection = unquote(module).new(geometries)

          assert length(geometry_collection.geometries) == 4

          assert geometry_collection == %unquote(module){
                   geometries: geometries
                 }
        end

        test "returns an empty geometry-collection" do
          assert unquote(module).new([]) == %unquote(module){geometries: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if geometry-collection is empty" do
          geometry_collection = unquote(module).new()
          assert Geometry.empty?(geometry_collection) == true
        end

        test "returns false if geometry-collection is not empty" do
          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.empty?(geometry_collection) == false
        end
      end

      describe "[#{inspect(module)}] from_geo_json/2" do
        @describetag :geo_json

        test "returns geometry-collection" do
          geo_json = geo_json(unquote(data[:term]))

          geometry_collection =
            geometry_collection_geo_json(unquote(module), unquote(data[:term]), unquote(dim))

          assert GeoJsonValidator.valid?(geo_json)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) ==
                   {:ok, geometry_collection}

          if unquote(dim) == :xy do
            assert Geometry.from_geo_json(geo_json) ==
                     {:ok, geometry_collection}
          end
        end

        test "returns an error for missing coordinates" do
          geo_json = Jason.decode!(~s|{"type": "GeometryCollection"}|)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) == {
                   :error,
                   %DecodeError{
                     from: :geo_json,
                     reason: :geometries_not_found
                   }
                 }
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        @describetag :geo_json

        test "returns json compatible map" do
          geometry_collection =
            geometry_collection_geo_json(unquote(module), unquote(data[:term]), unquote(dim))

          geo_json = Geometry.to_geo_json(geometry_collection)

          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
          assert geo_json["type"] == "GeometryCollection"

          assert Enum.sort(geo_json["geometries"]) ==
                   Enum.sort(geo_json(unquote(data[:term]))["geometries"])
        end

        test "returns json compatible map for an empty geometry-collection" do
          geometry_collection = unquote(module).new()
          geo_json = Geometry.to_geo_json(geometry_collection)

          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
          assert geo_json == %{"type" => "GeometryCollection", "geometries" => []}
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns geometry-collection from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])

          geometry_collection =
            geometry_collection(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_wkb(wkb) == {:ok, geometry_collection}
        end

        test "returns geometry-collection from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])

          geometry_collection =
            geometry_collection(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_wkb(wkb) == {:ok, geometry_collection}
        end

        test "returns an empty geometry-collection from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          geometry_collection = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, geometry_collection}
        end

        test "returns an empty geometry-collection from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          geometry_collection = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, geometry_collection}
        end

        test "returns geometry-collection from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_wkb(wkb) == {:ok, geometry_collection}
        end

        test "returns geometry-collection from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_wkb(wkb) == {:ok, geometry_collection}
        end

        test "returns an error for invalid length" do
          wkb = Binary.take(unquote(code_srid[:ndr] <> data[:ndr]), 10)

          assert Geometry.from_wkb(wkb) ==
                   {:error,
                    %DecodeError{from: :wkb, rest: <<4>>, offset: 9, reason: :invalid_length}}
        end

        test "returns an error for invalid endian flag" do
          wkb =
            unquote(code_srid[:xdr] <> data[:xdr])
            |> Binary.replace("0000000001", "0300000001")
            |> Binary.replace("0040000001", "0300000001")
            |> Binary.replace("0080000001", "0300000001")
            |> Binary.replace("00C0000001", "0300000001")

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: 13,
                    reason: [expected_endian: :xdr]
                  }} = Geometry.from_wkb(wkb)
        end

        test "returns an error for invalid geometry code" do
          wkb =
            unquote(code_srid[:xdr] <> data[:xdr])
            |> Binary.replace("0000000001", "0000000011")
            |> Binary.replace("0040000001", "0000000011")
            |> Binary.replace("0080000001", "0000000011")
            |> Binary.replace("00C0000001", "0000000011")

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: 14,
                    reason: :expected_geometry_code
                  }} = Geometry.from_wkb(wkb)
        end

        test "returns an error for invalid point" do
          wkb =
            unquote(code_srid[:xdr] <> data[:xdr])
            |> Binary.replace("invalid", 22)

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: 18,
                    reason: :invalid_coordinate
                  }} = Geometry.from_wkb(wkb)
        end

        test "returns an error for invalid line string" do
          wkb =
            unquote(code_srid[:xdr]) <>
              Base.decode16!("""
              00000002\
              00\
              00000002\
              00000002\
              00000002\
              """)

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: _offset,
                    reason: reason
                  }} = Geometry.from_wkb(wkb)

          assert reason in [:invalid_coordinate, :expected_geometry_code]
        end

        test "returns an error for invalid polygon" do
          wkb =
            unquote(code_srid[:xdr]) <>
              Base.decode16!("""
              00000002\
              00\
              00000003\
              00000002\
              00000002\
              """)

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: _offset,
                    reason: reason
                  }} = Geometry.from_wkb(wkb)

          assert reason in [:invalid_coordinate, :expected_geometry_code]
        end
      end

      describe "[#{inspect(module)}] from_ewkb/1" do
        @describetag :wkb

        test "returns geometry-collection from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              0,
              true
            )

          assert Geometry.from_ewkb(wkb) == {:ok, geometry_collection}
        end

        test "returns geometry-collection from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              0,
              true
            )

          assert Geometry.from_ewkb(wkb) == {:ok, geometry_collection}
        end

        test "returns geometry-collection from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_ewkb(wkb) == {:ok, geometry_collection}
        end

        test "returns geometry-collection from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_ewkb(wkb) == {:ok, geometry_collection}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.to_wkb(geometry_collection, :xdr) == wkb
        end

        test "returns ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.to_wkb(geometry_collection) == wkb
          assert Geometry.to_wkb(geometry_collection, :ndr) == wkb
        end

        test "returns xdr binary from an empty geometry-collection" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          geometry_collection = unquote(module).new()

          assert Geometry.to_wkb(geometry_collection, :xdr) == wkb
        end

        test "returns ndr binary from an empty geometry-collection" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          geometry_collection = unquote(module).new()

          assert Geometry.to_wkb(geometry_collection) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns geometry-collection from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.to_ewkb(geometry_collection, :xdr) == wkb
        end

        test "returns geometry-collection from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.to_ewkb(geometry_collection) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns geometry-collection" do
          wkt = wkt(unquote(text), unquote(dim), unquote(data[:term]))

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              0
            )

          assert Geometry.from_wkt(wkt) == {:ok, geometry_collection}
        end

        test "returns an empty geometry-collection" do
          wkt = wkt(unquote(text))
          geometry_collection = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, geometry_collection}
        end

        test "returns geometry-collection from WKT with srid" do
          wkt = wkt(unquote(text), unquote(dim), unquote(data[:term]), unquote(srid))

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_wkt(wkt) == {:ok, geometry_collection}
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns geometry-collection" do
          wkt =
            wkt(unquote(text), unquote(dim), unquote(data[:term]), unquote(srid))

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_ewkt(wkt) == {:ok, geometry_collection}
        end

        test "returns an empty geometry-collection" do
          wkt = wkt(unquote(text))
          geometry_collection = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, geometry_collection}
        end

        test "returns geometry-collection from WKT with srid" do
          wkt = wkt(unquote(text), unquote(dim), unquote(data[:term]), unquote(srid))

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_ewkt(wkt) == {:ok, geometry_collection}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          wkt_parts = wkt_parts(unquote(text), unquote(dim), unquote(data[:term]))

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          wkt = Geometry.to_wkt(geometry_collection)

          Enum.each(wkt_parts, fn regex ->
            assert Regex.match?(regex, wkt)
          end)
        end

        test "returns wkt from an empty geometry-collection" do
          [regex] = wkt_parts(unquote(text))
          geometry_collection = unquote(module).new()

          assert Regex.match?(regex, Geometry.to_wkt(geometry_collection))
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          wkt_parts = wkt_parts(unquote(text), unquote(dim), unquote(data[:term]))

          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          wkt = Geometry.to_ewkt(geometry_collection)

          Enum.each(wkt_parts, fn regex ->
            assert Regex.match?(regex, wkt)
          end)
        end

        test "returns ewkt from an empty geometry-collection" do
          [regex] = wkt_parts(unquote(text), nil, [], unquote(srid))
          geometry_collection = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Regex.match?(regex, Geometry.to_ewkt(geometry_collection))
        end
      end

      describe "[#{inspect(module)}] slice/2" do
        test "returns slice" do
          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          assert Enum.slice(geometry_collection, 1..2) |> length() == 2
        end
      end

      describe "[#{inspect(module)}] into/2" do
        test "returns geometry-collection" do
          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          geometries = geometries(unquote(data[:term]), unquote(dim), unquote(srid))

          assert Enum.into(geometries, unquote(module).new([], unquote(srid))) ==
                   geometry_collection
        end
      end

      describe "[#{inspect(module)}] member?/2" do
        test "returns true" do
          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          geometries = geometries(unquote(data[:term]), unquote(dim), unquote(srid))

          assert Enum.member?(geometry_collection, hd(geometries)) == true
        end

        test "returns false" do
          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          polygon = empty_polygon(unquote(dim))

          assert Enum.member?(geometry_collection, polygon) == false
        end
      end

      describe "[#{inspect(module)}] map/2" do
        test "returns geometries" do
          geometry_collection =
            geometry_collection(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid)
            )

          geometries =
            unquote(data[:term]) |> geometries(unquote(dim), unquote(srid)) |> Enum.sort()

          assert geometry_collection |> Enum.map(fn x -> x end) |> Enum.sort() == geometries
        end
      end
    end
  )

  defp wkt_parts(name, dim \\ nil, data \\ [], srid \\ "")

  defp wkt_parts(name, _dim, [], ""), do: [~r/#{name}\sEMPTY/]

  defp wkt_parts(name, _dim, [], srid), do: [~r/SRID=#{srid};#{name}\sEMPTY/]

  defp wkt_parts(name, dim, data, srid) do
    [~r/#{srid(srid)}#{name}\s\(.*\)/ | wkt_parts_regex(dim, data, srid)]
  end

  defp wkt_parts_regex(dim, data, srid) do
    data
    |> geometries(dim, srid)
    |> Enum.map(fn geometry ->
      Geometry.to_wkt(geometry) |> Regex.escape() |> Regex.compile!()
    end)
  end

  defp wkt(name, dim \\ nil, data \\ [], srid \\ "")

  defp wkt(name, _dim, [], ""), do: "#{name} EMPTY"

  defp wkt(name, _dim, [], srid), do: "SRID=#{srid};#{name} EMPTY"

  defp wkt(name, dim, data, srid) do
    "#{srid(srid)}#{name} (#{dim |> wkt_parts_text(data, srid) |> Enum.join(", ")})"
  end

  defp wkt_parts_text(dim, data, srid) do
    data
    |> geometries(dim, srid)
    |> Enum.map(fn geometry -> Geometry.to_wkt(geometry) end)
  end

  defp srid(""), do: ""

  defp srid(srid), do: "SRID=#{srid};"

  defp geometry_collection(module, data, dim, srid, float \\ false) do
    module.new(geometries(to_float(data, float), dim, srid), srid)
  end

  defp geometry_collection_geo_json(module, data, dim) do
    module.new(geometries(data, dim, 4326, false), 4326)
  end

  defp to_float(data, false), do: data

  defp to_float(data, true) do
    case Keyword.keyword?(data) do
      true ->
        Enum.map(data, fn {key, value} -> {key, to_float(value, true)} end)

      false ->
        Enum.map(data, fn
          list when is_list(list) -> to_float(list, true)
          value -> value * 1.0
        end)
    end
  end

  defp geo_json(data) do
    Jason.decode!("""
    {
      "type": "GeometryCollection",
      "geometries": [
        {"type": "Point", "coordinates": #{inspect(data[:point], charlists: :as_list)}},
        {"type": "LineString", "coordinates": #{inspect(data[:line_string], charlists: :as_list)}},
        {"type": "Polygon", "coordinates": #{inspect(data[:polygon], charlists: :as_list)}}
      ]
    }
    """)
  end

  defp empty_polygon(dim) do
    case dim do
      :xy -> Polygon.new()
      :xym -> PolygonM.new()
      :xyz -> PolygonZ.new()
      :xyzm -> PolygonZM.new()
    end
  end

  defp add_empty(list, item, true), do: [item | list]

  defp add_empty(list, _item, false), do: list

  defp geometries(data, dim, srid, empty? \\ true)

  defp geometries(data, :xy, srid, empty?) do
    add_empty(
      [
        %Point{coordinates: data[:point], srid: srid},
        %LineString{path: data[:line_string], srid: srid},
        %Polygon{rings: data[:polygon], srid: srid}
      ],
      %Point{coordinates: [], srid: srid},
      empty?
    )
  end

  defp geometries(data, :xym, srid, empty?) do
    add_empty(
      [
        %PointM{coordinates: data[:point], srid: srid},
        %LineStringM{path: data[:line_string], srid: srid},
        %PolygonM{rings: data[:polygon], srid: srid}
      ],
      %PointM{coordinates: [], srid: srid},
      empty?
    )
  end

  defp geometries(data, :xyz, srid, empty?) do
    add_empty(
      [
        %PointZ{coordinates: data[:point], srid: srid},
        %LineStringZ{path: data[:line_string], srid: srid},
        %PolygonZ{rings: data[:polygon], srid: srid}
      ],
      %PointZ{coordinates: [], srid: srid},
      empty?
    )
  end

  defp geometries(data, :xyzm, srid, empty?) do
    add_empty(
      [
        %PointZM{coordinates: data[:point], srid: srid},
        %LineStringZM{path: data[:line_string], srid: srid},
        %PolygonZM{rings: data[:polygon], srid: srid}
      ],
      %PointZM{coordinates: [], srid: srid},
      empty?
    )
  end
end
