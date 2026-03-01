defmodule Geometry.MultiSurfaceM do
  @moduledoc """
  A multi-surface struct, representing a 2D collection of surfaces with a measurement.

  A MultiSurface is a collection of surfaces which can include Polygons or
  CurvePolygons.
  """

  use Geometry.Protocols

  alias Geometry.MultiSurfaceM

  defstruct surfaces: [], srid: 0

  @type surface ::
          Geometry.PolygonM.t()
          | Geometry.CurvePolygonM.t()

  @type t :: %MultiSurfaceM{surfaces: [surface()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiSurfaceM`.

  ## Examples

      iex> Geometry.MultiSurfaceM.new()
      %Geometry.MultiSurfaceM{surfaces: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiSurfaceM{}

  @doc """
  Creates a `MultiSurfaceM` from the given surfaces.

  ## Examples

      iex> Geometry.MultiSurfaceM.new([
      ...>   Geometry.PolygonM.new([
      ...>     Geometry.LineStringM.new([
      ...>       Geometry.PointM.new(0, 0, 1), Geometry.PointM.new(4, 0, 2),
      ...>       Geometry.PointM.new(4, 4, 3), Geometry.PointM.new(0, 4, 4),
      ...>       Geometry.PointM.new(0, 0, 5)
      ...>     ])
      ...>   ])
      ...> ])
      %Geometry.MultiSurfaceM{
        surfaces: [
          %Geometry.PolygonM{rings: [[[0, 0, 1], [4, 0, 2], [4, 4, 3], [0, 4, 4], [0, 0, 5]]], srid: 0}
        ],
        srid: 0
      }
  """
  @spec new([surface()], Geometry.srid()) :: t()
  def new(surfaces, srid \\ 0), do: %MultiSurfaceM{surfaces: surfaces, srid: srid}
end
