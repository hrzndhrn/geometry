defmodule Geometry.CompoundCurveM do
  @moduledoc """
  A compound-curve struct, representing a 2D curve with a measurement.

  A CompoundCurve is a single continuous curve that may contain both
  CircularString segments and LineString segments. Each segment must connect
  to the next segment (the end point of one segment must equal the start point
  of the next segment).
  """

  use Geometry.Protocols

  alias Geometry.CompoundCurveM

  defstruct segments: [], srid: 0

  @type t :: %CompoundCurveM{segments: [Geometry.t()], srid: Geometry.srid()}

  @doc """
  Creates an empty `CompoundCurveM`.

  ## Examples

      iex> Geometry.CompoundCurveM.new()
      %Geometry.CompoundCurveM{segments: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CompoundCurveM{}

  @doc """
  Creates a `CompoundCurveM` from the given segments.

  ## Examples

      iex> Geometry.CompoundCurveM.new([
      ...>   Geometry.LineStringM.new([
      ...>     Geometry.PointM.new(1, 0, 5),
      ...>     Geometry.PointM.new(0, 1, 6)
      ...>   ])
      ...> ])
      %Geometry.CompoundCurveM{
        segments: [%Geometry.LineStringM{path: [[1, 0, 5], [0, 1, 6]], srid: 0}],
        srid: 0
      }
  """
  @spec new([Geometry.t()], Geometry.srid()) :: t()
  def new(segments, srid \\ 0), do: %CompoundCurveM{segments: segments, srid: srid}
end
