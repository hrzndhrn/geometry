defmodule Geometry.MultiSurfaceZ do
  @moduledoc """
  A multi-surface struct, representing a 3D collection of surfaces.

  A MultiSurface is a collection of surfaces which can include Polygons or
  CurvePolygons.
  """

  use Geometry.Protocols

  alias Geometry.MultiSurfaceZ

  defstruct surfaces: [], srid: 0

  @type surface ::
          Geometry.PolygonZ.t()
          | Geometry.CurvePolygonZ.t()

  @type t :: %MultiSurfaceZ{surfaces: [surface()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiSurfaceZ`.

  ## Examples

      iex> Geometry.MultiSurfaceZ.new()
      %Geometry.MultiSurfaceZ{surfaces: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiSurfaceZ{}

  @doc """
  Creates a `MultiSurfaceZ` from the given surfaces.

  ## Examples

      iex> Geometry.MultiSurfaceZ.new([
      ...>   Geometry.PolygonZ.new([
      ...>     Geometry.LineStringZ.new([
      ...>       Geometry.PointZ.new(0, 0, 1), Geometry.PointZ.new(4, 0, 2),
      ...>       Geometry.PointZ.new(4, 4, 3), Geometry.PointZ.new(0, 4, 4),
      ...>       Geometry.PointZ.new(0, 0, 1)
      ...>     ])
      ...>   ])
      ...> ])
      %Geometry.MultiSurfaceZ{
        surfaces: [
          %Geometry.PolygonZ{rings: [[[0, 0, 1], [4, 0, 2], [4, 4, 3], [0, 4, 4], [0, 0, 1]]], srid: 0}
        ],
        srid: 0
      }
  """
  @spec new([surface()], Geometry.srid()) :: t()
  def new(surfaces, srid \\ 0), do: %MultiSurfaceZ{surfaces: surfaces, srid: srid}
end
