defmodule Geometry.MultiLineStringZ do
  @moduledoc """
  A set of line-strings from type `Geometry.LineStringZ`

  `MultiLineStringZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiLineStringZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(1, 2, 3),
      ...>       PointZ.new(3, 4, 5)
      ...>     ]),
      ...>     LineStringZ.new([
      ...>       PointZ.new(1, 2, 3),
      ...>       PointZ.new(11, 12, 13),
      ...>       PointZ.new(13, 14, 15)
      ...>     ])
      ...>   ]),
      ...>   fn line_string -> length line_string end
      ...> )
      [2, 3]

      iex> Enum.into(
      ...>   [LineStringZ.new([PointZ.new(1, 2, 3), PointZ.new(5, 6, 7)])],
      ...>   MultiLineStringZ.new())
      %MultiLineStringZ{line_strings: [[[1, 2, 3], [5, 6, 7]]], srid: 0}
  """

  use Geometry.Protocols

  alias Geometry.LineStringZ
  alias Geometry.MultiLineStringZ

  defstruct line_strings: [], srid: 0

  @type t :: %MultiLineStringZ{line_strings: [Geometry.path()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiLineStringZ`.

  ## Examples

      iex> MultiLineStringZ.new()
      %MultiLineStringZ{}
  """
  @spec new :: t()
  def new, do: %MultiLineStringZ{}

  @doc """
  Creates a `MultiLineStringZ` from the given `Geometry.MultiLineStringZ`s.

  ## Examples

      iex> MultiLineStringZ.new([
      ...>   LineStringZ.new([
      ...>     PointZ.new(1, 2, 3),
      ...>     PointZ.new(2, 3, 4),
      ...>     PointZ.new(3, 4, 5)
      ...>   ]),
      ...>   LineStringZ.new([
      ...>     PointZ.new(10, 20, 30),
      ...>     PointZ.new(30, 40, 50)
      ...>   ])
      ...> ])
      %Geometry.MultiLineStringZ{
        line_strings: [
            [[1, 2, 3], [2, 3, 4], [3, 4, 5]],
            [[10, 20, 30], [30, 40, 50]]
          ],
        srid: 0
      }

      iex> MultiLineStringZ.new([])
      %MultiLineStringZ{}
  """
  @spec new([LineStringZ.t()], Geometry.srid()) :: t()
  def new(line_strings, srid \\ 0)

  def new([], srid), do: %MultiLineStringZ{srid: srid}

  def new(line_strings, srid) do
    %MultiLineStringZ{
      line_strings: Enum.map(line_strings, fn line_string -> line_string.path end),
      srid: srid
    }
  end
end
