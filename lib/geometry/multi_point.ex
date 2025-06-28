defmodule Geometry.MultiPoint do
  @moduledoc """
  A set of points from type `Geometry.Point`.

  `MultiPoint` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPoint.new([
      ...>     Point.new(1, 2),
      ...>     Point.new(3, 4)
      ...>   ]),
      ...>   fn [x, _y] -> x end
      ...> )
      [1, 3]

      iex> Enum.into([Point.new(1, 2)], MultiPoint.new())
      %MultiPoint{points: [[1, 2]]}
  """

  use Geometry.Protocols

  alias Geometry.MultiPoint
  alias Geometry.Point

  defstruct points: [], srid: 0

  @type t :: %MultiPoint{points: [Geometry.coordinate()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiPoint`.

  ## Examples

      iex> MultiPoint.new()
      %MultiPoint{points: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiPoint{}

  @doc """
  Creates a `MultiPoint` from the given `Geometry.Point`s.

  ## Examples

      iex> MultiPoint.new([
      ...>   Point.new(1, 2),
      ...>   Point.new(3, 4)
      ...> ])
      %MultiPoint{points: [[1, 2], [3, 4]], srid: 0}

      iex> MultiPoint.new([])
      %MultiPoint{points: [], srid: 0}
  """
  @spec new([Point.t()], Geometry.srid()) :: t()
  def new(points, srid \\ 0)

  def new([], srid), do: %MultiPoint{srid: srid}

  def new(points, srid) do
    %MultiPoint{points: Enum.map(points, fn point -> point.coordinate end), srid: srid}
  end
end
