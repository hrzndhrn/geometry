defmodule Geometry.FeatureCollection do
  @moduledoc """
  A collection of `Geometry.Featre`s.
  """

  alias Geometry.{Feature, FeatureCollection, GeoJson}

  defstruct features: MapSet.new()

  @type t :: %FeatureCollection{
          features: MapSet.t(Feature.t())
        }

  @doc """
  Creates an empty `FeatureCollection'.

  ## Examples

      iex> FeatureCollection.new()
      %FeatureCollection{}
  """
  @spec new :: t()
  def new, do: %FeatureCollection{}

  @doc """
  Creates a `FeatureCollection`.

  ## Examples

      iex> FeatureCollection.new([
      ...>   Feature.new(
      ...>     geometry: Point.new(1, 2),
      ...>     properties: %{facility: :hotel}
      ...>   ),
      ...>   Feature.new(
      ...>     geometry: Point.new(3, 4),
      ...>     properties: %{facility: :school}
      ...>   )
      ...> ])
      %FeatureCollection{features: MapSet.new([
        %Feature{
          geometry: %Geometry.Point{x: 1, y: 2},
          properties: %{facility: :hotel}},
        %Feature{
          geometry: %Geometry.Point{x: 3, y: 4},
          properties: %{facility: :school}}
      ])}
  """
  @spec new([Feature.t()]) :: t()
  def new(features), do: %FeatureCollection{features: MapSet.new(features)}

  @doc """
  Returns `true` for an empty `FeatureCollection`.

  ## Examples

      iex> FeatureCollection.empty?(FeatureCollection.new())
      true
  """
  @spec empty?(t()) :: boolean()
  def empty?(%FeatureCollection{features: features}), do: Enum.empty?(features)

  @doc """
  Returns an `:ok` tuple with the `FeatureCollection` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  The `:type` option specifies which type is expected. The
  possible values are `:z`, `:m`, and `:zm`.

  ## Examples

      iex> ~s({
      ...>   "type": "FeatureCollection",
      ...>   "features": [
      ...>     {
      ...>       "type": "Feature",
      ...>       "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
      ...>       "properties": {"facility": "Hotel"}
      ...>     }, {
      ...>       "type": "Feature",
      ...>       "geometry": {"type": "Point", "coordinates": [4, 3, 2]},
      ...>       "properties": {"facility": "School"}
      ...>     }
      ...>   ]
      ...> })
      iex> |> Jason.decode!()
      iex> |> FeatureCollection.from_geo_json(type: :z)
      {
        :ok,
        %FeatureCollection{
          features:
            MapSet.new([
              %Feature{
                geometry: %Geometry.PointZ{x: 1, y: 2, z: 3},
                properties: %{"facility" => "Hotel"}
              },
              %Feature{
                geometry: %Geometry.PointZ{x: 4, y: 3, z: 2},
                properties: %{"facility" => "School"}
              }
            ])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term(), opts) :: {:ok, t()} | Geometry.geo_json_error()
        when opts: [type: :z | :m | :zm]
  def from_geo_json(json, opts \\ []), do: GeoJson.to_feature_collection(json, opts)

  @doc """
  The same as `from_geo_josn/1`, but raises a `Geometry.Error` exception if it
  fails.

  ## Examples

      iex> ~s({
      ...>   "type": "FeatureCollection",
      ...>   "features": [
      ...>     {
      ...>       "type": "Feature",
      ...>       "geometry": {"type": "Point", "coordinates": [1, 2, 3]},
      ...>       "properties": {"facility": "Hotel"}
      ...>     }, {
      ...>       "type": "Feature",
      ...>       "geometry": {"type": "Point", "coordinates": [4, 3, 2]},
      ...>       "properties": {"facility": "School"}
      ...>     }
      ...>   ]
      ...> })
      iex> |> Jason.decode!()
      iex> |> FeatureCollection.from_geo_json!(type: :m)
      %FeatureCollection{
        features:
          MapSet.new([
            %Feature{
              geometry: %Geometry.PointM{x: 1, y: 2, m: 3},
              properties: %{"facility" => "Hotel"}
            },
            %Feature{
              geometry: %Geometry.PointM{x: 4, y: 3, m: 2},
              properties: %{"facility" => "School"}
            }
          ])
      }
  """
  @spec from_geo_json!(Geometry.geo_json_term(), opts) :: t()
        when opts: [type: :z | :m | :zm]
  def from_geo_json!(json, opts \\ []) do
    case GeoJson.to_feature_collection(json, opts) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `FeatureCollection`.

  ## Examples

      iex> FeatureCollection.to_geo_json(FeatureCollection.new([
      ...>   Feature.new(
      ...>     geometry: Point.new(1, 2),
      ...>     properties: %{facility: :hotel}
      ...>   )
      ...> ]))
      %{
        "type" => "FeatureCollection",
        "features" => [
          %{
            "type" => "Feature",
            "geometry" => %{"coordinates" => [1, 2], "type" => "Point"},
            "properties" => %{facility: :hotel}
          }
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%FeatureCollection{features: features}) do
    %{
      "type" => "FeatureCollection",
      "features" => Enum.map(features, &Feature.to_geo_json/1)
    }
  end
end
