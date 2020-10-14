defmodule Geometry.GeoJson do
  @moduledoc false

  alias Geometry.{
    LineString,
    LineStringM,
    LineStringZ,
    LineStringZM,
    MultiLineString,
    MultiLineStringM,
    MultiLineStringZ,
    MultiLineStringZM,
    MultiPoint,
    MultiPointM,
    MultiPointZ,
    MultiPointZM,
    MultiPolygon,
    MultiPolygonM,
    MultiPolygonZ,
    MultiPolygonZM,
    Point,
    PointM,
    PointZ,
    PointZM,
    Polygon,
    PolygonM,
    PolygonZ,
    PolygonZM
  }

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
      # credo:disable-for-previous-line Credo.Check.Readability.Specs

      case Map.fetch(json, "coordinates") do
        {:ok, coordinates} -> {:ok, module.from_coordinates(coordinates)}
        :error -> {:error, :coordinates_not_found}
      end
    rescue
      _error in FunctionClauseError ->
        {:error, :invalid_data}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def(unquote(:"to_#{geometry}")(_json, _line_string), do: {:error, :type_not_found})
  end)

  @spec to_geometry(Geometry.geo_json_term(), keyword()) ::
          {:ok, line_string()} | Geometry.geo_json_error()
  def to_geometry(%{"type" => type} = json, opts) do
    case {type, Keyword.get(opts, :type, :xy)} do
      {"Point", :xy} -> to_point(json, Point)
      {"Point", :m} -> to_point(json, PointM)
      {"Point", :z} -> to_point(json, PointZ)
      {"Point", :zm} -> to_point(json, PointZM)
      {"LineString", :xy} -> to_line_string(json, LineString)
      {"LineString", :m} -> to_line_string(json, LineStringM)
      {"LineString", :z} -> to_line_string(json, LineStringZ)
      {"LineString", :zm} -> to_line_string(json, LineStringZM)
      {"Polygon", :xy} -> to_polygon(json, Polygon)
      {"Polygon", :m} -> to_polygon(json, PolygonM)
      {"Polygon", :z} -> to_polygon(json, PolygonZ)
      {"Polygon", :zm} -> to_polygon(json, PolygonZM)
      {"MultiPoint", :xy} -> to_multi_point(json, MultiPoint)
      {"MultiPoint", :m} -> to_multi_point(json, MultiPointM)
      {"MultiPoint", :z} -> to_multi_point(json, MultiPointZ)
      {"MultiPoint", :zm} -> to_multi_point(json, MultiPointZM)
      {"MultiLineString", :xy} -> to_multi_line_string(json, MultiLineString)
      {"MultiLineString", :m} -> to_multi_line_string(json, MultiLineStringM)
      {"MultiLineString", :z} -> to_multi_line_string(json, MultiLineStringZ)
      {"MultiLineString", :zm} -> to_multi_line_string(json, MultiLineStringZM)
      {"MultiPolygon", :xy} -> to_multi_polygon(json, MultiPolygon)
      {"MultiPolygon", :m} -> to_multi_polygon(json, MultiPolygonM)
      {"MultiPolygon", :z} -> to_multi_polygon(json, MultiPolygonZ)
      {"MultiPolygon", :zm} -> to_multi_polygon(json, MultiPolygonZM)
      _not_found -> {:error, :unknown_type}
    end
  end

  def to_geometry(_json, _opts), do: {:error, :type_not_found}
end
