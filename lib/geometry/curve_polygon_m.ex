defmodule Geometry.CurvePolygonM do
  @moduledoc """
  A curve-polygon struct, representing a 2D polygon with a measurement and curved rings.

  A CurvePolygon is like a polygon, with an outer ring and zero or more inner
  rings. The difference is that a ring can be a CircularString or CompoundCurve
  as well as a LineString.
  """

  use Geometry.Protocols

  alias Geometry.CurvePolygonM

  defstruct rings: [], srid: 0

  @type ring ::
          Geometry.LineStringM.t()
          | Geometry.CircularStringM.t()
          | Geometry.CompoundCurveM.t()

  @type t :: %CurvePolygonM{rings: [ring()], srid: Geometry.srid()}

  @doc """
  Creates an empty `CurvePolygonM`.

  ## Examples

      iex> Geometry.CurvePolygonM.new()
      %Geometry.CurvePolygonM{rings: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CurvePolygonM{}

  @doc """
  Creates a `CurvePolygonM` from the given rings.

  ## Examples

      iex> Geometry.CurvePolygonM.new([
      ...>   Geometry.LineStringM.new([
      ...>     Geometry.PointM.new(0, 0, 1),
      ...>     Geometry.PointM.new(10, 0, 2),
      ...>     Geometry.PointM.new(10, 10, 3),
      ...>     Geometry.PointM.new(0, 0, 1)
      ...>   ])
      ...> ])
      %Geometry.CurvePolygonM{
        rings: [
          %Geometry.LineStringM{
            path: [[0, 0, 1], [10, 0, 2], [10, 10, 3], [0, 0, 1]],
            srid: 0
          }
        ],
        srid: 0
      }
  """
  @spec new([ring()], Geometry.srid()) :: t()
  def new(rings, srid \\ 0), do: %CurvePolygonM{rings: rings, srid: srid}
end
