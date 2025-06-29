defmodule Geometry.PointZ do
  @moduledoc """
  A point struct, representing a 3D point.
  """
  use Geometry.Protocols

  import Geometry.Guards

  alias Geometry.PointZ

  defstruct coordinates: [], srid: 0

  @type t :: %PointZ{coordinates: Geometry.coordinates() | [], srid: Geometry.srid()}

  @doc """
  Creates an empty `PointZ`.

  ## Examples

      iex> PointZ.new()
      %PointZ{coordinates: []}
  """
  @spec new :: t()
  def new, do: %PointZ{coordinates: []}

  @doc """
  Creates a `PointZ` from the given `coordinate`.

  ## Examples

      iex> PointZ.new([1.5, -2.1, 3])
      %PointZ{coordinates: [1.5, -2.1, 3]}
  """
  @spec new(Geometry.coordinates(), Geometry.srid()) :: t()
  def new([x, y, z] = coordinate, srid \\ 0) when is_coordinate(x, y, z) do
    %PointZ{coordinates: coordinate, srid: srid}
  end

  @doc """
  Creates a `PointZ` from the given `x`, `y`, and `z`.

  ## Examples

      iex> PointZ.new(-1.1, 2.2, 3)
      %PointZ{coordinates: [-1.1, 2.2, 3], srid: 0}
  """
  @spec new(number(), number(), number(), Geometry.srid()) :: t()
  def new(x, y, z, srid \\ 0) when is_coordinate(x, y, z) do
    %PointZ{coordinates: [x, y, z], srid: srid}
  end
end
