defmodule Geometry.MultiPolygonZ do
  @moduledoc """
  A set of polygons from type `Geometry.PolygonZ`

  `MultiPointZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPolygonZ.new([
      ...>     PolygonZ.new([
      ...>       LineStringZ.new([
      ...>         PointZ.new(11, 12, 13),
      ...>         PointZ.new(11, 22, 23),
      ...>         PointZ.new(31, 22, 33),
      ...>         PointZ.new(11, 12, 13)
      ...>       ]),
      ...>     ]),
      ...>     PolygonZ.new([
      ...>       LineStringZ.new([
      ...>         PointZ.new(35, 10, 13),
      ...>         PointZ.new(45, 45, 23),
      ...>         PointZ.new(10, 20, 33),
      ...>         PointZ.new(35, 10, 13)
      ...>       ]),
      ...>       LineStringZ.new([
      ...>         PointZ.new(20, 30, 13),
      ...>         PointZ.new(35, 35, 23),
      ...>         PointZ.new(30, 20, 33),
      ...>         PointZ.new(20, 30, 13)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   fn polygon -> length(polygon) == 1 end
      ...> )
      [true, false]

      iex> Enum.into(
      ...>   [
      ...>     PolygonZ.new([
      ...>       LineStringZ.new([
      ...>         PointZ.new(11, 12, 13),
      ...>         PointZ.new(11, 22, 23),
      ...>         PointZ.new(31, 22, 33),
      ...>         PointZ.new(11, 12, 13)
      ...>       ])
      ...>     ])
      ...>   ],
      ...>   MultiPolygonZ.new())
      %MultiPolygonZ{
        polygons: [
            [
              [
                [11, 12, 13],
                [11, 22, 23],
                [31, 22, 33],
                [11, 12, 13]
              ]
            ]
          ],
        srid: 0
      }
  """

  use Geometry.Protocols

  alias Geometry.MultiPolygonZ
  alias Geometry.PolygonZ

  defstruct polygons: [], srid: 0

  @type t :: %MultiPolygonZ{polygons: [Geometry.coordinates()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiPolygonZ`.

  ## Examples

      iex> MultiPolygonZ.new()
      %MultiPolygonZ{}
  """
  @spec new :: t()
  def new, do: %MultiPolygonZ{}

  @doc """
  Creates a `MultiPolygonZ` from the given `Geometry.MultiPolygonZ`s.

  ## Examples

      iex> MultiPolygonZ.new([
      ...>   PolygonZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(6, 2, 3),
      ...>       PointZ.new(8, 2, 4),
      ...>       PointZ.new(8, 4, 5),
      ...>       PointZ.new(6, 2, 3)
      ...>     ]),
      ...>   ]),
      ...>   PolygonZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(1, 1, 3),
      ...>       PointZ.new(9, 1, 4),
      ...>       PointZ.new(9, 8, 5),
      ...>       PointZ.new(1, 1, 3)
      ...>     ]),
      ...>     LineStringZ.new([
      ...>       PointZ.new(6, 2, 3),
      ...>       PointZ.new(7, 2, 4),
      ...>       PointZ.new(7, 3, 5),
      ...>       PointZ.new(6, 2, 3)
      ...>     ])
      ...>   ])
      ...> ])
      %MultiPolygonZ{
        polygons: [
            [[[6, 2, 3], [8, 2, 4], [8, 4, 5], [6, 2, 3]]],
            [
              [[1, 1, 3], [9, 1, 4], [9, 8, 5], [1, 1, 3]],
              [[6, 2, 3], [7, 2, 4], [7, 3, 5], [6, 2, 3]]
            ]
          ],
          srid: 0
      }

      iex> MultiPolygonZ.new([])
      %MultiPolygonZ{}
  """
  @spec new([PolygonZ.t()], Geometry.srid()) :: t()
  def new(polygons, srid \\ 0)

  def new([], srid), do: %MultiPolygonZ{srid: srid}

  def new(polygons, srid) do
    %MultiPolygonZ{polygons: Enum.map(polygons, fn polygon -> polygon.rings end), srid: srid}
  end
end
