defmodule Geometry.CircularStringZM do
  @moduledoc """
  A circular-string struct, representing a 3D curve with a measurement.

  A non-empty circular-string requires at least three coordinates. In a sequence
  of arcs the end point of the previous arc is the start point of the next arc,
  just like the segments of a LineString. This means that a CircularString must
  have an odd number of points greater than 1.
  """

  use Geometry.Protocols

  import Geometry.Guards

  alias Geometry.CircularStringZM
  alias Geometry.PointZM

  defstruct arcs: [], srid: 0

  @type t :: %CircularStringZM{arcs: Geometry.arcs(), srid: Geometry.srid()}

  @doc """
  Creates an empty `CircularStringZM`.

  ## Examples

      iex> CircularStringZM.new()
      %CircularStringZM{arcs: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CircularStringZM{}

  @doc """
  Creates a `CircularStringZM` from the given `Geometry.PointZM`s.

  ## Examples

      iex> CircularStringZM.new(
      ...>   [PointZM.new(1, 2, 3, 4), PointZM.new(3, 4, 5, 6), PointZM.new(5, 6, 7, 8)])
      %CircularStringZM{arcs: [[1, 2, 3, 4], [3, 4, 5, 6], [5, 6, 7, 8]], srid: 0}
  """
  @spec new([PointZM.t()], Geometry.srid()) :: t()
  def new(arcs, srid \\ 0)

  def new([], srid), do: %CircularStringZM{srid: srid}

  def new([_, _ | _] = arcs, srid) when is_odd_list(arcs) do
    %CircularStringZM{arcs: Enum.map(arcs, fn point -> point.coordinates end), srid: srid}
  end
end
