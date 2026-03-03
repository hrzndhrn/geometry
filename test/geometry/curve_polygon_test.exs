defmodule Geometry.CurvePolygonTest do
  use ExUnit.Case, async: true

  import Assertions
  import GeometryHelpers, except: [wkt: 1, wkt: 2, wkt: 3]

  alias Geometry.CurvePolygon
  alias Geometry.CurvePolygonM
  alias Geometry.CurvePolygonZ
  alias Geometry.CurvePolygonZM
  alias Geometry.DecodeError

  doctest Geometry.CurvePolygon, import: true
  doctest Geometry.CurvePolygonM, import: true
  doctest Geometry.CurvePolygonZ, import: true
  doctest Geometry.CurvePolygonZM, import: true

  Enum.each(
    [
      %{
        module: CurvePolygon,
        text: "CURVEPOLYGON",
        dim: :xy,
        srid: 123,
        code: %{
          xdr: Base.decode16!("000000000A"),
          ndr: Base.decode16!("010A000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000A0000007B"),
          ndr: Base.decode16!("010A0000207B000000")
        },
        data: %{
          rings: [
            {:circular_string, [[0.0, 0.0], [40.0, 0.0], [40.0, 40.0], [0.0, 40.0], [0.0, 0.0]]},
            {:coords, [[1.0, 1.0], [3.0, 3.0], [3.0, 1.0], [1.0, 1.0]]},
            {:line_string, [[11.0, 11.0], [13.0, 13.0], [13.0, 11.0], [11.0, 11.0]]},
            {:compound_curve,
             [
               {:circular_string, [[20.0, 20.0], [21.0, 21.0], [21.0, 20.0]]},
               {:line_string, [[21.0, 20.0], [20.0, 20.0]]}
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            0000000400000000080000000500000000000000000000000000000000404400\
            0000000000000000000000000040440000000000004044000000000000000000\
            0000000000404400000000000000000000000000000000000000000000000000\
            0002000000043FF00000000000003FF000000000000040080000000000004008\
            00000000000040080000000000003FF00000000000003FF00000000000003FF0\
            0000000000000000000002000000044026000000000000402600000000000040\
            2A000000000000402A000000000000402A000000000000402600000000000040\
            2600000000000040260000000000000000000009000000020000000008000000\
            0340340000000000004034000000000000403500000000000040350000000000\
            0040350000000000004034000000000000000000000200000002403500000000\
            0000403400000000000040340000000000004034000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0400000001080000000500000000000000000000000000000000000000000000\
            0000004440000000000000000000000000000044400000000000004440000000\
            0000000000000000000000444000000000000000000000000000000000010200\
            000004000000000000000000F03F000000000000F03F00000000000008400000\
            0000000008400000000000000840000000000000F03F000000000000F03F0000\
            00000000F03F0102000000040000000000000000002640000000000000264000\
            00000000002A400000000000002A400000000000002A40000000000000264000\
            0000000000264000000000000026400109000000020000000108000000030000\
            0000000000000034400000000000003440000000000000354000000000000035\
            4000000000000035400000000000003440010200000002000000000000000000\
            3540000000000000344000000000000034400000000000003440\
            """),
          unexpected_rings: [{:point, [1.0, 1.0]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            000000000A0000000100000000013FF00000000000003FF0000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010A000000010000000101000000000000000000F03F000000000000F03F\
            """),
          invalid_line_string_ring_wkb_ndr:
            Base.decode16!("010A00000001000000010200000002000000FF"),
          invalid_circular_string_ring_wkb_ndr:
            Base.decode16!("010A00000001000000010800000003000000FF"),
          invalid_compound_curve_ring_wkb_ndr: Base.decode16!("010A000000010000000109000000FF"),
          geometry_collection_code: %{
            # A prefix for a geometry collection with one element.
            xdr: Base.decode16!("000000000700000001"),
            ndr: Base.decode16!("010700000001000000")
          }
        }
      },
      %{
        module: CurvePolygonM,
        text: "CURVEPOLYGON M",
        dim: :xym,
        srid: 456,
        code: %{
          xdr: Base.decode16!("004000000A"),
          ndr: Base.decode16!("010A000040")
        },
        code_srid: %{
          xdr: Base.decode16!("006000000A000001C8"),
          ndr: Base.decode16!("010A000060C8010000")
        },
        data: %{
          rings: [
            {:circular_string,
             [
               [0.0, 0.0, 0.0],
               [40.0, 0.0, 1.0],
               [40.0, 40.0, 2.0],
               [0.0, 40.0, 3.0],
               [0.0, 0.0, 4.0]
             ]},
            {:coords, [[1.0, 1.0, 4.0], [3.0, 3.0, 3.0], [3.0, 1.0, 2.0], [1.0, 1.0, 4.0]]},
            {:line_string,
             [
               [11.0, 11.0, 22.0],
               [13.0, 13.0, 33.0],
               [13.0, 11.0, 44.0],
               [11.0, 11.0, 33.0]
             ]},
            {:compound_curve,
             [
               {:circular_string, [[20.0, 20.0, 55.0], [21.0, 21.0, 33.0], [21.0, 20.0, 11.0]]},
               {:line_string, [[21.0, 20.0, 11.0], [20.0, 20.0, 66.0]]}
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            0000000400400000080000000500000000000000000000000000000000000000\
            0000000000404400000000000000000000000000003FF0000000000000404400\
            0000000000404400000000000040000000000000000000000000000000404400\
            0000000000400800000000000000000000000000000000000000000000401000\
            00000000000040000002000000043FF00000000000003FF00000000000004010\
            0000000000004008000000000000400800000000000040080000000000004008\
            0000000000003FF000000000000040000000000000003FF00000000000003FF0\
            0000000000004010000000000000004000000200000004402600000000000040\
            260000000000004036000000000000402A000000000000402A00000000000040\
            40800000000000402A0000000000004026000000000000404600000000000040\
            2600000000000040260000000000004040800000000000004000000900000002\
            00400000080000000340340000000000004034000000000000404B8000000000\
            0040350000000000004035000000000000404080000000000040350000000000\
            0040340000000000004026000000000000004000000200000002403500000000\
            0000403400000000000040260000000000004034000000000000403400000000\
            00004050800000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0400000001080000400500000000000000000000000000000000000000000000\
            000000000000000000000044400000000000000000000000000000F03F000000\
            0000004440000000000000444000000000000000400000000000000000000000\
            0000004440000000000000084000000000000000000000000000000000000000\
            0000001040010200004004000000000000000000F03F000000000000F03F0000\
            0000000010400000000000000840000000000000084000000000000008400000\
            000000000840000000000000F03F0000000000000040000000000000F03F0000\
            00000000F03F0000000000001040010200004004000000000000000000264000\
            0000000000264000000000000036400000000000002A400000000000002A4000\
            000000008040400000000000002A400000000000002640000000000000464000\
            0000000000264000000000000026400000000000804040010900004002000000\
            010800004003000000000000000000344000000000000034400000000000804B\
            4000000000000035400000000000003540000000000080404000000000000035\
            4000000000000034400000000000002640010200004002000000000000000000\
            3540000000000000344000000000000026400000000000003440000000000000\
            34400000000000805040\
            """),
          unexpected_rings: [{:point, [1.0, 2.0, 3.0]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            004000000A0000000100400000013FF000000000000040000000000000004008000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010A000040010000000101000040000000000000F03F00000000000000400000000000000840\
            """),
          invalid_line_string_ring_wkb_ndr:
            Base.decode16!("010A00004001000000010200004002000000FF"),
          invalid_circular_string_ring_wkb_ndr:
            Base.decode16!("010A00004001000000010800004003000000FF"),
          invalid_compound_curve_ring_wkb_ndr: Base.decode16!("010A000040010000000109000040FF"),
          geometry_collection_code: %{
            # A prefix for a geometry collection with one element.
            xdr: Base.decode16!("004000000700000001"),
            ndr: Base.decode16!("010700004001000000")
          }
        }
      },
      %{
        module: CurvePolygonZ,
        text: "CURVEPOLYGON Z",
        dim: :xyz,
        srid: 789,
        code: %{
          xdr: Base.decode16!("008000000A"),
          ndr: Base.decode16!("010A000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A000000A00000315"),
          ndr: Base.decode16!("010A0000A015030000")
        },
        data: %{
          rings: [
            {:circular_string,
             [
               [0.0, 0.0, 0.0],
               [40.0, 0.0, 1.0],
               [40.0, 40.0, 2.0],
               [0.0, 40.0, 3.0],
               [0.0, 0.0, 0.0]
             ]},
            {:coords, [[1.0, 1.0, 4.0], [3.0, 3.0, 3.0], [3.0, 1.0, 2.0], [1.0, 1.0, 4.0]]},
            {:line_string,
             [
               [11.0, 11.0, 11.0],
               [13.0, 13.0, 33.0],
               [13.0, 11.0, 44.0],
               [11.0, 11.0, 11.0]
             ]},
            {:compound_curve,
             [
               {:circular_string, [[20.0, 20.0, 22.0], [21.0, 21.0, 33.0], [21.0, 20.0, 11.0]]},
               {:line_string, [[21.0, 20.0, 11.0], [20.0, 20.0, 22.0]]}
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            0000000400800000080000000500000000000000000000000000000000000000\
            0000000000404400000000000000000000000000003FF0000000000000404400\
            0000000000404400000000000040000000000000000000000000000000404400\
            0000000000400800000000000000000000000000000000000000000000000000\
            00000000000080000002000000043FF00000000000003FF00000000000004010\
            0000000000004008000000000000400800000000000040080000000000004008\
            0000000000003FF000000000000040000000000000003FF00000000000003FF0\
            0000000000004010000000000000008000000200000004402600000000000040\
            260000000000004026000000000000402A000000000000402A00000000000040\
            40800000000000402A0000000000004026000000000000404600000000000040\
            2600000000000040260000000000004026000000000000008000000900000002\
            0080000008000000034034000000000000403400000000000040360000000000\
            0040350000000000004035000000000000404080000000000040350000000000\
            0040340000000000004026000000000000008000000200000002403500000000\
            0000403400000000000040260000000000004034000000000000403400000000\
            00004036000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0400000001080000800500000000000000000000000000000000000000000000\
            000000000000000000000044400000000000000000000000000000F03F000000\
            0000004440000000000000444000000000000000400000000000000000000000\
            0000004440000000000000084000000000000000000000000000000000000000\
            0000000000010200008004000000000000000000F03F000000000000F03F0000\
            0000000010400000000000000840000000000000084000000000000008400000\
            000000000840000000000000F03F0000000000000040000000000000F03F0000\
            00000000F03F0000000000001040010200008004000000000000000000264000\
            0000000000264000000000000026400000000000002A400000000000002A4000\
            000000008040400000000000002A400000000000002640000000000000464000\
            0000000000264000000000000026400000000000002640010900008002000000\
            0108000080030000000000000000003440000000000000344000000000000036\
            4000000000000035400000000000003540000000000080404000000000000035\
            4000000000000034400000000000002640010200008002000000000000000000\
            3540000000000000344000000000000026400000000000003440000000000000\
            34400000000000003640\
            """),
          unexpected_rings: [{:point, [1.0, 2.0, 3.0]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            008000000A0000000100800000013FF000000000000040000000000000004008000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010A000080010000000101000080000000000000F03F00000000000000400000000000000840\
            """),
          invalid_line_string_ring_wkb_ndr:
            Base.decode16!("010A00008001000000010200008002000000FF"),
          invalid_circular_string_ring_wkb_ndr:
            Base.decode16!("010A00008001000000010800008003000000FF"),
          invalid_compound_curve_ring_wkb_ndr: Base.decode16!("010A000080010000000109000080FF"),
          geometry_collection_code: %{
            # A prefix for a geometry collection with one element.
            xdr: Base.decode16!("008000000700000001"),
            ndr: Base.decode16!("010700008001000000")
          }
        }
      },
      %{
        module: CurvePolygonZM,
        text: "CURVEPOLYGON ZM",
        dim: :xyzm,
        srid: 321,
        code: %{
          xdr: Base.decode16!("00C000000A"),
          ndr: Base.decode16!("010A0000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000A00000141"),
          ndr: Base.decode16!("010A0000E041010000")
        },
        data: %{
          rings: [
            {:circular_string,
             [
               [0.0, 0.0, 0.0, 1.0],
               [40.0, 0.0, 1.0, 2.0],
               [40.0, 40.0, 2.0, 3.0],
               [0.0, 40.0, 3.0, 4.0],
               [0.0, 0.0, 0.0, 5.0]
             ]},
            {:coords,
             [
               [1.0, 1.0, 4.0, 1.0],
               [3.0, 3.0, 3.0, 3.0],
               [3.0, 1.0, 2.0, 2.0],
               [1.0, 1.0, 4.0, 1.0]
             ]},
            {:line_string,
             [
               [11.0, 11.0, 11.0, 11.0],
               [13.0, 13.0, 33.0, 44.0],
               [13.0, 11.0, 44.0, 55.0],
               [11.0, 11.0, 11.0, 55.0]
             ]},
            {:compound_curve,
             [
               {:circular_string,
                [
                  [20.0, 20.0, 22.0, 12.0],
                  [21.0, 21.0, 33.0, 23.0],
                  [21.0, 20.0, 11.0, 66.0]
                ]},
               {:line_string, [[21.0, 20.0, 11.0, 69.0], [20.0, 20.0, 22.0, 84.0]]}
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            0000000400C00000080000000500000000000000000000000000000000000000\
            00000000003FF0000000000000404400000000000000000000000000003FF000\
            0000000000400000000000000040440000000000004044000000000000400000\
            0000000000400800000000000000000000000000004044000000000000400800\
            0000000000401000000000000000000000000000000000000000000000000000\
            0000000000401400000000000000C0000002000000043FF00000000000003FF0\
            00000000000040100000000000003FF000000000000040080000000000004008\
            0000000000004008000000000000400800000000000040080000000000003FF0\
            000000000000400000000000000040000000000000003FF00000000000003FF0\
            00000000000040100000000000003FF000000000000000C00000020000000440\
            2600000000000040260000000000004026000000000000402600000000000040\
            2A000000000000402A0000000000004040800000000000404600000000000040\
            2A00000000000040260000000000004046000000000000404B80000000000040\
            2600000000000040260000000000004026000000000000404B80000000000000\
            C00000090000000200C000000800000003403400000000000040340000000000\
            0040360000000000004028000000000000403500000000000040350000000000\
            0040408000000000004037000000000000403500000000000040340000000000\
            004026000000000000405080000000000000C000000200000002403500000000\
            0000403400000000000040260000000000004051400000000000403400000000\
            0000403400000000000040360000000000004055000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            0400000001080000C00500000000000000000000000000000000000000000000\
            0000000000000000000000F03F00000000000044400000000000000000000000\
            000000F03F000000000000004000000000000044400000000000004440000000\
            0000000040000000000000084000000000000000000000000000004440000000\
            0000000840000000000000104000000000000000000000000000000000000000\
            0000000000000000000000144001020000C004000000000000000000F03F0000\
            00000000F03F0000000000001040000000000000F03F00000000000008400000\
            0000000008400000000000000840000000000000084000000000000008400000\
            00000000F03F00000000000000400000000000000040000000000000F03F0000\
            00000000F03F0000000000001040000000000000F03F01020000C00400000000\
            0000000000264000000000000026400000000000002640000000000000264000\
            00000000002A400000000000002A400000000000804040000000000000464000\
            00000000002A40000000000000264000000000000046400000000000804B4000\
            00000000002640000000000000264000000000000026400000000000804B4001\
            090000C00200000001080000C003000000000000000000344000000000000034\
            4000000000000036400000000000002840000000000000354000000000000035\
            4000000000008040400000000000003740000000000000354000000000000034\
            400000000000002640000000000080504001020000C002000000000000000000\
            3540000000000000344000000000000026400000000000405140000000000000\
            3440000000000000344000000000000036400000000000005540\
            """),
          unexpected_rings: [{:point, [1.0, 2.0, 3.0, 4.0]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            00C000000A0000000100C00000013FF000000000000040000000000000004008\
            0000000000004010000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010A0000C00100000001010000C0000000000000F03F00000000000000400000\
            0000000008400000000000001040\
            """),
          invalid_line_string_ring_wkb_ndr:
            Base.decode16!("010A0000C00100000001020000C002000000FF"),
          invalid_circular_string_ring_wkb_ndr:
            Base.decode16!("010A0000C00100000001080000C003000000FF"),
          invalid_compound_curve_ring_wkb_ndr: Base.decode16!("010A0000C00100000001090000C0FF"),
          geometry_collection_code: %{
            # A prefix for a geometry collection with one element.
            xdr: Base.decode16!("00C000000700000001"),
            ndr: Base.decode16!("01070000C001000000")
          }
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
        test "returns an empty curve polygon" do
          assert unquote(module).new() == %unquote(module){rings: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a curve polygon" do
          rings = rings(unquote(Macro.escape(data[:rings])), unquote(dim))

          assert unquote(module).new(rings) == %unquote(module){
                   rings: rings
                 }
        end

        test "returns an empty curve polygon" do
          assert unquote(module).new([]) == %unquote(module){rings: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if curve polygon is empty" do
          curve_polygon = unquote(module).new

          assert Geometry.empty?(curve_polygon) == true
        end

        test "returns false if curve polygon is not empty" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))

          assert Geometry.empty?(curve_polygon) == false
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        @describetag :geo_json

        test "raises a protocol error" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))

          message =
            ~r|protocol.Geometry.Encoder.GeoJson.not.implemented.for.*#{inspect(unquote(module))}|

          assert_raise Protocol.UndefinedError, message, fn ->
            Geometry.to_geo_json(curve_polygon)
          end
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns curve polygon from xdr binary" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_wkb(wkb) == {:ok, curve_polygon}
        end

        test "returns curve polygon from ndr binary" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_wkb(wkb) == {:ok, curve_polygon}
        end

        test "returns an empty curve polygon from xdr binary" do
          curve_polygon = unquote(module).new
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>

          assert Geometry.from_wkb(wkb) == {:ok, curve_polygon}
        end

        test "returns an empty curve polygon from ndr binary" do
          curve_polygon = unquote(module).new
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>

          assert Geometry.from_wkb(wkb) == {:ok, curve_polygon}
        end

        test "returns curve polygon from xdr binary with srid" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_wkb(wkb) == {:ok, curve_polygon}
        end

        test "returns curve polygon from ndr binary with srid" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_wkb(wkb) == {:ok, curve_polygon}
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

        test "returns an error for an unexpected ring in xdr binary" do
          wkb = unquote(data[:unexpected_wkb_xdr])

          assert {:error, %Geometry.DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :expected_curve_polygon_ring
        end

        test "returns an error for an unexpected ring in ndr binary" do
          wkb = unquote(data[:unexpected_wkb_ndr])

          assert {:error, %Geometry.DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :expected_curve_polygon_ring
        end

        test "returns an error for an invalid coordinate in a line string ring" do
          wkb = unquote(data[:invalid_line_string_ring_wkb_ndr])

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_coordinate
        end

        test "returns an error for an invalid coordinate in a circular string ring" do
          wkb = unquote(data[:invalid_circular_string_ring_wkb_ndr])

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_coordinate
        end

        test "returns an error for an invalid length in a compound curve ring" do
          wkb = unquote(data[:invalid_compound_curve_ring_wkb_ndr])

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_length
        end

        test "returns a geometry for a curve polygon inside a geometry collection (xdr)" do
          wkb =
            unquote(data[:geometry_collection_code][:xdr]) <>
              unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert {:ok, _geometry} = Geometry.from_wkb(wkb)
        end

        test "returns a geometry for a curve polygon inside a geometry collection (ndr)" do
          wkb =
            unquote(data[:geometry_collection_code][:ndr]) <>
              unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert {:ok, _geometry} = Geometry.from_wkb(wkb)
        end

        test "returns an error for an invalid curve polygon in a geometry collection (xdr)" do
          wkb =
            unquote(data[:geometry_collection_code][:xdr]) <>
              unquote(data[:unexpected_wkb_xdr])

          assert {:error, _reason} = Geometry.from_wkb(wkb)
        end

        test "returns an error for an invalid curve polygon in a geometry collection (ndr)" do
          wkb =
            unquote(data[:geometry_collection_code][:ndr]) <>
              unquote(data[:unexpected_wkb_ndr])

          assert {:error, _reason} = Geometry.from_wkb(wkb)
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

        test "returns curve polygon from xdr binary" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_ewkb(wkb) == {:ok, curve_polygon}
        end

        test "returns curve polygon from ndr binary" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_ewkb(wkb) == {:ok, curve_polygon}
        end

        test "returns curve polygon from xdr binary with srid" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_ewkb(wkb) == {:ok, curve_polygon}
        end

        test "returns curve polygon from ndr binary with srid" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_ewkb(wkb) == {:ok, curve_polygon}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns a curve polygon as xdr binary" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.to_wkb(curve_polygon, :xdr) == wkb
        end

        test "returns a curve polygon as ndr binary" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.to_wkb(curve_polygon) == wkb
          assert Geometry.to_wkb(curve_polygon, :ndr) == wkb
        end

        test "returns an empty curve polygon as xdr binary" do
          curve_polygon = unquote(module).new
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>

          assert Geometry.to_wkb(curve_polygon, :xdr) == wkb
        end

        test "returns an empty curve polygon as ndr binary" do
          curve_polygon = unquote(module).new
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>

          assert Geometry.to_wkb(curve_polygon) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns curve polygon as xdr binary with srid" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.to_ewkb(curve_polygon, :xdr) == wkb
        end

        test "returns curve polygon as ndr binary with srid" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.to_ewkb(curve_polygon) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns curve polygon" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:rings])), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, curve_polygon}
        end

        test "returns curve polygon with srid" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:rings])),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_wkt(wkt) == {:ok, curve_polygon}
        end

        test "returns an empty curve polygon" do
          wkt = wkt(unquote(text))
          curve_polygon = unquote(module).new

          assert Geometry.from_wkt(wkt) == {:ok, curve_polygon}
        end

        test "returns an error for an unexpected ring" do
          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:unexpected_rings])),
              unquote(dim)
            )

          assert {:error, %DecodeError{} = error} = Geometry.from_wkt(wkt)
          assert error.from == :wkt
          assert error.message == "unexpected ring in curve polygon"
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns curve polygon" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:rings])), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, curve_polygon}
        end

        test "returns an empty curve polygon" do
          wkt = wkt(unquote(text))
          curve_polygon = unquote(module).new

          assert Geometry.from_ewkt(wkt) == {:ok, curve_polygon}
        end

        test "returns curve polygon from WKT with srid" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:rings])),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_ewkt(wkt) == {:ok, curve_polygon}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          curve_polygon = curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])))
          wkt = wkt(unquote(text), unquote(Macro.escape(data[:rings])), unquote(dim), "", true)

          assert Geometry.to_wkt(curve_polygon) == wkt
        end

        test "returns wkt from an empty curve polygon" do
          wkt = wkt(unquote(text))
          curve_polygon = unquote(module).new

          assert Geometry.to_wkt(curve_polygon) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          curve_polygon =
            curve_polygon(unquote(module), unquote(Macro.escape(data[:rings])), unquote(srid))

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:rings])),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.to_ewkt(curve_polygon) == wkt
        end

        test "returns ewkt from an empty curve polygon" do
          curve_polygon = curve_polygon(unquote(module), [], unquote(srid))
          wkt = wkt(unquote(text), [], unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(curve_polygon) == wkt
        end
      end
    end
  )

  defp wkt(name, ring_data \\ [], dim \\ :xy, srid \\ "", expand \\ false)

  defp wkt(name, [], _dim, "", _expand), do: "#{String.upcase(name)} EMPTY"

  defp wkt(name, [], _dim, srid, _expand), do: "SRID=#{srid};#{String.upcase(name)} EMPTY"

  defp wkt(name, ring_data, dim, srid, expand) do
    rings_wkt =
      Enum.map_join(ring_data, ", ", fn ring_desc ->
        ring_to_wkt(ring_desc, dim, expand)
      end)

    srid_prefix = if srid == "", do: "", else: "SRID=#{srid};"
    "#{srid_prefix}#{String.upcase(name)} (#{rings_wkt})"
  end

  defp ring_to_wkt({:point, coordinate}, dim, _expand) do
    "POINT#{wkt_dim(dim)}(#{wkt_coords([coordinate])})"
  end

  defp ring_to_wkt({:circular_string, coordinates}, dim, _expand) do
    "CIRCULARSTRING#{wkt_dim(dim)}(#{wkt_coords(coordinates)})"
  end

  defp ring_to_wkt({:line_string, coordinates}, dim, _expand) do
    "LINESTRING#{wkt_dim(dim)}(#{wkt_coords(coordinates)})"
  end

  defp ring_to_wkt({:coords, coordinates}, _dim, false) do
    "(#{wkt_coords(coordinates)})"
  end

  defp ring_to_wkt({:coords, coordinates}, dim, true) do
    "LINESTRING#{wkt_dim(dim)}(#{wkt_coords(coordinates)})"
  end

  defp ring_to_wkt({:compound_curve, segments_data}, dim, expand) do
    segments_wkt =
      Enum.map_join(segments_data, ", ", fn seg_desc ->
        ring_to_wkt(seg_desc, dim, expand)
      end)

    "COMPOUNDCURVE#{wkt_dim(dim)}(#{segments_wkt})"
  end

  defp curve_polygon(module, ring_data, srid \\ 0) do
    ring_data
    |> rings(dim(module), srid)
    |> module.new(srid)
  end

  defp rings(ring_data, dim, srid \\ 0) do
    Enum.map(ring_data, fn ring_desc -> create_ring(ring_desc, dim, srid) end)
  end

  defp create_ring({:circular_string, coordinates}, dim, srid),
    do: create_circular_string(coordinates, dim, srid)

  defp create_ring({type, coordinates}, dim, srid) when type in [:line_string, :coords],
    do: create_line_string(coordinates, dim, srid)

  defp create_ring({:compound_curve, segments_data}, dim, srid),
    do: create_compound_curve(segments_data, dim, srid)

  defp create_ring({:polygon, _coordinates}, _dim, _srid) do
    # Polygon rings are not valid in CurvePolygon — used for error tests only
    %Geometry.Polygon{rings: [], srid: 0}
  end
end
