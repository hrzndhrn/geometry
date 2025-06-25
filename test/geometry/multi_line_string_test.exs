defmodule Geometry.MultiLineStringTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Geometry.DecodeError
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.MultiLineString
  alias Geometry.MultiLineStringM
  alias Geometry.MultiLineStringZ
  alias Geometry.MultiLineStringZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Geometry.MultiLineString, import: true
  doctest Geometry.MultiLineStringM, import: true
  doctest Geometry.MultiLineStringZ, import: true
  doctest Geometry.MultiLineStringZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: MultiLineString,
        text: "MultiLineString",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000005"),
          ndr: Base.decode16!("0105000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000500001267"),
          ndr: Base.decode16!("010500002067120000")
        },
        data: %{
          term: [[[1, 2.2], [3, 4.4]], [[5, 6], [7, 8]]],
          xdr:
            Base.decode16!("""
            000000020000000002000000023FF0000000000000400199999999999A400800000000\
            0000401199999999999A00000000020000000240140000000000004018000000000000\
            401C0000000000004020000000000000\
            """),
          ndr:
            Base.decode16!("""
            02000000010200000002000000000000000000F03F9A99999999990140000000000000\
            08409A9999999999114001020000000200000000000000000014400000000000001840\
            0000000000001C400000000000002040\
            """)
        }
      },
      %{
        module: MultiLineStringM,
        text: "MultiLineString M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000005"),
          ndr: Base.decode16!("0105000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000050000002A"),
          ndr: Base.decode16!("01050000602A000000")
        },
        data: %{
          term: [
            [[1, 2.2, 3], [3, 4.4, 5]],
            [[1, 2.2, 3], [6, 7, 8]]
          ],
          xdr:
            Base.decode16!("""
            000000020040000002000000023FF0000000000000400199999999999A400800000000\
            00004008000000000000401199999999999A4014000000000000004000000200000002\
            3FF0000000000000400199999999999A40080000000000004018000000000000401C00\
            00000000004020000000000000\
            """),
          ndr:
            Base.decode16!("""
            02000000010200004002000000000000000000F03F9A99999999990140000000000000\
            084000000000000008409A999999999911400000000000001440010200004002000000\
            000000000000F03F9A9999999999014000000000000008400000000000001840000000\
            0000001C400000000000002040\
            """)
        }
      },
      %{
        module: MultiLineStringZ,
        text: "MultiLineString Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000005"),
          ndr: Base.decode16!("0105000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000005000004D2"),
          ndr: Base.decode16!("01050000A0D2040000")
        },
        data: %{
          term: [
            [[3, 3, 3], [4, 4, 4]],
            [[8, 8, 8], [9, 9, 9]]
          ],
          xdr:
            Base.decode16!("""
            0000000200800000020000000240080000000000004008000000000000400800000000\
            0000401000000000000040100000000000004010000000000000008000000200000002\
            4020000000000000402000000000000040200000000000004022000000000000402200\
            00000000004022000000000000\
            """),
          ndr:
            Base.decode16!("""
            0200000001020000800200000000000000000008400000000000000840000000000000\
            0840000000000000104000000000000010400000000000001040010200008002000000\
            0000000000002040000000000000204000000000000020400000000000002240000000\
            00000022400000000000002240\
            """)
        }
      },
      %{
        module: MultiLineStringZM,
        text: "MultiLineString ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000005"),
          ndr: Base.decode16!("01050000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000500000D7C"),
          ndr: Base.decode16!("01050000E07C0D0000")
        },
        data: %{
          term: [
            [[3, 3, 3, 9], [4, 4, 4, 10]],
            [[13, 13, 13, 19], [24, 24, 24, 20]]
          ],
          xdr:
            Base.decode16!("""
            0000000200C00000020000000240080000000000004008000000000000400800000000\
            0000402200000000000040100000000000004010000000000000401000000000000040\
            2400000000000000C000000200000002402A000000000000402A000000000000402A00\
            0000000000403300000000000040380000000000004038000000000000403800000000\
            00004034000000000000\
            """),
          ndr:
            Base.decode16!("""
            0200000001020000C00200000000000000000008400000000000000840000000000000\
            0840000000000000224000000000000010400000000000001040000000000000104000\
            0000000000244001020000C0020000000000000000002A400000000000002A40000000\
            0000002A40000000000000334000000000000038400000000000003840000000000000\
            38400000000000003440\
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
        test "returns an empty multi-line-string" do
          assert unquote(module).new() == %unquote(module){line_strings: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a multi-line-string" do
          line_strings = line_strings(unquote(data[:term]), unquote(dim))

          assert unquote(module).new(line_strings) == %unquote(module){
                   line_strings: unquote(data[:term])
                 }
        end

        test "returns an empty multi-line-string" do
          assert unquote(module).new([]) == %unquote(module){line_strings: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if multi-line-string is empty" do
          multi_line_string = unquote(module).new()
          assert Geometry.empty?(multi_line_string) == true
        end

        test "returns false if multi-line-string is not empty" do
          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.empty?(multi_line_string) == false
        end
      end

      describe "[#{inspect(module)}] from_geo_json/2" do
        @describetag :geo_json

        test "returns multi-line-string" do
          geo_json =
            Jason.decode!("""
            {
              "type": "MultiLineString",
              "coordinates": #{inspect(unquote(data[:term]), charlists: :as_lists)},
              "foo": "ignore"
            }
            """)

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), 4326)

          assert GeoJsonValidator.valid?(geo_json)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) ==
                   {:ok, multi_line_string}

          if unquote(dim) == :xy do
            assert Geometry.from_geo_json(geo_json) ==
                     {:ok, multi_line_string}
          end
        end

        test "returns an error for missing coordinates" do
          geo_json = Jason.decode!(~s|{"type": "MultiLineString"}|)

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
          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          geo_json = Geometry.to_geo_json(multi_line_string)

          assert geo_json == %{
                   "type" => "MultiLineString",
                   "coordinates" => unquote(data[:term])
                 }

          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end

        test "returns json compatible map for an empty multi-line-string" do
          multi_line_string = unquote(module).new()
          geo_json = Geometry.to_geo_json(multi_line_string)

          assert geo_json == %{"type" => "MultiLineString", "coordinates" => []}
          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns multi-line-string from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_wkb(wkb) == {:ok, multi_line_string}
        end

        test "returns multi-line-string from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_wkb(wkb) == {:ok, multi_line_string}
        end

        test "returns an empty multi-line-string from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          multi_line_string = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, multi_line_string}
        end

        test "returns an empty multi-line-string from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          multi_line_string = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, multi_line_string}
        end

        test "returns multi-line-string from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_line_string =
            multi_line_string(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_wkb(wkb) == {:ok, multi_line_string}
        end

        test "returns multi-line-string from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_line_string =
            multi_line_string(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_wkb(wkb) == {:ok, multi_line_string}
        end

        test "returns an error for invalid endian flag (xdr)" do
          wkb =
            unquote(code[:xdr] <> data[:xdr])
            |> Binary.replace("0000000002", "0300000002")
            |> Binary.replace("0040000002", "0300000002")
            |> Binary.replace("0080000002", "0300000002")
            |> Binary.replace("00C0000002", "0300000002")

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: 9,
                    reason: [expected_endian: :xdr]
                  }} = Geometry.from_wkb(wkb)
        end

        test "returns an error for invalid endian flag (ndr)" do
          wkb =
            unquote(code_srid[:ndr] <> data[:ndr])
            |> Binary.replace("0102000000", "0302000000")
            |> Binary.replace("0102000040", "0302000040")
            |> Binary.replace("0102000080", "0302000080")
            |> Binary.replace("01020000C0", "03020000C0")

          assert {:error,
                  %DecodeError{
                    from: :wkb,
                    rest: _rest,
                    offset: 13,
                    reason: [expected_endian: :ndr]
                  }} = Geometry.from_wkb(wkb)
        end

        test "returns an error for invalid geometry code" do
          wkb =
            unquote(code_srid[:ndr] <> data[:ndr])
            |> Binary.replace("0102000000", "0108000000")
            |> Binary.replace("0102000040", "0108000040")
            |> Binary.replace("0102000080", "0108000080")
            |> Binary.replace("01020000C0", "01080000C0")

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
                      rest: <<2, 0, 0>>,
                      offset: 5,
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

          assert offset in [75, 99, 123]

          assert rest in [
                   <<0, 0, 0, 0, 0, 0, 28, 64, 0, 0, 0, 0, 0, 0, 32>>,
                   <<0, 0, 0, 0, 0, 0, 24, 64, 0, 0, 0, 0, 0, 0, 28, 64, 0, 0, 0, 0, 0, 0, 32>>,
                   <<0, 0, 0, 0, 0, 0, 34, 64, 0, 0, 0, 0, 0, 0, 34, 64, 0, 0, 0, 0, 0, 0, 34>>,
                   <<0, 0, 0, 0, 0, 0, 56, 64, 0, 0, 0, 0, 0, 0, 56, 64, 0, 0, 0, 0, 0, 0, 56, 64,
                     0, 0, 0, 0, 0, 0, 52>>
                 ]
        end
      end

      describe "[#{inspect(module)}] from_wkb!/1" do
        @describetag :wkb

        test "raises an error tuple for invalid coordinate" do
          data = unquote(code[:ndr] <> data[:ndr])
          wkb = Binary.take(data, byte_size(data) - 1)

          assert_fail :from_wkb!, wkb, ~r/invalid coordiante at position .*, got: <<.*>>/
        end

        test "raises an error tuple for invalid length" do
          wkb = Binary.take(unquote(code[:ndr] <> data[:ndr]), 8)

          assert_fail :from_wkb!, wkb, ~r/invalid length at position .*, got: <<.*>>/
        end

        test "raises an error for invalid geometry code" do
          wkb =
            unquote(code_srid[:ndr] <> data[:ndr])
            |> Binary.replace("0102000000", "0108000000")
            |> Binary.replace("0102000040", "0108000040")
            |> Binary.replace("0102000080", "0108000080")
            |> Binary.replace("01020000C0", "01080000C0")

          assert_fail :from_wkb!, wkb, ~r/expected geometry code at position .*, got: <<.*>>/
        end

        test "returns an error for invalid endian flag (ndr)" do
          wkb =
            unquote(code_srid[:ndr] <> data[:ndr])
            |> Binary.replace("0102000000", "0302000000")
            |> Binary.replace("0102000040", "0302000040")
            |> Binary.replace("0102000080", "0302000080")
            |> Binary.replace("01020000C0", "03020000C0")

          assert_fail :from_wkb!, wkb, ~r/expected endian NDR at position .*, got: <<.*>>/
        end
      end

      describe "[#{inspect(module)}] from_ewkb/1" do
        @describetag :wkb

        test "returns multi-line-string from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_ewkb(wkb) == {:ok, multi_line_string}
        end

        test "returns multi-line-string from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), 0, true)

          assert Geometry.from_ewkb(wkb) == {:ok, multi_line_string}
        end

        test "returns multi-line-string from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_line_string =
            multi_line_string(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_ewkb(wkb) == {:ok, multi_line_string}
        end

        test "returns multi-line-string from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_line_string =
            multi_line_string(
              unquote(module),
              unquote(data[:term]),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.from_ewkb(wkb) == {:ok, multi_line_string}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns multi-line-string from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(multi_line_string, :xdr) == wkb
        end

        test "returns multi-line-string from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkb(multi_line_string) == wkb
          assert Geometry.to_wkb(multi_line_string, :ndr) == wkb
        end

        test "returns an empty multi-line-string from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          multi_line_string = unquote(module).new()

          assert Geometry.to_wkb(multi_line_string, :xdr) == wkb
        end

        test "returns an empty multi-line-string from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          multi_line_string = unquote(module).new()

          assert Geometry.to_wkb(multi_line_string) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns multi-line-string from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(multi_line_string, :xdr) == wkb
        end

        test "returns multi-line-string from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkb(multi_line_string) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns multi-line-string" do
          wkt = wkt(unquote(text), unquote(data[:term]))

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, multi_line_string}
        end

        test "returns an empty multi-line-string" do
          wkt = wkt(unquote(text))
          multi_line_string = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, multi_line_string}
        end

        test "returns multi-line-string from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, multi_line_string}
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns multi-line-string" do
          wkt = wkt(unquote(text), unquote(data[:term]))

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, multi_line_string}
        end

        test "returns an empty multi-line-string" do
          wkt = wkt(unquote(text))
          multi_line_string = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, multi_line_string}
        end

        test "returns multi-line-string from WKT with srid" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, multi_line_string}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          wkt = wkt(unquote(text), unquote(data[:term]))

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Geometry.to_wkt(multi_line_string) == wkt
        end

        test "returns wkt from an empty multi-line-string" do
          wkt = wkt(unquote(text))
          multi_line_string = unquote(module).new()

          assert Geometry.to_wkt(multi_line_string) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          wkt = wkt(unquote(text), unquote(data[:term]), unquote(srid))

          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(multi_line_string) == wkt
        end

        test "returns ewkt from an empty multi-line-string" do
          wkt = wkt(unquote(text), [], unquote(srid))
          multi_line_string = unquote(module).new([], unquote(srid))

          assert Geometry.to_ewkt(multi_line_string) == wkt
        end
      end

      describe "[#{inspect(module)}] slice/2" do
        test "returns slice" do
          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Enum.slice(multi_line_string, 1..2) == Enum.slice(unquote(data[:term]), 1..2)
        end
      end

      describe "[#{inspect(module)}] into/2" do
        test "returns multi-line-string" do
          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          line_strings = line_strings(unquote(data[:term]), unquote(dim))

          assert Enum.into(line_strings, unquote(module).new()) == multi_line_string
        end
      end

      describe "[#{inspect(module)}] member?/2" do
        test "returns true" do
          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          line_strings = line_strings(unquote(data[:term]), unquote(dim))

          assert Enum.member?(multi_line_string, hd(line_strings)) == true
        end

        test "returns false" do
          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          line_string = line_string([[0, 0, 0, 0], [1, 1, 1, 1]], unquote(dim))

          assert Enum.member?(multi_line_string, line_string) == false
        end
      end

      describe "[#{inspect(module)}] map/2" do
        test "returns line_strings" do
          multi_line_string =
            multi_line_string(unquote(module), unquote(data[:term]), unquote(dim))

          assert Enum.map(multi_line_string, fn x -> x end) == unquote(data[:term])
        end
      end
    end
  )

  defp wkt(name, data \\ [], srid \\ "")

  defp wkt(name, [], ""), do: "#{name} EMPTY"

  defp wkt(name, [], srid), do: "SRID=#{srid};#{name} EMPTY"

  defp wkt(name, data, srid) do
    coordinates =
      data
      |> Enum.map_join(", ", fn line ->
        line
        |> Enum.map_join(", ", fn point -> Enum.join(point, @blank) end)
        |> in_brackets()
      end)
      |> in_brackets()

    "#{srid(srid)}#{name} #{coordinates}"
  end

  defp srid(""), do: ""

  defp srid(srid), do: "SRID=#{srid};"

  defp in_brackets(str), do: "(#{str})"

  defp multi_line_string(module, data, dim, srid \\ 0, to_float \\ false) do
    module.new(line_strings(to_float(data, to_float), dim, srid), srid)
  end

  defp to_float(data, false), do: data

  defp to_float(data, true) do
    Enum.map(data, fn
      list when is_list(list) -> to_float(list, true)
      value -> value * 1.0
    end)
  end

  defp line_strings(data, dim, srid \\ 0) do
    case dim do
      :xy -> Enum.map(data, fn coordinates -> %LineString{path: coordinates, srid: srid} end)
      :xym -> Enum.map(data, fn coordinates -> %LineStringM{path: coordinates, srid: srid} end)
      :xyz -> Enum.map(data, fn coordinates -> %LineStringZ{path: coordinates, srid: srid} end)
      :xyzm -> Enum.map(data, fn coordinates -> %LineStringZM{path: coordinates, srid: srid} end)
    end
  end

  defp line_string(coordinates, dim, srid \\ 0) do
    line_strings = Enum.map(coordinates, fn point -> point(point, dim, srid) end)

    case dim do
      :xy -> LineString.new(line_strings, srid: srid)
      :xym -> LineStringM.new(line_strings, srid: srid)
      :xyz -> LineStringZ.new(line_strings, srid: srid)
      :xyzm -> LineStringZM.new(line_strings, srid: srid)
    end
  end

  defp point(data, dim, srid) do
    case dim do
      :xy -> data |> Enum.take(2) |> Point.new(srid)
      :xym -> data |> Enum.take(3) |> PointM.new(srid)
      :xyz -> data |> Enum.take(3) |> PointZ.new(srid)
      :xyzm -> data |> Enum.take(4) |> PointZM.new(srid)
    end
  end
end
