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
      [%Feature{geometry: %Point{coordinates: [11, 12]}, properties: %{"facility" => "Hotel"}}]

      iex> Enum.into(
      ...>   [Feature.new(geometry: Point.new(5, 1), properties: %{"area" => 51})],
      ...>   FeatureCollection.new([
      ...>     Feature.new(geometry: Point.new(4, 2), properties: %{"area" => 42})
      ...>   ])
      ...> )
      %FeatureCollection{
        features: [
            %Feature{geometry: %Point{coordinates: [5, 1]}, properties: %{"area" => 51}},
            %Feature{geometry: %Point{coordinates: [4, 2]}, properties: %{"area" => 42}}
          ]
      }
  """

  alias Geometry.Feature
  alias Geometry.FeatureCollection

  defstruct features: []

  @type t :: %FeatureCollection{features: [Feature.t()]}

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
      %FeatureCollection{features: [
        %Feature{
          geometry: %Point{coordinates: [1, 2]},
          properties: %{facility: :hotel}},
        %Feature{
          geometry: %Point{coordinates: [3, 4]},
          properties: %{facility: :school}}
      ]}
  """
  @spec new([Feature.t()]) :: t()
  def new(features), do: %FeatureCollection{features: features}

  defimpl Geometry.Protocol do
    def empty?(%{features: features}), do: Enum.empty?(features)
  end

  defimpl Geometry.Encoder.GeoJson do
    def to_geo_json(%{features: features}) do
      %{
        "type" => "FeatureCollection",
        "features" => Enum.map(features, fn feature -> Geometry.to_geo_json(feature) end)
      }
    end
  end

  defimpl Enumerable do
    def count(%{features: features}) do
      {:ok, length(features)}
    end

    def member?(%{features: features}, feature) do
      {:ok, Enum.member?(features, feature)}
    end

    def reduce(%{features: features}, acc, fun) do
      Enumerable.List.reduce(features, acc, fun)
    end

    def slice(%{features: features}) do
      {:ok, length(features), fn %{features: features} -> features end}
    end
  end

  defimpl Collectable do
    def into(%{features: features} = collection) do
      fun = fn
        list, {:cont, item} ->
          [item | list]

        list, :done ->
          %{
            collection
            | features: Enum.reduce(list, features, fn feature, acc -> [feature | acc] end)
          }

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
