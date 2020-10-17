defmodule Geometry.PointZTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{LineString, PointZ}

  doctest Geometry.PointZ, import: true

  @moduletag :point

  describe "new/0:" do
    prove PointZ.new() == %PointZ{x: nil, y: nil, z: nil}
  end

  describe "new/1:" do
    prove PointZ.new({1, 2, 3}) == %PointZ{x: 1, y: 2, z: 3}
    prove PointZ.new([3, 4, 5]) == %PointZ{x: 3, y: 4, z: 5}
  end

  describe "new/1" do
    test "raise an exception for invalid tuple argument" do
      assert_raise FunctionClauseError, fn ->
        PointZ.new({1, nil, 3, 4})
      end
    end

    test "raise an exception for invalid list argument" do
      assert_raise FunctionClauseError, fn ->
        PointZ.new([1, 2, 3, nil])
      end
    end
  end

  describe "empty?/1:" do
    prove PointZ.empty?(PointZ.new()) == true
    prove PointZ.empty?(PointZ.new(1, 2, 3)) == false
  end

  describe "to_wkt/1:" do
    prove PointZ.to_wkt(PointZ.new()) == "Point Z EMPTY"
    prove PointZ.to_wkt(PointZ.new(3.45, 6.78, 9.01)) == "Point Z (3.45 6.78 9.01)"
  end

  describe "from_wkt/1:" do
    prove PointZ.from_wkt("Point Z empty") == {:ok, %PointZ{}}

    prove PointZ.from_wkt("Point Z (5 4 9)") == {:ok, %PointZ{x: 5, y: 4, z: 9}}

    prove PointZ.from_wkt("srid=11;Point Z (1.1 -2.2 3.3)") ==
            {:ok, %PointZ{x: 1.1, y: -2.2, z: 3.3}, 11}

    prove PointZ.from_wkt("LineString (5 7, 3 3)") ==
            {:error, %{expected: Geometry.PointZ, got: Geometry.LineString}}

    prove PointZ.from_wkt("Point XY (5 6 7)") ==
            {:error, "expected Point data", "XY (5 6 7)", {1, 0}, 6}
  end

  describe "from_wkt!/1:" do
    prove PointZ.from_wkt!("Point Z (5 4 9)") == %PointZ{x: 5, y: 4, z: 9}

    prove PointZ.from_wkt!("srid=11;Point Z (1.1 -2.2 3.3)") ==
            {%PointZ{x: 1.1, y: -2.2, z: 3.3}, 11}

    test "raises an exception" do
      message = "expected Point data at 1:6, got: 'XY (5 6 7)'"

      assert_raise Geometry.Error, message, fn ->
        PointZ.from_wkt!("Point XY (5 6 7)")
      end
    end
  end

  describe "from_wkb/1" do
    test "returns ok tuple with PointZ from an xdr-string" do
      wkb = "00800000013FF199999999999A400199999999999A400A666666666666"
      assert PointZ.from_wkb(wkb) == {:ok, %PointZ{x: 1.1, y: 2.2, z: 3.3}}
    end

    test "returns ok tuple with PointZ from an ndr-string" do
      wkb = "01010000809A9999999999F13F9A999999999901406666666666660A40"
      assert PointZ.from_wkb(wkb) == {:ok, %PointZ{x: 1.1, y: 2.2, z: 3.3}}
    end

    test "returns an error tuple for an unexpected geometry" do
      wkb = "000000000200000000"
      assert PointZ.from_wkb(wkb) == {:error, %{expected: PointZ, got: LineString}}
    end

    test "returns an error tuple for an invalid WKB" do
      wkb = "foo"

      assert PointZ.from_wkb(wkb) ==
               {:error, "expected endian flag '00' or '01', got 'fo'", "o", 0}
    end
  end

  describe "from_wkb!/1" do
    test "returns ok tuple with PointZ from an xdr-string" do
      wkb = "00800000013FF199999999999A400199999999999A400A666666666666"
      assert PointZ.from_wkb!(wkb) == %PointZ{x: 1.1, y: 2.2, z: 3.3}
    end

    test "returns ok tuple with PointZ from an ndr-string" do
      wkb = "01010000809A9999999999F13F9A999999999901406666666666660A40"
      assert PointZ.from_wkb!(wkb) == %PointZ{x: 1.1, y: 2.2, z: 3.3}
    end

    test "raises an exception for an invalid WKB" do
      wkb = "foo"
      message = "expected endian flag '00' or '01', got 'fo', at position 0"

      assert_raise Geometry.Error, message, fn ->
        PointZ.from_wkb!(wkb)
      end
    end
  end

  describe "to_wkb/2" do
    test "returns xdr-string for PointZ" do
      wkb = "00800000013FF199999999999A400199999999999A400A666666666666"
      assert PointZ.to_wkb(%PointZ{x: 1.1, y: 2.2, z: 3.3}, endian: :xdr) == wkb
    end

    test "returns ndr-string for PointZ" do
      wkb = "01010000809A9999999999F13F9A999999999901406666666666660A40"
      assert PointZ.to_wkb(%PointZ{x: 1.1, y: 2.2, z: 3.3}) == wkb
    end
  end

  describe "to_geo_json/1:" do
    prove PointZ.to_geo_json(PointZ.new(3.45, 6.78, 9.01)) == %{
            "type" => "Point",
            "coordinates" => [3.45, 6.78, 9.01]
          }
  end

  describe "to_geo_json/1" do
    test "raise an exception for an empty point" do
      assert_raise FunctionClauseError, fn ->
        PointZ.to_geo_json(PointZ.new())
      end
    end
  end

  describe "from_geo_json/1:" do
    @geo_json Jason.decode!("""
              {
                "type": "Point",
                "coordinates": [1.2, 2.3, 4.5],
                "foo": 42
              }
              """)

    @geo_json_invalid Jason.decode!("""
                      {"type": "Point", "coordinates": ["invalid"]}
                      """)

    prove PointZ.from_geo_json(@geo_json) == {:ok, %PointZ{x: 1.2, y: 2.3, z: 4.5}}
    prove PointZ.from_geo_json(%{}) == {:error, :type_not_found}
    prove PointZ.from_geo_json(%{"type" => "Point"}) == {:error, :coordinates_not_found}
    prove PointZ.from_geo_json(@geo_json_invalid) == {:error, :invalid_data}
  end

  describe "from_geo_json!/1" do
    test "returns PointZ" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Point",
          "coordinates": [1.2, 2.3, 4.5],
          "foo": 42
        }
        """)

      assert PointZ.from_geo_json!(geo_json) == %PointZ{x: 1.2, y: 2.3, z: 4.5}
    end

    test "raises an exception" do
      geo_json = %{"type" => "Point"}
      message = "coordinates not found"

      assert_raise Geometry.Error, message, fn ->
        PointZ.from_geo_json!(geo_json)
      end
    end
  end

  describe "to_list/1:" do
    prove PointZ.to_list(PointZ.new(5, 7, 8)) == [5, 7, 8]
  end
end
