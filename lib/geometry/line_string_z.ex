defmodule Geometry.LineStringZ do
  @moduledoc """
  A line-string struct, representing a 3D line.

  A non-empty line-string requires at least two coordinates.
  """

  use Geometry.Protocols

  alias Geometry.LineStringZ
  alias Geometry.PointZ

  defstruct path: [], srid: 0

  @type t :: %LineStringZ{path: Geometry.path(), srid: Geometry.srid()}

  @doc """
  Creates an empty `LineStringZ`.

  ## Examples

      iex> LineStringZ.new()
      %LineStringZ{path: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %LineStringZ{}

  @doc """
  Creates a `LineStringZ` from the given `Geometry.PointZ`s.

  ## Examples

      iex> LineStringZ.new([PointZ.new(1, 2, 3), PointZ.new(3, 4, 5)])
      %LineStringZ{path: [[1, 2, 3], [3, 4, 5]], srid: 0}
  """
  @spec new([PointZ.t()], Geometry.srid()) :: t()
  def new(path, srid \\ 0)

  def new([], srid), do: %LineStringZ{srid: srid}

  def new([_, _ | _] = path, srid) do
    %LineStringZ{path: Enum.map(path, fn point -> point.coordinates end), srid: srid}
  end
end
