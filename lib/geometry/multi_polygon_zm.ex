defmodule Geometry.MultiPolygonZM do
  @moduledoc """
  A set of polygons from type `Geometry.PolygonZM`

  `MultiPointZM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPolygonZM.new([
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(11, 12, 13, 14),
      ...>         PointZM.new(11, 22, 23, 24),
      ...>         PointZM.new(31, 22, 33, 34),
      ...>         PointZM.new(11, 12, 13, 14)
      ...>       ]),
      ...>     ]),
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(35, 10, 13, 14),
      ...>         PointZM.new(45, 45, 23, 24),
      ...>         PointZM.new(10, 20, 33, 34),
      ...>         PointZM.new(35, 10, 13, 14)
      ...>       ]),
      ...>       LineStringZM.new([
      ...>         PointZM.new(20, 30, 13, 14),
      ...>         PointZM.new(35, 35, 23, 24),
      ...>         PointZM.new(30, 20, 33, 34),
      ...>         PointZM.new(20, 30, 13, 14)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   fn polygon -> length(polygon) == 1 end
      ...> )
      [true, false]

      iex> Enum.into(
      ...>   [
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(11, 12, 13, 14),
      ...>         PointZM.new(11, 22, 23, 24),
      ...>         PointZM.new(31, 22, 33, 34),
      ...>         PointZM.new(11, 12, 13, 14)
      ...>       ])
      ...>     ])
      ...>   ],
      ...>   MultiPolygonZM.new())
      %MultiPolygonZM{
        polygons: [
            [
              [
                [11, 12, 13, 14],
                [11, 22, 23, 24],
                [31, 22, 33, 34],
                [11, 12, 13, 14]
              ]
            ]
          ]
      }
  """

  use Geometry.Protocols

  alias Geometry.MultiPolygonZM
  alias Geometry.PolygonZM

  defstruct polygons: []

  @type t :: %MultiPolygonZM{polygons: [Geometry.coordinates()]}

  @doc """
  Creates an empty `MultiPolygonZM`.

  ## Examples

      iex> MultiPolygonZM.new()
      %MultiPolygonZM{}
  """
  @spec new :: t()
  def new, do: %MultiPolygonZM{}

  @doc """
  Creates a `MultiPolygonZM` from the given `Geometry.MultiPolygonZM`s.

  ## Examples

      iex> MultiPolygonZM.new([
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(6, 2, 3, 4),
      ...>       PointZM.new(8, 2, 4, 5),
      ...>       PointZM.new(8, 4, 5, 6),
      ...>       PointZM.new(6, 2, 3, 4)
      ...>     ]),
      ...>   ]),
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(1, 1, 3, 4),
      ...>       PointZM.new(9, 1, 4, 5),
      ...>       PointZM.new(9, 8, 5, 6),
      ...>       PointZM.new(1, 1, 3, 4)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(6, 2, 3, 4),
      ...>       PointZM.new(7, 2, 4, 5),
      ...>       PointZM.new(7, 3, 5, 6),
      ...>       PointZM.new(6, 2, 3, 4)
      ...>     ])
      ...>   ])
      ...> ])
      %MultiPolygonZM{
        polygons: [
            [[[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]]],
            [
              [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
              [[6, 2, 3, 4], [7, 2, 4, 5], [7, 3, 5, 6], [6, 2, 3, 4]]
            ]
          ]
      }

      iex> MultiPolygonZM.new([])
      %MultiPolygonZM{}
  """
  @spec new([PolygonZM.t()]) :: t()
  def new([]), do: %MultiPolygonZM{}

  def new(polygons) do
    %MultiPolygonZM{polygons: Enum.map(polygons, fn polygon -> polygon.rings end)}
  end
end
