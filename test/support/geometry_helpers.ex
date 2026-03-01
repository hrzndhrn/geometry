defmodule GeometryHelpers do
  @moduledoc false

  alias Geometry.CircularString
  alias Geometry.CircularStringM
  alias Geometry.CircularStringZ
  alias Geometry.CircularStringZM
  alias Geometry.CompoundCurve
  alias Geometry.CompoundCurveM
  alias Geometry.CompoundCurveZ
  alias Geometry.CompoundCurveZM
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM

  # Builds a WKT string for a geometry with flat coordinate data.
  def wkt(name, data \\ [], srid \\ "")

  def wkt(name, [], ""), do: "#{String.upcase(name)} EMPTY"

  def wkt(name, [], srid), do: "SRID=#{srid};#{String.upcase(name)} EMPTY"

  def wkt(name, data, srid) do
    srid = if srid == "", do: "", else: "SRID=#{srid};"
    "#{srid}#{String.upcase(name)} (#{wkt_coords(data)})"
  end

  # Returns the WKT dimension suffix for the given dimension atom.
  def wkt_dim(:xy), do: " "
  def wkt_dim(:xyz), do: " Z "
  def wkt_dim(:xym), do: " M "
  def wkt_dim(:xyzm), do: " ZM "

  # Returns the dimension atom for a geometry module, based on the module name suffix.
  # For example, `PointZM` -> `:xyzm`, `LineStringZ` -> `:xyz`, `PolygonM` -> `:xym`,
  # `MultiCurve` -> `:xy`.
  def dim(module) do
    name = module |> Module.split() |> List.last()

    cond do
      String.ends_with?(name, "ZM") -> :xyzm
      String.ends_with?(name, "Z") -> :xyz
      String.ends_with?(name, "M") -> :xym
      true -> :xy
    end
  end

  # Creates a point struct for the given coordinate list and dimension.
  def create_point(coord, :xy), do: Point.new(coord)
  def create_point(coord, :xym), do: PointM.new(coord)
  def create_point(coord, :xyz), do: PointZ.new(coord)
  def create_point(coord, :xyzm), do: PointZM.new(coord)

  # Maps a list of raw coordinate lists to point structs for the given dimension.
  def coordinates(data, dim) do
    Enum.map(data, &create_point(&1, dim))
  end

  # Joins a list of coordinate lists into a WKT coordinate string.
  def wkt_coords(coordinates) do
    Enum.map_join(coordinates, ", ", fn point -> Enum.join(point, " ") end)
  end

  # Creates a LineString from a coordinate list for the given dimension and srid.
  def create_line_string(coordinates, dim, srid) do
    points = Enum.map(coordinates, &create_point(&1, dim))

    case dim do
      :xy -> LineString.new(points, srid)
      :xym -> LineStringM.new(points, srid)
      :xyz -> LineStringZ.new(points, srid)
      :xyzm -> LineStringZM.new(points, srid)
    end
  end

  # Creates a CircularString from a coordinate list for the given dimension and srid.
  def create_circular_string(coordinates, dim, srid) do
    points = Enum.map(coordinates, &create_point(&1, dim))

    case dim do
      :xy -> CircularString.new(points, srid)
      :xym -> CircularStringM.new(points, srid)
      :xyz -> CircularStringZ.new(points, srid)
      :xyzm -> CircularStringZM.new(points, srid)
    end
  end

  # Creates a CompoundCurve from a list of segment descriptors.
  # Each descriptor is `{:line_string, coords}`, `{:coords, coords}`, or
  # `{:circular_string, coords}`.
  def create_compound_curve(segments_data, dim, srid) do
    segments =
      Enum.map(segments_data, fn
        {type, coords} when type in [:line_string, :coords] ->
          create_line_string(coords, dim, srid)

        {:circular_string, coords} ->
          create_circular_string(coords, dim, srid)
      end)

    case dim do
      :xy -> CompoundCurve.new(segments, srid)
      :xym -> CompoundCurveM.new(segments, srid)
      :xyz -> CompoundCurveZ.new(segments, srid)
      :xyzm -> CompoundCurveZM.new(segments, srid)
    end
  end
end
