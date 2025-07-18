defmodule Geometry.CircularStringTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Binary

  alias Geometry.DecodeError

  alias Geometry.CircularString
  alias Geometry.CircularStringM
  alias Geometry.CircularStringZ
  alias Geometry.CircularStringZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Geometry.CircularString, import: true
  doctest Geometry.CircularStringM, import: true
  doctest Geometry.CircularStringZ, import: true
  doctest Geometry.CircularStringZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: CircularString,
        text: "CIRCULARSTRING",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000008"),
          ndr: Base.decode16!("0108000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000800001267"),
          ndr: Base.decode16!("010800002067120000")
        },
        data: %{
          term: [[1, 2.02], [3, 4.4], [5, 6]],
          invalid:
            Base.decode16!("""
            03000000000000000000F03F295C8FC2F528004000000000000008409A\
            """),
          xdr:
            Base.decode16!("""
            000000033FF0000000000000400028F5C28F5C29400800000000000040\
            1199999999999A40140000000000004018000000000000\
            """),
          ndr:
            Base.decode16!("""
            03000000000000000000F03F295C8FC2F528004000000000000008409A\
            9999999999114000000000000014400000000000001840\
            """)
        }
      },
      %{
        module: CircularStringM,
        text: "CIRCULARSTRING M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000008"),
          ndr: Base.decode16!("0108000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000080000002A"),
          ndr: Base.decode16!("01080000602A000000")
        },
        data: %{
          term: [[1, 2.2, 3], [3, 4.4, 5], [6, 7, 8.008]],
          invalid:
            Base.decode16!("""
            03000000000000000000F03F9A999999999901400000000000000840000000000000\
            """),
          xdr:
            Base.decode16!("""
            000000033FF0000000000000400199999999999A4008000000000000400800000000\
            0000401199999999999A40140000000000004018000000000000401C000000000000\
            402004189374BC6A\
            """),
          ndr:
            Base.decode16!("""
            03000000000000000000F03F9A999999999901400000000000000840000000000000\
            08409A99999999991140000000000000144000000000000018400000000000001C40\
            6ABC749318042040\
            """)
        }
      },
      %{
        module: CircularStringZ,
        text: "CIRCULARSTRING Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000008"),
          ndr: Base.decode16!("0108000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000008000004D2"),
          ndr: Base.decode16!("01080000A0D2040000")
        },
        data: %{
          term: [[3, 3, 3], [4, 4, 4], [5, 5, 5]],
          invalid:
            Base.decode16!("""
            000000023FF00000000000000000F87F9999999A4008000000000000401199999999\
            """),
          xdr:
            Base.decode16!("""
            00000003400800000000000040080000000000004008000000000000401000000000\
            00004010000000000000401000000000000040140000000000004014000000000000\
            4014000000000000\
            """),
          ndr:
            Base.decode16!("""
            03000000000000000000084000000000000008400000000000000840000000000000\
            10400000000000001040000000000000104000000000000014400000000000001440\
            0000000000001440\
            """)
        }
      },
      %{
        module: CircularStringZM,
        text: "CIRCULARSTRING ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000008"),
          ndr: Base.decode16!("01080000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000800000D7C"),
          ndr: Base.decode16!("01080000E07C0D0000")
        },
        data: %{
          term: [[3, 3, 3, 9], [4, 4, 4, 10], [21.11, 22.22, 23.33, 99.9]],
          invalid:
            Base.decode16!("""
            22400000000000001040000000000000104000000000000010400000000000002440\
            """),
          xdr:
            Base.decode16!("""
            00000003400800000000000040080000000000004008000000000000402200000000\
            00004010000000000000401000000000000040100000000000004024000000000000\
            40351C28F5C28F5C40363851EB851EB84037547AE147AE144058F9999999999A\
            """),
          ndr:
            Base.decode16!("""
            03000000000000000000084000000000000008400000000000000840000000000000\
            22400000000000001040000000000000104000000000000010400000000000002440\
            5C8FC2F5281C3540B81E85EB5138364014AE47E17A5437409A99999999F95840\
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
        test "returns an empty curve" do
          assert unquote(module).new() == %unquote(module){arcs: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a curve" do
          coordinates = coordinates(unquote(data[:term]), unquote(dim))
          assert unquote(module).new(coordinates) == %unquote(module){arcs: unquote(data[:term])}
        end

        test "returns an empty curve" do
          assert unquote(module).new([]) == %unquote(module){arcs: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if curve is empty" do
          line = unquote(module).new()
          assert Geometry.empty?(line) == true
        end

        test "returns false if curve is not empty" do
          coordinates = coordinates(unquote(data[:term]), unquote(dim))
          line = unquote(module).new(coordinates)
          assert Geometry.empty?(line) == false
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        @describetag :geo_json

        test "raises a protocol error" do
          circular_string = %unquote(module){arcs: unquote(data[:term])}

          message =
            ~r|protocol.Geometry.Encoder.GeoJson.not.implemented.for.*#{inspect(unquote(module))}|

          assert_raise Protocol.UndefinedError, message, fn ->
            Geometry.to_geo_json(circular_string)
          end
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns circular string from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkb(wkb) == {:ok, circular_string}
        end

        test "returns circular string from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkb(wkb) == {:ok, circular_string}
        end

        test "returns an empty circular string from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          circular_string = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, circular_string}
        end

        test "returns an empty circular string from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          circular_string = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, circular_string}
        end

        test "returns circular string from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, circular_string}
        end

        test "returns circular string from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, circular_string}
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

          assert offset in [57, 81, 105]
        end

        test "returns an error tuple for invalid length" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 7)

          assert Geometry.from_wkb(wkb) == {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: <<3, 0>>,
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

          assert offset in [57, 81, 105]
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

        test "returns circular string from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkb(wkb) == {:ok, circular_string}
        end

        test "returns circular string from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkb(wkb) == {:ok, circular_string}
        end

        test "returns circular string from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, circular_string}
        end

        test "returns circular string from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, circular_string}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns a circular string as xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(circular_string, :xdr) == wkb
        end

        test "returns circular string as ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(circular_string) == wkb
          assert Geometry.to_wkb(circular_string, :ndr) == wkb
        end

        test "returns an empty circular string from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          circular_string = unquote(module).new()

          assert Geometry.to_wkb(circular_string, :xdr) == wkb
        end

        test "returns an empty circular string from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          circular_string = unquote(module).new()

          assert Geometry.to_wkb(circular_string) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns circular string as xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(circular_string, :xdr) == wkb
        end

        test "returns circular string as ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(circular_string) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns curve" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, circular_string}
        end

        test "returns curve with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, circular_string}
        end

        test "returns an empty curve" do
          wkt = wkt(unquote(text))
          circular_string = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, circular_string}
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns circular string" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, circular_string}
        end

        test "returns an empty circular string" do
          wkt = wkt(unquote(text))
          circular_string = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, circular_string}
        end

        test "returns circular string from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, circular_string}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          wkt = wkt(unquote(text), unquote(data[:term]))
          circular_string = circular_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkt(circular_string) == wkt
        end

        test "returns wkt from an empty circular string" do
          wkt = wkt(unquote(text))
          circular_string = unquote(module).new()

          assert Geometry.to_wkt(circular_string) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          circular_string =
            circular_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(circular_string) == wkt
        end

        test "returns ewkt from an empty circulat string" do
          wkt = wkt(unquote(text), [], unquote(srid))
          circular_string = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.to_ewkt(circular_string) == wkt
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

  defp circular_string(module, data, dim, srid \\ 0) do
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
