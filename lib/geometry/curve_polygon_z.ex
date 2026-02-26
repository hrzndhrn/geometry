defmodule Geometry.CurvePolygonZ do
  @moduledoc """
  A curve-polygon struct, representing a 3D polygon with curved rings.

  A CurvePolygon is like a polygon, with an outer ring and zero or more inner
  rings. The difference is that a ring can be a CircularString or CompoundCurve
  as well as a LineString.
  """

  use Geometry.Protocols

  alias Geometry.CurvePolygonZ

  defstruct rings: [], srid: 0

  @type ring ::
          Geometry.LineStringZ.t()
          | Geometry.CircularStringZ.t()
          | Geometry.CompoundCurveZ.t()

  @type t :: %CurvePolygonZ{rings: [ring()], srid: Geometry.srid()}

  @doc """
  Creates an empty `CurvePolygonZ`.

  ## Examples

      iex> Geometry.CurvePolygonZ.new()
      %Geometry.CurvePolygonZ{rings: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CurvePolygonZ{}

  @doc """
  Creates a `CurvePolygonZ` from the given rings.

  ## Examples

      iex> Geometry.CurvePolygonZ.new([
      ...>   Geometry.LineStringZ.new([
      ...>     Geometry.PointZ.new(0, 0, 1),
      ...>     Geometry.PointZ.new(10, 0, 2),
      ...>     Geometry.PointZ.new(10, 10, 3),
      ...>     Geometry.PointZ.new(0, 0, 1)
      ...>   ])
      ...> ])
      %Geometry.CurvePolygonZ{
        rings: [
          %Geometry.LineStringZ{
            path: [[0, 0, 1], [10, 0, 2], [10, 10, 3], [0, 0, 1]],
            srid: 0
          }
        ],
        srid: 0
      }
  """
  @spec new([ring()], Geometry.srid()) :: t()
  def new(rings, srid \\ 0), do: %CurvePolygonZ{rings: rings, srid: srid}
end
