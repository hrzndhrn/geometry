defmodule Geometry.MultiSurfaceTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Geometry.CircularString
  alias Geometry.CircularStringM
  alias Geometry.CircularStringZ
  alias Geometry.CircularStringZM
  alias Geometry.CurvePolygon
  alias Geometry.CurvePolygonM
  alias Geometry.CurvePolygonZ
  alias Geometry.CurvePolygonZM
  alias Geometry.DecodeError
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.MultiSurface
  alias Geometry.MultiSurfaceM
  alias Geometry.MultiSurfaceZ
  alias Geometry.MultiSurfaceZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM
  alias Geometry.Polygon
  alias Geometry.PolygonM
  alias Geometry.PolygonZ
  alias Geometry.PolygonZM

  doctest Geometry.MultiSurface, import: true
  doctest Geometry.MultiSurfaceM, import: true
  doctest Geometry.MultiSurfaceZ, import: true
  doctest Geometry.MultiSurfaceZM, import: true

  @blank "\s"

  Enum.each(
    [
      %{
        module: MultiSurface,
        text: "MULTISURFACE",
        dim: :xy,
        srid: 123,
        code: %{
          xdr: Base.decode16!("000000000C"),
          ndr: Base.decode16!("010C000000")
        },
        code_srid: %{
          xdr: Base.decode16!("002000000C0000007B"),
          ndr: Base.decode16!("010C0000207B000000")
        },
        data: %{
          surfaces: [
            {:curve_polygon,
             [
               {:circular_string, [[0.0, 0.0], [4.0, 0.0], [4.0, 4.0], [0.0, 4.0], [0.0, 0.0]]},
               {:coords, [[1.0, 1.0], [3.0, 3.0], [3.0, 1.0], [1.0, 1.0]]}
             ]},
            {:rings,
             [
               [[10.0, 10.0], [14.0, 12.0], [11.0, 10.0], [10.0, 10.0]],
               [[11.0, 11.0], [11.5, 11.0], [11.0, 11.5], [11.0, 11.0]]
             ]},
            {:polygon,
             [
               [[0.0, 0.0], [4.0, 0.0], [4.0, 4.0], [0.0, 4.0], [0.0, 0.0]],
               [[1.0, 1.0], [2.0, 1.0], [2.0, 2.0], [1.0, 2.0], [1.0, 1.0]]
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            00000003000000000A0000000200000000080000000500000000000000000000\
            0000000000004010000000000000000000000000000040100000000000004010\
            0000000000000000000000000000401000000000000000000000000000000000\
            0000000000000000000002000000043FF00000000000003FF000000000000040\
            08000000000000400800000000000040080000000000003FF00000000000003F\
            F00000000000003FF00000000000000000000003000000020000000440240000\
            000000004024000000000000402C000000000000402800000000000040260000\
            0000000040240000000000004024000000000000402400000000000000000004\
            4026000000000000402600000000000040270000000000004026000000000000\
            4026000000000000402700000000000040260000000000004026000000000000\
            0000000003000000020000000500000000000000000000000000000000401000\
            0000000000000000000000000040100000000000004010000000000000000000\
            0000000000401000000000000000000000000000000000000000000000000000\
            053FF00000000000003FF000000000000040000000000000003FF00000000000\
            00400000000000000040000000000000003FF000000000000040000000000000\
            003FF00000000000003FF0000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            03000000010A0000000200000001080000000500000000000000000000000000\
            0000000000000000000000001040000000000000000000000000000010400000\
            0000000010400000000000000000000000000000104000000000000000000000\
            000000000000010200000004000000000000000000F03F000000000000F03F00\
            0000000000084000000000000008400000000000000840000000000000F03F00\
            0000000000F03F000000000000F03F0103000000020000000400000000000000\
            0000244000000000000024400000000000002C40000000000000284000000000\
            0000264000000000000024400000000000002440000000000000244004000000\
            0000000000002640000000000000264000000000000027400000000000002640\
            0000000000002640000000000000274000000000000026400000000000002640\
            0103000000020000000500000000000000000000000000000000000000000000\
            0000001040000000000000000000000000000010400000000000001040000000\
            0000000000000000000000104000000000000000000000000000000000050000\
            00000000000000F03F000000000000F03F0000000000000040000000000000F0\
            3F00000000000000400000000000000040000000000000F03F00000000000000\
            40000000000000F03F000000000000F03F\
            """),
          unexpected_surfaces: [{:circular_string_s, [[1.0, 1.0], [2.0, 2.0], [3.0, 3.0]]}],
          unexpected_wkb_xdr:
            Base.decode16!("""
            000000000C0000000100000000013FF00000000000003FF0000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010C000000010000000101000000000000000000F03F000000000000F03F\
            """),
          invalid_polygon_wkb_ndr:
            Base.decode16!("010C0000000100000001030000000100000004000000FF"),
          invalid_curve_polygon_wkb_ndr: Base.decode16!("010C00000001000000010A000000FF"),
          geometry_collection_code: %{
            # A prefix for a geometry collection with one element.
            xdr: Base.decode16!("000000000700000001"),
            ndr: Base.decode16!("010700000001000000")
          }
        }
      },
      %{
        module: MultiSurfaceM,
        text: "MULTISURFACE M",
        dim: :xym,
        srid: 456,
        code: %{
          xdr: Base.decode16!("004000000C"),
          ndr: Base.decode16!("010C000040")
        },
        code_srid: %{
          xdr: Base.decode16!("006000000C000001C8"),
          ndr: Base.decode16!("010C000060C8010000")
        },
        data: %{
          surfaces: [
            {:curve_polygon,
             [
               {:circular_string,
                [
                  [0.0, 0.0, 1.0],
                  [4.0, 0.0, 2.0],
                  [4.0, 4.0, 3.0],
                  [0.0, 4.0, 4.0],
                  [0.0, 0.0, 5.0]
                ]},
               {:coords, [[1.0, 1.0, 1.0], [3.0, 3.0, 2.0], [3.0, 1.0, 3.0], [1.0, 1.0, 1.0]]}
             ]},
            {:rings,
             [
               [[10.0, 10.0, 1.0], [14.0, 12.0, 2.0], [11.0, 10.0, 3.0], [10.0, 10.0, 4.0]],
               [[11.0, 11.0, 5.0], [11.5, 11.0, 6.0], [11.0, 11.5, 7.0], [11.0, 11.0, 8.0]]
             ]},
            {:polygon,
             [
               [
                 [0.0, 0.0, 1.0],
                 [4.0, 0.0, 2.0],
                 [4.0, 4.0, 3.0],
                 [0.0, 4.0, 4.0],
                 [0.0, 0.0, 5.0]
               ],
               [
                 [1.0, 1.0, 5.0],
                 [2.0, 1.0, 2.0],
                 [2.0, 2.0, 3.0],
                 [1.0, 2.0, 4.0],
                 [1.0, 1.0, 5.0]
               ]
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            00000003004000000A0000000200400000080000000500000000000000000000\
            0000000000003FF0000000000000401000000000000000000000000000004000\
            0000000000004010000000000000401000000000000040080000000000000000\
            0000000000004010000000000000401000000000000000000000000000000000\
            00000000000040140000000000000040000002000000043FF00000000000003F\
            F00000000000003FF00000000000004008000000000000400800000000000040\
            0000000000000040080000000000003FF000000000000040080000000000003F\
            F00000000000003FF00000000000003FF0000000000000004000000300000002\
            00000004402400000000000040240000000000003FF0000000000000402C0000\
            0000000040280000000000004000000000000000402600000000000040240000\
            0000000040080000000000004024000000000000402400000000000040100000\
            0000000000000004402600000000000040260000000000004014000000000000\
            4027000000000000402600000000000040180000000000004026000000000000\
            4027000000000000401C00000000000040260000000000004026000000000000\
            4020000000000000004000000300000002000000050000000000000000000000\
            00000000003FF000000000000040100000000000000000000000000000400000\
            0000000000401000000000000040100000000000004008000000000000000000\
            0000000000401000000000000040100000000000000000000000000000000000\
            00000000004014000000000000000000053FF00000000000003FF00000000000\
            00401400000000000040000000000000003FF000000000000040000000000000\
            004000000000000000400000000000000040080000000000003FF00000000000\
            00400000000000000040100000000000003FF00000000000003FF00000000000\
            004014000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            03000000010A0000400200000001080000400500000000000000000000000000\
            000000000000000000000000F03F000000000000104000000000000000000000\
            0000000000400000000000001040000000000000104000000000000008400000\
            0000000000000000000000001040000000000000104000000000000000000000\
            0000000000000000000000001440010200004004000000000000000000F03F00\
            0000000000F03F000000000000F03F0000000000000840000000000000084000\
            000000000000400000000000000840000000000000F03F000000000000084000\
            0000000000F03F000000000000F03F000000000000F03F010300004002000000\
            0400000000000000000024400000000000002440000000000000F03F00000000\
            00002C4000000000000028400000000000000040000000000000264000000000\
            0000244000000000000008400000000000002440000000000000244000000000\
            0000104004000000000000000000264000000000000026400000000000001440\
            0000000000002740000000000000264000000000000018400000000000002640\
            00000000000027400000000000001C4000000000000026400000000000002640\
            0000000000002040010300004002000000050000000000000000000000000000\
            0000000000000000000000F03F00000000000010400000000000000000000000\
            0000000040000000000000104000000000000010400000000000000840000000\
            0000000000000000000000104000000000000010400000000000000000000000\
            0000000000000000000000144005000000000000000000F03F000000000000F0\
            3F00000000000014400000000000000040000000000000F03F00000000000000\
            40000000000000004000000000000000400000000000000840000000000000F0\
            3F00000000000000400000000000001040000000000000F03F000000000000F0\
            3F0000000000001440\
            """),
          unexpected_surfaces: [
            {:circular_string_s, [[1.0, 2.0, 3.0], [3.0, 2.0, 1.0], [3.0, 1.0, 2.0]]}
          ],
          unexpected_wkb_xdr:
            Base.decode16!("""
            004000000C0000000100400000013FF000000000000040000000000000004008000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010C000040010000000101000040000000000000F03F00000000000000400000000000000840\
            """),
          invalid_polygon_wkb_ndr:
            Base.decode16!("010C0000400100000001030000400100000004000000FF"),
          invalid_curve_polygon_wkb_ndr: Base.decode16!("010C00004001000000010A000040FF"),
          geometry_collection_code: %{
            # A prefix for a geometry collection with one element.
            xdr: Base.decode16!("004000000700000001"),
            ndr: Base.decode16!("010700004001000000")
          }
        }
      },
      %{
        module: MultiSurfaceZ,
        text: "MULTISURFACE Z",
        dim: :xyz,
        srid: 789,
        code: %{
          xdr: Base.decode16!("008000000C"),
          ndr: Base.decode16!("010C000080")
        },
        code_srid: %{
          xdr: Base.decode16!("00A000000C00000315"),
          ndr: Base.decode16!("010C0000A015030000")
        },
        data: %{
          surfaces: [
            {:curve_polygon,
             [
               {:circular_string,
                [
                  [0.0, 0.0, 1.0],
                  [4.0, 0.0, 2.0],
                  [4.0, 4.0, 3.0],
                  [0.0, 4.0, 4.0],
                  [0.0, 0.0, 1.0]
                ]},
               {:coords, [[1.0, 1.0, 1.0], [3.0, 3.0, 2.0], [3.0, 1.0, 3.0], [1.0, 1.0, 1.0]]}
             ]},
            {:rings,
             [
               [[10.0, 10.0, 1.0], [14.0, 12.0, 2.0], [11.0, 10.0, 3.0], [10.0, 10.0, 4.0]],
               [[11.0, 11.0, 5.0], [11.5, 11.0, 6.0], [11.0, 11.5, 7.0], [11.0, 11.0, 8.0]]
             ]},
            {:polygon,
             [
               [
                 [0.0, 0.0, 1.0],
                 [4.0, 0.0, 2.0],
                 [4.0, 4.0, 3.0],
                 [0.0, 4.0, 4.0],
                 [0.0, 0.0, 1.0]
               ],
               [
                 [1.0, 1.0, 5.0],
                 [2.0, 1.0, 2.0],
                 [2.0, 2.0, 3.0],
                 [1.0, 2.0, 4.0],
                 [1.0, 1.0, 5.0]
               ]
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            00000003008000000A0000000200800000080000000500000000000000000000\
            0000000000003FF0000000000000401000000000000000000000000000004000\
            0000000000004010000000000000401000000000000040080000000000000000\
            0000000000004010000000000000401000000000000000000000000000000000\
            0000000000003FF00000000000000080000002000000043FF00000000000003F\
            F00000000000003FF00000000000004008000000000000400800000000000040\
            0000000000000040080000000000003FF000000000000040080000000000003F\
            F00000000000003FF00000000000003FF0000000000000008000000300000002\
            00000004402400000000000040240000000000003FF0000000000000402C0000\
            0000000040280000000000004000000000000000402600000000000040240000\
            0000000040080000000000004024000000000000402400000000000040100000\
            0000000000000004402600000000000040260000000000004014000000000000\
            4027000000000000402600000000000040180000000000004026000000000000\
            4027000000000000401C00000000000040260000000000004026000000000000\
            4020000000000000008000000300000002000000050000000000000000000000\
            00000000003FF000000000000040100000000000000000000000000000400000\
            0000000000401000000000000040100000000000004008000000000000000000\
            0000000000401000000000000040100000000000000000000000000000000000\
            00000000003FF0000000000000000000053FF00000000000003FF00000000000\
            00401400000000000040000000000000003FF000000000000040000000000000\
            004000000000000000400000000000000040080000000000003FF00000000000\
            00400000000000000040100000000000003FF00000000000003FF00000000000\
            004014000000000000\
            """),
          wkb_ndr:
            Base.decode16!("""
            03000000010A0000800200000001080000800500000000000000000000000000\
            000000000000000000000000F03F000000000000104000000000000000000000\
            0000000000400000000000001040000000000000104000000000000008400000\
            0000000000000000000000001040000000000000104000000000000000000000\
            000000000000000000000000F03F010200008004000000000000000000F03F00\
            0000000000F03F000000000000F03F0000000000000840000000000000084000\
            000000000000400000000000000840000000000000F03F000000000000084000\
            0000000000F03F000000000000F03F000000000000F03F010300008002000000\
            0400000000000000000024400000000000002440000000000000F03F00000000\
            00002C4000000000000028400000000000000040000000000000264000000000\
            0000244000000000000008400000000000002440000000000000244000000000\
            0000104004000000000000000000264000000000000026400000000000001440\
            0000000000002740000000000000264000000000000018400000000000002640\
            00000000000027400000000000001C4000000000000026400000000000002640\
            0000000000002040010300008002000000050000000000000000000000000000\
            0000000000000000000000F03F00000000000010400000000000000000000000\
            0000000040000000000000104000000000000010400000000000000840000000\
            0000000000000000000000104000000000000010400000000000000000000000\
            0000000000000000000000F03F05000000000000000000F03F000000000000F0\
            3F00000000000014400000000000000040000000000000F03F00000000000000\
            40000000000000004000000000000000400000000000000840000000000000F0\
            3F00000000000000400000000000001040000000000000F03F000000000000F0\
            3F0000000000001440\
            """),
          unexpected_surfaces: [
            {:circular_string_s, [[1.0, 2.0, 3.0], [3.0, 2.0, 1.0], [3.0, 1.0, 2.0]]}
          ],
          unexpected_wkb_xdr:
            Base.decode16!("""
            008000000C0000000100800000013FF000000000000040000000000000004008000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010C000080010000000101000080000000000000F03F00000000000000400000000000000840\
            """),
          invalid_polygon_wkb_ndr:
            Base.decode16!("010C0000800100000001030000800100000004000000FF"),
          invalid_curve_polygon_wkb_ndr: Base.decode16!("010C00008001000000010A000080FF"),
          geometry_collection_code: %{
            # A prefix for a geometry collection with one element.
            xdr: Base.decode16!("008000000700000001"),
            ndr: Base.decode16!("010700008001000000")
          }
        }
      },
      %{
        module: MultiSurfaceZM,
        text: "MULTISURFACE ZM",
        dim: :xyzm,
        srid: 321,
        code: %{
          xdr: Base.decode16!("00C000000C"),
          ndr: Base.decode16!("010C0000C0")
        },
        code_srid: %{
          xdr: Base.decode16!("00E000000C00000141"),
          ndr: Base.decode16!("010C0000E041010000")
        },
        data: %{
          surfaces: [
            {:curve_polygon,
             [
               {:circular_string,
                [
                  [0.0, 0.0, 1.0, 2.0],
                  [4.0, 0.0, 2.0, 3.0],
                  [4.0, 4.0, 3.0, 4.0],
                  [0.0, 4.0, 4.0, 5.0],
                  [0.0, 0.0, 1.0, 6.0]
                ]},
               {:coords,
                [
                  [1.0, 1.0, 1.0, 1.0],
                  [3.0, 3.0, 2.0, 1.0],
                  [3.0, 1.0, 3.0, 2.0],
                  [1.0, 1.0, 1.0, 1.0]
                ]}
             ]},
            {:rings,
             [
               [
                 [10.0, 10.0, 1.0, 2.0],
                 [14.0, 12.0, 2.0, 3.0],
                 [11.0, 10.0, 3.0, 4.0],
                 [10.0, 10.0, 4.0, 5.0]
               ],
               [
                 [11.0, 11.0, 5.0, 6.0],
                 [11.5, 11.0, 6.0, 7.0],
                 [11.0, 11.5, 7.0, 8.0],
                 [11.0, 11.0, 8.0, 9.0]
               ]
             ]},
            {:polygon,
             [
               [
                 [0.0, 0.0, 1.0, 2.0],
                 [4.0, 0.0, 2.0, 3.0],
                 [4.0, 4.0, 3.0, 4.0],
                 [0.0, 4.0, 4.0, 5.0],
                 [0.0, 0.0, 5.0, 9.0]
               ],
               [
                 [1.0, 1.0, 5.0, 1.0],
                 [2.0, 1.0, 2.0, 3.0],
                 [2.0, 2.0, 3.0, 5.0],
                 [1.0, 2.0, 4.0, 2.0],
                 [1.0, 1.0, 5.0, 1.0]
               ]
             ]}
          ],
          wkb_xdr:
            Base.decode16!("""
            0000000300C000000A0000000200C00000080000000500000000000000000000\
            0000000000003FF0000000000000400000000000000040100000000000000000\
            0000000000004000000000000000400800000000000040100000000000004010\
            0000000000004008000000000000401000000000000000000000000000004010\
            0000000000004010000000000000401400000000000000000000000000000000\
            0000000000003FF0000000000000401800000000000000C0000002000000043F\
            F00000000000003FF00000000000003FF00000000000003FF000000000000040\
            08000000000000400800000000000040000000000000003FF000000000000040\
            080000000000003FF0000000000000400800000000000040000000000000003F\
            F00000000000003FF00000000000003FF00000000000003FF000000000000000\
            C00000030000000200000004402400000000000040240000000000003FF00000\
            000000004000000000000000402C000000000000402800000000000040000000\
            0000000040080000000000004026000000000000402400000000000040080000\
            0000000040100000000000004024000000000000402400000000000040100000\
            0000000040140000000000000000000440260000000000004026000000000000\
            4014000000000000401800000000000040270000000000004026000000000000\
            4018000000000000401C00000000000040260000000000004027000000000000\
            401C000000000000402000000000000040260000000000004026000000000000\
            4020000000000000402200000000000000C00000030000000200000005000000\
            000000000000000000000000003FF00000000000004000000000000000401000\
            0000000000000000000000000040000000000000004008000000000000401000\
            0000000000401000000000000040080000000000004010000000000000000000\
            0000000000401000000000000040100000000000004014000000000000000000\
            0000000000000000000000000040140000000000004022000000000000000000\
            053FF00000000000003FF000000000000040140000000000003FF00000000000\
            0040000000000000003FF0000000000000400000000000000040080000000000\
            0040000000000000004000000000000000400800000000000040140000000000\
            003FF00000000000004000000000000000401000000000000040000000000000\
            003FF00000000000003FF000000000000040140000000000003FF00000000000\
            00\
            """),
          wkb_ndr:
            Base.decode16!("""
            03000000010A0000C00200000001080000C00500000000000000000000000000\
            000000000000000000000000F03F000000000000004000000000000010400000\
            0000000000000000000000000040000000000000084000000000000010400000\
            0000000010400000000000000840000000000000104000000000000000000000\
            0000000010400000000000001040000000000000144000000000000000000000\
            000000000000000000000000F03F000000000000184001020000C00400000000\
            0000000000F03F000000000000F03F000000000000F03F000000000000F03F00\
            0000000000084000000000000008400000000000000040000000000000F03F00\
            00000000000840000000000000F03F0000000000000840000000000000004000\
            0000000000F03F000000000000F03F000000000000F03F000000000000F03F01\
            030000C002000000040000000000000000002440000000000000244000000000\
            0000F03F00000000000000400000000000002C40000000000000284000000000\
            0000004000000000000008400000000000002640000000000000244000000000\
            0000084000000000000010400000000000002440000000000000244000000000\
            0000104000000000000014400400000000000000000026400000000000002640\
            0000000000001440000000000000184000000000000027400000000000002640\
            00000000000018400000000000001C4000000000000026400000000000002740\
            0000000000001C40000000000000204000000000000026400000000000002640\
            0000000000002040000000000000224001030000C00200000005000000000000\
            00000000000000000000000000000000000000F03F0000000000000040000000\
            0000001040000000000000000000000000000000400000000000000840000000\
            0000001040000000000000104000000000000008400000000000001040000000\
            0000000000000000000000104000000000000010400000000000001440000000\
            0000000000000000000000000000000000000014400000000000002240050000\
            00000000000000F03F000000000000F03F0000000000001440000000000000F0\
            3F0000000000000040000000000000F03F000000000000004000000000000008\
            4000000000000000400000000000000040000000000000084000000000000014\
            40000000000000F03F0000000000000040000000000000104000000000000000\
            40000000000000F03F000000000000F03F0000000000001440000000000000F0\
            3F\
            """),
          unexpected_surfaces: [
            {:circular_string_s,
             [[1.0, 2.0, 3.0, 4.0], [3.0, 2.0, 1.0, 2.0], [3.0, 1.0, 2.0, 3.0]]}
          ],
          unexpected_wkb_xdr:
            Base.decode16!("""
            00C000000C0000000100C00000013FF000000000000040000000000000004008\
            0000000000004010000000000000\
            """),
          unexpected_wkb_ndr:
            Base.decode16!("""
            010C0000C00100000001010000C0000000000000F03F00000000000000400000\
            0000000008400000000000001040\
            """),
          invalid_polygon_wkb_ndr:
            Base.decode16!("010C0000C00100000001030000C00100000004000000FF"),
          invalid_curve_polygon_wkb_ndr: Base.decode16!("010C0000C001000000010A0000C0FF"),
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
        test "returns an empty multi surface" do
          assert unquote(module).new() == %unquote(module){surfaces: []}
        end
      end

      describe "[#{inspect(module)}] new/1" do
        test "returns a multi surface" do
          surfaces = surfaces(unquote(Macro.escape(data[:surfaces])), unquote(dim))

          assert unquote(module).new(surfaces) == %unquote(module){
                   surfaces: surfaces
                 }
        end

        test "returns an empty multi surface" do
          assert unquote(module).new([]) == %unquote(module){surfaces: []}
        end
      end

      describe "[#{inspect(module)}] empty?/1" do
        test "returns true if multi surface is empty" do
          multi_surface = unquote(module).new()

          assert Geometry.empty?(multi_surface) == true
        end

        test "returns false if multi surface is not empty" do
          multi_surface = multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          assert Geometry.empty?(multi_surface) == false
        end
      end

      describe "[#{inspect(module)}] to_geo_json/1" do
        @describetag :geo_json

        test "raises a protocol error" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          message =
            ~r|protocol.Geometry.Encoder.GeoJson.not.implemented.for.*#{inspect(unquote(module))}|

          assert_raise Protocol.UndefinedError, message, fn ->
            Geometry.to_geo_json(multi_surface)
          end
        end
      end

      describe "[#{inspect(module)}] from_wkb/1" do
        @describetag :wkb

        test "returns multi surface from xdr binary" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_wkb(wkb) == {:ok, multi_surface}
        end

        test "returns multi surface from ndr binary" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_wkb(wkb) == {:ok, multi_surface}
        end

        test "returns an empty multi surface from xdr binary" do
          multi_surface = unquote(module).new()
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>

          assert Geometry.from_wkb(wkb) == {:ok, multi_surface}
        end

        test "returns an empty multi surface from ndr binary" do
          multi_surface = unquote(module).new()
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>

          assert Geometry.from_wkb(wkb) == {:ok, multi_surface}
        end

        test "returns multi surface from xdr binary with srid" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_wkb(wkb) == {:ok, multi_surface}
        end

        test "returns multi surface from ndr binary with srid" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_wkb(wkb) == {:ok, multi_surface}
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

        test "returns an error for an unexpected surface in xdr binary" do
          wkb = unquote(data[:unexpected_wkb_xdr])

          assert {:error, %Geometry.DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :expected_multi_surface_surface
        end

        test "returns an error for an unexpected surface in ndr binary" do
          wkb = unquote(data[:unexpected_wkb_ndr])

          assert {:error, %Geometry.DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :expected_multi_surface_surface
        end

        test "returns an error for an invalid coordinate in a polygon surface" do
          wkb = unquote(data[:invalid_polygon_wkb_ndr])

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_coordinate
        end

        test "returns an error for an invalid length in a curve polygon surface" do
          wkb = unquote(data[:invalid_curve_polygon_wkb_ndr])

          assert {:error, %DecodeError{} = error} = Geometry.from_wkb(wkb)
          assert error.reason == :invalid_length
        end

        test "returns a geometry for a multi surface inside a geometry collection (xdr)" do
          wkb =
            unquote(data[:geometry_collection_code][:xdr]) <>
              unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert {:ok, _geometry} = Geometry.from_wkb(wkb)
        end

        test "returns a geometry for a multi surface inside a geometry collection (ndr)" do
          wkb =
            unquote(data[:geometry_collection_code][:ndr]) <>
              unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert {:ok, _geometry} = Geometry.from_wkb(wkb)
        end

        test "returns an error for an invalid multi surface in a geometry collection (xdr)" do
          wkb =
            unquote(data[:geometry_collection_code][:xdr]) <>
              unquote(data[:unexpected_wkb_xdr])

          assert {:error, _reason} = Geometry.from_wkb(wkb)
        end

        test "returns an error for an invalid multi surface in a geometry collection (ndr)" do
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

        test "returns multi surface from xdr binary" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_ewkb(wkb) == {:ok, multi_surface}
        end

        test "returns multi surface from ndr binary" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_ewkb(wkb) == {:ok, multi_surface}
        end

        test "returns multi surface from xdr binary with srid" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.from_ewkb(wkb) == {:ok, multi_surface}
        end

        test "returns multi surface from ndr binary with srid" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.from_ewkb(wkb) == {:ok, multi_surface}
        end
      end

      describe "[#{inspect(module)}] to_wkb/2" do
        @describetag :wkb

        test "returns a multi surface as xdr binary" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkb = unquote(code[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.to_wkb(multi_surface, :xdr) == wkb
        end

        test "returns a multi surface as ndr binary" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkb = unquote(code[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.to_wkb(multi_surface) == wkb
          assert Geometry.to_wkb(multi_surface, :ndr) == wkb
        end

        test "returns an empty multi surface as xdr binary" do
          multi_surface = unquote(module).new()
          wkb = unquote(code[:xdr]) <> <<0, 0, 0, 0>>

          assert Geometry.to_wkb(multi_surface, :xdr) == wkb
        end

        test "returns an empty multi surface as ndr binary" do
          multi_surface = unquote(module).new()
          wkb = unquote(code[:ndr]) <> <<0, 0, 0, 0>>

          assert Geometry.to_wkb(multi_surface) == wkb
        end
      end

      describe "[#{inspect(module)}] to_ewkb/2" do
        @describetag :wkb

        test "returns multi surface as xdr binary with srid" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkb = unquote(code_srid[:xdr]) <> unquote(data[:wkb_xdr])

          assert Geometry.to_ewkb(multi_surface, :xdr) == wkb
        end

        test "returns multi surface as ndr binary with srid" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkb = unquote(code_srid[:ndr]) <> unquote(data[:wkb_ndr])

          assert Geometry.to_ewkb(multi_surface) == wkb
        end
      end

      describe "[#{inspect(module)}] from_wkt/1" do
        @describetag :wkt

        test "returns multi surface" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkt = wkt(unquote(text), unquote(Macro.escape(data[:surfaces])), unquote(dim))

          assert Geometry.from_wkt(wkt) == {:ok, multi_surface}
        end

        test "returns multi surface with srid" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:surfaces])),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_wkt(wkt) == {:ok, multi_surface}
        end

        test "returns an empty multi surface" do
          wkt = wkt(unquote(text))
          multi_surface = unquote(module).new()

          assert Geometry.from_wkt(wkt) == {:ok, multi_surface}
        end

        test "returns an error for an unexpected surface" do
          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:unexpected_surfaces])),
              unquote(dim)
            )

          assert {:error, %DecodeError{} = error} = Geometry.from_wkt(wkt)
          assert error.from == :wkt
          assert error.message == "unexpected surface in multi surface"
        end

        test "returns an error for an unexpected geometry (wrong dimension)" do
          wrong_dim = unquote(if dim == :xy, do: " Z ", else: " ")

          wkt =
            "#{unquote(String.upcase(text))} (POLYGON#{wrong_dim}((0 0 1, 1 0 1, 1 1 1, 0 0 1)))"

          assert {:error, %DecodeError{} = error} = Geometry.from_wkt(wkt)
          assert error.from == :wkt
          assert error.message == "unexpected geometry in multi surface"
        end

        test "returns an error for a surface with SRID" do
          wkt =
            "#{unquote(String.upcase(text))} (SRID=4326;POLYGON#{wkt_dim(unquote(dim))}((0 0, 1 0, 0 1, 0 0)))"

          assert {:error, %DecodeError{} = error} = Geometry.from_wkt(wkt)
          assert error.from == :wkt
          assert error.message == "unexpected SRID in multi surface"
        end
      end

      describe "[#{inspect(module)}] from_ewkt/1" do
        @describetag :wkt

        test "returns multi surface" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkt = wkt(unquote(text), unquote(Macro.escape(data[:surfaces])), unquote(dim))

          assert Geometry.from_ewkt(wkt) == {:ok, multi_surface}
        end

        test "returns an empty multi surface" do
          wkt = wkt(unquote(text))
          multi_surface = unquote(module).new()

          assert Geometry.from_ewkt(wkt) == {:ok, multi_surface}
        end

        test "returns multi surface from WKT with srid" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:surfaces])),
              unquote(dim),
              unquote(srid)
            )

          assert Geometry.from_ewkt(wkt) == {:ok, multi_surface}
        end
      end

      describe "[#{inspect(module)}] to_wkt/1" do
        @describetag :wkt

        test "returns wkt" do
          multi_surface =
            multi_surface(unquote(module), unquote(Macro.escape(data[:surfaces])))

          wkt =
            wkt(unquote(text), unquote(Macro.escape(data[:surfaces])), unquote(dim), "", true)

          assert Geometry.to_wkt(multi_surface) == wkt
        end

        test "returns wkt from an empty multi surface" do
          wkt = wkt(unquote(text))
          multi_surface = unquote(module).new()

          assert Geometry.to_wkt(multi_surface) == wkt
        end
      end

      describe "[#{inspect(module)}] to_ewkt/2" do
        @describetag :wkt

        test "returns ewkt" do
          multi_surface =
            multi_surface(
              unquote(module),
              unquote(Macro.escape(data[:surfaces])),
              unquote(srid)
            )

          wkt =
            wkt(
              unquote(text),
              unquote(Macro.escape(data[:surfaces])),
              unquote(dim),
              unquote(srid),
              true
            )

          assert Geometry.to_ewkt(multi_surface) == wkt
        end

        test "returns ewkt from an empty multi surface" do
          multi_surface = multi_surface(unquote(module), [], unquote(srid))
          wkt = wkt(unquote(text), [], unquote(dim), unquote(srid))

          assert Geometry.to_ewkt(multi_surface) == wkt
        end
      end
    end
  )

  defp wkt(name, surface_data \\ [], dim \\ :xy, srid \\ "", expand \\ false)

  defp wkt(name, [], _dim, "", _expand), do: "#{String.upcase(name)} EMPTY"

  defp wkt(name, [], _dim, srid, _expand), do: "SRID=#{srid};#{String.upcase(name)} EMPTY"

  defp wkt(name, surface_data, dim, srid, expand) do
    surfaces_wkt =
      Enum.map_join(surface_data, ", ", fn s -> surface_to_wkt(s, dim, expand) end)

    srid_prefix = if srid == "", do: "", else: "SRID=#{srid};"
    "#{srid_prefix}#{String.upcase(name)} (#{surfaces_wkt})"
  end

  defp surface_to_wkt({:polygon, rings}, dim, _expand) do
    rings_wkt = Enum.map_join(rings, ", ", fn ring -> "(#{wkt_coords(ring)})" end)
    "POLYGON#{wkt_dim(dim)}(#{rings_wkt})"
  end

  defp surface_to_wkt({:rings, rings}, _dim, false) do
    rings_wkt = Enum.map_join(rings, ", ", fn ring -> "(#{wkt_coords(ring)})" end)
    "(#{rings_wkt})"
  end

  defp surface_to_wkt({:rings, rings}, dim, true) do
    rings_wkt = Enum.map_join(rings, ", ", fn ring -> "(#{wkt_coords(ring)})" end)
    "POLYGON#{wkt_dim(dim)}(#{rings_wkt})"
  end

  defp surface_to_wkt({:curve_polygon, rings_data}, dim, expand) do
    rings_wkt =
      Enum.map_join(rings_data, ", ", fn ring -> cp_ring_to_wkt(ring, dim, expand) end)

    "CURVEPOLYGON#{wkt_dim(dim)}(#{rings_wkt})"
  end

  defp surface_to_wkt({:circular_string_s, coords}, dim, _expand) do
    "CIRCULARSTRING#{wkt_dim(dim)}(#{wkt_coords(coords)})"
  end

  defp cp_ring_to_wkt({:circular_string, coords}, dim, _expand) do
    "CIRCULARSTRING#{wkt_dim(dim)}(#{wkt_coords(coords)})"
  end

  defp cp_ring_to_wkt({:coords, coords}, _dim, false) do
    "(#{wkt_coords(coords)})"
  end

  defp cp_ring_to_wkt({:coords, coords}, dim, true) do
    "LINESTRING#{wkt_dim(dim)}(#{wkt_coords(coords)})"
  end

  defp wkt_dim(:xy), do: " "
  defp wkt_dim(:xyz), do: " Z "
  defp wkt_dim(:xym), do: " M "
  defp wkt_dim(:xyzm), do: " ZM "

  defp wkt_coords(coordinates) do
    Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, @blank) end)
  end

  defp dim(MultiSurface), do: :xy
  defp dim(MultiSurfaceM), do: :xym
  defp dim(MultiSurfaceZ), do: :xyz
  defp dim(MultiSurfaceZM), do: :xyzm

  defp multi_surface(module, surface_data, srid \\ 0) do
    surface_data
    |> surfaces(dim(module), srid)
    |> module.new(srid)
  end

  defp surfaces(surface_data, dim, srid \\ 0) do
    Enum.map(surface_data, fn desc -> create_surface(desc, dim, srid) end)
  end

  defp create_surface({:polygon, rings}, dim, srid) do
    rings = Enum.map(rings, fn coords -> create_cp_ring({:coords, coords}, dim, srid) end)

    case dim do
      :xy -> Polygon.new(rings, srid)
      :xym -> PolygonM.new(rings, srid)
      :xyz -> PolygonZ.new(rings, srid)
      :xyzm -> PolygonZM.new(rings, srid)
    end
  end

  defp create_surface({:rings, rings}, dim, srid) do
    create_surface({:polygon, rings}, dim, srid)
  end

  defp create_surface({:curve_polygon, rings_data}, dim, srid) do
    rings = Enum.map(rings_data, fn ring_desc -> create_cp_ring(ring_desc, dim, srid) end)

    case dim do
      :xy -> CurvePolygon.new(rings, srid)
      :xym -> CurvePolygonM.new(rings, srid)
      :xyz -> CurvePolygonZ.new(rings, srid)
      :xyzm -> CurvePolygonZM.new(rings, srid)
    end
  end

  defp create_surface({:circular_string_s, coords}, dim, srid) do
    points = Enum.map(coords, &create_point(&1, dim))

    case dim do
      :xy -> CircularString.new(points, srid)
      :xym -> CircularStringM.new(points, srid)
      :xyz -> CircularStringZ.new(points, srid)
      :xyzm -> CircularStringZM.new(points, srid)
    end
  end

  defp create_cp_ring({:circular_string, coords}, dim, srid) do
    points = Enum.map(coords, &create_point(&1, dim))

    case dim do
      :xy -> CircularString.new(points, srid)
      :xym -> CircularStringM.new(points, srid)
      :xyz -> CircularStringZ.new(points, srid)
      :xyzm -> CircularStringZM.new(points, srid)
    end
  end

  defp create_cp_ring({:coords, coords}, dim, srid) do
    points = Enum.map(coords, &create_point(&1, dim))

    case dim do
      :xy -> LineString.new(points, srid)
      :xym -> LineStringM.new(points, srid)
      :xyz -> LineStringZ.new(points, srid)
      :xyzm -> LineStringZM.new(points, srid)
    end
  end

  defp create_point(coord, :xy), do: Point.new(coord)
  defp create_point(coord, :xym), do: PointM.new(coord)
  defp create_point(coord, :xyz), do: PointZ.new(coord)
  defp create_point(coord, :xyzm), do: PointZM.new(coord)
end
