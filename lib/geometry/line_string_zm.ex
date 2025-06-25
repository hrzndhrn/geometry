defmodule Geometry.LineStringZM do
  @moduledoc """
  A line-string struct, representing a 3D line with a measurement.

  A non-empty line-string requires at least two coordinates.
  """

  use Geometry.Protocols

  alias Geometry.LineStringZM
  alias Geometry.PointZM

  defstruct path: [], srid: 0

  @type t :: %LineStringZM{path: Geometry.path(), srid: Geometry.srid()}

  @doc """
  Creates an empty `LineStringZM`.

  ## Examples

      iex> LineStringZM.new()
      %LineStringZM{path: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %LineStringZM{}

  @doc """
  Creates a `LineStringZM` from the given `Geometry.PointZM`s.

  ## Examples

      iex> LineStringZM.new([PointZM.new(1, 2, 3, 4), PointZM.new(3, 4, 5, 6)])
      %LineStringZM{path: [[1, 2, 3, 4], [3, 4, 5, 6]], srid: 0}
  """
  @spec new([PointZM.t()], Geometry.srid()) :: t()
  def new(path, srid \\ 0)

  def new([], srid), do: %LineStringZM{srid: srid}

  def new([_, _ | _] = path, srid) do
    %LineStringZM{path: Enum.map(path, fn point -> point.coordinates end), srid: srid}
  end
end
