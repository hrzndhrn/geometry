defmodule Geometry.LineStringZ do
  @moduledoc """
  A line-string struct, representing a 3D line.

  A none empty line-string requires at least two points.
  """

  use Geometry.Protocols

  alias Geometry.LineStringZ
  alias Geometry.PointZ

  defstruct points: [], srid: 0

  @type t :: %LineStringZ{points: Geometry.coordinates(), srid: Geometry.srid()}

  @doc """
  Creates an empty `LineStringZ`.

  ## Examples

      iex> LineStringZ.new()
      %LineStringZ{points: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %LineStringZ{}

  @doc """
  Creates a `LineStringZ` from the given `Geometry.PointZ`s.

  ## Examples

      iex> LineStringZ.new([PointZ.new(1, 2, 3), PointZ.new(3, 4, 5)])
      %LineStringZ{points: [[1, 2, 3], [3, 4, 5]], srid: 0}
  """
  @spec new([PointZ.t()], Geometry.srid()) :: t()
  def new(point, srid \\ 0)

  def new([], srid), do: %LineStringZ{srid: srid}

  def new([_, _ | _] = points, srid) do
    %LineStringZ{points: Enum.map(points, fn point -> point.coordinate end), srid: srid}
  end
end
