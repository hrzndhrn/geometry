defmodule Geometry.MultiLineStringM do
  @moduledoc """
  A set of line-strings from type `Geometry.LineStringM`

  `MultiLineStringMZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiLineStringM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(1, 2, 4),
      ...>       PointM.new(3, 4, 6)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(1, 2, 4),
      ...>       PointM.new(11, 12, 14),
      ...>       PointM.new(13, 14, 16)
      ...>     ])
      ...>   ]),
      ...>   fn line_string -> length line_string end
      ...> )
      [2, 3]

      iex> Enum.into(
      ...>   [LineStringM.new([PointM.new(1, 2, 4), PointM.new(5, 6, 8)])],
      ...>   MultiLineStringM.new())
      %MultiLineStringM{line_strings: [[[1, 2, 4], [5, 6, 8]]], srid: 0}
  """

  use Geometry.Protocols

  alias Geometry.LineStringM
  alias Geometry.MultiLineStringM

  defstruct line_strings: [], srid: 0

  @type t :: %MultiLineStringM{line_strings: [Geometry.path()], srid: Geometry.srid()}

  @doc """
  Creates an empty `MultiLineStringM`.

  ## Examples

      iex> MultiLineStringM.new()
      %MultiLineStringM{}
  """
  @spec new :: t()
  def new, do: %MultiLineStringM{}

  @doc """
  Creates a `MultiLineStringM` from the given `Geometry.MultiLineStringM`s.

  ## Examples

      iex> MultiLineStringM.new([
      ...>   LineStringM.new([
      ...>     PointM.new(1, 2, 4),
      ...>     PointM.new(2, 3, 5),
      ...>     PointM.new(3, 4, 6)
      ...>   ]),
      ...>   LineStringM.new([
      ...>     PointM.new(10, 20, 40),
      ...>     PointM.new(30, 40, 60)
      ...>   ])
      ...> ])
      %Geometry.MultiLineStringM{
        line_strings:
          [
            [[1, 2, 4], [2, 3, 5], [3, 4, 6]],
            [[10, 20, 40], [30, 40, 60]]
          ],
          srid: 0
      }

      iex> MultiLineStringM.new([])
      %MultiLineStringM{}
  """
  @spec new([LineStringM.t()], Geometry.srid()) :: t()
  def new(line_strings, srid \\ 0)
  def new([], srid), do: %MultiLineStringM{srid: srid}

  def new(line_strings, srid) do
    %MultiLineStringM{
      line_strings: Enum.map(line_strings, fn line_string -> line_string.path end),
      srid: srid
    }
  end
end
