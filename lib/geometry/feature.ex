defmodule Geometry.Feature do
  @moduledoc """
  A combination of a `geometry` and `properties`.
  """

  alias Geometry.Feature

  defstruct [:geometry, :properties]

  @type t :: %Feature{
          geometry: Geometry.t() | nil,
          properties: map() | nil
        }

  @doc """
  Creates a new empty `Feature`.

  ## Examples

      iex> Feature.new()
      %Feature{}
  """
  @spec new :: Feature.t()
  def new, do: %Feature{}

  @doc """
  Creates a new `Feature`.

  ## Examples

      iex> Feature.new(
      ...>   geometry: Point.new(1, 2),
      ...>   properties: %{facility: :hotel}
      ...> )
      %Feature{
        geometry: %Point{coordinates: [1, 2]},
        properties: %{facility: :hotel}
      }
  """
  @spec new(geometry: Geometry.t(), properties: map()) :: t()
  def new(data), do: struct(Feature, data)

  defimpl Geometry.Protocol do
    def empty?(%{geometry: geometry}), do: is_nil(geometry)
  end

  defimpl Geometry.Encoder.GeoJson do
    def to_geo_json(feature) do
      geometry =
        case feature.geometry do
          nil -> nil
          geometry -> Geometry.to_geo_json(geometry)
        end

      %{
        "type" => "Feature",
        "geometry" => geometry,
        "properties" => feature.properties
      }
    end
  end
end
