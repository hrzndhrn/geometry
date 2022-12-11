defmodule Geometry.GeoJson do
  @moduledoc false

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

  @type point ::
          Point.t() | PointZ.t() | PointM.t() | PointZM.t()
  @type line_string ::
          LineString.t() | LineStringZ.t() | LineStringM.t() | LineStringZM.t()
  @type polygon ::
          Polygon.t() | PolygonZ.t() | PolygonM.t() | PolygonZM.t()
  @type multi_point ::
          MultiPoint.t() | MultiPointZ.t() | MultiPointM.t() | MultiPointZM.t()
  @type multi_line_string ::
          MultiLineString.t()
          | MultiLineStringZ.t()
          | MultiLineStringM.t()
          | MultiLineStringZM.t()
  @type multi_polygon ::
          MultiPolygon.t() | MultiPolygonZ.t() | MultiPolygonM.t() | MultiPolygonZM.t()

  @modules %{
    {"Point", :xy} => Point,
    {"Point", :m} => PointM,
    {"Point", :z} => PointZ,
    {"Point", :zm} => PointZM,
    {"LineString", :xy} => LineString,
    {"LineString", :m} => LineStringM,
    {"LineString", :z} => LineStringZ,
    {"LineString", :zm} => LineStringZM,
    {"Polygon", :xy} => Polygon,
    {"Polygon", :m} => PolygonM,
    {"Polygon", :z} => PolygonZ,
    {"Polygon", :zm} => PolygonZM,
    {"MultiPoint", :xy} => MultiPoint,
    {"MultiPoint", :m} => MultiPointM,
    {"MultiPoint", :z} => MultiPointZ,
    {"MultiPoint", :zm} => MultiPointZM,
    {"MultiLineString", :xy} => MultiLineString,
    {"MultiLineString", :m} => MultiLineStringM,
    {"MultiLineString", :z} => MultiLineStringZ,
    {"MultiLineString", :zm} => MultiLineStringZM,
    {"MultiPolygon", :xy} => MultiPolygon,
    {"MultiPolygon", :m} => MultiPolygonM,
    {"MultiPolygon", :z} => MultiPolygonZ,
    {"MultiPolygon", :zm} => MultiPolygonZM,
    {"GeometryCollection", :xy} => GeometryCollection,
    {"GeometryCollection", :m} => GeometryCollectionM,
    {"GeometryCollection", :z} => GeometryCollectionZ,
    {"GeometryCollection", :zm} => GeometryCollectionZM
  }

  [
    "point",
    "line_string",
    "polygon",
    "multi_point",
    "multi_line_string",
    "multi_polygon"
  ]
  |> Enum.map(fn geometry -> {geometry, Macro.camelize(geometry)} end)
  |> Enum.each(fn {geometry, type} ->
    @spec unquote(:"to_#{geometry}")(Geometry.geo_json_term(), module()) ::
            {:ok, unquote(:"#{geometry}")()} | Geometry.geo_json_error()
    def unquote(:"to_#{geometry}")(%{"type" => "#{unquote(type)}"} = json, module) do
      coordinates(json, module)
    end

    def(unquote(:"to_#{geometry}")(_json, _module), do: {:error, :type_not_found})
  end)

  @spec to_geometry_collection(Geometry.geo_json_term(), module(), keyword()) ::
          {:ok, geometry_collection} | Geometry.geo_json_error()
        when geometry_collection:
               GeometryCollection.t()
               | GeometryCollectionM.t()
               | GeometryCollectionZ.t()
               | GeometryCollectionZM.t()
  def to_geometry_collection(json, module, opts \\ [])

  def to_geometry_collection(%{"type" => "GeometryCollection"} = json, module, opts) do
    case Map.fetch(json, "geometries") do
      {:ok, geometries} ->
        with list when is_list(list) <- geometry_collection_items(geometries, opts) do
          {:ok, module.new(list)}
        end

      :error ->
        {:error, :geometries_not_found}
    end
  end

  def to_geometry_collection(_json, _module, _opts), do: {:error, :type_not_found}

  @spec to_feature(Geometry.geo_json_term(), keyword()) ::
          {:ok, Feature.t()} | Geometry.geo_json_error()
  def to_feature(%{"type" => "Feature"} = json, opts) do
    with {:ok, geometry} <- to_feature_geometry(json, opts) do
      {:ok, %Feature{geometry: geometry, properties: Map.get(json, "properties")}}
    end
  end

  def to_feature(_json, _opts), do: {:error, :type_not_found}

  @spec to_feature_collection(Geometry.geo_json_term(), keyword()) ::
          {:ok, FeatureCollection.t()} | Geometry.geo_json_error()
  def to_feature_collection(%{"type" => "FeatureCollection"} = json, opts) do
    with features when is_list(features) <- to_feature_collection_features(json, opts) do
      {:ok, %FeatureCollection{features: MapSet.new(features)}}
    end
  end

  def to_feature_collection(_json, _opts), do: {:error, :type_not_found}

  @spec to_geometry(Geometry.geo_json_term(), keyword()) ::
          {:ok, line_string()} | Geometry.geo_json_error()
  def to_geometry(%{"type" => type} = json, opts) do
    with {:ok, module} <- module(type, opts) do
      case type do
        "Point" -> coordinates(json, module)
        "LineString" -> coordinates(json, module)
        "Polygon" -> coordinates(json, module)
        "MultiPoint" -> coordinates(json, module)
        "MultiLineString" -> coordinates(json, module)
        "MultiPolygon" -> coordinates(json, module)
        "GeometryCollection" -> to_geometry_collection(json, module, opts)
        "Feature" -> to_feature(json, opts)
        "FeatureCollection" -> to_feature_collection(json, opts)
        _not_found -> {:error, :unknown_type}
      end
    end
  end

  def to_geometry(_json, _opts), do: {:error, :type_not_found}

  defp coordinates(%{"coordinates" => coordinates}, module) do
    {:ok, module.from_coordinates(coordinates)}
  rescue
    _error ->
      {:error, :invalid_data}
  end

  defp coordinates(_json, _module) do
    {:error, :coordinates_not_found}
  end

  @compile {:inline, geometry_collection_items: 2}
  defp geometry_collection_items(geometries, opts) do
    Enum.reduce_while(geometries, [], fn geometry, acc ->
      case to_geometry(geometry, opts) do
        {:ok, geometry} -> {:cont, [geometry | acc]}
        error -> {:halt, error}
      end
    end)
  end

  @compile {:inline, module: 2}
  defp module("Feature", _opts), do: {:ok, Feature}

  defp module("FeatureCollection", _opts), do: {:ok, FeatureCollection}

  defp module(type, opts) do
    with :error <- Map.fetch(@modules, {type, Keyword.get(opts, :type, :xy)}) do
      {:error, :unknown_type}
    end
  end

  @compile {:inline, to_feature_geometry: 2}
  defp to_feature_geometry(json, opts) do
    case Map.get(json, "geometry") do
      nil -> {:ok, nil}
      geometry -> to_geometry(geometry, opts)
    end
  end

  @compile {:inline, to_feature_collection_features: 2}
  defp to_feature_collection_features(json, opts) do
    case Map.get(json, "features") do
      nil -> {:ok, []}
      features -> to_feature_collection_reduce(features, opts)
    end
  end

  @compile {:inline, to_feature_collection_reduce: 2}
  defp to_feature_collection_reduce(features, opts) do
    Enum.reduce_while(features, [], fn feature, acc ->
      case to_feature(feature, opts) do
        {:ok, feature} -> {:cont, [feature | acc]}
        error -> {:halt, error}
      end
    end)
  end
end
