defmodule Geometry.CircularStringZ do
  @moduledoc """
  A circular-string struct, representing a 3D curve.

  A non-empty circular-string requires at least three coordinates. In a sequence
  of arcs the end point of the previous arc is the start point of the next arc,
  just like the segments of a LineString. This means that a CircularString must
  have an odd number of points greater than 1.
  """

  use Geometry.Protocols

  alias Geometry.CircularStringZ
  alias Geometry.PointZ

  defstruct arcs: [], srid: 0

  @type t :: %CircularStringZ{arcs: Geometry.arcs(), srid: Geometry.srid()}

  @doc """
  Creates an empty `CircularStringZ`.

  ## Examples

      iex> CircularStringZ.new()
      %CircularStringZ{arcs: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CircularStringZ{}

  @doc """
  Creates a `CircularStringZ` from the given `Geometry.PointZ`s.

  ## Examples

      iex> CircularStringZ.new(
      ...>   [PointZ.new(1, 2, 3), PointZ.new(3, 4, 5), PointZ.new(5, 6, 7)])
      %CircularStringZ{arcs: [[1, 2, 3], [3, 4, 5], [5, 6, 7]], srid: 0}
  """
  @spec new([PointZ.t()], Geometry.srid()) :: t()
  def new(arcs, srid \\ 0)

  def new([], srid), do: %CircularStringZ{srid: srid}

  def new([_, _ | _] = arcs, srid) do
    %CircularStringZ{arcs: Enum.map(arcs, fn point -> point.coordinates end), srid: srid}
  end
end
