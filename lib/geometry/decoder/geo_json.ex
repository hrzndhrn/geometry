defmodule Geometry.Decoder.GeoJson do
  @moduledoc false

  alias Geometry.DecodeError

  alias Geometry.Feature
  alias Geometry.FeatureCollection
  alias Geometry.GeometryCollection
  alias Geometry.GeometryCollectionM
  alias Geometry.GeometryCollectionZ
  alias Geometry.GeometryCollectionZM
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.MultiLineString
  alias Geometry.MultiLineStringM
  alias Geometry.MultiLineStringZ
  alias Geometry.MultiLineStringZM
  alias Geometry.MultiPoint
  alias Geometry.MultiPointM
  alias Geometry.MultiPointZ
  alias Geometry.MultiPointZM
  alias Geometry.MultiPolygon
  alias Geometry.MultiPolygonM
  alias Geometry.MultiPolygonZ
  alias Geometry.MultiPolygonZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM
  alias Geometry.Polygon
  alias Geometry.PolygonM
  alias Geometry.PolygonZ
  alias Geometry.PolygonZM

  @geojson_srid 4326

  @spec decode(term(), :xy | :xyz | :xym | :xyzm) ::
          {:ok, Geometry.t() | Feature.t() | FeatureCollection.t()}
          | {:error, DecodeError.t()}
  def decode(%{"type" => type} = json, dim), do: decode(type, json, dim)

  def decode(_json, _dim), do: {:error, %DecodeError{from: :geo_json, reason: :type_not_found}}

  defp decode("Point", %{"coordinates" => [_x, _y] = coordinate}, :xy) do
    {:ok, %Point{coordinate: coordinate, srid: @geojson_srid}}
  end

  defp decode("Point", %{"coordinates" => [_x, _y, _z] = coordinate}, :xyz) do
    {:ok, %PointZ{coordinate: coordinate, srid: @geojson_srid}}
  end

  defp decode("Point", %{"coordinates" => [_x, _y, _m] = coordinate}, :xym) do
    {:ok, %PointM{coordinate: coordinate, srid: @geojson_srid}}
  end

  defp decode("Point", %{"coordinates" => [_x, _y, _z, _m] = coordinate}, :xyzm) do
    {:ok, %PointZM{coordinate: coordinate, srid: @geojson_srid}}
  end

  defp decode("Point", %{"coordinates" => _coordinates}, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :invalid_data}}
  end

  defp decode("Point", _json, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :coordinates_not_found}}
  end

  defp decode("LineString", %{"coordinates" => points}, :xy) do
    {:ok, %LineString{points: points, srid: @geojson_srid}}
  end

  defp decode("LineString", %{"coordinates" => points}, :xym) do
    {:ok, %LineStringM{points: points, srid: @geojson_srid}}
  end

  defp decode("LineString", %{"coordinates" => points}, :xyz) do
    {:ok, %LineStringZ{points: points, srid: @geojson_srid}}
  end

  defp decode("LineString", %{"coordinates" => points}, :xyzm) do
    {:ok, %LineStringZM{points: points, srid: @geojson_srid}}
  end

  defp decode("LineString", _json, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :coordinates_not_found}}
  end

  defp decode("Polygon", %{"coordinates" => rings}, :xy) do
    {:ok, %Polygon{rings: rings, srid: @geojson_srid}}
  end

  defp decode("Polygon", %{"coordinates" => rings}, :xym) do
    {:ok, %PolygonM{rings: rings, srid: @geojson_srid}}
  end

  defp decode("Polygon", %{"coordinates" => rings}, :xyz) do
    {:ok, %PolygonZ{rings: rings, srid: @geojson_srid}}
  end

  defp decode("Polygon", %{"coordinates" => rings}, :xyzm) do
    {:ok, %PolygonZM{rings: rings, srid: @geojson_srid}}
  end

  defp decode("Polygon", _json, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :coordinates_not_found}}
  end

  defp decode("MultiPoint", %{"coordinates" => points}, :xy) do
    {:ok, %MultiPoint{points: points, srid: @geojson_srid}}
  end

  defp decode("MultiPoint", %{"coordinates" => points}, :xym) do
    {:ok, %MultiPointM{points: points, srid: @geojson_srid}}
  end

  defp decode("MultiPoint", %{"coordinates" => points}, :xyz) do
    {:ok, %MultiPointZ{points: points, srid: @geojson_srid}}
  end

  defp decode("MultiPoint", %{"coordinates" => points}, :xyzm) do
    {:ok, %MultiPointZM{points: points, srid: @geojson_srid}}
  end

  defp decode("MultiPoint", _json, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :coordinates_not_found}}
  end

  defp decode("MultiLineString", %{"coordinates" => line_strings}, :xy) do
    {:ok, %MultiLineString{line_strings: line_strings, srid: @geojson_srid}}
  end

  defp decode("MultiLineString", %{"coordinates" => line_strings}, :xym) do
    {:ok, %MultiLineStringM{line_strings: line_strings, srid: @geojson_srid}}
  end

  defp decode("MultiLineString", %{"coordinates" => line_strings}, :xyz) do
    {:ok, %MultiLineStringZ{line_strings: line_strings, srid: @geojson_srid}}
  end

  defp decode("MultiLineString", %{"coordinates" => line_strings}, :xyzm) do
    {:ok, %MultiLineStringZM{line_strings: line_strings, srid: @geojson_srid}}
  end

  defp decode("MultiLineString", _json, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :coordinates_not_found}}
  end

  defp decode("MultiPolygon", %{"coordinates" => polygons}, :xy) do
    {:ok, %MultiPolygon{polygons: polygons, srid: @geojson_srid}}
  end

  defp decode("MultiPolygon", %{"coordinates" => polygons}, :xym) do
    {:ok, %MultiPolygonM{polygons: polygons, srid: @geojson_srid}}
  end

  defp decode("MultiPolygon", %{"coordinates" => polygons}, :xyz) do
    {:ok, %MultiPolygonZ{polygons: polygons, srid: @geojson_srid}}
  end

  defp decode("MultiPolygon", %{"coordinates" => polygons}, :xyzm) do
    {:ok, %MultiPolygonZM{polygons: polygons, srid: @geojson_srid}}
  end

  defp decode("MultiPolygon", _json, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :coordinates_not_found}}
  end

  defp decode("GeometryCollection", %{"geometries" => geometries}, :xy) do
    with [_ | _] = geometries <- decode_geometries(geometries, :xy) do
      {:ok, %GeometryCollection{geometries: Enum.reverse(geometries), srid: @geojson_srid}}
    end
  end

  defp decode("GeometryCollection", %{"geometries" => geometries}, :xym) do
    with [_ | _] = geometries <- decode_geometries(geometries, :xym) do
      {:ok, %GeometryCollectionM{geometries: Enum.reverse(geometries), srid: @geojson_srid}}
    end
  end

  defp decode("GeometryCollection", %{"geometries" => geometries}, :xyz) do
    with [_ | _] = geometries <- decode_geometries(geometries, :xyz) do
      {:ok, %GeometryCollectionZ{geometries: Enum.reverse(geometries), srid: @geojson_srid}}
    end
  end

  defp decode("GeometryCollection", %{"geometries" => geometries}, :xyzm) do
    with [_ | _] = geometries <- decode_geometries(geometries, :xyzm) do
      {:ok, %GeometryCollectionZM{geometries: Enum.reverse(geometries), srid: @geojson_srid}}
    end
  end

  defp decode("GeometryCollection", _json, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :geometries_not_found}}
  end

  defp decode("Feature", %{"geometry" => geometry, "properties" => properties}, dim)
       when is_map(properties) or is_nil(properties) do
    with {:ok, geometry} <- decode(geometry, dim) do
      {:ok, %Feature{geometry: geometry, properties: properties}}
    end
  end

  defp decode("Feature", _data, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: :invalid_data}}
  end

  defp decode("FeatureCollection", %{"features" => features}, dim)
       when is_list(features) do
    with {:ok, features} <- decode_features(features, dim) do
      {:ok, %FeatureCollection{features: Enum.reverse(features)}}
    end
  end

  defp decode(type, _json, _dim) do
    {:error, %DecodeError{from: :geo_json, reason: [unknown_type: type]}}
  end

  defp decode_geometries(geometries, dim) do
    Enum.reduce_while(geometries, [], fn geometry, acc ->
      case decode(geometry, dim) do
        {:ok, geometry} -> {:cont, [geometry | acc]}
        error -> {:halt, error}
      end
    end)
  end

  defp decode_features(features, dim) do
    features =
      Enum.reduce_while(features, [], fn feature, acc ->
        case decode(feature, dim) do
          {:ok, feature} -> {:cont, [feature | acc]}
          error -> {:halt, error}
        end
      end)

    case features do
      {:error, _reason} = error -> error
      list -> {:ok, list}
    end
  end
end
