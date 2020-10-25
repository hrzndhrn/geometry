defmodule Geometry.Feature do
  @moduledoc """
  A combination of a `geometry` and `properties`.
  """

  alias Geometry.{Feature, GeoJson}

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
        geometry: %Point{coordinate: [1, 2]},
        properties: %{facility: :hotel}
      }
  """
  @spec new(geometry: Geometry.t(), properties: map()) :: Feature.t()
  def new(data), do: struct(Feature, data)

  @doc """
  Returns `true` for an empty `Feature`.

  ## Examples

      iex> Feature.empty?(Feature.new())
      true

      iex> Feature.empty?(Feature.new(geometry: Point.new(1, 2)))
      false
  """
  @spec empty?(t()) :: boolean()
  def empty?(%Feature{geometry: geometry}), do: is_nil(geometry)

  @doc """
  Returns an `:ok` tuple with the `Feature` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  The `:type` option specifies which type is expected. The
  possible values are `:z`, `:m`, and `:zm`.

  ## Examples

      iex> ~s({
      ...>   "type": "Feature",
      ...>   "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
      ...>   "properties": {"facility": "Hotel"}
      ...> })
      iex> |> Jason.decode!()
      iex> |> Feature.from_geo_json(type: :z)
      {:ok, %Feature{
        geometry: %PointZ{coordinate: [1, 2, 3]},
        properties: %{"facility" => "Hotel"}
      }}

      iex> ~s({
      ...>   "type": "Feature",
      ...>   "geometry": {"type": "Point", "coordinates": [1, 2]},
      ...>   "properties": {"facility": "Hotel"}
      ...> })
      iex> |> Jason.decode!()
      iex> |> Feature.from_geo_json()
      {:ok, %Feature{
        geometry: %Point{coordinate: [1, 2]},
        properties: %{"facility" => "Hotel"}
      }}
  """
  @spec from_geo_json(Geometry.geo_json_term(), opts) :: {:ok, t()} | Geometry.geo_json_error()
        when opts: [type: :z | :m | :zm]
  def from_geo_json(json, opts \\ []), do: GeoJson.to_feature(json, opts)

  @doc """
  The same as `from_geo_josn/1`, but raises a `Geometry.Error` exception if it
  fails.

  ## Examples

      iex> ~s({
      ...>   "type": "Feature",
      ...>   "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
      ...>   "properties": {"facility": "Hotel"}
      ...> })
      iex> |> Jason.decode!()
      iex> |> Feature.from_geo_json!(type: :m)
      %Feature{
        geometry: %PointM{coordinate: [1, 2, 3]},
        properties: %{"facility" => "Hotel"}
      }
  """
  @spec from_geo_json!(Geometry.geo_json_term(), opts) :: t()
        when opts: [type: :z | :m | :zm]
  def from_geo_json!(json, opts \\ []) do
    case GeoJson.to_feature(json, opts) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `Feature`.

  ## Examples

      iex> Feature.to_geo_json(Feature.new(
      ...>   geometry: Point.new(1, 2),
      ...>   properties: %{facility: :hotel}
      ...> ))
      %{
        "type" => "Feature",
        "geometry" => %{
          "type" => "Point",
          "coordinates" => [1, 2]
        },
        "properties" => %{facility: :hotel}
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%Feature{} = feature) do
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
