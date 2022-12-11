defmodule Geometry.GeometryCollectionZTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.GeometryCollectionZ
  alias Geometry.Hex
  alias Geometry.LineStringZ
  alias Geometry.PointZ
  alias Geometry.PolygonZ

  doctest Geometry.GeometryCollectionZ, import: true

  @moduletag :geometry_collection

  describe "to_wkb/2" do
    test "returns WKB as ndr-binary for a GeometryCollectionZ" do
      collection =
        GeometryCollectionZ.new([
          PointZ.new(1.1, 2.2, 3.3),
          LineStringZ.new([
            PointZ.new(1.1, 1.2, 1.3),
            PointZ.new(2.1, 2.2, 2.3)
          ]),
          PolygonZ.new([
            LineStringZ.new([
              PointZ.new(1.1, 1.2, 1.3),
              PointZ.new(2.1, 2.2, 2.3),
              PointZ.new(3.3, 2.2, 2.3),
              PointZ.new(1.1, 1.2, 1.3)
            ])
          ])
        ])

      wkb = """
      01\
      07000080\
      03000000\
      """

      assert result = GeometryCollectionZ.to_wkb(collection, endian: :ndr)
      assert String.starts_with?(result, Hex.to_binary(wkb))
      assert GeometryCollectionZ.from_wkb!(result) == collection
    end

    test "returns WKB as ndr-string for a GeometryCollectionZ" do
      collection =
        GeometryCollectionZ.new([
          PointZ.new(1.1, 2.2, 3.3),
          LineStringZ.new([
            PointZ.new(1.1, 1.2, 1.3),
            PointZ.new(2.1, 2.2, 2.3)
          ]),
          PolygonZ.new([
            LineStringZ.new([
              PointZ.new(1.1, 1.2, 1.3),
              PointZ.new(2.1, 2.2, 2.3),
              PointZ.new(3.3, 2.2, 2.3),
              PointZ.new(1.1, 1.2, 1.3)
            ])
          ])
        ])

      wkb = """
      01\
      07000080\
      03000000\
      """

      assert result = GeometryCollectionZ.to_wkb(collection, endian: :ndr, mode: :hex)
      assert String.starts_with?(result, wkb)
      assert GeometryCollectionZ.from_wkb!(result, :hex) == collection
    end

    test "returns WKB as xdr-string for a GeometryCollectionZ" do
      wkb = "008000000700000000"

      assert GeometryCollectionZ.to_wkb(GeometryCollectionZ.new(), mode: :hex) == wkb
    end

    test "returns WKB as xdr-binary for a GeometryCollectionZ" do
      wkb = "008000000700000000"

      assert GeometryCollectionZ.to_wkb(GeometryCollectionZ.new()) == Hex.to_binary(wkb)
    end

    test "returns WKB as ndr-string for a GeometryCollectionZ with SRID" do
      wkb = "01070000A07B00000000000000"

      assert GeometryCollectionZ.to_wkb(
               GeometryCollectionZ.new(),
               endian: :ndr,
               srid: 123,
               mode: :hex
             ) == wkb
    end

    test "returns WKB as ndr-binary for a GeometryCollectionZ with SRID" do
      wkb = "01070000A07B00000000000000"

      assert GeometryCollectionZ.to_wkb(
               GeometryCollectionZ.new(),
               endian: :ndr,
               srid: 123
             ) == Hex.to_binary(wkb)
    end

    test "returns WKB as xdr-string for a GeometryCollectionZ with SRID" do
      wkb = "00A00000070000014100000000"

      assert GeometryCollectionZ.to_wkb(
               GeometryCollectionZ.new(),
               srid: 321,
               mode: :hex
             ) == wkb
    end

    test "returns WKB as xdr-binary for a GeometryCollectionZ with SRID" do
      wkb = "00A00000070000014100000000"

      assert GeometryCollectionZ.to_wkb(
               GeometryCollectionZ.new(),
               srid: 321
             ) == Hex.to_binary(wkb)
    end
  end

  describe "from_wkb!/2" do
    test "returns an empty GeometryCollectionZ from ndr-string" do
      wkb = "010700008000000000"

      assert GeometryCollectionZ.from_wkb!(wkb, :hex) == %GeometryCollectionZ{}
    end

    test "returns an empty GeometryCollectionZ from ndr-binary" do
      wkb = "010700008000000000"

      assert wkb |> Hex.to_binary() |> GeometryCollectionZ.from_wkb!() == %GeometryCollectionZ{}
    end

    test "returns a GeometryCollectionZ from ndr-string" do
      wkb = """
      01\
      07000080\
      01000000\
      01\
      01000080\
      000000000000F03F00000000000000400000000000000840\
      """

      assert GeometryCollectionZ.from_wkb!(wkb, :hex) ==
               %GeometryCollectionZ{
                 geometries: MapSet.new([%PointZ{coordinate: [1.0, 2.0, 3.0]}])
               }
    end

    test "returns a GeometryCollectionZ from ndr-binary" do
      wkb = """
      01\
      07000080\
      01000000\
      01\
      01000080\
      000000000000F03F00000000000000400000000000000840\
      """

      assert wkb |> Hex.to_binary() |> GeometryCollectionZ.from_wkb!() ==
               %GeometryCollectionZ{
                 geometries: MapSet.new([%PointZ{coordinate: [1.0, 2.0, 3.0]}])
               }
    end

    test "returns a GeometryCollectionZ with an SRID from ndr-string" do
      wkb = """
      01\
      070000A0\
      37000000\
      01000000\
      01\
      01000080\
      000000000000F03F00000000000000400000000000000840\
      """

      assert GeometryCollectionZ.from_wkb!(wkb, :hex) ==
               {%GeometryCollectionZ{
                  geometries: MapSet.new([%PointZ{coordinate: [1.0, 2.0, 3.0]}])
                }, 55}
    end

    test "returns a GeometryCollectionZ with an SRID from ndr-binary" do
      wkb = """
      01\
      070000A0\
      37000000\
      01000000\
      01\
      01000080\
      000000000000F03F00000000000000400000000000000840\
      """

      assert wkb |> Hex.to_binary() |> GeometryCollectionZ.from_wkb!() ==
               {%GeometryCollectionZ{
                  geometries: MapSet.new([%PointZ{coordinate: [1.0, 2.0, 3.0]}])
                }, 55}
    end

    test "raises an error for an unexpected SRID in ndr-string" do
      wkb = """
      01\
      070000C0\
      01000000\
      01\
      010000E0\
      37000000\
      000000000000F03F000000000000004000000000000008400000000000001040\
      """

      message = "unexpected SRID in sub-geometry, at position 100"

      assert_raise Geometry.Error, message, fn ->
        GeometryCollectionZ.from_wkb!(wkb, :hex)
      end
    end

    test "raises an error for an unexpected SRID in ndr-binary" do
      wkb = """
      01\
      070000C0\
      01000000\
      01\
      010000E0\
      37000000\
      000000000000F03F000000000000004000000000000008400000000000001040\
      """

      message = "unexpected SRID in sub-geometry, at position 50"

      assert_raise Geometry.Error, message, fn ->
        wkb |> Hex.to_binary() |> GeometryCollectionZ.from_wkb!()
      end
    end
  end

  describe "from_wkb/2" do
    test "returns an empty GeometryCollectionZ from ndr-string" do
      wkb = "010700008000000000"

      assert GeometryCollectionZ.from_wkb(wkb, :hex) == {:ok, %GeometryCollectionZ{}}
    end

    test "returns an empty GeometryCollectionZ from ndr-binary" do
      wkb = "010700008000000000"

      assert wkb |> Hex.to_binary() |> GeometryCollectionZ.from_wkb() ==
               {:ok, %GeometryCollectionZ{}}
    end

    test "returns a GeometryCollectionZ from ndr-string" do
      wkb = """
      01\
      07000080\
      01000000\
      01\
      01000080\
      000000000000F03F00000000000000400000000000000840\
      """

      assert GeometryCollectionZ.from_wkb(wkb, :hex) ==
               {:ok,
                %GeometryCollectionZ{
                  geometries: MapSet.new([%PointZ{coordinate: [1.0, 2.0, 3.0]}])
                }}
    end

    test "returns a GeometryCollectionZ from ndr-binary" do
      wkb = """
      01\
      07000080\
      01000000\
      01\
      01000080\
      000000000000F03F00000000000000400000000000000840\
      """

      assert wkb |> Hex.to_binary() |> GeometryCollectionZ.from_wkb() ==
               {:ok,
                %GeometryCollectionZ{
                  geometries: MapSet.new([%PointZ{coordinate: [1.0, 2.0, 3.0]}])
                }}
    end

    test "returns a GeometryCollectionZ with an SRID from ndr-string" do
      wkb = """
      01\
      070000A0\
      37000000\
      01000000\
      01\
      01000080\
      000000000000F03F00000000000000400000000000000840\
      """

      assert GeometryCollectionZ.from_wkb(wkb, :hex) ==
               {:ok,
                {
                  %GeometryCollectionZ{
                    geometries: MapSet.new([%PointZ{coordinate: [1.0, 2.0, 3.0]}])
                  },
                  55
                }}
    end

    test "returns a GeometryCollectionZ with an SRID from ndr-binary" do
      wkb = """
      01\
      070000A0\
      37000000\
      01000000\
      01\
      01000080\
      000000000000F03F00000000000000400000000000000840\
      """

      assert wkb |> Hex.to_binary() |> GeometryCollectionZ.from_wkb() ==
               {:ok,
                {
                  %GeometryCollectionZ{
                    geometries: MapSet.new([%PointZ{coordinate: [1.0, 2.0, 3.0]}])
                  },
                  55
                }}
    end

    test "returns an error for an unexpected SRID in ndr-string" do
      wkb = """
      01\
      070000C0\
      01000000\
      01\
      010000E0\
      37000000\
      000000000000F03F000000000000004000000000000008400000000000001040\
      """

      assert {:error, "unexpected SRID in sub-geometry", _rest, 100} =
               GeometryCollectionZ.from_wkb(wkb, :hex)
    end

    test "returns an error for an unexpected SRID in ndr-binary" do
      wkb = """
      01\
      070000C0\
      01000000\
      01\
      010000E0\
      37000000\
      000000000000F03F000000000000004000000000000008400000000000001040\
      """

      assert {:error, "unexpected SRID in sub-geometry", _rest, 50} =
               wkb |> Hex.to_binary() |> GeometryCollectionZ.from_wkb()
    end
  end

  describe "from_wkt/1" do
    test "returns a GeometryCollectionZ" do
      assert GeometryCollectionZ.from_wkt("GeometryCollection Z (Point Z (1.1 2.2 3.3))") ==
               {
                 :ok,
                 %GeometryCollectionZ{
                   geometries: MapSet.new([%PointZ{coordinate: [1.1, 2.2, 3.3]}])
                 }
               }
    end

    test "returns a GeometryCollectionZ with an SRID" do
      assert GeometryCollectionZ.from_wkt("SRID=123;GeometryCollection Z (Point Z (1.1 2.2 3.3))") ==
               {
                 :ok,
                 {
                   %GeometryCollectionZ{
                     geometries: MapSet.new([%PointZ{coordinate: [1.1, 2.2, 3.3]}])
                   },
                   123
                 }
               }
    end

    test "returns an error for an unexpected SRID" do
      wkt = "SRID=123;GeometryCollection Z (SRID=666;Point Z (1.1 2.2 3.3))"

      assert {:error, "unexpected SRID in collection", "(1.1 2.2 3.3))", {1, 0}, _offset} =
               GeometryCollectionZ.from_wkt(wkt)
    end
  end

  describe "from_wkt!/1" do
    test "returns a GeometryCollectionZ" do
      assert GeometryCollectionZ.from_wkt!("GeometryCollection Z (Point Z (1.1 2.2 3.3))") ==
               %GeometryCollectionZ{
                 geometries: MapSet.new([%PointZ{coordinate: [1.1, 2.2, 3.3]}])
               }
    end

    test "returns a GeometryCollectionZ with an SRID" do
      assert GeometryCollectionZ.from_wkt!(
               "SRID=123;GeometryCollection Z (Point Z (1.1 2.2 3.3))"
             ) ==
               {%GeometryCollectionZ{
                  geometries: MapSet.new([%PointZ{coordinate: [1.1, 2.2, 3.3]}])
                }, 123}
    end

    test "raises an error for an invalid WKT" do
      message = ~s(no data found at 1:0, got: "")

      assert_raise Geometry.Error, message, fn ->
        GeometryCollectionZ.from_wkt!("")
      end
    end
  end

  describe "from_geo_json!" do
    test "return GeometryCollectionZ" do
      geo_json =
        Jason.decode!("""
          {
            "type": "GeometryCollection",
            "geometries": [
              {"type": "Point", "coordinates": [1.1, 2.2, 3.3]}
            ]
          }
        """)

      assert GeometryCollectionZ.from_geo_json!(geo_json) ==
               %GeometryCollectionZ{
                 geometries: MapSet.new([%PointZ{coordinate: [1.1, 2.2, 3.3]}])
               }
    end

    test "raises an error for invalid data" do
      geo_json =
        Jason.decode!("""
          {
            "type": "GeometryCollection",
            "geometries": [
              {"type": "Point", "coordinates": ["evil", 2.2, 3.3, 4.4]}
            ]
          }
        """)

      message = "invalid data"

      assert_raise Geometry.Error, message, fn ->
        GeometryCollectionZ.from_geo_json!(geo_json)
      end
    end
  end

  test "Enum.slice/3" do
    collection =
      GeometryCollectionZ.new([
        PointZ.new(11, 12, 13),
        LineStringZ.new([
          PointZ.new(21, 22, 23),
          PointZ.new(31, 32, 33)
        ])
      ])

    assert [_geometry] = Enum.slice(collection, 0, 1)
  end
end
