defmodule Geometry.MultiPointM do
  @moduledoc """
  A set of points from type `Geometry.PointM`.

  `MultiPointM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPointM.new([
      ...>     PointM.new(1, 2, 4),
      ...>     PointM.new(3, 4, 6)
      ...>   ]),
      ...>   fn [x, _y, _m] -> x end
      ...> )
      [1, 3]

      iex> Enum.into([PointM.new(1, 2, 4)], MultiPointM.new())
      %MultiPointM{points: [[1, 2, 4]]}
  """

  use Geometry.Protocols

  alias Geometry.MultiPointM
  alias Geometry.PointM

  defstruct points: [], srid: 0

  @type t :: %MultiPointM{points: [Geometry.coordinates()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiPointM`.

  ## Examples

      iex> MultiPointM.new()
      %MultiPointM{points: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %MultiPointM{}

  @doc """
  Creates a `MultiPointM` from the given `Geometry.PointM`s.

  ## Examples

      iex> MultiPointM.new([
      ...>   PointM.new(1, 2, 4),
      ...>   PointM.new(3, 4, 6)
      ...> ])
      %MultiPointM{points: [[1, 2, 4], [3, 4, 6]], srid: 0}

      iex> MultiPointM.new([])
      %MultiPointM{points: [], srid: 0}
  """
  @spec new([PointM.t()], Geometry.srid()) :: t()
  def new(points, srid \\ 0)

  def new([], srid), do: %MultiPointM{srid: srid}

  def new(points, srid) do
    %MultiPointM{points: Enum.map(points, fn point -> point.coordinates end), srid: srid}
  end
end
