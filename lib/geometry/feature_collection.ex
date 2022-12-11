defmodule Geometry.FeatureCollection do
  @moduledoc """
  A collection of `Geometry.Featre`s.

  `GeometryCollectionZM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.filter(
      ...>   FeatureCollection.new([
      ...>     Feature.new(
      ...>       geometry: Point.new(11, 12),
      ...>       properties: %{"facility" => "Hotel"}
      ...>     ),
      ...>     Feature.new(
      ...>       geometry: Point.new(55, 55),
      ...>       properties: %{"facility" => "Tower"}
      ...>     )
      ...>   ]),
      ...>   fn %Feature{properties: properties} ->
      ...>     Map.get(properties, "facility") == "Hotel"
      ...>   end
      ...> )
      [%Feature{geometry: %Point{coordinate: [11, 12]}, properties: %{"facility" => "Hotel"}}]

      iex> Enum.into(
      ...>   [Feature.new(geometry: Point.new(5, 1), properties: %{"area" => 51})],
      ...>   FeatureCollection.new([
      ...>     Feature.new(geometry: Point.new(4, 2), properties: %{"area" => 42})
      ...>   ])
      ...> )
      %FeatureCollection{
        features:
          MapSet.new([
            %Feature{geometry: %Point{coordinate: [4, 2]}, properties: %{"area" => 42}},
            %Feature{geometry: %Point{coordinate: [5, 1]}, properties: %{"area" => 51}}
          ])
      }
  """

  alias Geometry.{Feature, FeatureCollection, GeoJson}

  defstruct features: MapSet.new()

  @type t :: %FeatureCollection{
          features: MapSet.t(Feature.t())
        }

  @doc """
  Creates an empty `FeatureCollection`.

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
          geometry: %Point{coordinate: [1, 2]},
          properties: %{facility: :hotel}},
        %Feature{
          geometry: %Point{coordinate: [3, 4]},
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
                geometry: %PointZ{coordinate: [1, 2, 3]},
                properties: %{"facility" => "Hotel"}
              },
              %Feature{
                geometry: %PointZ{coordinate: [4, 3, 2]},
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
              geometry: %PointM{coordinate: [1, 2, 3]},
              properties: %{"facility" => "Hotel"}
            },
            %Feature{
              geometry: %PointM{coordinate: [4, 3, 2]},
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

  @doc """
  Returns the number of elements in `FeatureCollection`.

  ## Examples

      iex> FeatureCollection.size(
      ...>   FeatureCollection.new([
      ...>     Feature.new(geometry: Point.new(11, 12)),
      ...>     Feature.new(geometry:
      ...>       LineString.new([
      ...>         Point.new(21, 22),
      ...>         Point.new(31, 32)
      ...>       ])
      ...>     )
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%FeatureCollection{features: features}), do: MapSet.size(features)

  @doc """
  Checks if `FeatureCollection` contains `geometry`.

  ## Examples

      iex> FeatureCollection.member?(
      ...>   FeatureCollection.new([
      ...>     Feature.new(geometry: Point.new(11, 12)),
      ...>     Feature.new(geometry:
      ...>       LineString.new([
      ...>         Point.new(21, 22),
      ...>         Point.new(31, 32)
      ...>       ])
      ...>     )
      ...>   ]),
      ...>   Feature.new(geometry: Point.new(11, 12))
      ...> )
      true

      iex> FeatureCollection.member?(
      ...>   FeatureCollection.new([
      ...>     Feature.new(geometry: Point.new(11, 12)),
      ...>     Feature.new(geometry:
      ...>       LineString.new([
      ...>         Point.new(21, 22),
      ...>         Point.new(31, 32)
      ...>       ])
      ...>     )
      ...>   ]),
      ...>   Feature.new(geometry: Point.new(1, 2))
      ...> )
      false
  """
  @spec member?(t(), Geometry.t()) :: boolean()
  def member?(%FeatureCollection{features: features}, geometry),
    do: MapSet.member?(features, geometry)

  @doc """
  Converts `FeatureCollection` to a list.

  ## Examples

      iex> FeatureCollection.to_list(
      ...>   FeatureCollection.new([
      ...>     Feature.new(geometry: Point.new(11, 12))
      ...>   ])
      ...> )
      [%Feature{geometry: %Point{coordinate: [11, 12]}, properties: %{}}]
  """
  @spec to_list(t()) :: [Geometry.t()]
  def to_list(%FeatureCollection{features: features}), do: MapSet.to_list(features)

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(geometry_collection) do
      {:ok, FeatureCollection.size(geometry_collection)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(geometry_collection, val) do
      {:ok, FeatureCollection.member?(geometry_collection, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(geometry_collection) do
      size = FeatureCollection.size(geometry_collection)

      {:ok, size, &FeatureCollection.to_list/1}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(geometry_collection, acc, fun) do
      Enumerable.List.reduce(FeatureCollection.to_list(geometry_collection), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%FeatureCollection{features: features}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          %FeatureCollection{
            features: %{features | map: Map.merge(features.map, Map.new(list))}
          }

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
