defmodule Geometry.GeometryCollectionZM do
  @moduledoc """
  A collection set of 3D geometries with a measurement.
  """

  alias Geometry.{
    GeoJson,
    GeometryCollectionZM,
    WKB,
    WKT
  }

  defstruct geometries: MapSet.new()

  @type t :: %GeometryCollectionZM{geometries: MapSet.t(Geometry.t())}

  @doc """
  Creates an empty `GeometryCollectionZM`.

  ## Examples

      iex> GeometryCollectionZM.new()
      %GeometryCollectionZM{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %GeometryCollectionZM{}

  @doc """
  Creates an empty `GeometryCollectionZM`.

  ## Examples

      iex> GeometryCollectionZM.new([
      ...>   PointZM.new(1, 2, 3, 4),
      ...>   LineStringZM.new([PointZM.new(1, 1, 1, 1), PointZM.new(2, 2, 2, 2)])
      ...> ])
      %GeometryCollectionZM{geometries: MapSet.new([
        %PointZM{x: 1, y: 2, z: 3, m: 4},
        %LineStringZM{points: [
          %PointZM{x: 1, y: 1, z: 1, m: 1},
          %PointZM{x: 2, y: 2, z: 2, m: 2}
        ]}
      ])}
  """
  @spec new([Geometry.t()]) :: t()
  def new(geometries), do: %GeometryCollectionZM{geometries: MapSet.new(geometries)}

  @doc """
  Returns `true` if the given `GeometryCollectionZM` is empty.

  ## Examples

      iex> GeometryCollectionZM.empty?(GeometryCollectionZM.new())
      true

      iex> GeometryCollectionZM.empty?(GeometryCollectionZM.new([PointZM.new(1, 2, 3, 4)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%GeometryCollectionZM{geometries: geometries}), do: Enum.empty?(geometries)

  @doc """
  Returns the WKT representation for a `GeometryCollectionZM`. With option
  `:srid` an EWKT representation with the SRID is returned.

  ## Examples

      iex> GeometryCollectionZM.to_wkt(GeometryCollectionZM.new())
      "GeometryCollection ZM EMPTY"

      iex> GeometryCollectionZM.to_wkt(GeometryCollectionZM.new([PointZM.new(1.1, 2.2, 3.3, 4.4)]))
      "GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))"

      iex> GeometryCollectionZM.to_wkt(
      ...>   GeometryCollectionZM.new([PointZM.new(1.1, 2.2, 3.3, 4.4)]),
      ...>   srid: 4711)
      "SRID=4711;GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%GeometryCollectionZM{geometries: geometries}, opts \\ []) do
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
  Returns an `:ok` tuple with the `GeometryCollectionZM` from the given WKT
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> GeometryCollectionZM.from_wkt(
      ...>   "GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))")
      {
        :ok,
        %Geometry.GeometryCollectionZM{
          geometries: MapSet.new([%PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}])
        }
      }

      iex> GeometryCollectionZM.from_wkt(
      ...>   "SRID=123;GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))")
      {
        :ok,
        %Geometry.GeometryCollectionZM{
          geometries: MapSet.new([%PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}])
        },
        123
      }

      iex> GeometryCollectionZM.from_wkt("GeometryCollection ZM EMPTY")
      {:ok, %GeometryCollectionZM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, GeometryCollectionZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, GeometryCollectionZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `GeometryCollectionZM`.

  ## Examples

      iex> GeometryCollectionZM.to_geo_json(
      ...> GeometryCollectionZM.new([PointZM.new(1.1, 2.2, 3.3, 4.4)]))
      %{
        "type" => "GeometryCollection",
        "geometries" => [
          %{
            "type" => "Point",
            "coordinates" => [1.1, 2.2, 3.3, 4.4]
          }
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%GeometryCollectionZM{geometries: geometries}) do
    %{
      "type" => "GeometryCollection",
      "geometries" =>
        Enum.map(geometries, fn geometry ->
          Geometry.to_geo_json(geometry)
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `GeometryCollectionZM` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({
      ...>   "type": "GeometryCollection",
      ...>   "geometries": [
      ...>     {"type": "Point", "coordinates": [1.1, 2.2, 3.3, 4.4]}
      ...>   ]
      ...> })
      iex> |> Jason.decode!()
      iex> |> GeometryCollectionZM.from_geo_json()
      {
        :ok,
        %GeometryCollectionZM{
          geometries: MapSet.new([%PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json) do
    GeoJson.to_geometry_collection(json, GeometryCollectionZM, type: :zm)
  end

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_geometry_collection(json, GeometryCollectionZM, type: :zm) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKB representation for a `GeometryCollectionZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%GeometryCollectionZM{} = geometry_collection, opts \\ []) do
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
  Returns an `:ok` tuple with the `GeometryCollectionZM` from the given WKB
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, GeometryCollectionZM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, GeometryCollectionZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @compile {:inline, to_wkt_geometry_collection: 1}
  defp to_wkt_geometry_collection(wkt), do: <<"GeometryCollection ZM ", wkt::binary()>>

  @compile {:inline, to_wkt_geometries: 1}
  defp to_wkt_geometries(geometries) do
    geometries
    |> Enum.map(fn geometry -> Geometry.to_wkt(geometry) end)
    |> Enum.join(", ")
  end

  @compile {:inline, to_wkb_geometry_collection: 2}
  defp to_wkb_geometry_collection(%GeometryCollectionZM{geometries: geometries}, endian) do
    data =
      geometries
      |> Enum.map(fn geometry -> Geometry.to_wkb(geometry, endian: endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(geometries, endian)::binary(), data::binary()>>
  end

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000007"
      {:ndr, false} -> "070000C0"
      {:xdr, true} -> "E0000007"
      {:ndr, true} -> "070000E0"
    end
  end
end
