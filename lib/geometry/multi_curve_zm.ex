defmodule Geometry.MultiCurveZM do
  @moduledoc """
  A multi-curve struct, representing a 4D collection of curves.

  A MultiCurve is a collection of curves which can include LineStrings,
  CircularStrings or CompoundCurves.
  """

  use Geometry.Protocols

  alias Geometry.MultiCurveZM

  defstruct curves: [], srid: 0

  @type curve ::
          Geometry.LineStringZM.t()
          | Geometry.CircularStringZM.t()
          | Geometry.CompoundCurveZM.t()

  @type t :: %MultiCurveZM{curves: [curve()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiCurveZM`.

  ## Examples

      iex> Geometry.MultiCurveZM.new()
      %Geometry.MultiCurveZM{curves: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiCurveZM{}

  @doc """
  Creates a `MultiCurveZM` from the given curves.

  ## Examples

      iex> Geometry.MultiCurveZM.new([
      ...>   Geometry.LineStringZM.new([
      ...>     Geometry.PointZM.new(0, 0, 1, 5),
      ...>     Geometry.PointZM.new(5, 5, 2, 5)
      ...>   ]),
      ...>   Geometry.CircularStringZM.new([
      ...>     Geometry.PointZM.new(4, 0, 6, 5),
      ...>     Geometry.PointZM.new(4, 4, 7, 5),
      ...>     Geometry.PointZM.new(8, 4, 8, 8)
      ...>   ])
      ...> ])
      %Geometry.MultiCurveZM{
        curves: [
          %Geometry.LineStringZM{path: [[0, 0, 1, 5], [5, 5, 2, 5]], srid: 0},
          %Geometry.CircularStringZM{arcs: [[4, 0, 6, 5], [4, 4, 7, 5], [8, 4, 8, 8]], srid: 0}
        ],
        srid: 0
      }
  """
  @spec new([curve()], Geometry.srid()) :: t()
  def new(curves, srid \\ 0), do: %MultiCurveZM{curves: curves, srid: srid}
end
