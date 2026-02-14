defmodule Geometry.CompoundCurveTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Geometry.DecodeError

  alias Geometry.CircularString
  alias Geometry.CircularStringM
  alias Geometry.CircularStringZ
  alias Geometry.CircularStringZM
  alias Geometry.CompoundCurve
  alias Geometry.CompoundCurveM
  alias Geometry.CompoundCurveZ
  alias Geometry.CompoundCurveZM
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Geometry.CompoundCurve, import: true
  doctest Geometry.CompoundCurveM, import: true
  doctest Geometry.CompoundCurveZ, import: true
  doctest Geometry.CompoundCurveZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: CompoundCurve,
        text: "COMPOUNDCURVE",
        dim: :xy,
        srid: 4711,
        code: %{
          xdr: Base.decode16!("0000000009"),
          ndr: Base.decode16!("0109000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000900001267"),
          ndr: Base.decode16!("010900002067120000")
        },
        data: %{
          segments: [
            {:line_string, [[1.0, 0.0], [1.0, 1.0]]},
            {:circular_string, [[1.0, 1.0], [2.0, 2.0], [0.0, 1.0]]},
            {:line_string, [[0.0, 1.0], [5.0, 5.0]]}
          ],
          unexpected_segments: [
            {:point, [1, 1]}
          ],
          wkb_xdr:
            Base.decode16!("""
            000000030000000002000000023FF000000000000000000000000000003FF0000000\
            0000003FF00000000000000000000008000000033FF00000000000003FF000000000\
            00004000000000000000400000000000000000000000000000003FF0000000000000\
            00000000020000000200000000000000003FF0000000000000401400000000000040\
            14000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            03000000010200000002000000000000000000F03F00000000000000000000000000\
            00F03F000000000000F03F010800000003000000000000000000F03F000000000000\
            F03F000000000000004000000000000000400000000000000000000000000000F03F\
            0102000000020000000000000000000000000000000000F03F000000000000144000\
            00000000001440\
            """)
        }
      },
      %{
        module: CompoundCurveM,
        text: "COMPOUNDCURVE M",
        dim: :xym,
        srid: 42,
        code: %{
          xdr: Base.decode16!("0040000009"),
          ndr: Base.decode16!("0109000040")
        },
        code_srid: %{
          xdr: Base.decode16!("00600000090000002A"),
          ndr: Base.decode16!("01090000602A000000")
        },
        data: %{
          segments: [
            {:line_string, [[1.0, 0.0, 5.0], [1.0, 1.0, 7.0]]},
            {:circular_string, [[1.0, 1.0, 9.0], [2.0, 2.0, 6.0], [0.0, 1.0, 5.0]]},
            {:line_string, [[0.0, 1.0, 3.0], [5.0, 5.0, 6.0]]}
          ],
          wkb_xdr:
            Base.decode16!("""
            000000030040000002000000023FF000000000000000000000000000004014000000\
            0000003FF00000000000003FF0000000000000401C00000000000000400000080000\
            00033FF00000000000003FF000000000000040220000000000004000000000000000\
            4000000000000000401800000000000000000000000000003FF00000000000004014\
            00000000000000400000020000000200000000000000003FF0000000000000400800\
            0000000000401400000000000040140000000000004018000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            03000000010200004002000000000000000000F03F00000000000000000000000000\
            001440000000000000F03F000000000000F03F0000000000001C4001080000400300\
            0000000000000000F03F000000000000F03F00000000000022400000000000000040\
            000000000000004000000000000018400000000000000000000000000000F03F0000\
            0000000014400102000040020000000000000000000000000000000000F03F000000\
            0000000840000000000000144000000000000014400000000000001840\
            """)
        }
      },
      %{
        module: CompoundCurveZ,
        text: "COMPOUNDCURVE Z",
        dim: :xyz,
        srid: 1234,
        code: %{
          xdr: Base.decode16!("0080000009"),
          ndr: Base.decode16!("0109000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A0000009000004D2"),
          ndr: Base.decode16!("01090000A0D2040000")
        },
        data: %{
          segments: [
            {:line_string, [[1.0, 0.0, 5.0], [1.0, 1.0, 7.0]]},
            {:circular_string, [[1.0, 1.0, 9.0], [2.0, 2.0, 6.0], [0.0, 1.0, 5.0]]},
            {:line_string, [[0.0, 1.0, 3.0], [5.0, 5.0, 6.0]]}
          ],
          wkb_xdr:
            Base.decode16!("""
            000000030080000002000000023FF000000000000000000000000000004014000000\
            0000003FF00000000000003FF0000000000000401C00000000000000800000080000\
            00033FF00000000000003FF000000000000040220000000000004000000000000000\
            4000000000000000401800000000000000000000000000003FF00000000000004014\
            00000000000000800000020000000200000000000000003FF0000000000000400800\
            0000000000401400000000000040140000000000004018000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            03000000010200008002000000000000000000F03F00000000000000000000000000\
            001440000000000000F03F000000000000F03F0000000000001C4001080000800300\
            0000000000000000F03F000000000000F03F00000000000022400000000000000040\
            000000000000004000000000000018400000000000000000000000000000F03F0000\
            0000000014400102000080020000000000000000000000000000000000F03F000000\
            0000000840000000000000144000000000000014400000000000001840\
            """)
        }
      },
      %{
        module: CompoundCurveZM,
        text: "COMPOUNDCURVE ZM",
        dim: :xyzm,
        srid: 3452,
        code: %{
          xdr: Base.decode16!("00C0000009"),
          ndr: Base.decode16!("01090000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000900000D7C"),
          ndr: Base.decode16!("01090000E07C0D0000")
        },
        data: %{
          segments: [
            {:line_string, [[1.0, 0.0, 5.0, 3.0], [1.0, 1.0, 9.0, 5.0]]},
            {:circular_string,
             [[1.0, 1.0, 9.0, 1.0], [2.0, 2.0, 6.0, 3.0], [0.0, 1.0, 3.0, 6.0]]},
            {:line_string, [[0.0, 1.0, 3.0, 5.0], [5.0, 5.0, 6.0, 7.0]]}
          ],
          wkb_xdr:
            Base.decode16!("""
            0000000300C0000002000000023FF000000000000000000000000000004014000000\
            00000040080000000000003FF00000000000003FF000000000000040220000000000\
            00401400000000000000C0000008000000033FF00000000000003FF0000000000000\
            40220000000000003FF0000000000000400000000000000040000000000000004018\
            000000000000400800000000000000000000000000003FF000000000000040080000\
            00000000401800000000000000C00000020000000200000000000000003FF0000000\
            00000040080000000000004014000000000000401400000000000040140000000000\
            004018000000000000401C000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0300000001020000C002000000000000000000F03F00000000000000000000000000\
            0014400000000000000840000000000000F03F000000000000F03F00000000000022\
            40000000000000144001080000C003000000000000000000F03F000000000000F03F\
            0000000000002240000000000000F03F000000000000004000000000000000400000\
            00000000184000000000000008400000000000000000000000000000F03F00000000\
            00000840000000000000184001020000C00200000000000000000000000000000000\
            00F03F00000000000008400000000000001440000000000000144000000000000014\
            4000000000000018400000000000001C40\
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
          assert unquote(module).new() == %unquote(module){segments: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a compound curve" do
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))

          assert unquote(module).new(segments) == %unquote(module){
                   segments: segments
                 }
        end

        test "returns an empty curve" do
          assert unquote(module).new([]) == %unquote(module){segments: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if curve is empty" do
          curve = unquote(module).new()
          assert Geometry.empty?(curve) == true
        end

        test "returns false if curve is not empty" do
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          curve = unquote(module).new(segments)
          assert Geometry.empty?(curve) == false
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        @describetag :geo_json

        test "raises a protocol error" do
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = %unquote(module){segments: segments}

          message =
            ~r|protocol.Geometry.Encoder.GeoJson.not.implemented.for.*#{inspect(unquote(module))}|

          assert_raise Protocol.UndefinedError, message, fn ->
            Geometry.to_geo_json(compound_curve)
          end
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns compound curve from xdr binary" do
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.from_wkb(wkb) == {:ok, compound_curve}
        end

        test "returns compound curve from ndr binary" do
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.from_wkb(wkb) == {:ok, compound_curve}
        end

        test "returns an empty compound curve from xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          compound_curve = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, compound_curve}
        end

        test "returns an empty compound curve from ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          compound_curve = unquote(module).new()

          assert Geometry.from_wkb(wkb) == {:ok, compound_curve}
        end

        test "returns compound curve from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), unquote(srid))

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, compound_curve}
        end

        test "returns compound curve from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), unquote(srid))

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.from_wkb(wkb) == {:ok, compound_curve}
        end

        test "returns an error tuple for invalid length" do
          wkb = Binary.take(unquote(code[:ndr]) <> unquote(data[:wkb_ndr]), 7)
          <<_::binary-size(5), expected_rest::binary>> = wkb

          assert Geometry.from_wkb(wkb) == {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: expected_rest,
                     offset: 5,
                     reason: :invalid_length
                   }
                 }
        end

        test "returns an error tuple for extra data" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>> <> <<7>>

          assert {
                   :error,
                   %DecodeError{
                     from: :wkb,
                     rest: <<7>>,
                     offset: 9,
                     reason: :eos
                   }
                 } = Geometry.from_wkb(wkb)
        end

        test "returns an error for an invalid coordinate" do
          wkb = Binary.drop(unquote(code[:ndr]) <> unquote(data[:wkb_ndr]), -7)

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_coordinate
        end
      end

      describe "[#{inspect(module)}] from_wkb!/1" do
        @describetag :wkb

        test "raises an error for invalid length" do
          wkb = Binary.take(unquote(code[:ndr]) <> unquote(data[:wkb_ndr]), 7)

          assert_fail :from_wkb!, wkb, ~r/invalid length at position .*, got: <<.*>>/
        end

        test "raises an error for extra data" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>> <> <<7>>

          assert_fail :from_wkb!, wkb, ~r/expected end of binary at position .*, got: <<0.*>>/
        end
      end

      describe "[#{inspect(module)}] from_ewkb/1" do
        @describetag :wkb

        test "returns compound curve from xdr binary" do
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.from_ewkb(wkb) == {:ok, compound_curve}
        end

        test "returns compound curve from ndr binary" do
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.from_ewkb(wkb) == {:ok, compound_curve}
        end

        test "returns compound curve from xdr binary with srid" do
          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), unquote(srid))

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, compound_curve}
        end

        test "returns compound curve from ndr binary with srid" do
          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), unquote(srid))

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.from_ewkb(wkb) == {:ok, compound_curve}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns a compound curve as xdr binary" do
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.to_wkb(compound_curve, :xdr) == wkb
        end

        test "returns compound curve as ndr binary" do
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.to_wkb(compound_curve) == wkb
          assert Geometry.to_wkb(compound_curve, :ndr) == wkb
        end

        test "returns an empty compound curve as xdr binary" do
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>
          compound_curve = unquote(module).new()

          assert Geometry.to_wkb(compound_curve, :xdr) == wkb
        end

        test "returns an empty compound curve as ndr binary" do
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>
          compound_curve = unquote(module).new()

          assert Geometry.to_wkb(compound_curve) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns compound curve as xdr binary with srid" do
          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), 0)

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.to_ewkb(compound_curve, :xdr) == wkb
        end

        test "returns compound curve as ndr binary with srid" do
          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), 0)

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.to_ewkb(compound_curve) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns curve" do
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:segments])), unquote(dim))
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.from_wkt(wkt) == {:ok, compound_curve}
        end

        test "returns curve with srid" do
          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:segments])),
              unquote(dim),
              unquote(srid)
            )

          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), unquote(srid))

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.from_wkt(wkt) == {:ok, compound_curve}
        end

        test "returns an empty curve" do
          wkt = wkt(unquote(text))
          compound_curve = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, compound_curve}
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns compound curve" do
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:segments])), unquote(dim))
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.from_ewkt(wkt) == {:ok, compound_curve}
        end

        test "returns an empty compound curve" do
          wkt = wkt(unquote(text))
          compound_curve = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, compound_curve}
        end

        test "returns compound curve from WKT with srid" do
          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:segments])),
              unquote(dim),
              unquote(srid)
            )

          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), unquote(srid))

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.from_ewkt(wkt) == {:ok, compound_curve}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:segments])), unquote(dim))
          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim))
          compound_curve = compound_curve(unquote(module), segments)

          assert Geometry.to_wkt(compound_curve) == wkt
        end

        test "returns wkt from an empty compound curve" do
          wkt = wkt(unquote(text))
          compound_curve = unquote(module).new()

          assert Geometry.to_wkt(compound_curve) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:segments])),
              unquote(dim),
              unquote(srid)
            )

          segments = segments(unquote(Macro.escape(data[:segments])), unquote(dim), 0)

          compound_curve =
            compound_curve(unquote(module), segments, unquote(srid))

          assert Geometry.to_ewkt(compound_curve) == wkt
        end

        test "returns ewkt from an empty compound curve" do
          wkt = wkt(unquote(text), [], unquote(dim), unquote(srid))
          compound_curve = unquote(module).new() |> Map.put(:srid, unquote(srid))

          assert Geometry.to_ewkt(compound_curve) == wkt
        end
      end
    end
  )

  defp wkt(name, segment_data \\ [], dim \\ :xy, srid \\ "")

  defp wkt(name, [], _dim, ""), do: "#{String.upcase(name)} EMPTY"

  defp wkt(name, [], _dim, srid), do: "SRID=#{srid};#{String.upcase(name)} EMPTY"

  defp wkt(name, segment_data, dim, srid) do
    segments =
      Enum.map_join(segment_data, ", ", fn {type, coordinates} ->
        segment_wkt(type, coordinates, dim)
      end)

    srid = if srid == "", do: "", else: "SRID=#{srid};"

    "#{srid}#{String.upcase(name)} (#{segments})"
  end

  defp segment_wkt(:line_string, coordinates, :xy) do
    coords = Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
    "LINESTRING (#{coords})"
  end

  defp segment_wkt(:line_string, coordinates, :xym) do
    coords = Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
    "LINESTRING M (#{coords})"
  end

  defp segment_wkt(:line_string, coordinates, :xyz) do
    coords = Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
    "LINESTRING Z (#{coords})"
  end

  defp segment_wkt(:line_string, coordinates, :xyzm) do
    coords = Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
    "LINESTRING ZM (#{coords})"
  end

  defp segment_wkt(:circular_string, coordinates, :xy) do
    coords = Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
    "CIRCULARSTRING (#{coords})"
  end

  defp segment_wkt(:circular_string, coordinates, :xym) do
    coords = Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
    "CIRCULARSTRING M (#{coords})"
  end

  defp segment_wkt(:circular_string, coordinates, :xyz) do
    coords = Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
    "CIRCULARSTRING Z (#{coords})"
  end

  defp segment_wkt(:circular_string, coordinates, :xyzm) do
    coords = Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
    "CIRCULARSTRING ZM (#{coords})"
  end

  defp compound_curve(module, segments, srid \\ 0) do
    module.new(segments, srid)
  end

  defp segments(segment_data, dim, srid \\ 0) do
    Enum.map(segment_data, fn {type, coordinates} ->
      create_segment(type, coordinates, dim, srid)
    end)
  end

  defp create_segment(:line_string, coordinates, dim, srid) do
    points = Enum.map(coordinates, fn coord -> create_point(coord, dim) end)

    case dim do
      :xy -> LineString.new(points, srid)
      :xym -> LineStringM.new(points, srid)
      :xyz -> LineStringZ.new(points, srid)
      :xyzm -> LineStringZM.new(points, srid)
    end
  end

  defp create_segment(:circular_string, coordinates, dim, srid) do
    points = Enum.map(coordinates, fn coord -> create_point(coord, dim) end)

    case dim do
      :xy -> CircularString.new(points, srid)
      :xym -> CircularStringM.new(points, srid)
      :xyz -> CircularStringZ.new(points, srid)
      :xyzm -> CircularStringZM.new(points, srid)
    end
  end

  defp create_point(coord, :xy), do: Point.new(coord)
  defp create_point(coord, :xym), do: PointM.new(coord)
  defp create_point(coord, :xyz), do: PointZ.new(coord)
  defp create_point(coord, :xyzm), do: PointZM.new(coord)
end
