defmodule Geometry.PointZMTest do
  use ExUnit.Case, async: true

  import Prove

  alias Geometry.{Hex, LineString, PointZM}

  doctest PointZM, import: true

  @moduletag :point

  describe "new/0:" do
    prove PointZM.new() == %PointZM{coordinate: nil}
  end

  describe "new/1:" do
    prove PointZM.new([3, 4, 5, 6]) == %PointZM{coordinate: [3, 4, 5, 6]}
  end

  describe "new/1" do
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
    prove PointZM.to_wkt(PointZM.new()) == "Point ZM EMPTY"
    prove PointZM.to_wkt(PointZM.new(3.45, 6.78, 9.01, 11.1)) == "Point ZM (3.45 6.78 9.01 11.1)"

    prove PointZM.to_wkt(PointZM.new(3.45, 6.78, 9.01, 11.1), srid: 55) ==
            "SRID=55;Point ZM (3.45 6.78 9.01 11.1)"

    prove PointZM.to_wkt(PointZM.new(3.45, 6.78, 9.01, 11.1), foo: 55) ==
            "Point ZM (3.45 6.78 9.01 11.1)"
  end

  describe "from_wkt/1:" do
    prove PointZM.from_wkt("Point ZM empty") == {:ok, %PointZM{}}

    prove PointZM.from_wkt("Point ZM (5 4 9 1)") ==
            {:ok, %PointZM{coordinate: [5, 4, 9, 1]}}

    prove PointZM.from_wkt("srid=11;Point ZM (1.1 -2.2 3.3 4.4)") ==
            {:ok, %PointZM{coordinate: [1.1, -2.2, 3.3, 4.4]}, 11}

    prove PointZM.from_wkt("LineString ZM (5 7 8 9, 3 3 3 3)") ==
            {:error, %{expected: Geometry.PointZM, got: Geometry.LineStringZM}}

    prove PointZM.from_wkt("Point XY (5 6 7)") ==
            {:error, "expected Point data", "XY (5 6 7)", {1, 0}, 6}
  end

  describe "from_wkt!/1:" do
    prove PointZM.from_wkt!("Point ZM (5 4 9 1)") == %PointZM{coordinate: [5, 4, 9, 1]}

    prove PointZM.from_wkt!("srid=11;Point ZM (1.1 -2.2 3.3 4.4)") ==
            {%PointZM{coordinate: [1.1, -2.2, 3.3, 4.4]}, 11}

    test "raises an exception" do
      message = ~s[expected Point data at 1:6, got: "XY (5 6 7)"]

      assert_raise Geometry.Error, message, fn ->
        PointZM.from_wkt!("Point XY (5 6 7)")
      end
    end
  end

  describe "from_wkb/2" do
    test "returns ok tuple with PointZM from xdr-binary" do
      wkb = "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"

      assert wkb
             |> Hex.to_binary()
             |> PointZM.from_wkb() == {:ok, %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}}
    end

    test "returns ok tuple with PointZM from xdr-string" do
      wkb = "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"

      assert PointZM.from_wkb(wkb, :hex) == {:ok, %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}}
    end

    test "returns ok tuple with PointZM from ndr-string" do
      wkb = "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"
      assert PointZM.from_wkb(wkb, :hex) == {:ok, %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}}
    end

    test "returns ok tuple with PointZM from ndr-binary" do
      wkb = "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"

      assert wkb
             |> Hex.to_binary()
             |> PointZM.from_wkb() == {:ok, %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}}
    end

    test "returns an error tuple for an unexpected geometry from xdr-string" do
      wkb = "000000000200000000"
      assert PointZM.from_wkb(wkb, :hex) == {:error, %{expected: PointZM, got: LineString}}
    end

    test "returns an error tuple for an unexpected geometry from xdr-binary" do
      wkb = "000000000200000000"

      assert wkb |> Hex.to_binary() |> PointZM.from_wkb() ==
               {:error, %{expected: PointZM, got: LineString}}
    end

    test "returns an error tuple for an invalid WKB string" do
      wkb = "foo"

      assert PointZM.from_wkb(wkb, :hex) ==
               {:error, ~s(expected endian flag "00" or "01", got "fo"), "o", 0}
    end

    test "returns an error tuple for an invalid WKB binary" do
      wkb = "foo"

      assert PointZM.from_wkb(wkb) ==
               {:error, "expected endian flag", "foo", 0}
    end
  end

  describe "from_wkb!/2" do
    test "returns ok tuple with PointZM from xdr-string" do
      wkb = "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"
      assert PointZM.from_wkb!(wkb, :hex) == %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}
    end

    test "returns ok tuple with PointZM from ndr-string" do
      wkb = "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"
      assert PointZM.from_wkb!(wkb, :hex) == %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}
    end

    test "returns ok tuple with PointZM from xdr-binary" do
      wkb = "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"

      assert wkb
             |> Hex.to_binary()
             |> PointZM.from_wkb!() == %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}
    end

    test "returns ok tuple with PointZM from ndr-binary" do
      wkb = "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"

      assert wkb
             |> Hex.to_binary()
             |> PointZM.from_wkb!() == %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}
    end

    test "raises an exception for an invalid WKB string" do
      wkb = "foo"
      message = ~s(expected endian flag "00" or "01", got "fo", at position 0)

      assert_raise Geometry.Error, message, fn ->
        PointZM.from_wkb!(wkb, :hex)
      end
    end

    test "raises an exception for an invalid WKB binary" do
      wkb = "foo"
      message = "expected endian flag, at position 0"

      assert_raise Geometry.Error, message, fn ->
        PointZM.from_wkb!(wkb)
      end
    end
  end

  describe "to_wkb/2" do
    test "returns xdr-string for PointZM" do
      wkb = "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"
      assert PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), mode: :hex) == wkb
      assert PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), mode: :hex, endian: :xdr) == wkb
    end

    test "returns xdr-binary for PointZM" do
      wkb =
        Hex.to_binary(
          "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"
        )

      assert PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4)) == wkb
      assert PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), endian: :xdr) == wkb
    end

    test "returns xdr-string for PointZM with SRID" do
      wkb = "00E00000010000014D3FF199999999999A400199999999999A400A666666666666401199999999999A"
      assert PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), srid: 333, mode: :hex) == wkb
    end

    test "returns xdr-binary for PointZM with SRID" do
      wkb =
        Hex.to_binary(
          "00E00000010000014D3FF199999999999A400199999999999A400A666666666666401199999999999A"
        )

      assert PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), srid: 333) == wkb
    end

    test "returns ndr-string for PointZM" do
      wkb = "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"
      assert PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), endian: :ndr, mode: :hex) == wkb
    end

    test "returns ndr-binary for PointZM" do
      wkb =
        Hex.to_binary(
          "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"
        )

      assert PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), endian: :ndr) == wkb
    end

    test "returns ndr-string for PointZM with SRID" do
      wkb = "01010000E04D0100009A9999999999F13F9A999999999901406666666666660A409A99999999991140"

      assert PointZM.to_wkb(
               PointZM.new(1.1, 2.2, 3.3, 4.4),
               endian: :ndr,
               srid: 333,
               mode: :hex
             ) == wkb
    end

    test "returns ndr-binary for PointZM with SRID" do
      wkb = "01010000E04D0100009A9999999999F13F9A999999999901406666666666660A409A99999999991140"

      assert PointZM.to_wkb(
               PointZM.new(1.1, 2.2, 3.3, 4.4),
               endian: :ndr,
               srid: 333
             ) == Hex.to_binary(wkb)
    end
  end

  describe "to_geo_json/1:" do
    prove PointZM.to_geo_json(PointZM.new(3.45, 6.78, 9.01, 11.1)) == %{
            "type" => "Point",
            "coordinates" => [3.45, 6.78, 9.01, 11.1]
          }
  end

  describe "to_geo_json/1" do
    test "raise an exception for an empty point" do
      assert_raise FunctionClauseError, fn ->
        PointZM.to_geo_json(PointZM.new())
      end
    end
  end

  describe "from_geo_json/1:" do
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

    prove PointZM.from_geo_json(@geo_json) == {:ok, %PointZM{coordinate: [1.2, 2.3, 4.5, 6.7]}}
    prove PointZM.from_geo_json(%{}) == {:error, :type_not_found}
    prove PointZM.from_geo_json(%{"type" => "Point"}) == {:error, :coordinates_not_found}
    prove PointZM.from_geo_json(@geo_json_invalid) == {:error, :invalid_data}
  end

  describe "from_geo_json!/1" do
    test "returns PointZM" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Point",
          "coordinates": [1.2, 2.3, 4.5, 6.7],
          "foo": 42
        }
        """)

      assert PointZM.from_geo_json!(geo_json) == %PointZM{coordinate: [1.2, 2.3, 4.5, 6.7]}
    end

    test "raises an exception" do
      geo_json = %{"type" => "Point"}
      message = "coordinates not found"

      assert_raise Geometry.Error, message, fn ->
        PointZM.from_geo_json!(geo_json)
      end
    end
  end
end
