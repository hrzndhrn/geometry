defmodule Geometry.Point do
  @moduledoc """
  A point struct, representing a 2D point.
  """
  use Geometry.Protocols

  import Geometry.Guards

  alias Geometry.Point

  defstruct coordinates: [], srid: 0

  @type t :: %Point{coordinates: Geometry.coordinates() | [], srid: Geometry.srid()}

  @doc """
  Creates an empty `Point`.

  ## Examples

      iex> Point.new()
      %Point{coordinates: []}
  """
  @spec new :: t()
  def new, do: %Point{}

  @doc """
  Creates a `Point` from the given `coordinate`.

  ## Examples

      iex> Point.new([1.5, -2.1])
      %Point{coordinates: [1.5, -2.1], srid: 0}
  """
  @spec new(Geometry.coordinates()) :: t()
  def new([x, y] = coordinate) when is_coordinate(x, y) do
    %Point{coordinates: coordinate}
  end

  @doc """
  Creates a `Point` from the given `x` and `y`, or a coordinate and an srid

  ## Examples

      iex> Point.new(-1.1, 2.2)
      %Point{coordinates: [-1.1, 2.2], srid: 0}
  """
  @spec new(Geometry.coordinates() | [], Geometry.srid()) :: t()
  def new([], srid) do
    %Point{coordinates: [], srid: srid}
  end

  def new([x, y] = coordinate, srid) when is_coordinate(x, y) do
    %Point{coordinates: coordinate, srid: srid}
  end

  @spec new(number(), number()) :: t()
  def new(x, y) when is_coordinate(x, y) do
    %Point{coordinates: [x, y]}
  end

  @doc """
  Creates a `Point` from the given `x` and `y`.

  ## Examples

      iex> Point.new(-1.1, 2.2, 4326)
      %Point{coordinates: [-1.1, 2.2], srid: 4326}
  """
  @spec new(number(), number(), Geometry.srid()) :: t()
  def new(x, y, srid) when is_coordinate(x, y) do
    %Point{coordinates: [x, y], srid: srid}
  end
end
