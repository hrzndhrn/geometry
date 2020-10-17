defmodule Geometry.GeometryCollection do
  @moduledoc """
  A collection set of 2D geometries.
  """

  alias Geometry.{
    GeoJson,
    GeometryCollection,
    WKB,
    WKT
  }

  defstruct geometries: MapSet.new()

  @type t :: %GeometryCollection{geometries: MapSet.t(Geometry.t())}

  @doc """
  Creates an empty `GeometryCollection`.

  ## Examples

      iex> GeometryCollection.new()
      %GeometryCollection{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %GeometryCollection{}

  @doc """
  Creates an empty `GeometryCollection`.

  ## Examples

      iex> GeometryCollection.new([
      ...>   Point.new(1, 2),
      ...>   LineString.new([Point.new(1, 1), Point.new(2, 2)])
      ...> ])
      %GeometryCollection{geometries: MapSet.new([
        %Point{x: 1, y: 2},
        %LineString{points: [
          %Point{x: 1, y: 1},
          %Point{x: 2, y: 2}
        ]}
      ])}
  """
  @spec new([Geometry.t()]) :: t()
  def new(geometries), do: %GeometryCollection{geometries: MapSet.new(geometries)}

  @doc """
  Returns `true` if the given `GeometryCollection` is empty.

  ## Examples

      iex> GeometryCollection.empty?(GeometryCollection.new())
      true

      iex> GeometryCollection.empty?(GeometryCollection.new([Point.new(1, 2)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%GeometryCollection{geometries: geometries}), do: Enum.empty?(geometries)

  @doc """
  Returns the WKT representation for a `GeometryCollection`. With option
  `:srid` an EWKT representation with the SRID is returned.

  ## Examples

      iex> GeometryCollection.to_wkt(GeometryCollection.new())
      "GeometryCollection EMPTY"

      iex> GeometryCollection.to_wkt(GeometryCollection.new([Point.new(1.1, 2.2)]))
      "GeometryCollection (Point (1.1 2.2))"

      iex> GeometryCollection.to_wkt(
      ...>   GeometryCollection.new([Point.new(1.1, 2.2)]),
      ...>   srid: 4711)
      "SRID=4711;GeometryCollection (Point (1.1 2.2))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%GeometryCollection{geometries: geometries}, opts \\ []) do
    geometries
    |> Enum.empty?()
    |> case do
      true -> "EMPTY"
      false -> <<"(", to_wkt_geometries(geometries)::binary(), ")">>
    end
    |> to_wkt_geometry_collection()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns an `:ok` tuple with the `GeometryCollection` from the given WKT
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> GeometryCollection.from_wkt(
      ...>   "GeometryCollection (Point (1.1 2.2))")
      {
        :ok,
        %Geometry.GeometryCollection{
          geometries: MapSet.new([%Point{x: 1.1, y: 2.2}])
        }
      }

      iex> GeometryCollection.from_wkt(
      ...>   "SRID=123;GeometryCollection (Point (1.1 2.2))")
      {
        :ok,
        %Geometry.GeometryCollection{
          geometries: MapSet.new([%Point{x: 1.1, y: 2.2}])
        },
        123
      }

      iex> GeometryCollection.from_wkt("GeometryCollection EMPTY")
      {:ok, %GeometryCollection{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, GeometryCollection)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, GeometryCollection) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `GeometryCollection`.

  ## Examples

      iex> GeometryCollection.to_geo_json(
      ...> GeometryCollection.new([Point.new(1.1, 2.2)]))
      %{
        "type" => "GeometryCollection",
        "geometries" => [
          %{
            "type" => "Point",
            "coordinates" => [1.1, 2.2]
          }
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%GeometryCollection{geometries: geometries}) do
    %{
      "type" => "GeometryCollection",
      "geometries" =>
        Enum.map(geometries, fn geometry ->
          Geometry.to_geo_json(geometry)
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `GeometryCollection` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({
      ...>   "type": "GeometryCollection",
      ...>   "geometries": [
      ...>     {"type": "Point", "coordinates": [1.1, 2.2]}
      ...>   ]
      ...> })
      iex> |> Jason.decode!()
      iex> |> GeometryCollection.from_geo_json()
      {
        :ok,
        %GeometryCollection{
          geometries: MapSet.new([%Point{x: 1.1, y: 2.2}])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json) do
    GeoJson.to_geometry_collection(json, GeometryCollection)
  end

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_geometry_collection(json, GeometryCollection) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKB representation for a `GeometryCollection`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%GeometryCollection{} = geometry_collection, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_geometry_collection(geometry_collection, endian)::binary()
    >>
  end

  @doc """
  Returns an `:ok` tuple with the `GeometryCollection` from the given WKB
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, GeometryCollection)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, GeometryCollection) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @compile {:inline, to_wkt_geometry_collection: 1}
  defp to_wkt_geometry_collection(wkt), do: <<"GeometryCollection ", wkt::binary()>>

  @compile {:inline, to_wkt_geometries: 1}
  defp to_wkt_geometries(geometries) do
    geometries
    |> Enum.map(fn geometry -> Geometry.to_wkt(geometry) end)
    |> Enum.join(", ")
  end

  @compile {:inline, to_wkb_geometry_collection: 2}
  defp to_wkb_geometry_collection(%GeometryCollection{geometries: geometries}, endian) do
    data =
      geometries
      |> Enum.map(fn geometry -> Geometry.to_wkb(geometry, endian: endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(geometries, endian)::binary(), data::binary()>>
  end

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "00000007"
      {:ndr, false} -> "07000000"
      {:xdr, true} -> "20000007"
      {:ndr, true} -> "07000020"
    end
  end
end
