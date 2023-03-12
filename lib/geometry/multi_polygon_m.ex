defmodule Geometry.MultiPolygonM do
  @moduledoc """
  A set of polygons from type `Geometry.PolygonM`

  `MultiPointM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPolygonM.new([
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(11, 12, 14),
      ...>         PointM.new(11, 22, 24),
      ...>         PointM.new(31, 22, 34),
      ...>         PointM.new(11, 12, 14)
      ...>       ]),
      ...>     ]),
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(35, 10, 14),
      ...>         PointM.new(45, 45, 24),
      ...>         PointM.new(10, 20, 34),
      ...>         PointM.new(35, 10, 14)
      ...>       ]),
      ...>       LineStringM.new([
      ...>         PointM.new(20, 30, 14),
      ...>         PointM.new(35, 35, 24),
      ...>         PointM.new(30, 20, 34),
      ...>         PointM.new(20, 30, 14)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   fn polygon -> length(polygon) == 1 end
      ...> )
      [true, false]

      iex> Enum.into(
      ...>   [
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(11, 12, 14),
      ...>         PointM.new(11, 22, 24),
      ...>         PointM.new(31, 22, 34),
      ...>         PointM.new(11, 12, 14)
      ...>       ])
      ...>     ])
      ...>   ],
      ...>   MultiPolygonM.new())
      %MultiPolygonM{
        polygons: [
            [
              [
                [11, 12, 14],
                [11, 22, 24],
                [31, 22, 34],
                [11, 12, 14]
              ]
            ]
          ]
      }
  """

  use Geometry.Protocols

  alias Geometry.MultiPolygonM
  alias Geometry.PolygonM

  defstruct polygons: []

  @type t :: %MultiPolygonM{polygons: [Geometry.coordinates()]}

  @doc """
  Creates an empty `MultiPolygonM`.

  ## Examples

      iex> MultiPolygonM.new()
      %MultiPolygonM{}
  """
  @spec new :: t()
  def new, do: %MultiPolygonM{}

  @doc """
  Creates a `MultiPolygonM` from the given `Geometry.MultiPolygonM`s.

  ## Examples

      iex> MultiPolygonM.new([
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(6, 2, 4),
      ...>       PointM.new(8, 2, 5),
      ...>       PointM.new(8, 4, 6),
      ...>       PointM.new(6, 2, 4)
      ...>     ]),
      ...>   ]),
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(1, 1, 4),
      ...>       PointM.new(9, 1, 5),
      ...>       PointM.new(9, 8, 6),
      ...>       PointM.new(1, 1, 4)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(6, 2, 4),
      ...>       PointM.new(7, 2, 5),
      ...>       PointM.new(7, 3, 6),
      ...>       PointM.new(6, 2, 4)
      ...>     ])
      ...>   ])
      ...> ])
      %MultiPolygonM{
        polygons: [
            [[[6, 2, 4], [8, 2, 5], [8, 4, 6], [6, 2, 4]]],
            [
              [[1, 1, 4], [9, 1, 5], [9, 8, 6], [1, 1, 4]],
              [[6, 2, 4], [7, 2, 5], [7, 3, 6], [6, 2, 4]]
            ]
          ]
      }

      iex> MultiPolygonM.new([])
      %MultiPolygonM{}
  """
  @spec new([PolygonM.t()]) :: t()
  def new([]), do: %MultiPolygonM{}

  def new(polygons) do
    %MultiPolygonM{polygons: Enum.map(polygons, fn polygon -> polygon.rings end)}
  end
end
