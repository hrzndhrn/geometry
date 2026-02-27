defmodule Geometry.MultiCurve do
  @moduledoc """
  A multi-curve struct, representing a 2D collection of curves.

  A MultiCurve is a collection of curves which can include LineStrings,
  CircularStrings or CompoundCurves.
  """

  use Geometry.Protocols

  alias Geometry.MultiCurve

  defstruct curves: [], srid: 0

  @type curve ::
          Geometry.LineString.t()
          | Geometry.CircularString.t()
          | Geometry.CompoundCurve.t()

  @type t :: %MultiCurve{curves: [curve()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiCurve`.

  ## Examples

      iex> Geometry.MultiCurve.new()
      %Geometry.MultiCurve{curves: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiCurve{}

  @doc """
  Creates a `MultiCurve` from the given curves.

  ## Examples

      iex> Geometry.MultiCurve.new([
      ...>   Geometry.LineString.new([
      ...>     Geometry.Point.new(0, 0),
      ...>     Geometry.Point.new(5, 5)
      ...>   ]),
      ...>   Geometry.CircularString.new([
      ...>     Geometry.Point.new(4, 0),
      ...>     Geometry.Point.new(4, 4),
      ...>     Geometry.Point.new(8, 4)
      ...>   ])
      ...> ])
      %Geometry.MultiCurve{
        curves: [
          %Geometry.LineString{path: [[0, 0], [5, 5]], srid: 0},
          %Geometry.CircularString{arcs: [[4, 0], [4, 4], [8, 4]], srid: 0}
        ],
        srid: 0
      }
  """
  @spec new([curve()], Geometry.srid()) :: t()
  def new(curves, srid \\ 0), do: %MultiCurve{curves: curves, srid: srid}
end
