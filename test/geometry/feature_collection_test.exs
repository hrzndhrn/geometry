defmodule Geometry.FeatureCollectionTest do
  use ExUnit.Case, async: true

  import Assertions

  alias Geometry.Feature
  alias Geometry.FeatureCollection
  alias Geometry.LineString
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  doctest Geometry.FeatureCollection, import: true

  describe "empty?/1" do
    test "returns true for an empty collection" do
      assert Geometry.empty?(FeatureCollection.new())
    end
  end

  describe "to_geo_json/1" do
    test "returns geo json" do
      geo_json =
        Jason.decode!("""
        {
           "type": "FeatureCollection",
           "features": [
             {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [1, 2]},
               "properties": {"foo": "bar"}
             }, {
               "type": "Feature",
               "geometry": {"type": "LineString", "coordinates": [[4, 3],[1, 1]]},
               "properties": {"bar": "foo"}
             }
          ]
        }
        """)

      collection = %FeatureCollection{
        features: [
          %Feature{
            geometry: %Point{coordinates: [1, 2]},
            properties: %{"foo" => "bar"}
          },
          %Feature{
            geometry: %LineString{path: [[4, 3], [1, 1]]},
            properties: %{"bar" => "foo"}
          }
        ]
      }

      assert Geometry.to_geo_json(collection) == geo_json
    end
  end

  describe "from_geo_json!/2" do
    test "returns FeatureCollection (xy)" do
      geo_json =
        Jason.decode!("""
        {
           "type": "FeatureCollection",
           "features": [
             {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [1, 2]},
               "properties": {"facility": "Hotel"}
             }, {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [4, 3]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      assert Geometry.from_geo_json!(geo_json) ==
               %FeatureCollection{
                 features: [
                   %Feature{
                     geometry: %Point{coordinates: [1, 2], srid: 4326},
                     properties: %{"facility" => "Hotel"}
                   },
                   %Feature{
                     geometry: %Point{coordinates: [4, 3], srid: 4326},
                     properties: %{"facility" => "School"}
                   }
                 ]
               }
    end

    test "returns FeatureCollection (xyz)" do
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
               "geometry": {"type": "Point", "coordinates": [4, 3, 5]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      assert Geometry.from_geo_json!(geo_json, :xyz) ==
               %FeatureCollection{
                 features: [
                   %Feature{
                     geometry: %PointZ{coordinates: [1, 2, 3], srid: 4326},
                     properties: %{"facility" => "Hotel"}
                   },
                   %Feature{
                     geometry: %PointZ{coordinates: [4, 3, 5], srid: 4326},
                     properties: %{"facility" => "School"}
                   }
                 ]
               }
    end

    test "returns FeatureCollection (xym)" do
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
               "geometry": {"type": "Point", "coordinates": [4, 3, 5]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      assert Geometry.from_geo_json!(geo_json, :xym) ==
               %FeatureCollection{
                 features: [
                   %Feature{
                     geometry: %PointM{coordinates: [1, 2, 3], srid: 4326},
                     properties: %{"facility" => "Hotel"}
                   },
                   %Feature{
                     geometry: %PointM{coordinates: [4, 3, 5], srid: 4326},
                     properties: %{"facility" => "School"}
                   }
                 ]
               }
    end

    test "returns FeatureCollection (xyzm)" do
      geo_json =
        Jason.decode!("""
        {
           "type": "FeatureCollection",
           "features": [
             {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [1, 2, 3, 1]},
               "properties": {"facility": "Hotel"}
             }, {
               "type": "Feature",
               "geometry": {"type": "Point", "coordinates": [4, 3, 5, 1]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      assert Geometry.from_geo_json!(geo_json, :xyzm) ==
               %FeatureCollection{
                 features: [
                   %Feature{
                     geometry: %PointZM{coordinates: [1, 2, 3, 1], srid: 4326},
                     properties: %{"facility" => "Hotel"}
                   },
                   %Feature{
                     geometry: %PointZM{coordinates: [4, 3, 5, 1], srid: 4326},
                     properties: %{"facility" => "School"}
                   }
                 ]
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
               "geometry": {"type": "Point", "coordinates": [4, 3, 2]},
               "properties": {"facility": "School"}
             }
          ]
        }
        """)

      message = "invalid data"

      assert_fail :from_geo_json!, geo_json, message
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

      assert_fail :from_geo_json!, [geo_json, :xyz], message
    end

    test "raises an error for missing type" do
      geo_json = %{}

      message = "type not found"

      assert_fail :from_geo_json!, geo_json, message
    end
  end

  describe "Enum.slice/3" do
    test "slices the collection" do
      collection =
        FeatureCollection.new([
          Feature.new(
            geometry: Point.new(11, 12),
            properties: %{"facility" => "Hotel"}
          ),
          Feature.new(
            geometry: Point.new(55, 55),
            properties: %{"facility" => "Tower"}
          )
        ])

      assert [%Feature{}] = Enum.slice(collection, 0, 1)
    end
  end

  describe "Enum.count/1" do
    test "returns the coount" do
      collection = %FeatureCollection{
        features: [
          %Feature{
            geometry: %Point{coordinates: [1, 2]},
            properties: %{"foo" => "bar"}
          },
          %Feature{
            geometry: %LineString{path: [[4, 3], [1, 1]]},
            properties: %{"bar" => "foo"}
          }
        ]
      }

      assert Enum.count(collection) == 2
    end
  end

  describe "Enum.member/2" do
    test "returns true if the feature is in the collection" do
      collection = %FeatureCollection{
        features: [
          bar = %Feature{
            geometry: %Point{coordinates: [1, 2]},
            properties: %{"foo" => "bar"}
          },
          %Feature{
            geometry: %LineString{path: [[4, 3], [1, 1]]},
            properties: %{"bar" => "foo"}
          }
        ]
      }

      assert Enum.member?(collection, bar) == true
    end

    test "returns false if the feature is not in the collection" do
      collection = %FeatureCollection{
        features: [
          %Feature{
            geometry: %Point{coordinates: [1, 2]},
            properties: %{"foo" => "bar"}
          },
          %Feature{
            geometry: %LineString{path: [[4, 3], [1, 1]]},
            properties: %{"bar" => "foo"}
          }
        ]
      }

      feature = %Feature{
        geometry: %LineString{path: [[14, 13], [11, 11]]},
        properties: %{"bar" => "bar"}
      }

      assert Enum.member?(collection, feature) == false
    end
  end

  describe "Enum.into/2/3" do
    test "interrupted" do
      feature = %Feature{
        geometry: %LineString{path: [[4, 3], [1, 1]]},
        properties: %{"bar" => "foo"}
      }

      collection = %FeatureCollection{
        features: [
          %Feature{
            geometry: %LineString{path: [[4, 3], [1, 1]]},
            properties: %{"bar" => "foo"}
          }
        ]
      }

      assert Enum.into([feature], FeatureCollection.new()) == collection
      assert Enum.into([feature], FeatureCollection.new(), fn f -> f end) == collection

      assert_raise RuntimeError, fn ->
        Enum.into([feature], FeatureCollection.new(), fn _ignore -> raise "error" end)
      end
    end
  end
end
