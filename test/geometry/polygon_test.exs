defmodule Geometry.PolygonTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Geometry.DecodeError

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

  doctest Geometry.Polygon, import: true
  doctest Geometry.PolygonM, import: true
  doctest Geometry.PolygonZ, import: true
  doctest Geometry.PolygonZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: Polygon,
        text: "Polygon",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000003"),
          ndr: Base.decode16!("0103000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000300001267"),
          ndr: Base.decode16!("010300002067120000")
        },
        data: %{
          term: [
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
          ],
          xdr:
            Base.decode16!("""
            0000000200000005404180000000000040240000000000004046800000000000404680\
            0000000000402E00000000000040440000000000004024000000000000403400000000\
            000040418000000000004024000000000000000000044034000000000000403E000000\
            00000040418000000000004041800000000000403E0000000000004034000000000000\
            4034000000000000403E000000000000\
            """),
          ndr:
            Base.decode16!("""
            0200000005000000000000000080414000000000000024400000000000804640000000\
            00008046400000000000002E4000000000000044400000000000002440000000000000\
            3440000000000080414000000000000024400400000000000000000034400000000000\
            003E40000000000080414000000000008041400000000000003E400000000000003440\
            00000000000034400000000000003E40\
            """)
        }
      },
      %{
        module: PolygonM,
        text: "Polygon M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000003"),
          ndr: Base.decode16!("0103000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000030000002A"),
          ndr: Base.decode16!("01030000602A000000")
        },
        data: %{
          term: [
            [
              [35.0, 10.0, 1],
              [45.0, 45.0, 2],
              [15.0, 40.0, 3],
              [10.0, 20.0, 2],
              [35.0, 10.0, 1]
            ],
            [
              [20.0, 30.0, 1],
              [35.0, 35.0, 2],
              [30.0, 20.0, 2],
              [20.0, 30.0, 1]
            ]
          ],
          xdr:
            Base.decode16!("""
            0000000200000005404180000000000040240000000000003FF0000000000000404680\
            000000000040468000000000004000000000000000402E000000000000404400000000\
            0000400800000000000040240000000000004034000000000000400000000000000040\
            4180000000000040240000000000003FF0000000000000000000044034000000000000\
            403E0000000000003FF000000000000040418000000000004041800000000000400000\
            0000000000403E00000000000040340000000000004000000000000000403400000000\
            0000403E0000000000003FF0000000000000\
            """),
          ndr:
            Base.decode16!("""
            020000000500000000000000008041400000000000002440000000000000F03F000000\
            0000804640000000000080464000000000000000400000000000002E40000000000000\
            4440000000000000084000000000000024400000000000003440000000000000004000\
            000000008041400000000000002440000000000000F03F040000000000000000003440\
            0000000000003E40000000000000F03F00000000008041400000000000804140000000\
            00000000400000000000003E4000000000000034400000000000000040000000000000\
            34400000000000003E40000000000000F03F\
            """)
        }
      },
      %{
        module: PolygonZ,
        text: "Polygon Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000003"),
          ndr: Base.decode16!("0103000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000003000004D2"),
          ndr: Base.decode16!("01030000A0D2040000")
        },
        data: %{
          term: [
            [
              [35.0, 10.0, 1],
              [45.0, 45.0, 2],
              [15.0, 40.0, 3],
              [10.0, 20.0, 2],
              [35.0, 10.0, 1]
            ],
            [
              [20.0, 30.0, 1],
              [35.0, 35.0, 2],
              [30.0, 20.0, 2],
              [20.0, 30.0, 1]
            ]
          ],
          xdr:
            Base.decode16!("""
            0000000200000005404180000000000040240000000000003FF0000000000000404680\
            000000000040468000000000004000000000000000402E000000000000404400000000\
            0000400800000000000040240000000000004034000000000000400000000000000040\
            4180000000000040240000000000003FF0000000000000000000044034000000000000\
            403E0000000000003FF000000000000040418000000000004041800000000000400000\
            0000000000403E00000000000040340000000000004000000000000000403400000000\
            0000403E0000000000003FF0000000000000\
            """),
          ndr:
            Base.decode16!("""
            020000000500000000000000008041400000000000002440000000000000F03F000000\
            0000804640000000000080464000000000000000400000000000002E40000000000000\
            4440000000000000084000000000000024400000000000003440000000000000004000\
            000000008041400000000000002440000000000000F03F040000000000000000003440\
            0000000000003E40000000000000F03F00000000008041400000000000804140000000\
            00000000400000000000003E4000000000000034400000000000000040000000000000\
            34400000000000003E40000000000000F03F\
            """)
        }
      },
      %{
        module: PolygonZM,
        text: "Polygon ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000003"),
          ndr: Base.decode16!("01030000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000300000D7C"),
          ndr: Base.decode16!("01030000E07C0D0000")
        },
        data: %{
          term: [
            [
              [35.0, 10.0, 1, 2],
              [45.0, 45.0, 2, 3],
              [15.0, 40.0, 3, 4],
              [10.0, 20.0, 2, 5],
              [35.0, 10.0, 1, 6]
            ],
            [
              [20.0, 30.0, 1, 2],
              [35.0, 35.0, 2, 3],
              [30.0, 20.0, 2, 4],
              [20.0, 30.0, 1, 5]
            ]
          ],
          xdr:
            Base.decode16!("""
            0000000200000005404180000000000040240000000000003FF0000000000000400000\
            0000000000404680000000000040468000000000004000000000000000400800000000\
            0000402E00000000000040440000000000004008000000000000401000000000000040\
            2400000000000040340000000000004000000000000000401400000000000040418000\
            0000000040240000000000003FF0000000000000401800000000000000000004403400\
            0000000000403E0000000000003FF00000000000004000000000000000404180000000\
            0000404180000000000040000000000000004008000000000000403E00000000000040\
            34000000000000400000000000000040100000000000004034000000000000403E0000\
            000000003FF00000000000004014000000000000\
            """),
          ndr:
            Base.decode16!("""
            020000000500000000000000008041400000000000002440000000000000F03F000000\
            0000000040000000000080464000000000008046400000000000000040000000000000\
            08400000000000002E4000000000000044400000000000000840000000000000104000\
            0000000000244000000000000034400000000000000040000000000000144000000000\
            008041400000000000002440000000000000F03F000000000000184004000000000000\
            00000034400000000000003E40000000000000F03F0000000000000040000000000080\
            41400000000000804140000000000000004000000000000008400000000000003E4000\
            0000000000344000000000000000400000000000001040000000000000344000000000\
            00003E40000000000000F03F0000000000001440\
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
        test "returns an empty polygon" do
          assert unquote(module).new() == %unquote(module){rings: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a polygon" do
          rings = rings(unquote(data[:term]), unquote(dim))
          assert unquote(module).new(rings) == %unquote(module){rings: unquote(data[:term])}
        end

        test "returns an empty polygon" do
          assert unquote(module).new([]) == %unquote(module){rings: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if polygon is empty" do
          polygon = unquote(module).new()
          assert Geometry.empty?(polygon) == true
        end

        test "returns false if polygon is not empty" do
          rings = rings(unquote(data[:term]), unquote(dim))
          polygon = unquote(module).new(rings)
          assert Geometry.empty?(polygon) == false
        end
      end

      describe "[#{inspect(module)}] from_geo_json/2" do
        test "returns polygon" do
          coordinates = Jason.encode!(unquote(data[:term]))

          geo_json =
            Jason.decode!("""
            {
              "type": "Polygon",
              "coordinates": #{coordinates},
              "foo": "ignore"
            }
            """)

          assert GeoJsonValidator.valid?(geo_json)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) ==
                   {:ok, %unquote(module){rings: unquote(data[:term]), srid: 4326}}

          if unquote(dim) == :xy do
            assert Geometry.from_geo_json(geo_json) ==
                     {:ok, %unquote(module){rings: unquote(data[:term]), srid: 4326}}
          end
        end

        test "returns an error for missing coordinates" do
          geo_json = Jason.decode!(~s|{"type": "Polygon"}|)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) == {
                   :error,
                   %DecodeError{
                     from: :geo_json,
                     reason: :coordinates_not_found
                   }
                 }
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        test "returns json compatible map" do
          polygon = %unquote(module){rings: unquote(data[:term])}
          geo_json = Geometry.to_geo_json(polygon)

          assert geo_json == %{
                   "type" => "Polygon",
                   "coordinates" => unquote(data[:term])
                 }

          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end

        test "returns json compatible map for an empty polygon" do
          polygon = unquote(module).new()
          geo_json = Geometry.to_geo_json(polygon)

          assert geo_json == %{"type" => "Polygon", "coordinates" => []}
          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns polygon from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkb(wkb) == {:ok, polygon}
        end

        test "returns polygon from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkb(wkb) == {:ok, polygon}
        end

        test "returns an empty polygon from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          polygon = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, polygon}
        end

        test "returns an empty polygon from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          polygon = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, polygon}
        end

        test "returns polygon from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, polygon}
        end

        test "returns polygon from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, polygon}
        end

        test "returns an error tuple for invalid length" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 8)

          assert Geometry.from_wkb(wkb) == {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     offset: 5,
                     reason: :invalid_length,
                     rest: <<2, 0, 0>>
                   }
                 }
        end

        test "returns an error tuple for invalid length in ring" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 12)

          assert Geometry.from_wkb(wkb) == {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     offset: 9,
                     reason: :invalid_length,
                     rest: <<5, 0, 0>>
                   }
                 }
        end

        test "returns an error tuple for invalid data" do
          wkb =
            Binary.replace(
              unquote(code[:ndr] <> data[:ndr]),
              Base.decode16!("FFFFFFFFFFFFFFFFFFFFFFFFFFFF"),
              29
            )

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: <<rest::8, _ignore::binary>>,
                     offset: offset,
                     reason: :invalid_coordinate
                   }
                 } = Geometry.from_wkb(wkb)

          assert offset in [13, 29]
          assert rest in [0, 255]
        end
      end

      describe "[#{inspect(module)}] from_wkb!" do
        @describetag :wkb

        test "raises an error tuple for invalid length" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 8)

          assert_fail :from_wkb!, wkb, "invalid length at position 5, got: <<0x2, 0x0, 0x0>>"
        end

        test "raises an error tuple for invalid length in ring" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 12)

          assert_fail :from_wkb!, wkb, "invalid length at position 9, got: <<0x5, 0x0, 0x0>>"
        end

        test "raises an error tuple for invalid data" do
          wkb =
            Binary.replace(
              unquote(code[:ndr] <> data[:ndr]),
              Base.decode16!("FFFFFFFFFFFFFFFFFFFFFFFFFFFF"),
              29
            )

          assert_fail :from_wkb!, wkb, ~r/invalid coordiante at position .*, got: <<.*>>/
        end
      end

      describe "[#{inspect(module)}] from_ewkb/1" do
        @describetag :wkb

        test "returns polygon from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkb(wkb) == {:ok, polygon}
        end

        test "returns polygon from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkb(wkb) == {:ok, polygon}
        end

        test "returns polygon from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, polygon}
        end

        test "returns polygon from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, polygon}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns polygon from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(polygon, :xdr) == wkb
        end

        test "returns polygon from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(polygon) == wkb
          assert Geometry.to_wkb(polygon, :ndr) == wkb
        end

        test "returns an empty polygon from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          polygon = unquote(module).new()

          assert Geometry.to_wkb(polygon, :xdr) == wkb
        end

        test "returns an empty polygon from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          polygon = unquote(module).new()

          assert Geometry.to_wkb(polygon) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns polygon from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(polygon, :xdr) == wkb
        end

        test "returns polygon from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(polygon) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns polygon" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, polygon}
        end

        test "returns an empty polygon" do
          wkt = wkt(unquote(text))
          polygon = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, polygon}
        end

        test "returns polygon from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, polygon}
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns polygon" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, polygon}
        end

        test "returns an empty polygon" do
          wkt = wkt(unquote(text))
          polygon = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, polygon}
        end

        test "returns polygon from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, polygon}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkt(polygon) == wkt
        end

        test "returns wkt from an empty polygon" do
          wkt = wkt(unquote(text))
          polygon = unquote(module).new()

          assert Geometry.to_wkt(polygon) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))
          polygon = polygon(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(polygon) == wkt
        end

        test "returns ewkt from an empty polygon" do
          wkt = wkt(unquote(text), [], unquote(srid))
          polygon = unquote(module).new([], unquote(srid))

          assert Geometry.to_ewkt(polygon) == wkt
        end
      end
    end
  )

  defp wkt(name, data \\ [], srid \\ "")

  defp wkt(name, [], ""), do: "#{name} EMPTY"

  defp wkt(name, [], srid), do: "SRID=#{srid};#{name} EMPTY"

  defp wkt(name, data, srid) do
    rings =
      Enum.map_join(data, ", ", fn line ->
        line = Enum.map_join(line, ", ", fn point -> Enum.join(point, @blank) end)
        "(#{line})"
      end)

    srid = if srid == "", do: "", else: "SRID=#{srid};"

    "#{srid}#{name} (#{rings})"
  end

  defp polygon(module, data, dim, srid \\ 0) do
    module.new(rings(data, dim), srid)
  end

  defp rings(data, dim) do
    case dim do
      :xy ->
        Enum.map(data, fn line ->
          coordinates = Enum.map(line, fn [x, y] -> Point.new(x, y) end)
          LineString.new(coordinates)
        end)

      :xym ->
        Enum.map(data, fn line ->
          coordinates = Enum.map(line, fn [x, y, m] -> PointM.new(x, y, m) end)
          LineStringM.new(coordinates)
        end)

      :xyz ->
        Enum.map(data, fn line ->
          coordinates = Enum.map(line, fn [x, y, z] -> PointZ.new(x, y, z) end)
          LineStringZ.new(coordinates)
        end)

      :xyzm ->
        Enum.map(data, fn line ->
          coordinates = Enum.map(line, fn [x, y, z, m] -> PointZM.new(x, y, z, m) end)
          LineStringZM.new(coordinates)
        end)
    end
  end
end
