defmodule Geometry.MultiLineString do
  @moduledoc """
  A set of line-strings from type `Geometry.LineString`

  `MultiLineStringMZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiLineString.new([
      ...>     LineString.new([
      ...>       Point.new(1, 2),
      ...>       Point.new(3, 4)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(1, 2),
      ...>       Point.new(11, 12),
      ...>       Point.new(13, 14)
      ...>     ])
      ...>   ]),
      ...>   fn line_string -> length line_string end
      ...> )
      [2, 3]

      iex> Enum.into(
      ...>   [LineString.new([Point.new(1, 2), Point.new(5, 6)])],
      ...>   MultiLineString.new())
      %MultiLineString{
        line_strings: [[[1, 2], [5, 6]]], srid: 0
      }
  """

  use Geometry.Protocols

  alias Geometry.LineString
  alias Geometry.MultiLineString

  defstruct line_strings: [], srid: 0

  @type t :: %MultiLineString{line_strings: [Geometry.path()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiLineString`.

  ## Examples

      iex> MultiLineString.new()
      %MultiLineString{}
  """
  @spec new :: t()
  def new, do: %MultiLineString{}

  @doc """
  Creates a `MultiLineString` from the given `Geometry.MultiLineString`s.

  ## Examples

      iex> MultiLineString.new([
      ...>   LineString.new([
      ...>     Point.new(1, 2),
      ...>     Point.new(2, 3),
      ...>     Point.new(3, 4)
      ...>   ]),
      ...>   LineString.new([
      ...>     Point.new(10, 20),
      ...>     Point.new(30, 40)
      ...>   ])
      ...> ])
      %Geometry.MultiLineString{
        line_strings: [
            [[1, 2], [2, 3], [3, 4]],
            [[10, 20], [30, 40]]
          ],
        srid: 0
      }

      iex> MultiLineString.new([])
      %MultiLineString{line_strings: [], srid: 0}
  """
  @spec new([LineString.t()], Geometry.srid()) :: t()
  def new(line_strings, srid \\ 0)

  def new([], srid), do: %MultiLineString{srid: srid}

  def new(line_strings, srid) do
    %MultiLineString{
      line_strings: Enum.map(line_strings, fn line_string -> line_string.path end),
      srid: srid
    }
  end
end
