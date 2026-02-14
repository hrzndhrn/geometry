defmodule Geometry.CompoundCurveZ do
  @moduledoc """
  A compound-curve struct, representing a 3D curve.

  A CompoundCurve is a single continuous curve that may contain both
  CircularString segments and LineString segments. Each segment must connect
  to the next segment (the end point of one segment must equal the start point
  of the next segment).
  """

  use Geometry.Protocols

  alias Geometry.CompoundCurveZ

  defstruct segments: [], srid: 0

  @type t :: %CompoundCurveZ{segments: [Geometry.t()], srid: Geometry.srid()}

  @doc """
  Creates an empty `CompoundCurveZ`.

  ## Examples

      iex> Geometry.CompoundCurveZ.new()
      %Geometry.CompoundCurveZ{segments: [], srid: 0}
  """
  @spec new :: t()
  def new, do: %CompoundCurveZ{}

  @doc """
  Creates a `CompoundCurveZ` from the given segments.

  ## Examples

      iex> Geometry.CompoundCurveZ.new([
      ...>   Geometry.LineStringZ.new([
      ...>     Geometry.PointZ.new(1, 0, 1),
      ...>     Geometry.PointZ.new(0, 1, 2)
      ...>   ])
      ...> ])
      %Geometry.CompoundCurveZ{
        segments: [%Geometry.LineStringZ{path: [[1, 0, 1], [0, 1, 2]], srid: 0}],
        srid: 0
      }
  """
  @spec new([Geometry.t()], Geometry.srid()) :: t()
  def new(segments, srid \\ 0), do: %CompoundCurveZ{segments: segments, srid: srid}
end
