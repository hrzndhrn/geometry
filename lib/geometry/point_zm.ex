defmodule Geometry.PointZM do
  @moduledoc """
  A point struct, representing a 3D point with a measurement.
  """
  use Geometry.Protocols

  import Geometry.Guards

  alias Geometry.PointZM

  defstruct coordinate: [], srid: 0

  @type t :: %PointZM{coordinate: Geometry.coordinate() | [], srid: Geometry.srid()}

  @doc """
  Creates an empty `PointZM`.

  ## Examples

      iex> PointZM.new()
      %PointZM{coordinate: []}
  """
  @spec new :: t()
  def new, do: %PointZM{coordinate: []}

  @doc """
  Creates a `PointZM` from the given `coordinate`.

  ## Examples

      iex> PointZM.new([1.5, -2.1, 3, 4])
      %PointZM{coordinate: [1.5, -2.1, 3, 4]}
  """
  @spec new(Geometry.coordinate(), Geometry.srid()) :: t()
  def new([x, y, z, m] = coordinate, srid \\ 0) when is_coordinate(x, y, z, m) do
    %PointZM{coordinate: coordinate, srid: srid}
  end

  @doc """
  Creates a `PointZM` from the given `x`, `y`, `z`, and `m`.

  ## Examples

      iex> PointZM.new(-1.1, 2.2, 3, 4)
      %PointZM{coordinate: [-1.1, 2.2, 3, 4], srid: 0}
  """
  @spec new(number(), number(), number(), number(), Geometry.srid()) :: t()
  def new(x, y, z, m, srid \\ 0) when is_coordinate(x, y, z, m) do
    %PointZM{coordinate: [x, y, z, m], srid: srid}
  end
end
