defmodule Geometry.GeometryCollectionM do
  @moduledoc """
  A collection set of 2D geometries with a measurement.

  `GeometryCollectionM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   GeometryCollectionM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     LineStringM.new([
      ...>       PointM.new(21, 22, 24),
      ...>       PointM.new(31, 32, 34)
      ...>     ])
      ...>   ]),
      ...>   fn
      ...>     %PointM{} -> :point
      ...>     %LineStringM{} -> :line_string
      ...>   end
      ...> ) |> Enum.sort()
      [:line_string, :point]

      iex> Enum.into([PointM.new(1, 2, 4)], GeometryCollectionM.new())
      %GeometryCollectionM{geometries: [%PointM{coordinates: [1, 2, 4]}], srid: 0}
  """

  use Geometry.Protocols

  alias Geometry.GeometryCollectionM

  defstruct geometries: [], srid: 0

  @type t :: %GeometryCollectionM{geometries: [Geometry.t()], srid: Geometry.srid()}

  @doc """
  Creates an empty `GeometryCollectionM`.

  ## Examples

      iex> GeometryCollectionM.new()
      %GeometryCollectionM{}
  """
  @spec new :: t()
  def new, do: %GeometryCollectionM{}

  @doc """
  Creates an empty `GeometryCollectionM`.

  ## Examples

      iex> GeometryCollectionM.new([
      ...>   PointM.new(1, 2, 4),
      ...>   LineStringM.new([PointM.new(1, 1, 1), PointM.new(2, 2, 2)])
      ...> ])
      %GeometryCollectionM{geometries: [
        %PointM{coordinates: [1, 2, 4]},
        %LineStringM{path: [[1, 1, 1], [2, 2, 2]]}
      ],
      srid: 0}
  """
  @spec new([Geometry.t()], Geometry.srid()) :: t()
  def new(geometries, srid \\ 0), do: %GeometryCollectionM{geometries: geometries, srid: srid}
end
