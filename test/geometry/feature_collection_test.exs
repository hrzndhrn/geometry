defmodule Geometry.FeatureCollectionTest do
  use ExUnit.Case, async: true

  alias Geometry.{Feature, FeatureCollection, Point}

  doctest Geometry.FeatureCollection, import: true

  describe "from_geo_json!/2" do
    test "returns FeatureCollection" do
      geo_json =
        Jason.decode!("""
        {
           "type": "FeatureCollection",
           "features": [
             {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
               "properties": {"facility": "Hotel"}
             }, {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [4, 3, 2]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      assert FeatureCollection.from_geo_json!(geo_json, type: :z) ==
               %FeatureCollection{
                 features:
                   MapSet.new([
                     %Feature{
                       geometry: %Geometry.PointZ{x: 1, y: 2, z: 3},
                       properties: %{"facility" => "Hotel"}
                     },
                     %Feature{
                       geometry: %Geometry.PointZ{x: 4, y: 3, z: 2},
                       properties: %{"facility" => "School"}
                     }
                   ])
               }
    end

    test "raises an error for invalid data" do
      geo_json =
        Jason.decode!("""
        {
           "type": "FeatureCollection",
           "features": [
             {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
               "properties": {"facility": "Hotel"}
             }, {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": ["4", 3, 2]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      message = "invalid data"

      assert_raise Geometry.Error, message, fn ->
        FeatureCollection.from_geo_json!(geo_json, type: :z)
      end
    end

    test "raises an error for missing type in features" do
      geo_json =
        Jason.decode!("""
        {
           "type": "FeatureCollection",
           "features": [
             {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
               "properties": {"facility": "Hotel"}
             }, {
               "geometry": {"type": "Point", "coordinates": [4, 3, 2]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        FeatureCollection.from_geo_json!(geo_json, type: :z)
      end
    end

    test "raises an error for missing type" do
      geo_json = %{}

      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        FeatureCollection.from_geo_json!(geo_json, type: :z)
      end
    end
  end
end
