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
          {:ok, Geometry.t() | {Geometry.t(), Geometry.srid() | nil}} | {:error, DecodeError.t()}
  def decode(wkt) do
    with {:ok, type, dim, data, srid} <- Parser.parse(wkt) do
      {:ok, geometry(type, dim, data, srid)}
    end
  end

  defp geometry(type, dim, data, nil = _srid), do: geometry(type, dim, data, 0)

  defp geometry(:point, :xy, [coordinate], srid), do: %Point{coordinate: coordinate, srid: srid}

  defp geometry(:point, :xy, coordinate, srid), do: %Point{coordinate: coordinate, srid: srid}

  defp geometry(:point, :xyz, [coordinate], srid), do: %PointZ{coordinate: coordinate, srid: srid}

  defp geometry(:point, :xyz, coordinate, srid), do: %PointZ{coordinate: coordinate, srid: srid}

  defp geometry(:point, :xym, [coordinate], srid), do: %PointM{coordinate: coordinate, srid: srid}

  defp geometry(:point, :xym, coordinate, srid), do: %PointM{coordinate: coordinate, srid: srid}

  defp geometry(:point, :xyzm, [coordinate], srid),
    do: %PointZM{coordinate: coordinate, srid: srid}

  defp geometry(:point, :xyzm, coordinate, srid), do: %PointZM{coordinate: coordinate, srid: srid}

  defp geometry(:line_string, :xy, points, srid), do: %LineString{points: points, srid: srid}

  defp geometry(:line_string, :xym, points, srid), do: %LineStringM{points: points, srid: srid}

  defp geometry(:line_string, :xyz, points, srid), do: %LineStringZ{points: points, srid: srid}

  defp geometry(:line_string, :xyzm, points, srid), do: %LineStringZM{points: points, srid: srid}

  defp geometry(:polygon, :xy, rings, srid), do: %Polygon{rings: rings, srid: srid}

  defp geometry(:polygon, :xym, rings, srid), do: %PolygonM{rings: rings, srid: srid}

  defp geometry(:polygon, :xyz, rings, srid), do: %PolygonZ{rings: rings, srid: srid}

  defp geometry(:polygon, :xyzm, rings, srid), do: %PolygonZM{rings: rings, srid: srid}

  defp geometry(:multi_point, :xy, points, srid), do: %MultiPoint{points: points, srid: srid}

  defp geometry(:multi_point, :xym, points, srid), do: %MultiPointM{points: points, srid: srid}

  defp geometry(:multi_point, :xyz, points, srid), do: %MultiPointZ{points: points, srid: srid}

  defp geometry(:multi_point, :xyzm, points, srid), do: %MultiPointZM{points: points, srid: srid}

  defp geometry(:multi_line_string, :xy, line_strings, srid),
    do: %MultiLineString{line_strings: line_strings, srid: srid}

  defp geometry(:multi_line_string, :xym, line_strings, srid),
    do: %MultiLineStringM{line_strings: line_strings, srid: srid}

  defp geometry(:multi_line_string, :xyz, line_strings, srid),
    do: %MultiLineStringZ{line_strings: line_strings, srid: srid}

  defp geometry(:multi_line_string, :xyzm, line_strings, srid),
    do: %MultiLineStringZM{line_strings: line_strings, srid: srid}

  defp geometry(:multi_polygon, :xy, polygons, srid),
    do: %MultiPolygon{polygons: polygons, srid: srid}

  defp geometry(:multi_polygon, :xym, polygons, srid),
    do: %MultiPolygonM{polygons: polygons, srid: srid}

  defp geometry(:multi_polygon, :xyz, polygons, srid),
    do: %MultiPolygonZ{polygons: polygons, srid: srid}

  defp geometry(:multi_polygon, :xyzm, polygons, srid),
    do: %MultiPolygonZM{polygons: polygons, srid: srid}

  defp geometry(:geometry_collection, dim, {:geometries, geometries}, srid) do
    geometry(:geometry_collection, dim, geometries, srid)
  end

  defp geometry(:geometry_collection, :xy, geometries, srid) do
    geometries =
      Enum.map(geometries, fn {type, geometry} -> geometry(type, :xy, geometry, srid) end)

    %GeometryCollection{geometries: geometries, srid: srid}
  end

  defp geometry(:geometry_collection, :xym, geometries, srid) do
    geometries =
      Enum.map(geometries, fn {type, geometry} -> geometry(type, :xym, geometry, srid) end)

    %GeometryCollectionM{geometries: geometries, srid: srid}
  end

  defp geometry(:geometry_collection, :xyz, geometries, srid) do
    geometries =
      Enum.map(geometries, fn {type, geometry} -> geometry(type, :xyz, geometry, srid) end)

    %GeometryCollectionZ{geometries: geometries, srid: srid}
  end

  defp geometry(:geometry_collection, :xyzm, geometries, srid) do
    geometries =
      Enum.map(geometries, fn {type, geometry} -> geometry(type, :xyzm, geometry, srid) end)

    %GeometryCollectionZM{geometries: geometries, srid: srid}
  end
end
