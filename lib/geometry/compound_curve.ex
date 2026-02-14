defmodule Geometry.CompoundCurve do
  @moduledoc """
  A compound-curve struct, representing a 2D curve.

  A CompoundCurve is a single continuous curve that may contain both
  CircularString segments and LineString segments. Each segment must connect
  to the next segment (the end point of one segment must equal the start point
  of the next segment).
  """

  use Geometry.Protocols

  alias Geometry.CompoundCurve

  defstruct segments: [], srid: 0

  @type t :: %CompoundCurve{segments: [Geometry.t()], srid: Geometry.srid()}

  @doc """
  Creates an empty `CompoundCurve`.

  ## Examples

      iex> Geometry.CompoundCurve.new()
      %Geometry.CompoundCurve{segments: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CompoundCurve{}

  @doc """
  Creates a `CompoundCurve` from the given segments.

  ## Examples

      iex> Geometry.CompoundCurve.new([
      ...>   Geometry.LineString.new([Geometry.Point.new(1, 0), Geometry.Point.new(0, 1)])
      ...> ])
      %Geometry.CompoundCurve{
        segments: [%Geometry.LineString{path: [[1, 0], [0, 1]], srid: 0}],
        srid: 0
      }

      iex> Geometry.CompoundCurve.new(
      ...>   [Geometry.LineString.new([Geometry.Point.new(1, 2), Geometry.Point.new(3, 4)])],
      ...>   4326
      ...> )
      %Geometry.CompoundCurve{
        segments: [%Geometry.LineString{path: [[1, 2], [3, 4]], srid: 0}],
        srid: 4326
      }
  """
  @spec new([Geometry.t()], Geometry.srid()) :: t()
  def new(segments, srid \\ 0), do: %CompoundCurve{segments: segments, srid: srid}
end
