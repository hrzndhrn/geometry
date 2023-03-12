defmodule Geometry.PointZ do
  @moduledoc """
  A point struct, representing a 3D point.
  """
  use Geometry.Protocols

  import Geometry.Guards

  alias Geometry.PointZ

  defstruct [:coordinate]

  @type t :: %PointZ{coordinate: Geometry.coordinate() | []}

  @doc """
  Creates an empty `PointZ`.

  ## Examples

      iex> PointZ.new()
      %PointZ{coordinate: []}
  """
  @spec new :: t()
  def new, do: %PointZ{coordinate: []}

  @doc """
  Creates a `PointZ` from the given `coordinate`.

  ## Examples

      iex> PointZ.new([1.5, -2.1, 3])
      %PointZ{coordinate: [1.5, -2.1, 3]}
  """
  @spec new(Geometry.coordinate()) :: t()
  def new([x, y, z] = coordinate) when is_coordinate(x, y, z) do
    %PointZ{coordinate: coordinate}
  end

  @doc """
  Creates a `PointZ` from the given `x`, `y`, and `z`.

  ## Examples

      iex> PointZ.new(-1.1, 2.2, 3)
      %PointZ{coordinate: [-1.1, 2.2, 3]}
  """
  @spec new(number(), number(), number()) :: t()
  def new(x, y, z) when is_coordinate(x, y, z) do
    %PointZ{coordinate: [x, y, z]}
  end
end
