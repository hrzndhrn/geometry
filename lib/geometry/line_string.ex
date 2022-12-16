defmodule Geometry.LineString do
  @moduledoc """
  A line-string struct, representing a 2D line.

  A none empty line-string requires at least two points.
  """

  use Geometry.Protocols

  alias Geometry.LineString
  alias Geometry.Point

  defstruct points: []

  @type t :: %LineString{points: Geometry.coordinates()}

  @doc """
  Creates an empty `LineString`.

  ## Examples

      iex> LineString.new()
      %LineString{points: []}
  """
  @spec new :: t()
  def new, do: %LineString{}

  @doc """
  Creates a `LineString` from the given `Geometry.Point`s.

  ## Examples

      iex> LineString.new([Point.new(1, 2), Point.new(3, 4)])
      %LineString{points: [[1, 2], [3, 4]]}
  """
  @spec new([Point.t()]) :: t()
  def new([]), do: %LineString{}

  def new([_, _ | _] = points) do
    %LineString{points: Enum.map(points, fn point -> point.coordinate end)}
  end
end
