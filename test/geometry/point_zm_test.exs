defmodule Geometry.PointZMTest do
  use ExUnit.Case

  import Prove

  alias Geometry.{LineString, PointZM}

  doctest Geometry.PointZM, import: true

  @moduletag :point

  describe "new/0:" do
    prove PointZM.new() == %PointZM{x: nil, y: nil, z: nil, m: nil}
  end

  describe "new/1:" do
    prove PointZM.new({1, 2, 3, 4}) == %PointZM{x: 1, y: 2, z: 3, m: 4}
    prove PointZM.new([3, 4, 5, 6]) == %PointZM{x: 3, y: 4, z: 5, m: 6}
  end

  describe "new/1" do
    test "raise an exception for invalid tuple argument" do
      assert_raise FunctionClauseError, fn ->
        PointZM.new({1, nil, 3, 4})
      end
    end

    test "raise an exception for invalid list argument" do
      assert_raise FunctionClauseError, fn ->
        PointZM.new([1, 2, 3, nil])
      end
    end
  end

  describe "empty?/1:" do
    prove PointZM.empty?(PointZM.new()) == true
    prove PointZM.empty?(PointZM.new(1, 2, 3, 4)) == false
  end

  describe "to_wkt/1:" do
    @describetag :wkt

    prove PointZM.to_wkt(PointZM.new()) == "Point ZM EMPTY"
    prove PointZM.to_wkt(PointZM.new(3.45, 6.78, 9.01, 11.1)) == "Point ZM (3.45 6.78 9.01 11.1)"
  end

  describe "from_wkt/1:" do
    @describetag :wkt

    prove PointZM.from_wkt("Point ZM (5 4 9 1)") == {:ok, %PointZM{x: 5, y: 4, z: 9, m: 1}}

    prove PointZM.from_wkt("srid=11;Point ZM (1.1 -2.2 3.3 4.4)") ==
            {:ok, %PointZM{x: 1.1, y: -2.2, z: 3.3, m: 4.4}, 11}

    prove PointZM.from_wkt("LineString (5 7, 3 3)") ==
            {:error, %{expected: Geometry.PointZM, got: Geometry.LineString}}

    prove PointZM.from_wkt("Point XY (5 6 7)") == {:error, "expected (", "XY (5 6 7)", {1, 0}, 6}
  end

  describe "from_wkt!/1:" do
    @describetag :wkt

    prove PointZM.from_wkt!("Point ZM (5 4 9 1)") == %PointZM{x: 5, y: 4, z: 9, m: 1}

    prove PointZM.from_wkt!("srid=11;Point ZM (1.1 -2.2 3.3 4.4)") ==
            {%PointZM{x: 1.1, y: -2.2, z: 3.3, m: 4.4}, 11}

    test "raises an exception" do
      message = "expected ( at 1:6, got: 'XY (5 6 7)'"

      assert_raise Geometry.Error, message, fn ->
        PointZM.from_wkt!("Point XY (5 6 7)")
      end
    end
  end

  describe "from_wkb/1" do
    @describetag :wkb

    test "returns ok tuple with PointZM from an xdr-string" do
      wkb = "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"
      assert PointZM.from_wkb(wkb) == {:ok, %PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}}
    end

    test "returns ok tuple with PointZM from an ndr-string" do
      wkb = "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"
      assert PointZM.from_wkb(wkb) == {:ok, %PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}}
    end

    test "returns an error tuple for an unexpected geometry" do
      wkb = "000000000200000000"
      assert PointZM.from_wkb(wkb) == {:error, %{expected: PointZM, got: LineString}}
    end

    test "returns an error tuple for an invalid WKB" do
      wkb = "foo"

      assert PointZM.from_wkb(wkb) ==
               {:error, "expected endian flag '00' or '01', got 'fo'", "o", 0}
    end
  end

  describe "from_wkb!/1" do
    @describetag :wkb

    test "returns ok tuple with PointZM from an xdr-string" do
      wkb = "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"
      assert PointZM.from_wkb!(wkb) == %PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}
    end

    test "returns ok tuple with PointZM from an ndr-string" do
      wkb = "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"
      assert PointZM.from_wkb!(wkb) == %PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}
    end

    test "raises an exception for an invalid WKB" do
      wkb = "foo"
      message = "expected endian flag '00' or '01', got 'fo', at position 0"

      assert_raise Geometry.Error, message, fn ->
        PointZM.from_wkb!(wkb)
      end
    end
  end

  describe "to_wkb/2" do
    @describetag :wkb

    test "returns xdr-string for PointZM" do
      wkb = "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"
      assert PointZM.to_wkb(%PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}, endian: :xdr) == wkb
    end

    test "returns ndr-string for PointZM" do
      wkb = "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"
      assert PointZM.to_wkb(%PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}) == wkb
    end
  end

  describe "to_geo_json/1:" do
    @describetag :geo_json

    prove PointZM.to_geo_json(PointZM.new(3.45, 6.78, 9.01, 11.1)) == %{
            "type" => "Point",
            "coordinates" => [3.45, 6.78, 9.01, 11.1]
          }
  end

  describe "to_geo_json/1" do
    @describetag :geo_json

    test "raise an exception for an empty point" do
      assert_raise FunctionClauseError, fn ->
        PointZM.to_geo_json(PointZM.new())
      end
    end
  end

  describe "from_geo_json/1:" do
    @describetag :geo_json

    @geo_json Jason.decode!("""
              {
                "type": "Point",
                "coordinates": [1.2, 2.3, 4.5, 6.7],
                "foo": 42
              }
              """)

    @geo_json_invalid Jason.decode!("""
                      {"type": "Point", "coordinates": ["invalid"]}
                      """)

    prove PointZM.from_geo_json(@geo_json) == {:ok, %PointZM{x: 1.2, y: 2.3, z: 4.5, m: 6.7}}
    prove PointZM.from_geo_json(%{}) == {:error, :type_not_found}
    prove PointZM.from_geo_json(%{"type" => "Point"}) == {:error, :coordinates_not_found}
    prove PointZM.from_geo_json(@geo_json_invalid) == {:error, :invalid_data}
  end

  describe "from_geo_json!/1" do
    @describetag :geo_json

    test "returns PointZM" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Point",
          "coordinates": [1.2, 2.3, 4.5, 6.7],
          "foo": 42
        }
        """)

      assert PointZM.from_geo_json!(geo_json) == %PointZM{x: 1.2, y: 2.3, z: 4.5, m: 6.7}
    end

    test "raises an exception" do
      geo_json = %{"type" => "Point"}
      message = "coordinates not found"

      assert_raise Geometry.Error, message, fn ->
        PointZM.from_geo_json!(geo_json)
      end
    end
  end

  describe "to_list/1:" do
    prove PointZM.to_list(PointZM.new(5, 7, 8, 42)) == [5, 7, 8, 42]
  end
end
