defmodule Geometry.MultiSurface do
  @moduledoc """
  A multi-surface struct, representing a 2D collection of surfaces.

  A MultiSurface is a collection of surfaces which can include Polygons or
  CurvePolygons.
  """

  use Geometry.Protocols

  alias Geometry.MultiSurface

  defstruct surfaces: [], srid: 0

  @type surface ::
          Geometry.Polygon.t()
          | Geometry.CurvePolygon.t()

  @type t :: %MultiSurface{surfaces: [surface()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiSurface`.

  ## Examples

      iex> Geometry.MultiSurface.new()
      %Geometry.MultiSurface{surfaces: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiSurface{}

  @doc """
  Creates a `MultiSurface` from the given surfaces.

  ## Examples

      iex> Geometry.MultiSurface.new([
      ...>   Geometry.Polygon.new([
      ...>     Geometry.LineString.new([
      ...>       Geometry.Point.new(0, 0), Geometry.Point.new(4, 0),
      ...>       Geometry.Point.new(4, 4), Geometry.Point.new(0, 4),
      ...>       Geometry.Point.new(0, 0)
      ...>     ])
      ...>   ])
      ...> ])
      %Geometry.MultiSurface{
        surfaces: [
          %Geometry.Polygon{rings: [[[0, 0], [4, 0], [4, 4], [0, 4], [0, 0]]], srid: 0}
        ],
        srid: 0
      }
  """
  @spec new([surface()], Geometry.srid()) :: t()
  def new(surfaces, srid \\ 0), do: %MultiSurface{surfaces: surfaces, srid: srid}
end
