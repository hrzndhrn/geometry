defmodule Geometry.GeometryCollectionZ do
  @moduledoc """
  A collection set of 3D geometries.

  `GeometryCollectionZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   GeometryCollectionZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     LineStringZ.new([
      ...>       PointZ.new(21, 22, 23),
      ...>       PointZ.new(31, 32, 33)
      ...>     ])
      ...>   ]),
      ...>   fn
      ...>     %PointZ{} -> :point
      ...>     %LineStringZ{} -> :line_string
      ...>   end
      ...> ) |> Enum.sort()
      [:line_string, :point]

      iex> Enum.into([PointZ.new(1, 2, 3)], GeometryCollectionZ.new())
      %GeometryCollectionZ{geometries: [%PointZ{coordinates: [1, 2, 3]}], srid: 0}
  """

  use Geometry.Protocols

  alias Geometry.GeometryCollectionZ

  defstruct geometries: [], srid: 0

  @type t :: %GeometryCollectionZ{geometries: [Geometry.t()], srid: Geometry.srid()}

  @doc """
  Creates an empty `GeometryCollectionZ`.

  ## Examples

      iex> GeometryCollectionZ.new()
      %GeometryCollectionZ{geometries: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %GeometryCollectionZ{}

  @doc """
  Creates an empty `GeometryCollectionZ`.

  ## Examples

      iex> GeometryCollectionZ.new([
      ...>   PointZ.new(1, 2, 3),
      ...>   LineStringZ.new([PointZ.new(1, 1, 1), PointZ.new(2, 2, 2)])
      ...> ])
      %GeometryCollectionZ{geometries: [
        %PointZ{coordinates: [1, 2, 3]},
        %LineStringZ{path: [[1, 1, 1], [2, 2, 2]]}
      ],
      srid: 0}
  """
  @spec new([Geometry.t()], Geometry.srid()) :: t()
  def new(geometries, srid \\ 0), do: %GeometryCollectionZ{geometries: geometries, srid: srid}
end
