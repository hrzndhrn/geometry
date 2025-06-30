defmodule Geometry.LineString do
  @moduledoc """
  A line-string struct, representing a 2D line.

  A non-empty line-string requires at least two points.
  """

  use Geometry.Protocols

  alias Geometry.LineString
  alias Geometry.Point

  defstruct path: [], srid: 0

  @type t :: %LineString{path: Geometry.path(), srid: Geometry.srid()}

  @doc """
  Creates an empty `LineString`.

  ## Examples

      iex> LineString.new()
      %LineString{path: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %LineString{}

  @doc """
  Creates a `LineString` from the given `Geometry.Point`s.

  ## Examples

      iex> LineString.new([Point.new(1, 2), Point.new(3, 4)])
      %LineString{path: [[1, 2], [3, 4]], srid: 0}
  """
  @spec new([Point.t()], Geometry.srid()) :: t()
  def new(path, srid \\ 0)

  def new([], srid), do: %LineString{srid: srid}

  def new([_, _ | _] = path, srid) do
    %LineString{path: Enum.map(path, fn point -> point.coordinates end), srid: srid}
  end
end
