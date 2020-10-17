defmodule Geometry.FeatureTest do
  use ExUnit.Case, async: true

  alias Geometry.{Feature, Point, PointM, PointZ}

  doctest Geometry.Feature, import: true

  describe "from_geo_json!" do
    test "returns a Feature" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Feature",
          "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
          "properties": {"facility": "Hotel"}
        }
        """)

      assert Feature.from_geo_json!(geo_json, type: :m) ==
               %Feature{
                 geometry: %PointM{x: 1, y: 2, m: 3},
                 properties: %{"facility" => "Hotel"}
               }
    end

    test "raises an error for invalid data" do
      geo_json =
        Jason.decode!("""
        {
          "type": "Feature",
          "geometry": {"type": "Point", "coordinates": ["1", 2, 3]},
          "properties": {"facility": "Hotel"}
        }
        """)

      message = "invalid data"

      assert_raise Geometry.Error, message, fn ->
        Feature.from_geo_json!(geo_json, type: :z)
      end
    end

    test "raises a missing type" do
      message = "type not found"

      assert_raise Geometry.Error, message, fn ->
        Feature.from_geo_json!(%{}, type: :z)
      end
    end
  end
end
