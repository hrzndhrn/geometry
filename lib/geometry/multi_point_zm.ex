defmodule Geometry.MultiPointZM do
  @moduledoc """
  A set of points from type `Geometry.PointZM`.

  `MultiPointZM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPointZM.new([
      ...>     PointZM.new(1, 2, 3, 4),
      ...>     PointZM.new(3, 4, 5, 6)
      ...>   ]),
      ...>   fn [x, _y, _z, _m] -> x end
      ...> )
      [1, 3]

      iex> Enum.into([PointZM.new(1, 2, 3, 4)], MultiPointZM.new())
      %MultiPointZM{points: [[1, 2, 3, 4]]}
  """

  use Geometry.Protocols

  alias Geometry.MultiPointZM
  alias Geometry.PointZM

  defstruct points: [], srid: 0

  @type t :: %MultiPointZM{points: [Geometry.coordinates()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiPointZM`.

  ## Examples

      iex> MultiPointZM.new()
      %MultiPointZM{}
  """
  @spec new :: t()
  def new, do: %MultiPointZM{}

  @doc """
  Creates a `MultiPointZM` from the given `Geometry.PointZM`s.

  ## Examples

      iex> MultiPointZM.new([
      ...>   PointZM.new(1, 2, 3, 4),
      ...>   PointZM.new(3, 4, 5, 6)
      ...> ])
      %MultiPointZM{points: [[1, 2, 3, 4], [3, 4, 5, 6]], srid: 0}

      iex> MultiPointZM.new([])
      %MultiPointZM{}
  """
  @spec new([PointZM.t()], Geometry.srid()) :: t()
  def new(points, srid \\ 0)

  def new([], srid), do: %MultiPointZM{srid: srid}

  def new(points, srid) do
    %MultiPointZM{points: Enum.map(points, fn point -> point.coordinates end), srid: srid}
  end
end
