defmodule Geometry.MultiCurveZ do
  @moduledoc """
  A multi-curve struct, representing a 3D collection of curves.

  A MultiCurve is a collection of curves which can include LineStrings,
  CircularStrings or CompoundCurves.
  """

  use Geometry.Protocols

  alias Geometry.MultiCurveZ

  defstruct curves: [], srid: 0

  @type curve ::
          Geometry.LineStringZ.t()
          | Geometry.CircularStringZ.t()
          | Geometry.CompoundCurveZ.t()

  @type t :: %MultiCurveZ{curves: [curve()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiCurveZ`.

  ## Examples

      iex> Geometry.MultiCurveZ.new()
      %Geometry.MultiCurveZ{curves: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiCurveZ{}

  @doc """
  Creates a `MultiCurveZ` from the given curves.

  ## Examples

      iex> Geometry.MultiCurveZ.new([
      ...>   Geometry.LineStringZ.new([
      ...>     Geometry.PointZ.new(0, 0, 1),
      ...>     Geometry.PointZ.new(5, 5, 2)
      ...>   ]),
      ...>   Geometry.CircularStringZ.new([
      ...>     Geometry.PointZ.new(4, 0, 6),
      ...>     Geometry.PointZ.new(4, 4, 7),
      ...>     Geometry.PointZ.new(8, 4, 8)
      ...>   ])
      ...> ])
      %Geometry.MultiCurveZ{
        curves: [
          %Geometry.LineStringZ{path: [[0, 0, 1], [5, 5, 2]], srid: 0},
          %Geometry.CircularStringZ{arcs: [[4, 0, 6], [4, 4, 7], [8, 4, 8]], srid: 0}
        ],
        srid: 0
      }
  """
  @spec new([curve()], Geometry.srid()) :: t()
  def new(curves, srid \\ 0), do: %MultiCurveZ{curves: curves, srid: srid}
end
