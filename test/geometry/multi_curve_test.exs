defmodule Geometry.MultiCurveTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Geometry.CircularString
  alias Geometry.CircularStringM
  alias Geometry.CircularStringZ
  alias Geometry.CircularStringZM
  alias Geometry.CompoundCurve
  alias Geometry.CompoundCurveM
  alias Geometry.CompoundCurveZ
  alias Geometry.CompoundCurveZM
  alias Geometry.DecodeError
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.MultiCurve
  alias Geometry.MultiCurveM
  alias Geometry.MultiCurveZ
  alias Geometry.MultiCurveZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Geometry.MultiCurve, import: true
  doctest Geometry.MultiCurveM, import: true
  doctest Geometry.MultiCurveZ, import: true
  doctest Geometry.MultiCurveZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: MultiCurve,
        text: "MULTICURVE",
        dim: :xy,
        srid: 123,
        code: %{
          xdr: Base.decode16!("000000000B"),
          ndr: Base.decode16!("010B000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000B0000007B"),
          ndr: Base.decode16!("010B0000207B000000")
        },
        data: %{
          curves: [
            {:coords, [[0.0, 0.0], [5.0, 5.0]]},
            {:line_string, [[0.0, 1.0], [1.0, 1.0], [1.0, 0.0]]},
            {:circular_string, [[4.0, 0.0], [4.0, 4.0], [8.0, 4.0]]},
            {:compound_curve,
             [
               {:circular_string,
                [[0.0, 0.0], [2.0, 0.0], [2.0, 1.0], [2.0, 3.0], [4.0, 3.0]]},
               {:coords, [[4.0, 3.0], [4.0, 5.0], [1.0, 4.0], [0.0, 0.0]]}
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            0000000400000000020000000200000000000000000000000000000000401400\
            0000000000401400000000000000000000020000000300000000000000003FF0\
            0000000000003FF00000000000003FF00000000000003FF00000000000000000\
            0000000000000000000008000000034010000000000000000000000000000040\
            1000000000000040100000000000004020000000000000401000000000000000\
            0000000900000002000000000800000005000000000000000000000000000000\
            004000000000000000000000000000000040000000000000003FF00000000000\
            0040000000000000004008000000000000401000000000000040080000000000\
            0000000000020000000440100000000000004008000000000000401000000000\
            000040140000000000003FF00000000000004010000000000000000000000000\
            00000000000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0400000001020000000200000000000000000000000000000000000000000000\
            0000001440000000000000144001020000000300000000000000000000000000\
            00000000F03F000000000000F03F000000000000F03F000000000000F03F0000\
            0000000000000108000000030000000000000000001040000000000000000000\
            0000000000104000000000000010400000000000002040000000000000104001\
            0900000002000000010800000005000000000000000000000000000000000000\
            00000000000000004000000000000000000000000000000040000000000000F0\
            3F00000000000000400000000000000840000000000000104000000000000008\
            4001020000000400000000000000000010400000000000000840000000000000\
            10400000000000001440000000000000F03F0000000000001040000000000000\
            00000000000000000000\
            """),
          unexpected_curves: [{:point, [1.0, 1.0]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            000000000B0000000100000000013FF00000000000003FF0000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010B000000010000000101000000000000000000F03F000000000000F03F\
            """),
          invalid_line_string_wkb_ndr:
            Base.decode16!("010B00000001000000010200000002000000FF"),
          invalid_circular_string_wkb_ndr:
            Base.decode16!("010B00000001000000010800000003000000FF"),
          invalid_compound_curve_wkb_ndr: Base.decode16!("010B000000010000000109000000FF")
        }
      },
      %{
        module: MultiCurveM,
        text: "MULTICURVE M",
        dim: :xym,
        srid: 456,
        code: %{
          xdr: Base.decode16!("004000000B"),
          ndr: Base.decode16!("010B000040")
        },
        code_srid: %{
          xdr: Base.decode16!("006000000B000001C8"),
          ndr: Base.decode16!("010B000060C8010000")
        },
        data: %{
          curves: [
            {:coords, [[0.0, 0.0, 1.0], [5.0, 5.0, 2.0]]},
            {:line_string, [[0.0, 1.0, 3.0], [1.0, 1.0, 4.0], [0.0, 2.0, 5.0]]},
            {:circular_string, [[4.0, 0.0, 6.0], [4.0, 4.0, 7.0], [8.0, 4.0, 8.0]]},
            {:compound_curve,
             [
               {:circular_string,
                [
                  [0.0, 0.0, 9.0],
                  [2.0, 0.0, 0.0],
                  [2.0, 1.0, 1.0],
                  [2.0, 3.0, 2.0],
                  [4.0, 3.0, 3.0]
                ]},
               {:coords,
                [[4.0, 3.0, 6.0], [4.0, 5.0, 7.0], [1.0, 4.0, 8.0], [0.0, 0.0, 9.0]]}
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            00000004004000000200000002000000000000000000000000000000003FF000\
            0000000000401400000000000040140000000000004000000000000000004000\
            00020000000300000000000000003FF000000000000040080000000000003FF0\
            0000000000003FF0000000000000401000000000000000000000000000004000\
            0000000000004014000000000000004000000800000003401000000000000000\
            0000000000000040180000000000004010000000000000401000000000000040\
            1C00000000000040200000000000004010000000000000402000000000000000\
            4000000900000002004000000800000005000000000000000000000000000000\
            0040220000000000004000000000000000000000000000000000000000000000\
            0040000000000000003FF00000000000003FF000000000000040000000000000\
            0040080000000000004000000000000000401000000000000040080000000000\
            0040080000000000000040000002000000044010000000000000400800000000\
            0000401800000000000040100000000000004014000000000000401C00000000\
            00003FF000000000000040100000000000004020000000000000000000000000\
            000000000000000000004022000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0400000001020000400200000000000000000000000000000000000000000000\
            000000F03F000000000000144000000000000014400000000000000040010200\
            0040030000000000000000000000000000000000F03F00000000000008400000\
            00000000F03F000000000000F03F000000000000104000000000000000000000\
            0000000000400000000000001440010800004003000000000000000000104000\
            0000000000000000000000000018400000000000001040000000000000104000\
            00000000001C4000000000000020400000000000001040000000000000204001\
            0900004002000000010800004005000000000000000000000000000000000000\
            0000000000000022400000000000000040000000000000000000000000000000\
            000000000000000040000000000000F03F000000000000F03F00000000000000\
            4000000000000008400000000000000040000000000000104000000000000008\
            4000000000000008400102000040040000000000000000001040000000000000\
            0840000000000000184000000000000010400000000000001440000000000000\
            1C40000000000000F03F00000000000010400000000000002040000000000000\
            000000000000000000000000000000002240\
            """),
          unexpected_curves: [{:point, [1.0, 2.0, 3.0]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            004000000B0000000100400000013FF000000000000040000000000000004008000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010B000040010000000101000040000000000000F03F00000000000000400000000000000840\
            """),
          invalid_line_string_wkb_ndr:
            Base.decode16!("010B00004001000000010200004002000000FF"),
          invalid_circular_string_wkb_ndr:
            Base.decode16!("010B00004001000000010800004003000000FF"),
          invalid_compound_curve_wkb_ndr: Base.decode16!("010B000040010000000109000040FF")
        }
      },
      %{
        module: MultiCurveZ,
        text: "MULTICURVE Z",
        dim: :xyz,
        srid: 789,
        code: %{
          xdr: Base.decode16!("008000000B"),
          ndr: Base.decode16!("010B000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A000000B00000315"),
          ndr: Base.decode16!("010B0000A015030000")
        },
        data: %{
          curves: [
            {:coords, [[0.0, 0.0, 1.0], [5.0, 5.0, 2.0]]},
            {:line_string, [[0.0, 1.0, 3.0], [1.0, 1.0, 4.0], [0.0, 2.0, 5.0]]},
            {:circular_string, [[4.0, 0.0, 6.0], [4.0, 4.0, 7.0], [8.0, 4.0, 8.0]]},
            {:compound_curve,
             [
               {:circular_string,
                [
                  [0.0, 0.0, 9.0],
                  [2.0, 0.0, 0.0],
                  [2.0, 1.0, 1.0],
                  [2.0, 3.0, 2.0],
                  [4.0, 3.0, 3.0]
                ]},
               {:coords,
                [[4.0, 3.0, 6.0], [4.0, 5.0, 7.0], [1.0, 4.0, 8.0], [0.0, 0.0, 9.0]]}
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            00000004008000000200000002000000000000000000000000000000003FF000\
            0000000000401400000000000040140000000000004000000000000000008000\
            00020000000300000000000000003FF000000000000040080000000000003FF0\
            0000000000003FF0000000000000401000000000000000000000000000004000\
            0000000000004014000000000000008000000800000003401000000000000000\
            0000000000000040180000000000004010000000000000401000000000000040\
            1C00000000000040200000000000004010000000000000402000000000000000\
            8000000900000002008000000800000005000000000000000000000000000000\
            0040220000000000004000000000000000000000000000000000000000000000\
            0040000000000000003FF00000000000003FF000000000000040000000000000\
            0040080000000000004000000000000000401000000000000040080000000000\
            0040080000000000000080000002000000044010000000000000400800000000\
            0000401800000000000040100000000000004014000000000000401C00000000\
            00003FF000000000000040100000000000004020000000000000000000000000\
            000000000000000000004022000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0400000001020000800200000000000000000000000000000000000000000000\
            000000F03F000000000000144000000000000014400000000000000040010200\
            0080030000000000000000000000000000000000F03F00000000000008400000\
            00000000F03F000000000000F03F000000000000104000000000000000000000\
            0000000000400000000000001440010800008003000000000000000000104000\
            0000000000000000000000000018400000000000001040000000000000104000\
            00000000001C4000000000000020400000000000001040000000000000204001\
            0900008002000000010800008005000000000000000000000000000000000000\
            0000000000000022400000000000000040000000000000000000000000000000\
            000000000000000040000000000000F03F000000000000F03F00000000000000\
            4000000000000008400000000000000040000000000000104000000000000008\
            4000000000000008400102000080040000000000000000001040000000000000\
            0840000000000000184000000000000010400000000000001440000000000000\
            1C40000000000000F03F00000000000010400000000000002040000000000000\
            000000000000000000000000000000002240\
            """),
          unexpected_curves: [{:point, [1.0, 2.0, 3.0]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            008000000B0000000100800000013FF000000000000040000000000000004008000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010B000080010000000101000080000000000000F03F00000000000000400000000000000840\
            """),
          invalid_line_string_wkb_ndr:
            Base.decode16!("010B00008001000000010200008002000000FF"),
          invalid_circular_string_wkb_ndr:
            Base.decode16!("010B00008001000000010800008003000000FF"),
          invalid_compound_curve_wkb_ndr: Base.decode16!("010B000080010000000109000080FF")
        }
      },
      %{
        module: MultiCurveZM,
        text: "MULTICURVE ZM",
        dim: :xyzm,
        srid: 321,
        code: %{
          xdr: Base.decode16!("00C000000B"),
          ndr: Base.decode16!("010B0000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000B00000141"),
          ndr: Base.decode16!("010B0000E041010000")
        },
        data: %{
          curves: [
            {:coords, [[0.0, 0.0, 1.0, 5.0], [5.0, 5.0, 2.0, 5.0]]},
            {:line_string,
             [[0.0, 1.0, 3.0, 4.0], [1.0, 1.0, 4.0, 5.0], [0.0, 2.0, 5.0, 6.0]]},
            {:circular_string,
             [[4.0, 0.0, 6.0, 5.0], [4.0, 4.0, 7.0, 5.0], [8.0, 4.0, 8.0, 8.0]]},
            {:compound_curve,
             [
               {:circular_string,
                [
                  [0.0, 0.0, 9.0, 5.0],
                  [2.0, 0.0, 0.0, 3.0],
                  [2.0, 1.0, 1.0, 2.0],
                  [2.0, 3.0, 2.0, 1.0],
                  [4.0, 3.0, 3.0, 1.0]
                ]},
               {:coords,
                [
                  [4.0, 3.0, 6.0, 1.0],
                  [4.0, 5.0, 7.0, 1.0],
                  [1.0, 4.0, 8.0, 2.0],
                  [0.0, 0.0, 9.0, 5.0]
                ]}
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            0000000400C000000200000002000000000000000000000000000000003FF000\
            0000000000401400000000000040140000000000004014000000000000400000\
            0000000000401400000000000000C00000020000000300000000000000003FF0\
            000000000000400800000000000040100000000000003FF00000000000003FF0\
            0000000000004010000000000000401400000000000000000000000000004000\
            0000000000004014000000000000401800000000000000C00000080000000340\
            1000000000000000000000000000004018000000000000401400000000000040\
            100000000000004010000000000000401C000000000000401400000000000040\
            2000000000000040100000000000004020000000000000402000000000000000\
            C00000090000000200C000000800000005000000000000000000000000000000\
            0040220000000000004014000000000000400000000000000000000000000000\
            000000000000000000400800000000000040000000000000003FF00000000000\
            003FF00000000000004000000000000000400000000000000040080000000000\
            0040000000000000003FF0000000000000401000000000000040080000000000\
            0040080000000000003FF000000000000000C000000200000004401000000000\
            0000400800000000000040180000000000003FF0000000000000401000000000\
            00004014000000000000401C0000000000003FF00000000000003FF000000000\
            0000401000000000000040200000000000004000000000000000000000000000\
            0000000000000000000040220000000000004014000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0400000001020000C00200000000000000000000000000000000000000000000\
            000000F03F000000000000144000000000000014400000000000001440000000\
            0000000040000000000000144001020000C00300000000000000000000000000\
            00000000F03F00000000000008400000000000001040000000000000F03F0000\
            00000000F03F0000000000001040000000000000144000000000000000000000\
            0000000000400000000000001440000000000000184001080000C00300000000\
            0000000000104000000000000000000000000000001840000000000000144000\
            0000000000104000000000000010400000000000001C40000000000000144000\
            0000000000204000000000000010400000000000002040000000000000204001\
            090000C00200000001080000C005000000000000000000000000000000000000\
            0000000000000022400000000000001440000000000000004000000000000000\
            00000000000000000000000000000008400000000000000040000000000000F0\
            3F000000000000F03F0000000000000040000000000000004000000000000008\
            400000000000000040000000000000F03F000000000000104000000000000008\
            400000000000000840000000000000F03F01020000C004000000000000000000\
            104000000000000008400000000000001840000000000000F03F000000000000\
            104000000000000014400000000000001C40000000000000F03F000000000000\
            F03F000000000000104000000000000020400000000000000040000000000000\
            0000000000000000000000000000000022400000000000001440\
            """),
          unexpected_curves: [{:point, [1.0, 2.0, 3.0, 4.0]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            00C000000B0000000100C00000013FF000000000000040000000000000004008\
            0000000000004010000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010B0000C00100000001010000C0000000000000F03F00000000000000400000\
            0000000008400000000000001040\
            """),
          invalid_line_string_wkb_ndr:
            Base.decode16!("010B0000C00100000001020000C002000000FF"),
          invalid_circular_string_wkb_ndr:
            Base.decode16!("010B0000C00100000001080000C003000000FF"),
          invalid_compound_curve_wkb_ndr: Base.decode16!("010B0000C00100000001090000C0FF")
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
        test "returns an empty multi curve" do
          assert unquote(module).new() == %unquote(module){curves: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a multi curve" do
          curves = curves(unquote(Macro.escape(data[:curves])), unquote(dim))

          assert unquote(module).new(curves) == %unquote(module){
                   curves: curves
                 }
        end

        test "returns an empty multi curve" do
          assert unquote(module).new([]) == %unquote(module){curves: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if multi curve is empty" do
          multi_curve = unquote(module).new()

          assert Geometry.empty?(multi_curve) == true
        end

        test "returns false if multi curve is not empty" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))

          assert Geometry.empty?(multi_curve) == false
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        @describetag :geo_json

        test "raises a protocol error" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))

          message =
            ~r|protocol.Geometry.Encoder.GeoJson.not.implemented.for.*#{inspect(unquote(module))}|

          assert_raise Protocol.UndefinedError, message, fn ->
            Geometry.to_geo_json(multi_curve)
          end
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns multi curve from xdr binary" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_wkb(wkb) == {:ok, multi_curve}
        end

        test "returns multi curve from ndr binary" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_wkb(wkb) == {:ok, multi_curve}
        end

        test "returns an empty multi curve from xdr binary" do
          multi_curve = unquote(module).new()
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>

          assert Geometry.from_wkb(wkb) == {:ok, multi_curve}
        end

        test "returns an empty multi curve from ndr binary" do
          multi_curve = unquote(module).new()
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>

          assert Geometry.from_wkb(wkb) == {:ok, multi_curve}
        end

        test "returns multi curve from xdr binary with srid" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_wkb(wkb) == {:ok, multi_curve}
        end

        test "returns multi curve from ndr binary with srid" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_wkb(wkb) == {:ok, multi_curve}
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

        test "returns an error for an unexpected curve in xdr binary" do
          wkb = unquote(data[:unexpected_wkb_xdr])

          assert {:error, %Geometry.DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :expected_multi_curve_curve
        end

        test "returns an error for an unexpected curve in ndr binary" do
          wkb = unquote(data[:unexpected_wkb_ndr])

          assert {:error, %Geometry.DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :expected_multi_curve_curve
        end

        test "returns an error for an invalid coordinate in a line string curve" do
          wkb = unquote(data[:invalid_line_string_wkb_ndr])

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_coordinate
        end

        test "returns an error for an invalid coordinate in a circular string curve" do
          wkb = unquote(data[:invalid_circular_string_wkb_ndr])

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_coordinate
        end

        test "returns an error for an invalid length in a compound curve" do
          wkb = unquote(data[:invalid_compound_curve_wkb_ndr])

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_length
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

        test "returns multi curve from xdr binary" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_ewkb(wkb) == {:ok, multi_curve}
        end

        test "returns multi curve from ndr binary" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_ewkb(wkb) == {:ok, multi_curve}
        end

        test "returns multi curve from xdr binary with srid" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_ewkb(wkb) == {:ok, multi_curve}
        end

        test "returns multi curve from ndr binary with srid" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_ewkb(wkb) == {:ok, multi_curve}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns a multi curve as xdr binary" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.to_wkb(multi_curve, :xdr) == wkb
        end

        test "returns a multi curve as ndr binary" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.to_wkb(multi_curve) == wkb
          assert Geometry.to_wkb(multi_curve, :ndr) == wkb
        end

        test "returns an empty multi curve as xdr binary" do
          multi_curve = unquote(module).new()
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>

          assert Geometry.to_wkb(multi_curve, :xdr) == wkb
        end

        test "returns an empty multi curve as ndr binary" do
          multi_curve = unquote(module).new()
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>

          assert Geometry.to_wkb(multi_curve) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns multi curve as xdr binary with srid" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.to_ewkb(multi_curve, :xdr) == wkb
        end

        test "returns multi curve as ndr binary with srid" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.to_ewkb(multi_curve) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns multi curve" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:curves])), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, multi_curve}
        end

        test "returns multi curve with srid" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:curves])),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_wkt(wkt) == {:ok, multi_curve}
        end

        test "returns an empty multi curve" do
          wkt = wkt(unquote(text))
          multi_curve = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, multi_curve}
        end

        test "returns an error for an unexpected curve" do
          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:unexpected_curves])),
              unquote(dim)
            )

          assert {:error, %DecodeError{} = error} = Geometry.from_wkt(wkt)
          assert error.from == :wkt
          assert error.message == "unexpected curve in multi curve"
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns multi curve" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:curves])), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, multi_curve}
        end

        test "returns an empty multi curve" do
          wkt = wkt(unquote(text))
          multi_curve = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, multi_curve}
        end

        test "returns multi curve from WKT with srid" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:curves])),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_ewkt(wkt) == {:ok, multi_curve}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          multi_curve = multi_curve(unquote(module), unquote(Macro.escape(data[:curves])))
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:curves])), unquote(dim), "", true)

          assert Geometry.to_wkt(multi_curve) == wkt
        end

        test "returns wkt from an empty multi curve" do
          wkt = wkt(unquote(text))
          multi_curve = unquote(module).new()

          assert Geometry.to_wkt(multi_curve) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          multi_curve =
            multi_curve(unquote(module), unquote(Macro.escape(data[:curves])), unquote(srid))

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:curves])),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.to_ewkt(multi_curve) == wkt
        end

        test "returns ewkt from an empty multi curve" do
          multi_curve = multi_curve(unquote(module), [], unquote(srid))
          wkt = wkt(unquote(text), [], unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(multi_curve) == wkt
        end
      end
    end
  )

  defp wkt(name, curve_data \\ [], dim \\ :xy, srid \\ "", expand \\ false)

  defp wkt(name, [], _dim, "", _expand), do: "#{String.upcase(name)} EMPTY"

  defp wkt(name, [], _dim, srid, _expand), do: "SRID=#{srid};#{String.upcase(name)} EMPTY"

  defp wkt(name, curve_data, dim, srid, expand) do
    curves_wkt =
      Enum.map_join(curve_data, ", ", fn curve_desc ->
        curve_to_wkt(curve_desc, dim, expand)
      end)

    srid_prefix = if srid == "", do: "", else: "SRID=#{srid};"
    "#{srid_prefix}#{String.upcase(name)} (#{curves_wkt})"
  end

  defp curve_to_wkt({:point, coordinate}, dim, _expand) do
    "POINT#{wkt_dim(dim)}(#{wkt_coords([coordinate])})"
  end

  defp curve_to_wkt({:circular_string, coordinates}, dim, _expand) do
    "CIRCULARSTRING#{wkt_dim(dim)}(#{wkt_coords(coordinates)})"
  end

  defp curve_to_wkt({:line_string, coordinates}, dim, _expand) do
    "LINESTRING#{wkt_dim(dim)}(#{wkt_coords(coordinates)})"
  end

  defp curve_to_wkt({:coords, coordinates}, _dim, false) do
    "(#{wkt_coords(coordinates)})"
  end

  defp curve_to_wkt({:coords, coordinates}, dim, true) do
    "LINESTRING#{wkt_dim(dim)}(#{wkt_coords(coordinates)})"
  end

  defp curve_to_wkt({:compound_curve, segments_data}, dim, expand) do
    segments_wkt =
      Enum.map_join(segments_data, ", ", fn seg_desc ->
        curve_to_wkt(seg_desc, dim, expand)
      end)

    "COMPOUNDCURVE#{wkt_dim(dim)}(#{segments_wkt})"
  end

  defp wkt_dim(:xy), do: " "
  defp wkt_dim(:xyz), do: " Z "
  defp wkt_dim(:xym), do: " M "
  defp wkt_dim(:xyzm), do: " ZM "

  defp dim(MultiCurve), do: :xy
  defp dim(MultiCurveM), do: :xym
  defp dim(MultiCurveZ), do: :xyz
  defp dim(MultiCurveZM), do: :xyzm

  defp wkt_coords(coordinates) do
    Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
  end

  defp multi_curve(module, curve_data, srid \\ 0) do
    curve_data
    |> curves(dim(module), srid)
    |> module.new(srid)
  end

  defp curves(curve_data, dim, srid \\ 0) do
    Enum.map(curve_data, fn curve_desc -> create_curve(curve_desc, dim, srid) end)
  end

  defp create_curve({:circular_string, coordinates}, dim, srid) do
    points = Enum.map(coordinates, &create_point(&1, dim))

    case dim do
      :xy -> CircularString.new(points, srid)
      :xym -> CircularStringM.new(points, srid)
      :xyz -> CircularStringZ.new(points, srid)
      :xyzm -> CircularStringZM.new(points, srid)
    end
  end

  defp create_curve({type, coordinates}, dim, srid) when type in [:line_string, :coords] do
    points = Enum.map(coordinates, &create_point(&1, dim))

    case dim do
      :xy -> LineString.new(points, srid)
      :xym -> LineStringM.new(points, srid)
      :xyz -> LineStringZ.new(points, srid)
      :xyzm -> LineStringZM.new(points, srid)
    end
  end

  defp create_curve({:compound_curve, segments_data}, dim, srid) do
    segments = Enum.map(segments_data, &create_curve(&1, dim, srid))

    case dim do
      :xy -> CompoundCurve.new(segments, srid)
      :xym -> CompoundCurveM.new(segments, srid)
      :xyz -> CompoundCurveZ.new(segments, srid)
      :xyzm -> CompoundCurveZM.new(segments, srid)
    end
  end

  defp create_curve({:point, _coordinates}, _dim, _srid) do
    # Points are not valid in MultiCurve — used for error tests only
    %Geometry.Point{coordinates: [], srid: 0}
  end

  defp create_point(coord, :xy), do: Point.new(coord)
  defp create_point(coord, :xym), do: PointM.new(coord)
  defp create_point(coord, :xyz), do: PointZ.new(coord)
  defp create_point(coord, :xyzm), do: PointZM.new(coord)
end
