defmodule Geometry.CompoundCurveZM do
  @moduledoc """
  A compound-curve struct, representing a 4D curve.

  A CompoundCurve is a single continuous curve that may contain both
  CircularString segments and LineString segments. Each segment must connect
  to the next segment (the end point of one segment must equal the start point
  of the next segment).
  """

  use Geometry.Protocols

  alias Geometry.CompoundCurveZM

  defstruct segments: [], srid: 0

  @type t :: %CompoundCurveZM{segments: [Geometry.t()], srid: Geometry.srid()}

  @doc """
  Creates an empty `CompoundCurveZM`.

  ## Examples

      iex> Geometry.CompoundCurveZM.new()
      %Geometry.CompoundCurveZM{segments: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CompoundCurveZM{}

  @doc """
  Creates a `CompoundCurveZM` from the given segments.

  ## Examples

      iex> Geometry.CompoundCurveZM.new([
      ...>   Geometry.LineStringZM.new([
      ...>     Geometry.PointZM.new(1, 0, 1, 5),
      ...>     Geometry.PointZM.new(0, 1, 2, 6)
      ...>   ])
      ...> ])
      %Geometry.CompoundCurveZM{
        segments: [%Geometry.LineStringZM{path: [[1, 0, 1, 5], [0, 1, 2, 6]], srid: 0}],
        srid: 0
      }
  """
  @spec new([Geometry.t()], Geometry.srid()) :: t()
  def new(segments, srid \\ 0), do: %CompoundCurveZM{segments: segments, srid: srid}
end
