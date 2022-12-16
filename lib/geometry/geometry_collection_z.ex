defmodule Geometry.GeometryCollectionZ do
  # This file is auto-generated by `mix geometry.gen`.
  # The ZM version of this file is used as a template.

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
      %GeometryCollectionZ{geometries: [%PointZ{coordinate: [1, 2, 3]}]}
  """

  use Geometry.Protocols

  alias Geometry.GeometryCollectionZ

  defstruct geometries: []

  @type t :: %GeometryCollectionZ{geometries: [Geometry.t()]}

  @doc """
  Creates an empty `GeometryCollectionZ`.

  ## Examples

      iex> GeometryCollectionZ.new()
      %GeometryCollectionZ{geometries: []}
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
        %PointZ{coordinate: [1, 2, 3]},
        %LineStringZ{points: [[1, 1, 1], [2, 2, 2]]}
      ]}
  """
  @spec new([Geometry.t()]) :: t()
  def new(geometries), do: %GeometryCollectionZ{geometries: geometries}
end
