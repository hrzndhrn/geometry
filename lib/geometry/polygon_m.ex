defmodule Geometry.PolygonM do
  @moduledoc """
  A polygon struct, representing a 2D polygon with a measurement.

  A none empty line-string requires at least one ring with four coordinates.
  """

  use Geometry.Protocols

  alias Geometry.LineStringM
  alias Geometry.PolygonM

  defstruct rings: [], srid: 0

  @type t :: %PolygonM{rings: [Geometry.ring()], srid: Geometry.srid()}

  @doc """
  Creates an empty `PolygonM`.

  ## Examples

      iex> PolygonM.new()
      %PolygonM{rings: []}
  """
  @spec new :: t()
  def new, do: %PolygonM{}

  @doc """
  Creates a `PolygonM` from the given `rings`.

  ## Examples

      iex> PolygonM.new([
      ...>   LineStringM.new([
      ...>     PointM.new(35, 10, 14),
      ...>     PointM.new(45, 45, 24),
      ...>     PointM.new(10, 20, 34),
      ...>     PointM.new(35, 10, 14)
      ...>   ]),
      ...>   LineStringM.new([
      ...>     PointM.new(20, 30, 14),
      ...>     PointM.new(35, 35, 24),
      ...>     PointM.new(30, 20, 34),
      ...>     PointM.new(20, 30, 14)
      ...>   ])
      ...> ])
      %PolygonM{
        rings: [
          [[35, 10, 14], [45, 45, 24], [10, 20, 34], [35, 10, 14]],
          [[20, 30, 14], [35, 35, 24], [30, 20, 34], [20, 30, 14]]
        ],
        srid: 0
      }

      iex> PolygonM.new()
      %PolygonM{}
  """
  @spec new([LineStringM.t()], Geometry.srid()) :: t()
  def new(rings, srid \\ 0) when is_list(rings) do
    %PolygonM{rings: Enum.map(rings, fn line_string -> line_string.path end), srid: srid}
  end
end
