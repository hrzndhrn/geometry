defmodule Geometry.PointNewTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Geometry.DecodeError

  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Point, import: true
  doctest PointM, import: true
  doctest PointZ, import: true
  doctest PointZM, import: true

  @empty_ndr Base.decode16!("000000000000F87F")
  @empty_xdr Base.decode16!("7FF8000000000000")
  @blank "\s"

  Enum.each(
    [
      %{
        module: Point,
        text: "Point",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000001"),
          ndr: Base.decode16!("0101000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000100001267"),
          ndr: Base.decode16!("010100002067120000")
        },
        empty: %{
          xdr: @empty_xdr <> @empty_xdr,
          ndr: @empty_ndr <> @empty_ndr
        },
        invalid: %{
          xdr: @empty_xdr <> @empty_ndr,
          ndr: @empty_ndr <> @empty_xdr
        },
        data: %{
          term: [1.0, 2.2],
          xdr: Base.decode16!("3FF0000000000000400199999999999A"),
          ndr: Base.decode16!("000000000000F03F9A99999999990140")
        }
      },
      %{
        module: PointM,
        text: "Point M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000001"),
          ndr: Base.decode16!("0101000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000010000002A"),
          ndr: Base.decode16!("01010000602A000000")
        },
        empty: %{
          xdr: @empty_xdr <> @empty_xdr <> @empty_xdr,
          ndr: @empty_ndr <> @empty_ndr <> @empty_ndr
        },
        invalid: %{
          xdr: @empty_ndr <> @empty_xdr <> @empty_xdr,
          ndr: @empty_xdr <> @empty_ndr <> @empty_ndr
        },
        data: %{
          term: [3, 4.4, 5.5],
          xdr: Base.decode16!("4008000000000000401199999999999A4016000000000000"),
          ndr: Base.decode16!("00000000000008409A999999999911400000000000001640")
        }
      },
      %{
        module: PointZ,
        text: "Point Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000001"),
          ndr: Base.decode16!("0101000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000001000004D2"),
          ndr: Base.decode16!("01010000A0D2040000")
        },
        empty: %{
          xdr: @empty_xdr <> @empty_xdr <> @empty_xdr,
          ndr: @empty_ndr <> @empty_ndr <> @empty_ndr
        },
        invalid: %{
          xdr: @empty_ndr <> @empty_xdr <> @empty_xdr,
          ndr: @empty_xdr <> @empty_ndr <> @empty_ndr
        },
        data: %{
          term: [6, 7.7, 8.8],
          xdr: Base.decode16!("4018000000000000401ECCCCCCCCCCCD402199999999999A"),
          ndr: Base.decode16!("0000000000001840CDCCCCCCCCCC1E409A99999999992140")
        }
      },
      %{
        module: PointZM,
        text: "Point ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000001"),
          ndr: Base.decode16!("01010000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000100000D7C"),
          ndr: Base.decode16!("01010000E07C0D0000")
        },
        empty: %{
          xdr: @empty_xdr <> @empty_xdr <> @empty_xdr <> @empty_xdr,
          ndr: @empty_ndr <> @empty_ndr <> @empty_ndr <> @empty_ndr
        },
        invalid: %{
          xdr: @empty_ndr <> @empty_xdr <> @empty_xdr <> @empty_xdr,
          ndr: @empty_xdr <> @empty_ndr <> @empty_ndr <> @empty_ndr
        },
        data: %{
          term: [9, 10.0, 11.1, 12.2],
          xdr: Base.decode16!("4022000000000000402400000000000040263333333333334028666666666666"),
          ndr: Base.decode16!("0000000000002240000000000000244033333333333326406666666666662840")
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
         code_srid: code_srid,
         empty: empty,
         invalid: invalid
       } ->
      describe "[#{inspect(module)}] new/0" do
        test "returns an empty point" do
          assert unquote(module).new() == %unquote(module){coordinate: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a point" do
          assert unquote(module).new(unquote(data[:term])) ==
                   %unquote(module){coordinate: unquote(data[:term])}
        end
      end

      describe "[#{inspect(module)}] new/#{length(data[:term])}" do
        test "returns a point" do
          assert unquote(module).new(unquote_splicing(data[:term])) ==
                   %unquote(module){coordinate: unquote(data[:term])}
        end

        test "[#{inspect(module)}] raises an error for invalid args" do
          assert_raise FunctionClauseError, fn ->
            unquote(module).new(unquote_splicing(List.replace_at(data[:term], 1, [])))
          end
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true for an empty point" do
          point = unquote(module).new()
          assert Geometry.empty?(point) == true
        end

        test "returns false for a  none empty point" do
          point = unquote(module).new(unquote(data[:term]))
          assert Geometry.empty?(point) == false
        end
      end

      describe "[#{inspect(module)}] from_geo_json/2" do
        @describetag :geo_json

        test "returns point" do
          geo_json =
            Jason.decode!("""
            {
              "type": "Point",
              "coordinates": [#{Enum.join(unquote(data[:term]), ",")}],
              "foo": "ignore"
            }
            """)

          assert GeoJsonValidator.valid?(geo_json)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) ==
                   {:ok, %unquote(module){coordinate: unquote(data[:term]), srid: 4326}}

          if unquote(dim) == :xy do
            assert Geometry.from_geo_json(geo_json) ==
                     {:ok, %unquote(module){coordinate: unquote(data[:term]), srid: 4326}}
          end
        end

        test "returns an error for missing coordinates" do
          geo_json = Jason.decode!(~s|{"type": "Point"}|)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) == {
                   :error,
                   %DecodeError{
                     from: :geo_json,
                     reason: :coordinates_not_found
                   }
                 }
        end

        test "returns an error for invalid coordinates" do
          geo_json = Jason.decode!(~s|{"type": "Point", "coordinates": ["invalid"]}|)

          assert Geometry.from_geo_json(geo_json, unquote(dim)) == {
                   :error,
                   %DecodeError{
                     from: :geo_json,
                     reason: :invalid_data
                   }
                 }
        end
      end

      describe "[#{inspect(module)}] from_geo_json!/2" do
        @describetag :geo_json

        test "returns point" do
          geo_json =
            Jason.decode!("""
            {
              "type": "Point",
              "coordinates": [#{Enum.join(unquote(data[:term]), ",")}],
              "foo": "ignore"
            }
            """)

          assert Geometry.from_geo_json!(geo_json, unquote(dim)) ==
                   %unquote(module){coordinate: unquote(data[:term]), srid: 4326}

          if unquote(dim) == :xy do
            assert Geometry.from_geo_json!(geo_json) ==
                     %unquote(module){coordinate: unquote(data[:term]), srid: 4326}
          end
        end

        test "raises an error for missing coordinates" do
          geo_json = Jason.decode!(~s|{"type": "Point"}|)
          message = "coordinates not found"

          assert_fail :from_geo_json!, [geo_json, unquote(dim)], message
        end

        test "raises an error for invalid coordinates" do
          geo_json = Jason.decode!(~s|{"type": "Point", "coordinates": ["invalid"]}|)
          message = "invalid data"

          assert_fail :from_geo_json!, [geo_json, unquote(dim)], message
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        @describetag :geo_json

        test "returns json compatible map" do
          point = unquote(module).new(unquote(data[:term]))
          geo_json = Geometry.to_geo_json(point)

          assert geo_json == %{
                   "type" => "Point",
                   "coordinates" => unquote(data[:term])
                 }

          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end

        test "returns json compatible map for an empty point" do
          point = unquote(module).new()
          geo_json = Geometry.to_geo_json(point)

          assert geo_json == %{
                   "type" => "Point",
                   "coordinates" => []
                 }

          assert Jason.encode!(geo_json)
          assert GeoJsonValidator.valid?(geo_json)
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns point from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_wkb(wkb) == {:ok, point}
        end

        test "returns point from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_wkb(wkb) == {:ok, point}
        end

        test "returns an empty point from xdr binary" do
          wkb = unquote(code[:xdr] <> empty[:xdr])
          point = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, point}
        end

        test "returns an empty point from ndr binary" do
          wkb = unquote(code[:ndr] <> empty[:ndr])
          point = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, point}
        end

        test "returns point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, point}
        end

        test "returns point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, point}
        end

        test "returns an empty point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> empty[:xdr])
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, point}
        end

        test "returns an empty point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> empty[:ndr])
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, point}
        end

        test "returns an error tuple for an invalid data" do
          wkb = unquote(code_srid[:ndr] <> invalid[:xdr])

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: _rest,
                     offset: 9,
                     reason: :invalid_data
                   }
                 } = Geometry.from_wkb(wkb)
        end

        test "returns an error tuple for an invalid coordinate" do
          wkb = unquote(code_srid[:ndr] <> <<11, 22>>)

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: _rest,
                     offset: 9,
                     reason: :invalid_data
                   }
                 } = Geometry.from_wkb(wkb)
        end
      end

      describe "[#{inspect(module)}] from_wkb!/1" do
        @describetag :wkb

        test "returns point from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_wkb!(wkb) == point
        end

        test "returns point from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_wkb!(wkb) == point
        end

        test "returns an empty point from xdr binary" do
          wkb = unquote(code[:xdr] <> empty[:xdr])
          point = unquote(module).new()

          assert Geometry.from_wkb!(wkb) == point
        end

        test "returns an empty point from ndr binary" do
          wkb = unquote(code[:ndr] <> empty[:ndr])
          point = unquote(module).new()

          assert Geometry.from_wkb!(wkb) == point
        end

        test "returns point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.from_wkb!(wkb) == point
        end

        test "returns point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.from_wkb!(wkb) == point
        end

        test "returns an empty point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> empty[:xdr])
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.from_wkb!(wkb) == point
        end

        test "returns an empty point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> empty[:ndr])
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.from_wkb!(wkb) == point
        end

        test "raises an error tuple for an invalid coordinate" do
          wkb = unquote(code_srid[:ndr] <> <<11, 22>>)

          assert_fail :from_wkb!, wkb, "unexpected data at position 9, got: <<0xB, 0x16>>"
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns xdr binary for point" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.to_wkb(point, :xdr) == wkb
        end

        test "returns ndr binary for point" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.to_wkb(point) == wkb
          assert Geometry.to_wkb(point, :ndr) == wkb
        end

        test "returns xdr binary for an empty point" do
          wkb = unquote(code[:xdr] <> empty[:xdr])
          point = unquote(module).new()

          assert Geometry.to_wkb(point, :xdr) == wkb
        end

        test "returns ndr binary for an empty point" do
          wkb = unquote(code[:ndr] <> empty[:ndr])
          point = unquote(module).new()

          assert Geometry.to_wkb(point) == wkb
        end
      end

      describe "[#{inspect(module)}] from_ewkb/1" do
        @describetag :wkb

        test "returns point from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_ewkb(wkb) == {:ok, point}
        end

        test "returns point from ndr binary" do
          wkb = unquote(code[:ndr] <> data[:ndr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_ewkb(wkb) == {:ok, point}
        end

        test "returns an empty point from xdr binary" do
          wkb = unquote(code[:xdr] <> empty[:xdr])
          point = unquote(module).new()

          assert Geometry.from_ewkb(wkb) == {:ok, point}
        end

        test "returns an empty point from ndr binary" do
          wkb = unquote(code[:ndr] <> empty[:ndr])
          point = unquote(module).new()

          assert Geometry.from_ewkb(wkb) == {:ok, point}
        end

        test "returns point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, point}
        end

        test "returns point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, point}
        end

        test "returns an empty point from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr] <> empty[:xdr])
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, point}
        end

        test "returns an empty point from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr] <> empty[:ndr])
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, point}
        end
      end

      describe "[#{inspect(module)}] from_ewkb!/1" do
        @describetag :wkb

        test "returns point from xdr binary" do
          wkb = unquote(code[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_ewkb!(wkb) == point
        end
      end

      describe "[#{inspect(module)}] to_ewkb/3" do
        @describetag :wkb

        test "returns xdr binary for point" do
          wkb = unquote(code_srid[:xdr] <> data[:xdr])
          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.to_ewkb(point, :xdr) == wkb
        end

        test "returns ndr binary for point" do
          wkb = unquote(code_srid[:ndr] <> data[:ndr])
          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.to_ewkb(point) == wkb
          assert Geometry.to_ewkb(point, :ndr) == wkb
        end

        test "returns xdr binary for an empty point" do
          wkb = unquote(code_srid[:xdr] <> empty[:xdr])
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.to_ewkb(point, :xdr) == wkb
        end

        test "returns ndr binary for an empty point" do
          wkb = unquote(code_srid[:ndr] <> empty[:ndr])
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.to_ewkb(point) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1:" do
        @describetag :wkt

        test "returns a point from WKT" do
          wkt = "#{unquote(text)} (#{unquote(Enum.join(data[:term], @blank))})"
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_wkt(wkt) == {:ok, point}
        end

        test "returns an empty point from WKT" do
          wkt = "#{unquote(text)} empty"
          point = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, point}
        end

        test "returns a point from WKT with srid" do
          wkt =
            "SRID=#{unquote(srid)};#{unquote(text)} (#{unquote(Enum.join(data[:term], @blank))})"

          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, point}
        end

        test "returns an empty point from WKT with srid" do
          wkt = "SRID=#{unquote(srid)};#{unquote(text)} empty"
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, point}
        end
      end

      describe "[#{inspect(module)}] from_wkt!/1:" do
        @describetag :wkt

        test "returns a point from WKT" do
          wkt = "#{unquote(text)} (#{unquote(Enum.join(data[:term], @blank))})"
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_wkt!(wkt) == point
        end
      end

      describe "[#{inspect(module)}] to_wkt/1:" do
        @describetag :wkt

        test "returns WKT for a point" do
          wkt = "#{unquote(text)} (#{unquote(Enum.join(data[:term], @blank))})"
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.to_wkt(point) == wkt
        end

        test "returns WKT for an empty point" do
          wkt = "#{unquote(text)} EMPTY"
          point = unquote(module).new()

          assert Geometry.to_wkt(point) == wkt
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1:" do
        @describetag :wkt

        test "returns a point from WKT" do
          wkt = "#{unquote(text)} (#{unquote(Enum.join(data[:term], @blank))})"
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_ewkt(wkt) == {:ok, point}
        end

        test "returns an empty point from WKT" do
          wkt = "#{unquote(text)} empty"
          point = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, point}
        end

        test "returns a point from WKT with srid" do
          wkt =
            "SRID=#{unquote(srid)};#{unquote(text)} (#{unquote(Enum.join(data[:term], @blank))})"

          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, point}
        end

        test "returns an empty point from WKT with srid" do
          wkt = "SRID=#{unquote(srid)};#{unquote(text)} empty"
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, point}
        end
      end

      describe "[#{inspect(module)}] from_ewkt!/1:" do
        @describetag :wkt

        test "returns a point from WKT" do
          wkt = "#{unquote(text)} (#{unquote(Enum.join(data[:term], @blank))})"
          point = unquote(module).new(unquote(data[:term]))

          assert Geometry.from_ewkt!(wkt) == point
        end
      end

      describe "[#{inspect(module)}] to_ewkt/1:" do
        @describetag :wkt

        test "returns WKT for a point" do
          wkt =
            "SRID=#{unquote(srid)};#{unquote(text)} (#{unquote(Enum.join(data[:term], @blank))})"

          point = unquote(module).new(unquote(data[:term]), unquote(srid))

          assert Geometry.to_ewkt(point) == wkt
        end

        test "returns WKT for an empty point" do
          wkt = "SRID=#{unquote(srid)};#{unquote(text)} EMPTY"
          point = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.to_ewkt(point) == wkt
        end
      end
    end
  )
end
