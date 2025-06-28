defmodule Geometry.Polygon do
  @moduledoc """
  A polygon struct, representing a 2D polygon.

  A non-empty line-string requires at least one ring with four coordinates.
  """

  use Geometry.Protocols

  alias Geometry.LineString
  alias Geometry.Polygon

  defstruct rings: [], srid: 0

  @type t :: %Polygon{rings: [Geometry.ring()], srid: Geometry.srid()}

  @doc """
  Creates an empty `Polygon`.

  ## Examples

      iex> Polygon.new()
      %Polygon{rings: []}
  """
  @spec new :: t()
  def new, do: %Polygon{}

  @doc """
  Creates a `Polygon` from the given `rings`.

  ## Examples

      iex> Polygon.new([
      ...>   LineString.new([
      ...>     Point.new(35, 10),
      ...>     Point.new(45, 45),
      ...>     Point.new(10, 20),
      ...>     Point.new(35, 10)
      ...>   ]),
      ...>   LineString.new([
      ...>     Point.new(20, 30),
      ...>     Point.new(35, 35),
      ...>     Point.new(30, 20),
      ...>     Point.new(20, 30)
      ...>   ])
      ...> ])
      %Polygon{
        rings: [
          [[35, 10], [45, 45], [10, 20], [35, 10]],
          [[20, 30], [35, 35], [30, 20], [20, 30]]
        ],
        srid: 0
      }

      iex> Polygon.new()
      %Polygon{}
  """
  @spec new([LineString.t()], Geometry.srid()) :: t()
  def new(rings, srid \\ 0) when is_list(rings) do
    %Polygon{rings: Enum.map(rings, fn line_string -> line_string.path end), srid: srid}
  end
end
