defmodule Geometry.MultiSurfaceZM do
  @moduledoc """
  A multi-surface struct, representing a 4D collection of surfaces.

  A MultiSurface is a collection of surfaces which can include Polygons or
  CurvePolygons.
  """

  use Geometry.Protocols

  alias Geometry.MultiSurfaceZM

  defstruct surfaces: [], srid: 0

  @type surface ::
          Geometry.PolygonZM.t()
          | Geometry.CurvePolygonZM.t()

  @type t :: %MultiSurfaceZM{surfaces: [surface()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiSurfaceZM`.

  ## Examples

      iex> Geometry.MultiSurfaceZM.new()
      %Geometry.MultiSurfaceZM{surfaces: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiSurfaceZM{}

  @doc """
  Creates a `MultiSurfaceZM` from the given surfaces.

  ## Examples

      iex> Geometry.MultiSurfaceZM.new([
      ...>   Geometry.PolygonZM.new([
      ...>     Geometry.LineStringZM.new([
      ...>       Geometry.PointZM.new(0, 0, 1, 2), Geometry.PointZM.new(4, 0, 2, 3),
      ...>       Geometry.PointZM.new(4, 4, 3, 4), Geometry.PointZM.new(0, 4, 4, 5),
      ...>       Geometry.PointZM.new(0, 0, 5, 9)
      ...>     ])
      ...>   ])
      ...> ])
      %Geometry.MultiSurfaceZM{
        surfaces: [
          %Geometry.PolygonZM{rings: [[[0, 0, 1, 2], [4, 0, 2, 3], [4, 4, 3, 4], [0, 4, 4, 5], [0, 0, 5, 9]]], srid: 0}
        ],
        srid: 0
      }
  """
  @spec new([surface()], Geometry.srid()) :: t()
  def new(surfaces, srid \\ 0), do: %MultiSurfaceZM{surfaces: surfaces, srid: srid}
end
