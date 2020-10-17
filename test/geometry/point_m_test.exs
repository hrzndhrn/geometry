defmodule Geometry.PointMTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{LineString, PointM}

  doctest Geometry.PointM, import: true

  @moduletag :point

  describe "new/0:" do
    prove PointM.new() == %PointM{x: nil, y: nil, m: nil}
  end

  describe "new/1:" do
    prove PointM.new({1, 2, 4}) == %PointM{x: 1, y: 2, m: 4}
    prove PointM.new([3, 4, 6]) == %PointM{x: 3, y: 4, m: 6}
  end

  describe "new/1" do
    test "raise an exception for invalid tuple argument" do
      assert_raise FunctionClauseError, fn ->
        PointM.new({1, nil, 3, 4})
      end
    end

    test "raise an exception for invalid list argument" do
      assert_raise FunctionClauseError, fn ->
        PointM.new([1, 2, 3, nil])
      end
    end
  end

  describe "empty?/1:" do
    prove PointM.empty?(PointM.new()) == true
    prove PointM.empty?(PointM.new(1, 2, 4)) == false
  end

  describe "to_wkt/1:" do
    prove PointM.to_wkt(PointM.new()) == "Point M EMPTY"
    prove PointM.to_wkt(PointM.new(3.45, 6.78, 11.1)) == "Point M (3.45 6.78 11.1)"
  end

  describe "from_wkt/1:" do
    prove PointM.from_wkt("Point M empty") == {:ok, %PointM{}}

    prove PointM.from_wkt("Point M (5 4 1)") == {:ok, %PointM{x: 5, y: 4, m: 1}}

    prove PointM.from_wkt("srid=11;Point M (1.1 -2.2 4.4)") ==
            {:ok, %PointM{x: 1.1, y: -2.2, m: 4.4}, 11}

    prove PointM.from_wkt("LineString (5 7, 3 3)") ==
            {:error, %{expected: Geometry.PointM, got: Geometry.LineString}}

    prove PointM.from_wkt("Point XY (5 6 7)") ==
            {:error, "expected Point data", "XY (5 6 7)", {1, 0}, 6}
  end

  describe "from_wkt!/1:" do
    prove PointM.from_wkt!("Point M (5 4 1)") == %PointM{x: 5, y: 4, m: 1}

    prove PointM.from_wkt!("srid=11;Point M (1.1 -2.2 4.4)") ==
            {%PointM{x: 1.1, y: -2.2, m: 4.4}, 11}

    test "raises an exception" do
      message = "expected Point data at 1:6, got: 'XY (5 6 7)'"

      assert_raise Geometry.Error, message, fn ->
        PointM.from_wkt!("Point XY (5 6 7)")
      end
    end
  end

  describe "from_wkb/1" do
    test "returns ok tuple with PointM from an xdr-string" do
      wkb = "00400000013FF199999999999A400199999999999A401199999999999A"
      assert PointM.from_wkb(wkb) == {:ok, %PointM{x: 1.1, y: 2.2, m: 4.4}}
    end

    test "returns ok tuple with PointM from an ndr-string" do
      wkb = "01010000409A9999999999F13F9A999999999901409A99999999991140"
      assert PointM.from_wkb(wkb) == {:ok, %PointM{x: 1.1, y: 2.2, m: 4.4}}
    end

    test "returns an error tuple for an unexpected geometry" do
      wkb = "000000000200000000"
      assert PointM.from_wkb(wkb) == {:error, %{expected: PointM, got: LineString}}
    end

    test "returns an error tuple for an invalid WKB" do
      wkb = "foo"

      assert PointM.from_wkb(wkb) ==
               {:error, "expected endian flag '00' or '01', got 'fo'", "o", 0}
    end
  end

  describe "from_wkb!/1" do
    test "returns ok tuple with PointM from an xdr-string" do
      wkb = "00400000013FF199999999999A400199999999999A401199999999999A"
      assert PointM.from_wkb!(wkb) == %PointM{x: 1.1, y: 2.2, m: 4.4}
    end

    test "returns ok tuple with PointM from an ndr-string" do
      wkb = "01010000409A9999999999F13F9A999999999901409A99999999991140"
      assert PointM.from_wkb!(wkb) == %PointM{x: 1.1, y: 2.2, m: 4.4}
    end

    test "raises an exception for an invalid WKB" do
      wkb = "foo"
      message = "expected endian flag '00' or '01', got 'fo', at position 0"

      assert_raise Geometry.Error, message, fn ->
        PointM.from_wkb!(wkb)
      end
    end
  end

  describe "to_wkb/2" do
    test "returns xdr-string for PointM" do
      wkb = "00400000013FF199999999999A400199999999999A401199999999999A"
      assert PointM.to_wkb(%PointM{x: 1.1, y: 2.2, m: 4.4}, endian: :xdr) == wkb
    end

    test "returns ndr-string for PointM" do
      wkb = "01010000409A9999999999F13F9A999999999901409A99999999991140"
      assert PointM.to_wkb(%PointM{x: 1.1, y: 2.2, m: 4.4}) == wkb
    end
  end

  describe "to_geo_json/1:" do
    prove PointM.to_geo_json(PointM.new(3.45, 6.78, 11.1)) == %{
            "type" => "Point",
            "coordinates" => [3.45, 6.78, 11.1]
          }
  end

  describe "to_geo_json/1" do
    test "raise an exception for an empty point" do
      assert_raise FunctionClauseError, fn ->
        PointM.to_geo_json(PointM.new())
      end
    end
  end

  describe "from_geo_json/1:" do
    @geo_json Jason.decode!("""
              {
                "type": "Point",
                "coordinates": [1.2, 2.3, 6.7],
                "foo": 42
              }
              """)

    @geo_json_invalid Jason.decode!("""
                      {"type": "Point", "coordinates": ["invalid"]}
                      """)

    prove PointM.from_geo_json(@geo_json) == {:ok, %PointM{x: 1.2, y: 2.3, m: 6.7}}
    prove PointM.from_geo_json(%{}) == {:error, :type_not_found}
    prove PointM.from_geo_json(%{"type" => "Point"}) == {:error, :coordinates_not_found}
    prove PointM.from_geo_json(@geo_json_invalid) == {:error, :invalid_data}
  end

  describe "from_geo_json!/1" do
    test "returns PointM" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Point",
          "coordinates": [1.2, 2.3, 6.7],
          "foo": 42
        }
        """)

      assert PointM.from_geo_json!(geo_json) == %PointM{x: 1.2, y: 2.3, m: 6.7}
    end

    test "raises an exception" do
      geo_json = %{"type" => "Point"}
      message = "coordinates not found"

      assert_raise Geometry.Error, message, fn ->
        PointM.from_geo_json!(geo_json)
      end
    end
  end

  describe "to_list/1:" do
    prove PointM.to_list(PointM.new(5, 7, 42)) == [5, 7, 42]
  end
end
