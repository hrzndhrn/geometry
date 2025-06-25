defmodule Geometry.LineStringZM do
  @moduledoc """
  A line-string struct, representing a 3D line with a measurement.

  A none empty line-string requires at least two points.
  """

  use Geometry.Protocols

  alias Geometry.LineStringZM
  alias Geometry.PointZM

  defstruct points: [], srid: 0

  @type t :: %LineStringZM{points: Geometry.coordinates(), srid: Geometry.srid()}

  @doc """
  Creates an empty `LineStringZM`.

  ## Examples

      iex> LineStringZM.new()
      %LineStringZM{points: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %LineStringZM{}

  @doc """
  Creates a `LineStringZM` from the given `Geometry.PointZM`s.

  ## Examples

      iex> LineStringZM.new([PointZM.new(1, 2, 3, 4), PointZM.new(3, 4, 5, 6)])
      %LineStringZM{points: [[1, 2, 3, 4], [3, 4, 5, 6]], srid: 0}
  """
  @spec new([PointZM.t()], Geometry.srid()) :: t()
  def new(points, srid \\ 0)

  def new([], srid), do: %LineStringZM{srid: srid}

  def new([_, _ | _] = points, srid) do
    %LineStringZM{points: Enum.map(points, fn point -> point.coordinate end), srid: srid}
  end
end
