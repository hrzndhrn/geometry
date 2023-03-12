defmodule Geometry.PolygonZM do
  @moduledoc """
  A polygon struct, representing a 3D polygon with a measurement.

  A none empty line-string requires at least one ring with four points.
  """

  use Geometry.Protocols

  alias Geometry.LineStringZM
  alias Geometry.PolygonZM

  defstruct rings: []

  @type t :: %PolygonZM{rings: [Geometry.coordinates()]}

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
        ]
      }

      iex> PolygonZM.new()
      %PolygonZM{}
  """
  @spec new([LineStringZM.t()]) :: t()
  def new(rings) when is_list(rings) do
    %PolygonZM{rings: Enum.map(rings, fn line_string -> line_string.points end)}
  end
end
