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
      %GeometryCollectionZM{geometries: [%PointZM{coordinates: [1, 2, 3, 4]}], srid: 0}
  """

  use Geometry.Protocols

  alias Geometry.GeometryCollectionZM

  defstruct geometries: [], srid: 0

  @type t :: %GeometryCollectionZM{geometries: [Geometry.t()], srid: Geometry.srid()}

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
        %PointZM{coordinates: [1, 2, 3, 4]},
        %LineStringZM{path: [[1, 1, 1, 1], [2, 2, 2, 2]]}
      ],
      srid: 0}
  """
  @spec new([Geometry.t()], Geometry.srid()) :: t()
  def new(geometries, srid \\ 0), do: %GeometryCollectionZM{geometries: geometries, srid: srid}
end
