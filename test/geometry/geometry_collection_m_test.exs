defmodule Geometry.GeometryCollectionMTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  alias Geometry.{
    GeometryCollectionM,
    LineStringM,
    PointM,
    PolygonM
  }

  doctest Geometry.GeometryCollectionM, import: true

  @moduletag :geometry_collection

  describe "to_wkb/2" do
    test "returns WKB for a GeometryCollectionM" do
      collection =
        GeometryCollectionM.new([
          PointM.new(1.1, 2.2, 4.4),
          LineStringM.new([
            PointM.new(1.1, 1.2, 1.4),
            PointM.new(2.1, 2.2, 2.4)
          ]),
          PolygonM.new([
            PointM.new(1.1, 1.2, 1.4),
            PointM.new(2.1, 2.2, 2.4),
            PointM.new(3.3, 2.2, 2.4),
            PointM.new(1.1, 1.2, 1.4)
          ])
        ])

      wkb = """
      01\
      07000040\
      03000000\
      """

      assert result = GeometryCollectionM.to_wkb(collection)
      assert String.starts_with?(result, wkb)
      assert GeometryCollectionM.from_wkb!(result) == collection
    end
  end

  describe "from_wkb!/1" do
    test "returns an empty GeometryCollectionM" do
      wkb = "010700004000000000"

      assert GeometryCollectionM.from_wkb!(wkb) == %GeometryCollectionM{}
    end

    test "returns a GeometryCollectionM" do
      wkb = """
      01\
      07000040\
      01000000\
      01\
      01000040\
      000000000000F03F00000000000000400000000000001040\
      """

      assert GeometryCollectionM.from_wkb!(wkb) ==
               %GeometryCollectionM{
                 geometries: MapSet.new([%PointM{x: 1.0, y: 2.0, m: 4.0}])
               }
    end

    test "returns a GeometryCollectionM with an SRID" do
      wkb = """
      01\
      07000060\
      37000000\
      01000000\
      01\
      01000040\
      000000000000F03F00000000000000400000000000001040\
      """

      assert GeometryCollectionM.from_wkb!(wkb) ==
               {%GeometryCollectionM{
                  geometries: MapSet.new([%PointM{x: 1.0, y: 2.0, m: 4.0}])
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
        GeometryCollectionM.from_wkb!(wkb)
      end
    end
  end

  describe "from_wkb/1" do
    test "returns an empty GeometryCollectionM" do
      wkb = "010700004000000000"

      assert GeometryCollectionM.from_wkb(wkb) == {:ok, %GeometryCollectionM{}}
    end

    test "returns a GeometryCollectionM" do
      wkb = """
      01\
      07000040\
      01000000\
      01\
      01000040\
      000000000000F03F00000000000000400000000000001040\
      """

      assert GeometryCollectionM.from_wkb(wkb) ==
               {:ok,
                %GeometryCollectionM{
                  geometries: MapSet.new([%PointM{x: 1.0, y: 2.0, m: 4.0}])
                }}
    end

    test "returns a GeometryCollectionM with an SRID" do
      wkb = """
      01\
      07000060\
      37000000\
      01000000\
      01\
      01000040\
      000000000000F03F00000000000000400000000000001040\
      """

      assert GeometryCollectionM.from_wkb(wkb) ==
               {:ok,
                %GeometryCollectionM{
                  geometries: MapSet.new([%PointM{x: 1.0, y: 2.0, m: 4.0}])
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
               GeometryCollectionM.from_wkb(wkb)
    end
  end

  describe "from_wkt/1" do
    test "returns a GeometryCollectionM" do
      assert GeometryCollectionM.from_wkt("GeometryCollection M (Point M (1.1 2.2 4.4))") ==
               {
                 :ok,
                 %GeometryCollectionM{
                   geometries: MapSet.new([%PointM{x: 1.1, y: 2.2, m: 4.4}])
                 }
               }
    end

    test "returns a GeometryCollectionM with an SRID" do
      assert GeometryCollectionM.from_wkt(
               "SRID=123;GeometryCollection M (Point M (1.1 2.2 4.4))"
             ) ==
               {
                 :ok,
                 %GeometryCollectionM{
                   geometries: MapSet.new([%PointM{x: 1.1, y: 2.2, m: 4.4}])
                 },
                 123
               }
    end

    test "returns an error for an unexpected SRID" do
      wkt = "SRID=123;GeometryCollection M (SRID=666;Point M (1.1 2.2 4.4))"

      assert {:error, "unexpected SRID in collection", "(1.1 2.2 4.4))", {1, 0}, _offset} =
               GeometryCollectionM.from_wkt(wkt)
    end
  end

  describe "from_wkt!/1" do
    test "returns a GeometryCollectionM" do
      assert GeometryCollectionM.from_wkt!("GeometryCollection M (Point M (1.1 2.2 4.4))") ==
               %GeometryCollectionM{
                 geometries: MapSet.new([%PointM{x: 1.1, y: 2.2, m: 4.4}])
               }
    end

    test "returns a GeometryCollectionM with an SRID" do
      assert GeometryCollectionM.from_wkt!(
               "SRID=123;GeometryCollection M (Point M (1.1 2.2 4.4))"
             ) ==
               {%GeometryCollectionM{
                  geometries: MapSet.new([%PointM{x: 1.1, y: 2.2, m: 4.4}])
                }, 123}
    end

    test "raises an error for an invalid WKT" do
      message = "no data found at 1:0, got: ''"

      assert_raise Geometry.Error, message, fn ->
        GeometryCollectionM.from_wkt!("")
      end
    end
  end

  describe "from_geo_json!" do
    test "return GeometryCollectionM" do
      geo_json =
        Jason.decode!("""
          {
            "type": "GeometryCollection",
            "geometries": [
              {"type": "Point", "coordinates": [1.1, 2.2, 4.4]}
            ]
          }
        """)

      assert GeometryCollectionM.from_geo_json!(geo_json) ==
               %GeometryCollectionM{
                 geometries: MapSet.new([%PointM{x: 1.1, y: 2.2, m: 4.4}])
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
        GeometryCollectionM.from_geo_json!(geo_json)
      end
    end
  end
end
