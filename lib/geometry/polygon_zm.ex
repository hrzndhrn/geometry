defmodule Geometry.PolygonZM do
  @moduledoc """
  A polygon struct, representing a 3D polygon with a measurement.

  A non-empty line-string requires at least one ring with four coordinates.
  """

  use Geometry.Protocols

  alias Geometry.LineStringZM
  alias Geometry.PolygonZM

  defstruct rings: [], srid: 0

  @type t :: %PolygonZM{rings: [Geometry.ring()], srid: Geometry.srid()}

  @doc """
  Creates an empty `PolygonZM`.

  ## Examples

      iex> PolygonZM.new()
      %PolygonZM{rings: []}
  """
  @spec new :: t()
  def new, do: %PolygonZM{}

  @doc """
  Creates a `PolygonZM` from the given `rings`.

  ## Examples

      iex> PolygonZM.new([
      ...>   LineStringZM.new([
      ...>     PointZM.new(35, 10, 13, 14),
      ...>     PointZM.new(45, 45, 23, 24),
      ...>     PointZM.new(10, 20, 33, 34),
      ...>     PointZM.new(35, 10, 13, 14)
      ...>   ]),
      ...>   LineStringZM.new([
      ...>     PointZM.new(20, 30, 13, 14),
      ...>     PointZM.new(35, 35, 23, 24),
      ...>     PointZM.new(30, 20, 33, 34),
      ...>     PointZM.new(20, 30, 13, 14)
      ...>   ])
      ...> ])
      %PolygonZM{
        rings: [
          [[35, 10, 13, 14], [45, 45, 23, 24], [10, 20, 33, 34], [35, 10, 13, 14]],
          [[20, 30, 13, 14], [35, 35, 23, 24], [30, 20, 33, 34], [20, 30, 13, 14]]
        ],
        srid: 0
      }

      iex> PolygonZM.new()
      %PolygonZM{}
  """
  @spec new([LineStringZM.t()], Geometry.srid()) :: t()
  def new(rings, srid \\ 0) when is_list(rings) do
    %PolygonZM{rings: Enum.map(rings, fn line_string -> line_string.path end), srid: srid}
  end
end
