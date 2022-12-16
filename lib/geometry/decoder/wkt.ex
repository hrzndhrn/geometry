defmodule Geometry.Decoder.WKT do
  @moduledoc false

  alias Geometry.Decoder.WKT.Parser

  alias Geometry.DecodeError

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

  @spec decode(String.t()) ::
          {:ok, Geometry.t() | {Geometry.t(), Geometry.srid()}} | {:error, DecodeError.t()}
  def decode(wkt) do
    with {:ok, type, dim, data, srid} <- Parser.parse(wkt) do
      {:ok, geometry(type, dim, data), srid}
    end
  end

  defp geometry(:point, :xy, [coordinate]), do: %Point{coordinate: coordinate}

  defp geometry(:point, :xy, coordinate), do: %Point{coordinate: coordinate}

  defp geometry(:point, :xyz, [coordinate]), do: %PointZ{coordinate: coordinate}

  defp geometry(:point, :xyz, coordinate), do: %PointZ{coordinate: coordinate}

  defp geometry(:point, :xym, [coordinate]), do: %PointM{coordinate: coordinate}

  defp geometry(:point, :xym, coordinate), do: %PointM{coordinate: coordinate}

  defp geometry(:point, :xyzm, [coordinate]), do: %PointZM{coordinate: coordinate}

  defp geometry(:point, :xyzm, coordinate), do: %PointZM{coordinate: coordinate}

  defp geometry(:line_string, :xy, points), do: %LineString{points: points}

  defp geometry(:line_string, :xym, points), do: %LineStringM{points: points}

  defp geometry(:line_string, :xyz, points), do: %LineStringZ{points: points}

  defp geometry(:line_string, :xyzm, points), do: %LineStringZM{points: points}

  defp geometry(:polygon, :xy, rings), do: %Polygon{rings: rings}

  defp geometry(:polygon, :xym, rings), do: %PolygonM{rings: rings}

  defp geometry(:polygon, :xyz, rings), do: %PolygonZ{rings: rings}

  defp geometry(:polygon, :xyzm, rings), do: %PolygonZM{rings: rings}

  defp geometry(:multi_point, :xy, points), do: %MultiPoint{points: points}

  defp geometry(:multi_point, :xym, points), do: %MultiPointM{points: points}

  defp geometry(:multi_point, :xyz, points), do: %MultiPointZ{points: points}

  defp geometry(:multi_point, :xyzm, points), do: %MultiPointZM{points: points}

  defp geometry(:multi_line_string, :xy, line_strings),
    do: %MultiLineString{line_strings: line_strings}

  defp geometry(:multi_line_string, :xym, line_strings),
    do: %MultiLineStringM{line_strings: line_strings}

  defp geometry(:multi_line_string, :xyz, line_strings),
    do: %MultiLineStringZ{line_strings: line_strings}

  defp geometry(:multi_line_string, :xyzm, line_strings),
    do: %MultiLineStringZM{line_strings: line_strings}

  defp geometry(:multi_polygon, :xy, polygons), do: %MultiPolygon{polygons: polygons}

  defp geometry(:multi_polygon, :xym, polygons),
    do: %MultiPolygonM{polygons: polygons}

  defp geometry(:multi_polygon, :xyz, polygons),
    do: %MultiPolygonZ{polygons: polygons}

  defp geometry(:multi_polygon, :xyzm, polygons),
    do: %MultiPolygonZM{polygons: polygons}

  defp geometry(:geometry_collection, dim, {:geometries, geometries}) do
    geometry(:geometry_collection, dim, geometries)
  end

  defp geometry(:geometry_collection, :xy, geometries) do
    geometries = Enum.map(geometries, fn {type, geometry} -> geometry(type, :xy, geometry) end)

    %GeometryCollection{geometries: geometries}
  end

  defp geometry(:geometry_collection, :xym, geometries) do
    geometries = Enum.map(geometries, fn {type, geometry} -> geometry(type, :xym, geometry) end)

    %GeometryCollectionM{geometries: geometries}
  end

  defp geometry(:geometry_collection, :xyz, geometries) do
    geometries = Enum.map(geometries, fn {type, geometry} -> geometry(type, :xyz, geometry) end)

    %GeometryCollectionZ{geometries: geometries}
  end

  defp geometry(:geometry_collection, :xyzm, geometries) do
    geometries = Enum.map(geometries, fn {type, geometry} -> geometry(type, :xyzm, geometry) end)

    %GeometryCollectionZM{geometries: geometries}
  end
end
