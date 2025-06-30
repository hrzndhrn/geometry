defmodule Geometry.MultiPointZ do
  @moduledoc """
  A set of coordinates from type `Geometry.PointZ`.

  `MultiPointZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPointZ.new([
      ...>     PointZ.new(1, 2, 3),
      ...>     PointZ.new(3, 4, 5)
      ...>   ]),
      ...>   fn [x, _y, _z] -> x end
      ...> )
      [1, 3]

      iex> Enum.into([PointZ.new(1, 2, 3)], MultiPointZ.new())
      %MultiPointZ{points: [[1, 2, 3]]}
  """

  use Geometry.Protocols

  alias Geometry.MultiPointZ
  alias Geometry.PointZ

  defstruct points: [], srid: 0

  @type t :: %MultiPointZ{points: [Geometry.coordinates()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiPointZ`.

  ## Examples

      iex> MultiPointZ.new()
      %MultiPointZ{points: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiPointZ{}

  @doc """
  Creates a `MultiPointZ` from the given `Geometry.PointZ`s.

  ## Examples

      iex> MultiPointZ.new([
      ...>   PointZ.new(1, 2, 3),
      ...>   PointZ.new(3, 4, 5)
      ...> ])
      %MultiPointZ{points: [[1, 2, 3], [3, 4, 5]], srid: 0}

      iex> MultiPointZ.new([])
      %MultiPointZ{points: [], srid: 0}
  """
  @spec new([PointZ.t()], Geometry.srid()) :: t()
  def new(points, srid \\ 0)

  def new([], srid), do: %MultiPointZ{srid: srid}

  def new(points, srid) do
    %MultiPointZ{points: Enum.map(points, fn point -> point.coordinates end), srid: srid}
  end
end
