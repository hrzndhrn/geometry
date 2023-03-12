defmodule Geometry.MultiLineStringZM do
  @moduledoc """
  A set of line-strings from type `Geometry.LineStringZM`

  `MultiLineStringMZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiLineStringZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(1, 2, 3, 4),
      ...>       PointZM.new(3, 4, 5, 6)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(1, 2, 3, 4),
      ...>       PointZM.new(11, 12, 13, 14),
      ...>       PointZM.new(13, 14, 15, 16)
      ...>     ])
      ...>   ]),
      ...>   fn line_string -> length line_string end
      ...> )
      [2, 3]

      iex> Enum.into(
      ...>   [LineStringZM.new([PointZM.new(1, 2, 3, 4), PointZM.new(5, 6, 7, 8)])],
      ...>   MultiLineStringZM.new())
      %MultiLineStringZM{line_strings: [[[1, 2, 3, 4], [5, 6, 7, 8]]]}
  """

  use Geometry.Protocols

  alias Geometry.LineStringZM
  alias Geometry.MultiLineStringZM

  defstruct line_strings: []

  @type t :: %MultiLineStringZM{line_strings: [Geometry.coordinates()]}

  @doc """
  Creates an empty `MultiLineStringZM`.

  ## Examples

      iex> MultiLineStringZM.new()
      %MultiLineStringZM{}
  """
  @spec new :: t()
  def new, do: %MultiLineStringZM{}

  @doc """
  Creates a `MultiLineStringZM` from the given `Geometry.MultiLineStringZM`s.

  ## Examples

      iex> MultiLineStringZM.new([
      ...>   LineStringZM.new([
      ...>     PointZM.new(1, 2, 3, 4),
      ...>     PointZM.new(2, 3, 4, 5),
      ...>     PointZM.new(3, 4, 5, 6)
      ...>   ]),
      ...>   LineStringZM.new([
      ...>     PointZM.new(10, 20, 30, 40),
      ...>     PointZM.new(30, 40, 50, 60)
      ...>   ])
      ...> ])
      %Geometry.MultiLineStringZM{
        line_strings: [
            [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]],
            [[10, 20, 30, 40], [30, 40, 50, 60]]
          ]
      }

      iex> MultiLineStringZM.new([])
      %MultiLineStringZM{}
  """
  @spec new([LineStringZM.t()]) :: t()
  def new([]), do: %MultiLineStringZM{}

  def new(line_strings) do
    %MultiLineStringZM{
      line_strings: Enum.map(line_strings, fn line_string -> line_string.points end)
    }
  end
end
