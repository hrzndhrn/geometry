defmodule Geometry.GeometryCollectionZM do
  @moduledoc """
  A collection set of 3D geometries with a measurement.

  `GeometryCollectionZM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   GeometryCollectionZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     LineStringZM.new([
      ...>       PointZM.new(21, 22, 23, 24),
      ...>       PointZM.new(31, 32, 33, 34)
      ...>     ])
      ...>   ]),
      ...>   fn
      ...>     %PointZM{} -> :point
      ...>     %LineStringZM{} -> :line_string
      ...>   end
      ...> ) |> Enum.sort()
      [:line_string, :point]

      iex> Enum.into([PointZM.new(1, 2, 3, 4)], GeometryCollectionZM.new())
      %GeometryCollectionZM{geometries: [%PointZM{coordinate: [1, 2, 3, 4]}]}
  """

  use Geometry.Protocols

  alias Geometry.GeometryCollectionZM

  defstruct geometries: []

  @type t :: %GeometryCollectionZM{geometries: [Geometry.t()]}

  @doc """
  Creates an empty `GeometryCollectionZM`.

  ## Examples

      iex> GeometryCollectionZM.new()
      %GeometryCollectionZM{}
  """
  @spec new :: t()
  def new, do: %GeometryCollectionZM{}

  @doc """
  Creates an empty `GeometryCollectionZM`.

  ## Examples

      iex> GeometryCollectionZM.new([
      ...>   PointZM.new(1, 2, 3, 4),
      ...>   LineStringZM.new([PointZM.new(1, 1, 1, 1), PointZM.new(2, 2, 2, 2)])
      ...> ])
      %GeometryCollectionZM{geometries: [
        %PointZM{coordinate: [1, 2, 3, 4]},
        %LineStringZM{points: [[1, 1, 1, 1], [2, 2, 2, 2]]}
      ]}
  """
  @spec new([Geometry.t()]) :: t()
  def new(geometries), do: %GeometryCollectionZM{geometries: geometries}
end
