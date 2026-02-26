defmodule Geometry.CurvePolygonZM do
  @moduledoc """
  A curve-polygon struct, representing a 4D polygon with curved rings.

  A CurvePolygon is like a polygon, with an outer ring and zero or more inner
  rings. The difference is that a ring can be a CircularString or CompoundCurve
  as well as a LineString.
  """

  use Geometry.Protocols

  alias Geometry.CurvePolygonZM

  defstruct rings: [], srid: 0

  @type ring ::
          Geometry.LineStringZM.t()
          | Geometry.CircularStringZM.t()
          | Geometry.CompoundCurveZM.t()

  @type t :: %CurvePolygonZM{rings: [ring()], srid: Geometry.srid()}

  @doc """
  Creates an empty `CurvePolygonZM`.

  ## Examples

      iex> Geometry.CurvePolygonZM.new()
      %Geometry.CurvePolygonZM{rings: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CurvePolygonZM{}

  @doc """
  Creates a `CurvePolygonZM` from the given rings.

  ## Examples

      iex> Geometry.CurvePolygonZM.new([
      ...>   Geometry.LineStringZM.new([
      ...>     Geometry.PointZM.new(0, 0, 1, 10),
      ...>     Geometry.PointZM.new(10, 0, 2, 11),
      ...>     Geometry.PointZM.new(10, 10, 3, 12),
      ...>     Geometry.PointZM.new(0, 0, 1, 10)
      ...>   ])
      ...> ])
      %Geometry.CurvePolygonZM{
        rings: [
          %Geometry.LineStringZM{
            path: [[0, 0, 1, 10], [10, 0, 2, 11], [10, 10, 3, 12], [0, 0, 1, 10]],
            srid: 0
          }
        ],
        srid: 0
      }
  """
  @spec new([ring()], Geometry.srid()) :: t()
  def new(rings, srid \\ 0), do: %CurvePolygonZM{rings: rings, srid: srid}
end
