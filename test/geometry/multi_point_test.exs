defmodule Geometry.MultiPointTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Binary

  alias Geometry.DecodeError

  alias Geometry.MultiPoint
  alias Geometry.MultiPointM
  alias Geometry.MultiPointZ
  alias Geometry.MultiPointZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Geometry.MultiPoint, import: true
  doctest Geometry.MultiPointM, import: true
  doctest Geometry.MultiPointZ, import: true
  doctest Geometry.MultiPointZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: MultiPoint,
        text: "MultiPoint",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000004"),
          ndr: Base.decode16!("0104000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000400001267"),
          ndr: Base.decode16!("010400002067120000")
        },
        data: %{
          term: [[1, 2.2], [3, 4.4]],
          xdr:
            Base.decode16!("""
            0000000200000000013FF0000000000000400199999999999A00000000014008000000\
            000000401199999999999A\
            """),
          ndr:
            Base.decode16!("""
            020000000101000000000000000000F03F9A9999999999014001010000000000000000\
            0008409A99999999991140\
            """)
        }
      },
      %{
        module: MultiPointM,
        text: "MultiPoint M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000004"),
          ndr: Base.decode16!("0104000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000040000002A"),
          ndr: Base.decode16!("01040000602A000000")
        },
        data: %{
          term: [[1, 2.2, 3], [3, 4.4, 5]],
          xdr:
            Base.decode16!("""
            0000000200400000013FF0000000000000400199999999999A40080000000000000040\
            0000014008000000000000401199999999999A4014000000000000\
            """),
          ndr:
            Base.decode16!("""
            020000000101000040000000000000F03F9A9999999999014000000000000008400101\
            00004000000000000008409A999999999911400000000000001440\
            """)
        }
      },
      %{
        module: MultiPointZ,
        text: "MultiPoint Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000004"),
          ndr: Base.decode16!("0104000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000004000004D2"),
          ndr: Base.decode16!("01040000A0D2040000")
        },
        data: %{
          term: [[3, 3, 3], [4, 4, 4]],
          xdr:
            Base.decode16!("""
            0000000200800000014008000000000000400800000000000040080000000000000080\
            000001401000000000000040100000000000004010000000000000\
            """),
          ndr:
            Base.decode16!("""
            0200000001010000800000000000000840000000000000084000000000000008400101\
            000080000000000000104000000000000010400000000000001040\
            """)
        }
      },
      %{
        module: MultiPointZM,
        text: "MultiPoint ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000004"),
          ndr: Base.decode16!("01040000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000400000D7C"),
          ndr: Base.decode16!("01040000E07C0D0000")
        },
        data: %{
          term: [[3, 3, 3, 9], [4, 4, 4, 10]],
          xdr:
            Base.decode16!("""
            0000000200C00000014008000000000000400800000000000040080000000000004022\
            00000000000000C0000001401000000000000040100000000000004010000000000000\
            4024000000000000\
            """),
          ndr:
            Base.decode16!("""
            0200000001010000C00000000000000840000000000000084000000000000008400000\
            00000000224001010000C0000000000000104000000000000010400000000000001040\
            0000000000002440\
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
        test "returns an empty multi-point" do
          assert unquote(module).new() == %unquote(module){points: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a multi-point" do
          coordinates = coordinates(unquote(data[:term]), unquote(dim))

          assert unquote(module).new(coordinates) == %unquote(module){
                   points: unquote(data[:term])
                 }
        end

        test "returns an empty multi-point" do
          assert unquote(module).new([]) == %unquote(module){points: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if multi-point is empty" do
          multi_point = unquote(module).new()
          assert Geometry.empty?(multi_point) == true
        end

        test "returns false if multi-point is not empty" do
          coordinates = coordinates(unquote(data[:term]), unquote(dim))
          multi_point = unquote(module).new(coordinates)
          assert Geometry.empty?(multi_point) == false
        end
      end

      describe "[#{inspect(module)}] from_geo_json/2" do
        @describetag :geo_json

        test "returns multi-point" do
          geo_json =
            :json.decode("""
            {
              "type": "MultiPoint",
              "coordinates": #{inspect(unquote(data[:term]), charlists: :as_lists)},
              "foo": "ignore"
            }
            """)

          assert GeoJsonValidator.valid?(geo_json)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) ==
                   {:ok, %unquote(module){points: unquote(data[:term]), srid: 4326}}

          if unquote(dim) == :xy do
            assert Geometry.from_geo_json(geo_json) ==
                     {:ok, %unquote(module){points: unquote(data[:term]), srid: 4326}}
          end
        end

        test "returns an error for missing coordinates" do
          geo_json = :json.decode(~s|{"type": "MultiPoint"}|)

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
        @describetag :geo_json

        test "returns json compatible map" do
          multi_point = %unquote(module){points: unquote(data[:term])}
          geo_json = Geometry.to_geo_json(multi_point)

          assert geo_json == %{
                   "type" => "MultiPoint",
                   "coordinates" => unquote(data[:term])
                 }

          assert :json.encode(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end

        test "returns json compatible map for an empty multi-point" do
          multi_point = unquote(module).new()
          geo_json = Geometry.to_geo_json(multi_point)

          assert geo_json == %{"type" => "MultiPoint", "coordinates" => []}
          assert :json.encode(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns multi-point from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_wkb(wkb) == {:ok, multi_point}
        end

        test "returns multi-point from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_wkb(wkb) == {:ok, multi_point}
        end

        test "returns an empty multi-point from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          multi_point = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, multi_point}
        end

        test "returns an empty multi-point from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          multi_point = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, multi_point}
        end

        test "returns multi-point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid), true)

          assert Geometry.from_wkb(wkb) == {:ok, multi_point}
        end

        test "returns multi-point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid), true)

          assert Geometry.from_wkb(wkb) == {:ok, multi_point}
        end

        test "returns an error tuple for an invalid endian flag" do
          wkb = Base.encode16("42")

          assert Geometry.from_wkb(wkb) ==
                   {
                     :error,
                     %DecodeError{
                       from: :wkb,
                       rest: "3432",
                       offset: 0,
                       reason: [expected_endian: :flag]
                     }
                   }
        end

        test "returns an error tuple for an invalid endian flag inside of ndr" do
          wkb = Binary.replace(unquote(code[:ndr] <> data[:ndr]), <<3>>, 9)

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: rest,
                     offset: 9,
                     reason: [expected_endian: :ndr]
                   }
                 } = Geometry.from_wkb(wkb)

          assert byte_size(rest) in [42, 58, 74]
        end

        test "returns an error tuple for an invalid endian flag inside of xdr" do
          wkb = Binary.replace(unquote(code[:xdr] <> data[:xdr]), <<3>>, 9)

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: rest,
                     offset: 9,
                     reason: [expected_endian: :xdr]
                   }
                 } = Geometry.from_wkb(wkb)

          assert byte_size(rest) in [42, 58, 74]
        end

        test "returns an error tuple for an invalid code inside of ndr" do
          wkb = Binary.replace(unquote(code[:ndr] <> data[:ndr]), <<3>>, 10)

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: rest,
                     offset: 10,
                     reason: :expected_geometry_code
                   }
                 } = Geometry.from_wkb(wkb)

          assert byte_size(rest) in [41, 57, 73]
        end

        test "retruns an error for invalid length" do
          wkb = unquote(code[:ndr] <> <<42>>)

          assert Geometry.from_wkb(wkb) ==
                   {:error,
                    %DecodeError{
                      from: :wkb,
                      rest: <<42>>,
                      offset: 5,
                      reason: :invalid_length
                    }}
        end

        test "returns an error tuple for an invalid coordinate" do
          data = unquote(code[:ndr] <> data[:ndr])
          wkb = Binary.take(data, byte_size(data) - 2)

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: rest,
                     offset: offset,
                     reason: :invalid_coordinate
                   }
                 } = Geometry.from_wkb(wkb)

          assert offset in [35, 43, 51]
          assert byte_size(rest) in [14, 22, 30]
        end
      end

      describe "[#{inspect(module)}] from_wkb!/1" do
        @describetag :wkb

        test "raises an error tuple for an invalid endian flag inside of xdr" do
          wkb = Binary.replace(unquote(code[:xdr] <> data[:xdr]), <<3>>, 9)

          assert_fail :from_wkb!, wkb, ~r/expected endian XDR at position .*, got: <<0x3, ...>>/
        end

        test "raises an error tuple for an invalid endian flag inside of ndr" do
          wkb = Binary.replace(unquote(code[:ndr] <> data[:ndr]), <<3>>, 9)

          assert_fail :from_wkb!, wkb, ~r/expected endian NDR at position .*, got: <<0x3, ...>>/
        end

        test "raises an error tuple for an invalid code inside of ndr" do
          wkb = Binary.replace(unquote(code[:ndr] <> data[:ndr]), <<3>>, 10)

          assert_fail :from_wkb!, wkb, ~r/expected geometry code at position .*, got: <<.*>>/
        end

        test "raises an error for invalid length" do
          wkb = unquote(code[:ndr] <> <<42>>)

          assert_fail :from_wkb!, wkb, ~r/invalid length at position .*, got: <<.*>>/
        end

        test "raises an error tuple for an invalid coordinate (reason: :invalid_coordinate)" do
          data = unquote(code[:ndr] <> data[:ndr])
          wkb = Binary.take(data, byte_size(data) - 2)

          assert_fail :from_wkb!, wkb, ~r/invalid coordiante at position .*, got: <<.*>>/
        end
      end

      describe "[#{inspect(module)}] from_ewkb/1" do
        @describetag :wkb

        test "returns multi-point from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_ewkb(wkb) == {:ok, multi_point}
        end

        test "returns multi-point from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_ewkb(wkb) == {:ok, multi_point}
        end

        test "returns multi-point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid), true)

          assert Geometry.from_ewkb(wkb) == {:ok, multi_point}
        end

        test "returns multi-point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid), true)

          assert Geometry.from_ewkb(wkb) == {:ok, multi_point}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns multi-point from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(multi_point, :xdr) == wkb
        end

        test "returns multi-point from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(multi_point) == wkb
          assert Geometry.to_wkb(multi_point, :ndr) == wkb
        end

        test "returns an empty multi-point from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          multi_point = unquote(module).new()

          assert Geometry.to_wkb(multi_point, :xdr) == wkb
        end

        test "returns an empty multi-point from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          multi_point = unquote(module).new()

          assert Geometry.to_wkb(multi_point) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns multi-point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(multi_point, :xdr) == wkb
        end

        test "returns multi-point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(multi_point) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns multi-point" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, multi_point}
        end

        test "returns an empty multi-point" do
          wkt = wkt(unquote(text))
          multi_point = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, multi_point}
        end

        test "returns multi-point from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, multi_point}
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns multi-point" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, multi_point}
        end

        test "returns an empty multi-point" do
          wkt = wkt(unquote(text))
          multi_point = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, multi_point}
        end

        test "returns multi-point from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, multi_point}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkt(multi_point) == wkt
        end

        test "returns wkt from an empty multi-point" do
          wkt = wkt(unquote(text))
          multi_point = unquote(module).new()

          assert Geometry.to_wkt(multi_point) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_point =
            multi_point(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(multi_point) == wkt
        end

        test "returns ewkt from an empty multi-point" do
          wkt = wkt(unquote(text), [], unquote(srid))
          multi_point = Map.put(unquote(module).new(), :srid, unquote(srid))

          assert Geometry.to_ewkt(multi_point) == wkt
        end
      end

      describe "[#{inspect(module)}] slice/2" do
        test "returns slice" do
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Enum.slice(multi_point, 1..2) == Enum.slice(unquote(data[:term]), 1..2)
        end
      end

      describe "[#{inspect(module)}] into/2" do
        test "returns multi-point" do
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))
          coordinates = coordinates(unquote(data[:term]), unquote(dim))

          assert Enum.into(coordinates, unquote(module).new()) == multi_point
        end
      end

      describe "[#{inspect(module)}] member?/2" do
        test "returns true" do
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))
          coordinates = coordinates(unquote(data[:term]), unquote(dim))

          assert Enum.member?(multi_point, hd(coordinates)) == true
        end

        test "returns false" do
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Enum.member?(multi_point, point([0, 0, 0, 0], unquote(dim))) == false
        end
      end

      describe "[#{inspect(module)}] map/2" do
        test "returns coordinates" do
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Enum.map(multi_point, fn x -> x end) == unquote(data[:term])
        end
      end

      describe "[#{inspect(module)}] count/1" do
        test "returns the coordinate length" do
          multi_point = multi_point(unquote(module), unquote(data[:term]), unquote(dim))

          assert Enum.count(multi_point) == 2
        end
      end
    end
  )

  defp wkt(name, data \\ [], srid \\ "")

  defp wkt(name, [], ""), do: "#{String.upcase(name)} EMPTY"

  defp wkt(name, [], srid), do: "SRID=#{srid};#{String.upcase(name)} EMPTY"

  defp wkt(name, data, srid) do
    coordinates = Enum.map_join(data, ", ", fn point -> Enum.join(point, @blank) end)

    srid = if srid == "", do: "", else: "SRID=#{srid};"

    "#{srid}#{String.upcase(name)} (#{coordinates})"
  end

  defp multi_point(module, data, dim, srid \\ 0, to_float \\ false) do
    module.new(coordinates(data, dim, srid, to_float), srid)
  end

  defp coordinates(data, dim, srid \\ 0, to_float \\ false) do
    Enum.map(data, fn point ->
      point = if to_float, do: Enum.map(point, fn value -> value * 1.0 end), else: point

      point(point, dim, srid)
    end)
  end

  defp point(data, dim, srid \\ 0) do
    case dim do
      :xy -> data |> Enum.take(2) |> Point.new(srid)
      :xym -> data |> Enum.take(3) |> PointM.new(srid)
      :xyz -> data |> Enum.take(3) |> PointZ.new(srid)
      :xyzm -> data |> Enum.take(4) |> PointZM.new(srid)
    end
  end
end
