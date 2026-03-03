defmodule Geometry.CurvePolygon do
  @moduledoc """
  A curve-polygon struct, representing a 2D polygon with curved rings.

  A CurvePolygon is like a polygon, with an outer ring and zero or more inner
  rings. The difference is that a ring can be a CircularString or CompoundCurve
  as well as a LineString.
  """

  use Geometry.Protocols

  alias Geometry.CurvePolygon

  defstruct rings: [], srid: 0

  @type ring ::
          Geometry.LineString.t()
          | Geometry.CircularString.t()
          | Geometry.CompoundCurve.t()

  @type t :: %CurvePolygon{rings: [ring()], srid: Geometry.srid()}

  @doc """
  Creates an empty `CurvePolygon`.

  ## Examples

      iex> Geometry.CurvePolygon.new()
      %Geometry.CurvePolygon{rings: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CurvePolygon{}

  @doc """
  Creates a `CurvePolygon` from the given rings.

  ## Examples

      iex> Geometry.CurvePolygon.new([
      ...>   Geometry.CircularString.new([
      ...>     Geometry.Point.new(0, 0),
      ...>     Geometry.Point.new(4, 0),
      ...>     Geometry.Point.new(4, 4),
      ...>     Geometry.Point.new(0, 4),
      ...>     Geometry.Point.new(0, 0)
      ...>   ])
      ...> ])
      %Geometry.CurvePolygon{
        rings: [
          %Geometry.CircularString{
            arcs: [[0, 0], [4, 0], [4, 4], [0, 4], [0, 0]],
            srid: 0
          }
        ],
        srid: 0
      }

      iex> Geometry.CurvePolygon.new(
      ...>   [
      ...>     Geometry.LineString.new([
      ...>       Geometry.Point.new(0, 0),
      ...>       Geometry.Point.new(10, 0),
      ...>       Geometry.Point.new(10, 10),
      ...>       Geometry.Point.new(0, 0)
      ...>     ])
      ...>   ],
      ...>   4326
      ...> )
      %Geometry.CurvePolygon{
        rings: [
          %Geometry.LineString{path: [[0, 0], [10, 0], [10, 10], [0, 0]], srid: 0}
        ],
        srid: 4326
      }
  """
  @spec new([ring()], Geometry.srid()) :: t()
  def new(rings, srid \\ 0), do: %CurvePolygon{rings: rings, srid: srid}
end
