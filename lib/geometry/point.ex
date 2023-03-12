defmodule Geometry.Point do
  @moduledoc """
  A point struct, representing a 2D point.
  """
  use Geometry.Protocols

  import Geometry.Guards

  alias Geometry.Point

  defstruct [:coordinate]

  @type t :: %Point{coordinate: Geometry.coordinate() | []}

  @doc """
  Creates an empty `Point`.

  ## Examples

      iex> Point.new()
      %Point{coordinate: []}
  """
  @spec new :: t()
  def new, do: %Point{coordinate: []}

  @doc """
  Creates a `Point` from the given `coordinate`.

  ## Examples

      iex> Point.new([1.5, -2.1])
      %Point{coordinate: [1.5, -2.1]}
  """
  @spec new(Geometry.coordinate()) :: t()
  def new([x, y] = coordinate) when is_coordinate(x, y) do
    %Point{coordinate: coordinate}
  end

  @doc """
  Creates a `Point` from the given `x` and `y`.

  ## Examples

      iex> Point.new(-1.1, 2.2)
      %Point{coordinate: [-1.1, 2.2]}
  """
  @spec new(number(), number()) :: t()
  def new(x, y) when is_coordinate(x, y) do
    %Point{coordinate: [x, y]}
  end
end
