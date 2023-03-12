defmodule Geometry.LineStringM do
  @moduledoc """
  A line-string struct, representing a 2D line with a measurement.

  A none empty line-string requires at least two points.
  """

  use Geometry.Protocols

  alias Geometry.LineStringM
  alias Geometry.PointM

  defstruct points: []

  @type t :: %LineStringM{points: Geometry.coordinates()}

  @doc """
  Creates an empty `LineStringM`.

  ## Examples

      iex> LineStringM.new()
      %LineStringM{points: []}
  """
  @spec new :: t()
  def new, do: %LineStringM{}

  @doc """
  Creates a `LineStringM` from the given `Geometry.PointM`s.

  ## Examples

      iex> LineStringM.new([PointM.new(1, 2, 4), PointM.new(3, 4, 6)])
      %LineStringM{points: [[1, 2, 4], [3, 4, 6]]}
  """
  @spec new([PointM.t()]) :: t()
  def new([]), do: %LineStringM{}

  def new([_, _ | _] = points) do
    %LineStringM{points: Enum.map(points, fn point -> point.coordinate end)}
  end
end
