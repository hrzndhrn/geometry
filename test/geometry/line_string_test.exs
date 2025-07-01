defmodule Geometry.LineStringTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Binary

  alias Geometry.DecodeError

  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Geometry.LineString, import: true
  doctest Geometry.LineStringM, import: true
  doctest Geometry.LineStringZ, import: true
  doctest Geometry.LineStringZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: LineString,
        text: "LineString",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000002"),
          ndr: Base.decode16!("0102000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000200001267"),
          ndr: Base.decode16!("010200002067120000")
        },
        data: %{
          term: [[1, 2.2], [3, 4.4]],
          invalid:
            Base.decode16!("""
            000000023FF00000000000004FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF\
            """),
          xdr:
            Base.decode16!("""
            000000023FF0000000000000400199999999999A4008000000000000401199999999999A\
            """),
          ndr:
            Base.decode16!("""
            02000000000000000000F03F9A9999999999014000000000000008409A99999999991140\
            """)
        }
      },
      %{
        module: LineStringM,
        text: "LineString M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000002"),
          ndr: Base.decode16!("0102000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000020000002A"),
          ndr: Base.decode16!("01020000602A000000")
        },
        data: %{
          term: [[1, 2.2, 3], [3, 4.4, 5]],
          invalid:
            Base.decode16!("""
            000000023FF0000000000000400199999999999A400800000000000040080000000000\
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF\
            """),
          xdr:
            Base.decode16!("""
            000000023FF0000000000000400199999999999A400800000000000040080000000000\
            00401199999999999A4014000000000000\
            """),
          ndr:
            Base.decode16!("""
            02000000000000000000F03F9A99999999990140000000000000084000000000000008\
            409A999999999911400000000000001440\
            """)
        }
      },
      %{
        module: LineStringZ,
        text: "LineString Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000002"),
          ndr: Base.decode16!("0102000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000002000004D2"),
          ndr: Base.decode16!("01020000A0D2040000")
        },
        data: %{
          term: [[3, 3, 3], [4, 4, 4]],
          invalid:
            Base.decode16!("""
            000000023FF00000000000000000F87F9999999A4008000000000000401199999999999A\
            """),
          xdr:
            Base.decode16!("""
            0000000240080000000000004008000000000000400800000000000040100000000000\
            0040100000000000004010000000000000\
            """),
          ndr:
            Base.decode16!("""
            0200000000000000000008400000000000000840000000000000084000000000000010\
            4000000000000010400000000000001040\
            """)
        }
      },
      %{
        module: LineStringZM,
        text: "LineString ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000002"),
          ndr: Base.decode16!("01020000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000200000D7C"),
          ndr: Base.decode16!("01020000E07C0D0000")
        },
        data: %{
          term: [[3, 3, 3, 9], [4, 4, 4, 10]],
          invalid:
            Base.decode16!("""
            000000023FF00000000000000000F87F9999999A4008000000000000401199999999999A\
            """),
          xdr:
            Base.decode16!("""
            0000000240080000000000004008000000000000400800000000000040220000000000\
            004010000000000000401000000000000040100000000000004024000000000000\
            """),
          ndr:
            Base.decode16!("""
            0200000000000000000008400000000000000840000000000000084000000000000022\
            400000000000001040000000000000104000000000000010400000000000002440\
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
        test "returns an empty line" do
          assert unquote(module).new() == %unquote(module){path: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a line" do
          coordinates = coordinates(unquote(data[:term]), unquote(dim))
          assert unquote(module).new(coordinates) == %unquote(module){path: unquote(data[:term])}
        end

        test "returns an empty line" do
          assert unquote(module).new([]) == %unquote(module){path: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if line is empty" do
          line = unquote(module).new()
          assert Geometry.empty?(line) == true
        end

        test "returns false if line is not empty" do
          coordinates = coordinates(unquote(data[:term]), unquote(dim))
          line = unquote(module).new(coordinates)
          assert Geometry.empty?(line) == false
        end
      end

      describe "[#{inspect(module)}] from_geo_json/2" do
        @describetag :geo_json

        test "returns line" do
          coordinates =
            Enum.map_join(unquote(data[:term]), ", ", fn point -> "[#{Enum.join(point, ",")}]" end)

          geo_json =
            Jason.decode!("""
            {
              "type": "LineString",
              "coordinates": [#{coordinates}],
              "foo": "ignore"
            }
            """)

          assert GeoJsonValidator.valid?(geo_json)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) ==
                   {:ok, %unquote(module){path: unquote(data[:term]), srid: 4326}}

          if unquote(dim) == :xy do
            assert Geometry.from_geo_json(geo_json) ==
                     {:ok, %unquote(module){path: unquote(data[:term]), srid: 4326}}
          end
        end

        test "returns an error for missing coordinates" do
          geo_json = Jason.decode!(~s|{"type": "LineString"}|)

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
          line = %unquote(module){path: unquote(data[:term])}
          geo_json = Geometry.to_geo_json(line)

          assert geo_json == %{
                   "type" => "LineString",
                   "coordinates" => unquote(data[:term])
                 }

          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end

        test "returns json compatible map for an empty line" do
          line = unquote(module).new()
          geo_json = Geometry.to_geo_json(line)

          assert geo_json == %{"type" => "LineString", "coordinates" => []}
          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns line from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkb(wkb) == {:ok, line}
        end

        test "returns line from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkb(wkb) == {:ok, line}
        end

        test "returns an empty line from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          line = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, line}
        end

        test "returns an empty line from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          line = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, line}
        end

        test "returns line from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, line}
        end

        test "returns line from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, line}
        end

        test "returns an error tuple for invalid data" do
          wkb =
            Binary.replace(
              unquote(code_srid[:ndr] <> data[:ndr]),
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

        test "returns an error tuple for wrong length" do
          wkb =
            Binary.replace(
              unquote(code[:ndr] <> data[:ndr]),
              <<15::little-integer-size(32)>>,
              5
            )

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: <<>>,
                     offset: offset,
                     reason: :invalid_coordinate
                   }
                 } = Geometry.from_wkb(wkb)

          assert offset in [41, 57, 73]
        end

        test "returns an error tuple for invalid length" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 7)

          assert Geometry.from_wkb(wkb) == {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: <<2, 0>>,
                     offset: 5,
                     reason: :invalid_length
                   }
                 }
        end

        test "returns an error tuple for missing data" do
          wkb =
            Binary.replace(unquote(code[:ndr] <> data[:ndr]), <<5::little-integer-size(32)>>, 6)

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: <<>>,
                     offset: offset,
                     reason: :invalid_coordinate
                   }
                 } = Geometry.from_wkb(wkb)

          assert offset == byte_size(wkb)
        end

        test "returns an error tuple for extra data" do
          wkb = unquote(code[:ndr] <> data[:ndr]) <> <<7>>

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: <<7>>,
                     offset: offset,
                     reason: :eos
                   }
                 } = Geometry.from_wkb(wkb)

          assert offset in [41, 57, 73]
        end
      end

      describe "[#{inspect(module)}] from_wkb!/1" do
        @describetag :wkb

        test "returns an error tuple for invalid length (reason: :invalid_length)" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 7)

          assert_fail :from_wkb!, wkb, ~r/invalid length at position .*, got: <<.*>>/
        end

        test "returns an error tuple for missing data (reason: :invalid_coordinate)" do
          wkb =
            Binary.replace(unquote(code[:ndr] <> data[:ndr]), <<5::little-integer-size(32)>>, 6)

          assert_fail :from_wkb!, wkb, ~r/invalid coordiante at position .*, got: <<>>/
        end

        test "raises an error tuple for extra data (reason: :eos)" do
          wkb = unquote(code[:ndr] <> data[:ndr]) <> <<7>>

          assert_fail :from_wkb!, wkb, ~r/expected end of binary at position .*, got: <<0.*>>/
        end
      end

      describe "[#{inspect(module)}] from_ewkb/1" do
        @describetag :wkb

        test "returns line from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkb(wkb) == {:ok, line}
        end

        test "returns line from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkb(wkb) == {:ok, line}
        end

        test "returns line from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, line}
        end

        test "returns line from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, line}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns line from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(line, :xdr) == wkb
        end

        test "returns line from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(line) == wkb
          assert Geometry.to_wkb(line, :ndr) == wkb
        end

        test "returns an empty line from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          line = unquote(module).new()

          assert Geometry.to_wkb(line, :xdr) == wkb
        end

        test "returns an empty line from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          line = unquote(module).new()

          assert Geometry.to_wkb(line) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns line from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(line, :xdr) == wkb
        end

        test "returns line from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(line) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns line" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, line}
        end

        test "returns an empty line" do
          wkt = wkt(unquote(text))
          line = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, line}
        end

        test "returns line from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, line}
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns line" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, line}
        end

        test "returns an empty line" do
          wkt = wkt(unquote(text))
          line = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, line}
        end

        test "returns line from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, line}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          line = line(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkt(line) == wkt
        end

        test "returns wkt from an empty line" do
          wkt = wkt(unquote(text))
          line = unquote(module).new()

          assert Geometry.to_wkt(line) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))
          line = line(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(line) == wkt
        end

        test "returns ewkt from an empty line" do
          wkt = wkt(unquote(text), [], unquote(srid))
          line = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.to_ewkt(line) == wkt
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

  defp line(module, data, dim, srid \\ 0) do
    module.new(coordinates(data, dim), srid)
  end

  defp coordinates(data, dim) do
    Enum.map(data, fn point ->
      case dim do
        :xy -> Point.new(point)
        :xym -> PointM.new(point)
        :xyz -> PointZ.new(point)
        :xyzm -> PointZM.new(point)
      end
    end)
  end
end
