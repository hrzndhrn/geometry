defmodule Geometry.MultiCurveM do
  @moduledoc """
  A multi-curve struct, representing a 2D collection of curves with a measurement.

  A MultiCurve is a collection of curves which can include LineStrings,
  CircularStrings or CompoundCurves.
  """

  use Geometry.Protocols

  alias Geometry.MultiCurveM

  defstruct curves: [], srid: 0

  @type curve ::
          Geometry.LineStringM.t()
          | Geometry.CircularStringM.t()
          | Geometry.CompoundCurveM.t()

  @type t :: %MultiCurveM{curves: [curve()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiCurveM`.

  ## Examples

      iex> Geometry.MultiCurveM.new()
      %Geometry.MultiCurveM{curves: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiCurveM{}

  @doc """
  Creates a `MultiCurveM` from the given curves.

  ## Examples

      iex> Geometry.MultiCurveM.new([
      ...>   Geometry.LineStringM.new([
      ...>     Geometry.PointM.new(0, 0, 1),
      ...>     Geometry.PointM.new(5, 5, 2)
      ...>   ]),
      ...>   Geometry.CircularStringM.new([
      ...>     Geometry.PointM.new(4, 0, 6),
      ...>     Geometry.PointM.new(4, 4, 7),
      ...>     Geometry.PointM.new(8, 4, 8)
      ...>   ])
      ...> ])
      %Geometry.MultiCurveM{
        curves: [
          %Geometry.LineStringM{path: [[0, 0, 1], [5, 5, 2]], srid: 0},
          %Geometry.CircularStringM{arcs: [[4, 0, 6], [4, 4, 7], [8, 4, 8]], srid: 0}
        ],
        srid: 0
      }
  """
  @spec new([curve()], Geometry.srid()) :: t()
  def new(curves, srid \\ 0), do: %MultiCurveM{curves: curves, srid: srid}
end
