defmodule Geometry.GeometryCollection do
  @moduledoc """
  A collection set of 2D geometries.

  `GeometryCollection` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   GeometryCollection.new([
      ...>     Point.new(11, 12),
      ...>     LineString.new([
      ...>       Point.new(21, 22),
      ...>       Point.new(31, 32)
      ...>     ])
      ...>   ]),
      ...>   fn
      ...>     %Point{} -> :point
      ...>     %LineString{} -> :line_string
      ...>   end
      ...> ) |> Enum.sort()
      [:line_string, :point]

      iex> Enum.into([Point.new(1, 2)], GeometryCollection.new())
      %GeometryCollection{geometries: [%Point{coordinates: [1, 2]}]}
  """

  use Geometry.Protocols

  alias Geometry.GeometryCollection

  defstruct geometries: [], srid: 0

  @type t :: %GeometryCollection{geometries: [], srid: Geometry.srid()}

  @doc """
  Creates an empty `GeometryCollection`.

  ## Examples

      iex> GeometryCollection.new()
      %GeometryCollection{geometries: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %GeometryCollection{}

  @doc """
  Creates an empty `GeometryCollection`.

  ## Examples

      iex> GeometryCollection.new([
      ...>   Point.new(1, 2),
      ...>   LineString.new([Point.new(1, 1), Point.new(2, 2)])
      ...> ])
      %GeometryCollection{geometries: [
        %Point{coordinates: [1, 2]},
        %LineString{path: [[1, 1], [2, 2]]}
      ],
      srid: 0}
  """
  @spec new([Geometry.t()], Geometry.srid()) :: t()
  def new(geometries, srid \\ 0), do: %GeometryCollection{geometries: geometries, srid: srid}
end
