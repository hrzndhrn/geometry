defmodule Geometry.PolygonZ do
  @moduledoc """
  A polygon struct, representing a 3D polygon.

  A non-empty line-string requires at least one ring with four coordinates.
  """

  use Geometry.Protocols

  alias Geometry.LineStringZ
  alias Geometry.PolygonZ

  defstruct rings: [], srid: 0

  @type t :: %PolygonZ{rings: [Geometry.ring()], srid: Geometry.srid()}

  @doc """
  Creates an empty `PolygonZ`.

  ## Examples

      iex> PolygonZ.new()
      %PolygonZ{rings: []}
  """
  @spec new :: t()
  def new, do: %PolygonZ{}

  @doc """
  Creates a `PolygonZ` from the given `rings`.

  ## Examples

      iex> PolygonZ.new([
      ...>   LineStringZ.new([
      ...>     PointZ.new(35, 10, 13),
      ...>     PointZ.new(45, 45, 23),
      ...>     PointZ.new(10, 20, 33),
      ...>     PointZ.new(35, 10, 13)
      ...>   ]),
      ...>   LineStringZ.new([
      ...>     PointZ.new(20, 30, 13),
      ...>     PointZ.new(35, 35, 23),
      ...>     PointZ.new(30, 20, 33),
      ...>     PointZ.new(20, 30, 13)
      ...>   ])
      ...> ])
      %PolygonZ{
        rings: [
          [[35, 10, 13], [45, 45, 23], [10, 20, 33], [35, 10, 13]],
          [[20, 30, 13], [35, 35, 23], [30, 20, 33], [20, 30, 13]]
        ],
        srid: 0
      }

      iex> PolygonZ.new()
      %PolygonZ{}
  """
  @spec new([LineStringZ.t()], Geometry.srid()) :: t()
  def new(rings, srid \\ 0) when is_list(rings) do
    %PolygonZ{rings: Enum.map(rings, fn line_string -> line_string.path end), srid: srid}
  end
end
