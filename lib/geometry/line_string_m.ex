defmodule Geometry.LineStringM do
  @moduledoc """
  A line-string struct, representing a 2D line with a measurement.

  A none empty line-string requires at least two points.
  """

  use Geometry.Protocols

  alias Geometry.LineStringM
  alias Geometry.PointM

  defstruct points: [], srid: 0

  @type t :: %LineStringM{points: Geometry.coordinates(), srid: Geometry.srid()}

  @doc """
  Creates an empty `LineStringM`.

  ## Examples

      iex> LineStringM.new()
      %LineStringM{points: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %LineStringM{}

  @doc """
  Creates a `LineStringM` from the given `Geometry.PointM`s.

  ## Examples

      iex> LineStringM.new([PointM.new(1, 2, 4), PointM.new(3, 4, 6)])
      %LineStringM{points: [[1, 2, 4], [3, 4, 6]], srid: 0}
  """
  @spec new([PointM.t()], Geometry.srid()) :: t()
  def new(points, srid \\ 0)

  def new([], srid), do: %LineStringM{srid: srid}

  def new([_, _ | _] = points, srid) do
    %LineStringM{points: Enum.map(points, fn point -> point.coordinate end), srid: srid}
  end
end
