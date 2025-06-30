defmodule Geometry.LineStringM do
  @moduledoc """
  A line-string struct, representing a 2D line with a measurement.

  A non-empty line-string requires at least two path.
  """

  use Geometry.Protocols

  alias Geometry.LineStringM
  alias Geometry.PointM

  defstruct path: [], srid: 0

  @type t :: %LineStringM{path: Geometry.path(), srid: Geometry.srid()}

  @doc """
  Creates an empty `LineStringM`.

  ## Examples

      iex> LineStringM.new()
      %LineStringM{path: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %LineStringM{}

  @doc """
  Creates a `LineStringM` from the given `Geometry.PointM`s.

  ## Examples

      iex> LineStringM.new([PointM.new(1, 2, 4), PointM.new(3, 4, 6)])
      %LineStringM{path: [[1, 2, 4], [3, 4, 6]], srid: 0}
  """
  @spec new([PointM.t()], Geometry.srid()) :: t()
  def new(path, srid \\ 0)

  def new([], srid), do: %LineStringM{srid: srid}

  def new([_, _ | _] = path, srid) do
    %LineStringM{path: Enum.map(path, fn point -> point.coordinates end), srid: srid}
  end
end
