defmodule Geometry.LineString do
  @moduledoc """
  A line-string struct, representing a 2D line.

  A none empty line-string requires at least two points.
  """

  use Geometry.Protocols

  alias Geometry.LineString
  alias Geometry.Point

  defstruct points: [], srid: 0

  @type t :: %LineString{points: Geometry.coordinates(), srid: Geometry.srid()}

  @doc """
  Creates an empty `LineString`.

  ## Examples

      iex> LineString.new()
      %LineString{points: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %LineString{}

  @doc """
  Creates a `LineString` from the given `Geometry.Point`s.

  ## Examples

      iex> LineString.new([Point.new(1, 2), Point.new(3, 4)])
      %LineString{points: [[1, 2], [3, 4]], srid: 0}
  """
  @spec new([Point.t()], Geometry.srid()) :: t()
  def new(poing, srid \\ 0)

  def new([], srid), do: %LineString{srid: srid}

  def new([_, _ | _] = points, srid) do
    %LineString{points: Enum.map(points, fn point -> point.coordinate end), srid: srid}
  end
end
