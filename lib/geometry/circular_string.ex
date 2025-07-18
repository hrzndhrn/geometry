defmodule Geometry.CircularString do
  @moduledoc """
  A circular-string struct, representing a 2D curve.

  A non-empty circular-string requires at least three coordinates. In a sequence
  of arcs the end point of the previous arc is the start point of the next arc,
  just like the segments of a LineString. This means that a CircularString must
  have an odd number of points greater than 1.
  """

  use Geometry.Protocols

  alias Geometry.CircularString
  alias Geometry.Point

  defstruct arcs: [], srid: 0

  @type t :: %CircularString{arcs: Geometry.arcs(), srid: Geometry.srid()}

  @doc """
  Creates an empty `CircularString`.

  ## Examples

      iex> CircularString.new()
      %CircularString{arcs: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CircularString{}

  @doc """
  Creates a `CircularString` from the given `Geometry.Point`s.

  ## Examples

      iex> CircularString.new(
      ...>   [Point.new(1, 2), Point.new(3, 4), Point.new(5, 6)])
      %CircularString{arcs: [[1, 2], [3, 4], [5, 6]], srid: 0}
  """
  @spec new([Point.t()], Geometry.srid()) :: t()
  def new(arcs, srid \\ 0)

  def new([], srid), do: %CircularString{srid: srid}

  def new([_, _ | _] = arcs, srid) do
    %CircularString{arcs: Enum.map(arcs, fn point -> point.coordinates end), srid: srid}
  end
end
