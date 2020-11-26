defmodule Geometry.PointTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{Hex, LineString, Point}

  doctest Point, import: true

  @moduletag :point

  describe "new/0:" do
    prove Point.new() == %Point{coordinate: nil}
  end

  describe "new/1:" do
    prove Point.new([3, 4]) == %Point{coordinate: [3, 4]}
  end

  describe "new/1" do
    test "raise an exception for invalid list argument" do
      assert_raise FunctionClauseError, fn ->
        Point.new([1, 2, 3, nil])
      end
    end
  end

  describe "empty?/1:" do
    prove Point.empty?(Point.new()) == true
    prove Point.empty?(Point.new(1, 2)) == false
  end

  describe "to_wkt/1:" do
    prove Point.to_wkt(Point.new()) == "Point EMPTY"
    prove Point.to_wkt(Point.new(3.45, 6.78)) == "Point (3.45 6.78)"

    prove Point.to_wkt(Point.new(3.45, 6.78), srid: 55) ==
            "SRID=55;Point (3.45 6.78)"

    prove Point.to_wkt(Point.new(3.45, 6.78), foo: 55) ==
            "Point (3.45 6.78)"
  end

  describe "from_wkt/1:" do
    prove Point.from_wkt("Point empty") == {:ok, %Point{}}

    prove Point.from_wkt("Point (5 4)") ==
            {:ok, %Point{coordinate: [5, 4]}}

    prove Point.from_wkt("srid=11;Point (1.1 -2.2)") ==
            {:ok, {%Point{coordinate: [1.1, -2.2]}, 11}}

    prove Point.from_wkt("LineString (5 7, 3 3)") ==
            {:error, %{expected: Geometry.Point, got: Geometry.LineString}}

    prove Point.from_wkt("Point XY (5 6 7)") ==
            {:error, "expected Point data", "XY (5 6 7)", {1, 0}, 6}
  end

  describe "from_wkt!/1:" do
    prove Point.from_wkt!("Point (5 4)") == %Point{coordinate: [5, 4]}

    prove Point.from_wkt!("srid=11;Point (1.1 -2.2)") ==
            {%Point{coordinate: [1.1, -2.2]}, 11}

    test "raises an exception" do
      message = ~s[expected Point data at 1:6, got: "XY (5 6 7)"]

      assert_raise Geometry.Error, message, fn ->
        Point.from_wkt!("Point XY (5 6 7)")
      end
    end
  end

  describe "from_wkb/2" do
    test "returns ok tuple with Point from xdr-binary" do
      wkb = "00000000013FF199999999999A400199999999999A"

      assert wkb
             |> Hex.to_binary()
             |> Point.from_wkb() == {:ok, %Point{coordinate: [1.1, 2.2]}}
    end

    test "returns ok tuple with Point from xdr-string" do
      wkb = "00000000013FF199999999999A400199999999999A"

      assert Point.from_wkb(wkb, :hex) == {:ok, %Point{coordinate: [1.1, 2.2]}}
    end

    test "returns ok tuple with Point from ndr-string" do
      wkb = "01010000009A9999999999F13F9A99999999990140"
      assert Point.from_wkb(wkb, :hex) == {:ok, %Point{coordinate: [1.1, 2.2]}}
    end

    test "returns ok tuple with Point from ndr-binary" do
      wkb = "01010000009A9999999999F13F9A99999999990140"

      assert wkb
             |> Hex.to_binary()
             |> Point.from_wkb() == {:ok, %Point{coordinate: [1.1, 2.2]}}
    end

    test "returns an error tuple for an unexpected geometry from xdr-string" do
      wkb = "000000000200000000"
      assert Point.from_wkb(wkb, :hex) == {:error, %{expected: Point, got: LineString}}
    end

    test "returns an error tuple for an unexpected geometry from xdr-binary" do
      wkb = "000000000200000000"

      assert wkb |> Hex.to_binary() |> Point.from_wkb() ==
               {:error, %{expected: Point, got: LineString}}
    end

    test "returns an error tuple for an invalid WKB string" do
      wkb = "foo"

      assert Point.from_wkb(wkb, :hex) ==
               {:error, ~s(expected endian flag "00" or "01", got "fo"), "o", 0}
    end

    test "returns an error tuple for an invalid WKB binary" do
      wkb = "foo"

      assert Point.from_wkb(wkb) ==
               {:error, "expected endian flag", "foo", 0}
    end
  end

  describe "from_wkb!/2" do
    test "returns ok tuple with Point from xdr-string" do
      wkb = "00000000013FF199999999999A400199999999999A"
      assert Point.from_wkb!(wkb, :hex) == %Point{coordinate: [1.1, 2.2]}
    end

    test "returns ok tuple with Point from ndr-string" do
      wkb = "01010000009A9999999999F13F9A99999999990140"
      assert Point.from_wkb!(wkb, :hex) == %Point{coordinate: [1.1, 2.2]}
    end

    test "returns ok tuple with Point from xdr-binary" do
      wkb = "00000000013FF199999999999A400199999999999A"

      assert wkb
             |> Hex.to_binary()
             |> Point.from_wkb!() == %Point{coordinate: [1.1, 2.2]}
    end

    test "returns ok tuple with Point from ndr-binary" do
      wkb = "01010000009A9999999999F13F9A99999999990140"

      assert wkb
             |> Hex.to_binary()
             |> Point.from_wkb!() == %Point{coordinate: [1.1, 2.2]}
    end

    test "raises an exception for an invalid WKB string" do
      wkb = "foo"
      message = ~s(expected endian flag "00" or "01", got "fo", at position 0)

      assert_raise Geometry.Error, message, fn ->
        Point.from_wkb!(wkb, :hex)
      end
    end

    test "raises an exception for an invalid WKB binary" do
      wkb = "foo"
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        Point.from_wkb!(wkb)
      end
    end
  end

  describe "to_wkb/2" do
    test "returns xdr-string for Point" do
      wkb = "00000000013FF199999999999A400199999999999A"
      assert Point.to_wkb(Point.new(1.1, 2.2), mode: :hex) == wkb
      assert Point.to_wkb(Point.new(1.1, 2.2), mode: :hex, endian: :xdr) == wkb
    end

    test "returns xdr-binary for Point" do
      wkb = Hex.to_binary("00000000013FF199999999999A400199999999999A")

      assert Point.to_wkb(Point.new(1.1, 2.2)) == wkb
      assert Point.to_wkb(Point.new(1.1, 2.2), endian: :xdr) == wkb
    end

    test "returns xdr-string for Point with SRID" do
      wkb = "00200000010000014D3FF199999999999A400199999999999A"
      assert Point.to_wkb(Point.new(1.1, 2.2), srid: 333, mode: :hex) == wkb
    end

    test "returns xdr-binary for Point with SRID" do
      wkb = Hex.to_binary("00200000010000014D3FF199999999999A400199999999999A")

      assert Point.to_wkb(Point.new(1.1, 2.2), srid: 333) == wkb
    end

    test "returns ndr-string for Point" do
      wkb = "01010000009A9999999999F13F9A99999999990140"
      assert Point.to_wkb(Point.new(1.1, 2.2), endian: :ndr, mode: :hex) == wkb
    end

    test "returns ndr-binary for Point" do
      wkb = Hex.to_binary("01010000009A9999999999F13F9A99999999990140")

      assert Point.to_wkb(Point.new(1.1, 2.2), endian: :ndr) == wkb
    end

    test "returns ndr-string for Point with SRID" do
      wkb = "01010000204D0100009A9999999999F13F9A99999999990140"

      assert Point.to_wkb(
               Point.new(1.1, 2.2),
               endian: :ndr,
               srid: 333,
               mode: :hex
             ) == wkb
    end

    test "returns ndr-binary for Point with SRID" do
      wkb = "01010000204D0100009A9999999999F13F9A99999999990140"

      assert Point.to_wkb(
               Point.new(1.1, 2.2),
               endian: :ndr,
               srid: 333
             ) == Hex.to_binary(wkb)
    end
  end

  describe "to_geo_json/1:" do
    prove Point.to_geo_json(Point.new(3.45, 6.78)) == %{
            "type" => "Point",
            "coordinates" => [3.45, 6.78]
          }
  end

  describe "to_geo_json/1" do
    test "raise an exception for an empty point" do
      assert_raise FunctionClauseError, fn ->
        Point.to_geo_json(Point.new())
      end
    end
  end

  describe "from_geo_json/1:" do
    @geo_json Jason.decode!("""
              {
                "type": "Point",
                "coordinates": [1.2, 2.3],
                "foo": 42
              }
              """)

    @geo_json_invalid Jason.decode!("""
                      {"type": "Point", "coordinates": ["invalid"]}
                      """)

    prove Point.from_geo_json(@geo_json) == {:ok, %Point{coordinate: [1.2, 2.3]}}
    prove Point.from_geo_json(%{}) == {:error, :type_not_found}
    prove Point.from_geo_json(%{"type" => "Point"}) == {:error, :coordinates_not_found}
    prove Point.from_geo_json(@geo_json_invalid) == {:error, :invalid_data}
  end

  describe "from_geo_json!/1" do
    test "returns Point" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Point",
          "coordinates": [1.2, 2.3],
          "foo": 42
        }
        """)

      assert Point.from_geo_json!(geo_json) == %Point{coordinate: [1.2, 2.3]}
    end

    test "raises an exception" do
      geo_json = %{"type" => "Point"}
      message = "coordinates not found"

      assert_raise Geometry.Error, message, fn ->
        Point.from_geo_json!(geo_json)
      end
    end
  end
end
