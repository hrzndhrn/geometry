defmodule Geometry.CircularStringM do
  @moduledoc """
  A circular-string struct, representing a 2D curve with a measurement.

  A non-empty circular-string requires at least three coordinates. In a sequence
  of arcs the end point of the previous arc is the start point of the next arc,
  just like the segments of a LineString. This means that a CircularString must
  have an odd number of points greater than 1.
  """

  use Geometry.Protocols

  alias Geometry.CircularStringM
  alias Geometry.PointM

  defstruct arcs: [], srid: 0

  @type t :: %CircularStringM{arcs: Geometry.arcs(), srid: Geometry.srid()}

  @doc """
  Creates an empty `CircularStringM`.

  ## Examples

      iex> CircularStringM.new()
      %CircularStringM{arcs: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CircularStringM{}

  @doc """
  Creates a `CircularStringM` from the given `Geometry.PointM`s.

  ## Examples

      iex> CircularStringM.new(
      ...>   [PointM.new(1, 2, 3), PointM.new(3, 4, 5), PointM.new(5, 6, 7)])
      %CircularStringM{arcs: [[1, 2, 3], [3, 4, 5], [5, 6, 7]], srid: 0}
  """
  @spec new([PointM.t()], Geometry.srid()) :: t()
  def new(arcs, srid \\ 0)

  def new([], srid), do: %CircularStringM{srid: srid}

  def new([_, _ | _] = arcs, srid) do
    %CircularStringM{arcs: Enum.map(arcs, fn point -> point.coordinates end), srid: srid}
  end
end
