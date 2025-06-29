defmodule Geometry.FeatureTest do
  use ExUnit.Case, async: true

  import Assertions
  import Jason.Sigil

  alias Geometry.DecodeError

  alias Geometry.Feature
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Geometry.Feature, import: true

  describe "empty?/1" do
    test "returns true for an emtpy feature" do
      assert Geometry.empty?(Feature.new()) == true
    end

    test "returns false for a none empty feature" do
      feature =
        Feature.new(
          geometry: Point.new(1, 2),
          properties: %{facility: :hotel}
        )

      assert Geometry.empty?(feature) == false
    end
  end

  describe "to_geo_json/1" do
    test "returns json represenation for a feature" do
      geo_json = ~J"""
      {
        "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [1, 2]},
        "properties": {"facility": "Hotel"}
      }
      """

      feature = %Feature{
        geometry: %Point{coordinates: [1, 2], srid: 4326},
        properties: %{"facility" => "Hotel"}
      }

      assert Geometry.to_geo_json(feature) == geo_json
    end

    test "returns json represenation for an empty feature" do
      geo_json = ~J"""
      {
        "type": "Feature",
        "geometry": null,
        "properties": null
      }
      """

      assert Geometry.to_geo_json(Feature.new()) == geo_json
    end
  end

  describe "from_geo_json/1" do
    test "returns a feature (xym)" do
      geo_json = ~J"""
      {
        "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
        "properties": {"facility": "Hotel"}
      }
      """

      assert Geometry.from_geo_json(geo_json, :xym) ==
               {:ok,
                %Feature{
                  geometry: %PointM{coordinates: [1, 2, 3], srid: 4326},
                  properties: %{"facility" => "Hotel"}
                }}
    end

    test "returns a feature (xyz)" do
      geo_json = ~J"""
      {
        "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
        "properties": {"facility": "Hotel"}
      }
      """

      assert Geometry.from_geo_json(geo_json, :xyz) ==
               {:ok,
                %Feature{
                  geometry: %PointZ{coordinates: [1, 2, 3], srid: 4326},
                  properties: %{"facility" => "Hotel"}
                }}
    end

    test "returns a feature (xyzm)" do
      geo_json = ~J"""
      {
        "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [1, 2, 3, 4]},
        "properties": {"facility": "Hotel"}
      }
      """

      assert Geometry.from_geo_json(geo_json, :xyzm) ==
               {:ok,
                %Feature{
                  geometry: %PointZM{coordinates: [1, 2, 3, 4], srid: 4326},
                  properties: %{"facility" => "Hotel"}
                }}
    end

    test "returns an error tuple for invalid data" do
      geo_json = ~J"""
      {
        "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [1, 2]},
        "properties": 44
      }
      """

      assert Geometry.from_geo_json(geo_json, :xy) ==
               {:error,
                %DecodeError{
                  from: :geo_json,
                  line: nil,
                  message: nil,
                  offset: nil,
                  reason: :invalid_data,
                  rest: nil
                }}
    end

    test "returns an error tuple for invalid geometry" do
      geo_json = ~J"""
      {
        "type": "Feature",
        "geometry": {"type": "Thing", "coordinates": [1, 2]},
        "properties": null
      }
      """

      assert Geometry.from_geo_json(geo_json, :xy) ==
               {:error,
                %DecodeError{
                  from: :geo_json,
                  line: nil,
                  message: nil,
                  offset: nil,
                  reason: [unknown_type: "Thing"],
                  rest: nil
                }}
    end
  end

  describe "from_geo_json!/1" do
    test "raises an error for invalid geometry" do
      geo_json = ~J"""
      {
        "type": "Feature",
        "geometry": {"type": "Thing", "coordinates": [1, 2]},
        "properties": null
      }
      """

      message = "unknown type 'Thing'"

      assert_fail :from_geo_json!, geo_json, message
    end
  end
end
