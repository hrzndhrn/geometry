defmodule Geometry.PointZTest do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{Hex, LineString, PointZ}

  doctest PointZ, import: true

  @moduletag :point

  describe "new/0:" do
    prove PointZ.new() == %PointZ{coordinate: nil}
  end

  describe "new/1:" do
    prove PointZ.new([3, 4, 5]) == %PointZ{coordinate: [3, 4, 5]}
  end

  describe "new/1" do
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

    prove PointZ.to_wkt(PointZ.new(3.45, 6.78, 9.01), srid: 55) ==
            "SRID=55;Point Z (3.45 6.78 9.01)"

    prove PointZ.to_wkt(PointZ.new(3.45, 6.78, 9.01), foo: 55) ==
            "Point Z (3.45 6.78 9.01)"
  end

  describe "from_wkt/1:" do
    prove PointZ.from_wkt("Point Z empty") == {:ok, %PointZ{}}

    prove PointZ.from_wkt("Point Z (5 4 9)") ==
            {:ok, %PointZ{coordinate: [5, 4, 9]}}

    prove PointZ.from_wkt("srid=11;Point Z (1.1 -2.2 3.3)") ==
            {:ok, {%PointZ{coordinate: [1.1, -2.2, 3.3]}, 11}}

    prove PointZ.from_wkt("LineString Z (5 7 8, 3 3 3)") ==
            {:error, %{expected: Geometry.PointZ, got: Geometry.LineStringZ}}

    prove PointZ.from_wkt("Point XY (5 6 7)") ==
            {:error, "expected Point data", "XY (5 6 7)", {1, 0}, 6}
  end

  describe "from_wkt!/1:" do
    prove PointZ.from_wkt!("Point Z (5 4 9)") == %PointZ{coordinate: [5, 4, 9]}

    prove PointZ.from_wkt!("srid=11;Point Z (1.1 -2.2 3.3)") ==
            {%PointZ{coordinate: [1.1, -2.2, 3.3]}, 11}

    test "raises an exception" do
      message = ~s[expected Point data at 1:6, got: "XY (5 6 7)"]

      assert_raise Geometry.Error, message, fn ->
        PointZ.from_wkt!("Point XY (5 6 7)")
      end
    end
  end

  describe "from_wkb/2" do
    test "returns ok tuple with PointZ from xdr-binary" do
      wkb = "00800000013FF199999999999A400199999999999A400A666666666666"

      assert wkb
             |> Hex.to_binary()
             |> PointZ.from_wkb() == {:ok, %PointZ{coordinate: [1.1, 2.2, 3.3]}}
    end

    test "returns ok tuple with PointZ from xdr-string" do
      wkb = "00800000013FF199999999999A400199999999999A400A666666666666"

      assert PointZ.from_wkb(wkb, :hex) == {:ok, %PointZ{coordinate: [1.1, 2.2, 3.3]}}
    end

    test "returns ok tuple with PointZ from ndr-string" do
      wkb = "01010000809A9999999999F13F9A999999999901406666666666660A40"
      assert PointZ.from_wkb(wkb, :hex) == {:ok, %PointZ{coordinate: [1.1, 2.2, 3.3]}}
    end

    test "returns ok tuple with PointZ from ndr-binary" do
      wkb = "01010000809A9999999999F13F9A999999999901406666666666660A40"

      assert wkb
             |> Hex.to_binary()
             |> PointZ.from_wkb() == {:ok, %PointZ{coordinate: [1.1, 2.2, 3.3]}}
    end

    test "returns an error tuple for an unexpected geometry from xdr-string" do
      wkb = "000000000200000000"
      assert PointZ.from_wkb(wkb, :hex) == {:error, %{expected: PointZ, got: LineString}}
    end

    test "returns an error tuple for an unexpected geometry from xdr-binary" do
      wkb = "000000000200000000"

      assert wkb |> Hex.to_binary() |> PointZ.from_wkb() ==
               {:error, %{expected: PointZ, got: LineString}}
    end

    test "returns an error tuple for an invalid WKB string" do
      wkb = "foo"

      assert PointZ.from_wkb(wkb, :hex) ==
               {:error, ~s(expected endian flag "00" or "01", got "fo"), "o", 0}
    end

    test "returns an error tuple for an invalid WKB binary" do
      wkb = "foo"

      assert PointZ.from_wkb(wkb) ==
               {:error, "expected endian flag", "foo", 0}
    end
  end

  describe "from_wkb!/2" do
    test "returns ok tuple with PointZ from xdr-string" do
      wkb = "00800000013FF199999999999A400199999999999A400A666666666666"
      assert PointZ.from_wkb!(wkb, :hex) == %PointZ{coordinate: [1.1, 2.2, 3.3]}
    end

    test "returns ok tuple with PointZ from ndr-string" do
      wkb = "01010000809A9999999999F13F9A999999999901406666666666660A40"
      assert PointZ.from_wkb!(wkb, :hex) == %PointZ{coordinate: [1.1, 2.2, 3.3]}
    end

    test "returns ok tuple with PointZ from xdr-binary" do
      wkb = "00800000013FF199999999999A400199999999999A400A666666666666"

      assert wkb
             |> Hex.to_binary()
             |> PointZ.from_wkb!() == %PointZ{coordinate: [1.1, 2.2, 3.3]}
    end

    test "returns ok tuple with PointZ from ndr-binary" do
      wkb = "01010000809A9999999999F13F9A999999999901406666666666660A40"

      assert wkb
             |> Hex.to_binary()
             |> PointZ.from_wkb!() == %PointZ{coordinate: [1.1, 2.2, 3.3]}
    end

    test "raises an exception for an invalid WKB string" do
      wkb = "foo"
      message = ~s(expected endian flag "00" or "01", got "fo", at position 0)

      assert_raise Geometry.Error, message, fn ->
        PointZ.from_wkb!(wkb, :hex)
      end
    end

    test "raises an exception for an invalid WKB binary" do
      wkb = "foo"
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        PointZ.from_wkb!(wkb)
      end
    end
  end

  describe "to_wkb/2" do
    test "returns xdr-string for PointZ" do
      wkb = "00800000013FF199999999999A400199999999999A400A666666666666"
      assert PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), mode: :hex) == wkb
      assert PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), mode: :hex, endian: :xdr) == wkb
    end

    test "returns xdr-binary for PointZ" do
      wkb = Hex.to_binary("00800000013FF199999999999A400199999999999A400A666666666666")

      assert PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3)) == wkb
      assert PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), endian: :xdr) == wkb
    end

    test "returns xdr-string for PointZ with SRID" do
      wkb = "00A00000010000014D3FF199999999999A400199999999999A400A666666666666"
      assert PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), srid: 333, mode: :hex) == wkb
    end

    test "returns xdr-binary for PointZ with SRID" do
      wkb = Hex.to_binary("00A00000010000014D3FF199999999999A400199999999999A400A666666666666")

      assert PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), srid: 333) == wkb
    end

    test "returns ndr-string for PointZ" do
      wkb = "01010000809A9999999999F13F9A999999999901406666666666660A40"
      assert PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), endian: :ndr, mode: :hex) == wkb
    end

    test "returns ndr-binary for PointZ" do
      wkb = Hex.to_binary("01010000809A9999999999F13F9A999999999901406666666666660A40")

      assert PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), endian: :ndr) == wkb
    end

    test "returns ndr-string for PointZ with SRID" do
      wkb = "01010000A04D0100009A9999999999F13F9A999999999901406666666666660A40"

      assert PointZ.to_wkb(
               PointZ.new(1.1, 2.2, 3.3),
               endian: :ndr,
               srid: 333,
               mode: :hex
             ) == wkb
    end

    test "returns ndr-binary for PointZ with SRID" do
      wkb = "01010000A04D0100009A9999999999F13F9A999999999901406666666666660A40"

      assert PointZ.to_wkb(
               PointZ.new(1.1, 2.2, 3.3),
               endian: :ndr,
               srid: 333
             ) == Hex.to_binary(wkb)
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

    prove PointZ.from_geo_json(@geo_json) == {:ok, %PointZ{coordinate: [1.2, 2.3, 4.5]}}
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

      assert PointZ.from_geo_json!(geo_json) == %PointZ{coordinate: [1.2, 2.3, 4.5]}
    end

    test "raises an exception" do
      geo_json = %{"type" => "Point"}
      message = "coordinates not found"

      assert_raise Geometry.Error, message, fn ->
        PointZ.from_geo_json!(geo_json)
      end
    end
  end
end
