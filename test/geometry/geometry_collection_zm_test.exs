defmodule Geometry.GeometryCollectionZMTest do
  use ExUnit.Case, async: true

  alias Geometry.{
    GeometryCollectionZM,
    Hex,
    LineStringZM,
    PointZM,
    PolygonZM
  }

  doctest Geometry.GeometryCollectionZM, import: true

  @moduletag :geometry_collection

  describe "to_wkb/2" do
    test "returns WKB as ndr-binary for a GeometryCollectionZM" do
      collection =
        GeometryCollectionZM.new([
          PointZM.new(1.1, 2.2, 3.3, 4.4),
          LineStringZM.new([
            PointZM.new(1.1, 1.2, 1.3, 1.4),
            PointZM.new(2.1, 2.2, 2.3, 2.4)
          ]),
          PolygonZM.new([
            LineStringZM.new([
              PointZM.new(1.1, 1.2, 1.3, 1.4),
              PointZM.new(2.1, 2.2, 2.3, 2.4),
              PointZM.new(3.3, 2.2, 2.3, 2.4),
              PointZM.new(1.1, 1.2, 1.3, 1.4)
            ])
          ])
        ])

      wkb = """
      01\
      070000C0\
      03000000\
      """

      assert result = GeometryCollectionZM.to_wkb(collection, endian: :ndr)
      assert String.starts_with?(result, Hex.to_binary(wkb))
      assert GeometryCollectionZM.from_wkb!(Hex.from_binary(result)) == collection
    end

    test "returns WKB as ndr-string for a GeometryCollectionZM" do
      collection =
        GeometryCollectionZM.new([
          PointZM.new(1.1, 2.2, 3.3, 4.4),
          LineStringZM.new([
            PointZM.new(1.1, 1.2, 1.3, 1.4),
            PointZM.new(2.1, 2.2, 2.3, 2.4)
          ]),
          PolygonZM.new([
            LineStringZM.new([
              PointZM.new(1.1, 1.2, 1.3, 1.4),
              PointZM.new(2.1, 2.2, 2.3, 2.4),
              PointZM.new(3.3, 2.2, 2.3, 2.4),
              PointZM.new(1.1, 1.2, 1.3, 1.4)
            ])
          ])
        ])

      wkb = """
      01\
      070000C0\
      03000000\
      """

      assert result = GeometryCollectionZM.to_wkb(collection, endian: :ndr, mode: :hex)
      assert String.starts_with?(result, wkb)
      assert GeometryCollectionZM.from_wkb!(result) == collection
    end
  end

  describe "from_wkb!/1" do
    test "returns an empty GeometryCollectionZM" do
      wkb = "01070000C000000000"

      assert GeometryCollectionZM.from_wkb!(wkb) == %GeometryCollectionZM{}
    end

    test "returns a GeometryCollectionZM" do
      wkb = """
      01\
      070000C0\
      01000000\
      01\
      010000C0\
      000000000000F03F000000000000004000000000000008400000000000001040\
      """

      assert GeometryCollectionZM.from_wkb!(wkb) ==
               %GeometryCollectionZM{
                 geometries: MapSet.new([%PointZM{coordinate: [1.0, 2.0, 3.0, 4.0]}])
               }
    end

    test "returns a GeometryCollectionZM with an SRID" do
      wkb = """
      01\
      070000E0\
      37000000\
      01000000\
      01\
      010000C0\
      000000000000F03F000000000000004000000000000008400000000000001040\
      """

      assert GeometryCollectionZM.from_wkb!(wkb) ==
               {%GeometryCollectionZM{
                  geometries: MapSet.new([%PointZM{coordinate: [1.0, 2.0, 3.0, 4.0]}])
                }, 55}
    end

    test "raises an error for an unexpected SRID" do
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
        GeometryCollectionZM.from_wkb!(wkb)
      end
    end
  end

  describe "from_wkb/1" do
    test "returns an empty GeometryCollectionZM" do
      wkb = "01070000C000000000"

      assert GeometryCollectionZM.from_wkb(wkb) == {:ok, %GeometryCollectionZM{}}
    end

    test "returns a GeometryCollectionZM" do
      wkb = """
      01\
      070000C0\
      01000000\
      01\
      010000C0\
      000000000000F03F000000000000004000000000000008400000000000001040\
      """

      assert GeometryCollectionZM.from_wkb(wkb) ==
               {:ok,
                %GeometryCollectionZM{
                  geometries: MapSet.new([%PointZM{coordinate: [1.0, 2.0, 3.0, 4.0]}])
                }}
    end

    test "returns a GeometryCollectionZM with an SRID" do
      wkb = """
      01\
      070000E0\
      37000000\
      01000000\
      01\
      010000C0\
      000000000000F03F000000000000004000000000000008400000000000001040\
      """

      assert GeometryCollectionZM.from_wkb(wkb) ==
               {:ok,
                %GeometryCollectionZM{
                  geometries: MapSet.new([%PointZM{coordinate: [1.0, 2.0, 3.0, 4.0]}])
                }, 55}
    end

    test "returns an error for an unexpected SRID" do
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
               GeometryCollectionZM.from_wkb(wkb)
    end
  end

  describe "from_wkt/1" do
    test "returns a GeometryCollectionZM" do
      assert GeometryCollectionZM.from_wkt("GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))") ==
               {
                 :ok,
                 %GeometryCollectionZM{
                   geometries: MapSet.new([%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}])
                 }
               }
    end

    test "returns a GeometryCollectionZM with an SRID" do
      assert GeometryCollectionZM.from_wkt(
               "SRID=123;GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))"
             ) ==
               {
                 :ok,
                 %GeometryCollectionZM{
                   geometries: MapSet.new([%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}])
                 },
                 123
               }
    end

    test "returns an error for an unexpected SRID" do
      wkt = "SRID=123;GeometryCollection ZM (SRID=666;Point ZM (1.1 2.2 3.3 4.4))"

      assert {:error, "unexpected SRID in collection", "(1.1 2.2 3.3 4.4))", {1, 0}, _offset} =
               GeometryCollectionZM.from_wkt(wkt)
    end
  end

  describe "from_wkt!/1" do
    test "returns a GeometryCollectionZM" do
      assert GeometryCollectionZM.from_wkt!("GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))") ==
               %GeometryCollectionZM{
                 geometries: MapSet.new([%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}])
               }
    end

    test "returns a GeometryCollectionZM with an SRID" do
      assert GeometryCollectionZM.from_wkt!(
               "SRID=123;GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))"
             ) ==
               {%GeometryCollectionZM{
                  geometries: MapSet.new([%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}])
                }, 123}
    end

    test "raises an error for an invalid WKT" do
      message = "no data found at 1:0, got: ''"

      assert_raise Geometry.Error, message, fn ->
        GeometryCollectionZM.from_wkt!("")
      end
    end
  end

  describe "from_geo_json!" do
    test "return GeometryCollectionZM" do
      geo_json =
        Jason.decode!("""
          {
            "type": "GeometryCollection",
            "geometries": [
              {"type": "Point", "coordinates": [1.1, 2.2, 3.3, 4.4]}
            ]
          }
        """)

      assert GeometryCollectionZM.from_geo_json!(geo_json) ==
               %GeometryCollectionZM{
                 geometries: MapSet.new([%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}])
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
        GeometryCollectionZM.from_geo_json!(geo_json)
      end
    end
  end

  test "Enum.slice/3" do
    collection =
      GeometryCollectionZM.new([
        PointZM.new(11, 12, 13, 14),
        LineStringZM.new([
          PointZM.new(21, 22, 23, 24),
          PointZM.new(31, 32, 33, 34)
        ])
      ])

    assert [_geometry] = Enum.slice(collection, 0, 1)
  end
end
