defmodule Geometry.MultiPolygon do
  @moduledoc """
  A set of polygons from type `Geometry.Polygon`

  `MultiPoint` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(11, 12),
      ...>         Point.new(11, 22),
      ...>         Point.new(31, 22),
      ...>         Point.new(11, 12)
      ...>       ]),
      ...>     ]),
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(35, 10),
      ...>         Point.new(45, 45),
      ...>         Point.new(10, 20),
      ...>         Point.new(35, 10)
      ...>       ]),
      ...>       LineString.new([
      ...>         Point.new(20, 30),
      ...>         Point.new(35, 35),
      ...>         Point.new(30, 20),
      ...>         Point.new(20, 30)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   fn polygon -> length(polygon) == 1 end
      ...> )
      [true, false]

      iex> Enum.into(
      ...>   [
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(11, 12),
      ...>         Point.new(11, 22),
      ...>         Point.new(31, 22),
      ...>         Point.new(11, 12)
      ...>       ])
      ...>     ])
      ...>   ],
      ...>   MultiPolygon.new())
      %MultiPolygon{
        polygons: [
            [
              [
                [11, 12],
                [11, 22],
                [31, 22],
                [11, 12]
              ]
            ]
          ],
        srid: 0
      }
  """

  use Geometry.Protocols

  alias Geometry.MultiPolygon
  alias Geometry.Polygon

  defstruct polygons: [], srid: 0

  @type t :: %MultiPolygon{polygons: [[Geometry.ring()]], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiPolygon`.

  ## Examples

      iex> MultiPolygon.new()
      %MultiPolygon{polygons: []}
  """
  @spec new :: t()
  def new, do: %MultiPolygon{}

  @doc """
  Creates a `MultiPolygon` from the given `Geometry.MultiPolygon`s.

  ## Examples

      iex> MultiPolygon.new([
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(6, 2),
      ...>       Point.new(8, 2),
      ...>       Point.new(8, 4),
      ...>       Point.new(6, 2)
      ...>     ]),
      ...>   ]),
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(1, 1),
      ...>       Point.new(9, 1),
      ...>       Point.new(9, 8),
      ...>       Point.new(1, 1)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(6, 2),
      ...>       Point.new(7, 2),
      ...>       Point.new(7, 3),
      ...>       Point.new(6, 2)
      ...>     ])
      ...>   ])
      ...> ])
      %MultiPolygon{
        polygons: [
            [[[6, 2], [8, 2], [8, 4], [6, 2]]],
            [
              [[1, 1], [9, 1], [9, 8], [1, 1]],
              [[6, 2], [7, 2], [7, 3], [6, 2]]
            ]
          ],
          srid: 0
      }

      iex> MultiPolygon.new([])
      %MultiPolygon{}
  """
  @spec new([Polygon.t()], Geometry.srid()) :: t()
  def new(polygons, srid \\ 0)

  def new([], srid), do: %MultiPolygon{srid: srid}

  def new(polygons, srid) do
    %MultiPolygon{
      polygons: Enum.map(polygons, fn polygon -> polygon.rings end),
      srid: srid
    }
  end
end
