defmodule Geometry.GeometryCollectionM do
  @moduledoc """
  A collection set of 2D geometries with a measurement.

  `GeometryCollectionM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   GeometryCollectionM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     LineStringM.new([
      ...>       PointM.new(21, 22, 24),
      ...>       PointM.new(31, 32, 34)
      ...>     ])
      ...>   ]),
      ...>   fn
      ...>     %PointM{} -> :point
      ...>     %LineStringM{} -> :line_string
      ...>   end
      ...> )
      [:line_string, :point]

      iex> Enum.into([PointM.new(1, 2, 4)], GeometryCollectionM.new())
      %GeometryCollectionM{
        geometries: MapSet.new([%PointM{x: 1, y: 2, m: 4}])
      }
  """

  alias Geometry.{
    GeoJson,
    GeometryCollectionM,
    WKB,
    WKT
  }

  defstruct geometries: MapSet.new()

  @type t :: %GeometryCollectionM{geometries: MapSet.t(Geometry.t())}

  @doc """
  Creates an empty `GeometryCollectionM`.

  ## Examples

      iex> GeometryCollectionM.new()
      %GeometryCollectionM{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %GeometryCollectionM{}

  @doc """
  Creates an empty `GeometryCollectionM`.

  ## Examples

      iex> GeometryCollectionM.new([
      ...>   PointM.new(1, 2, 4),
      ...>   LineStringM.new([PointM.new(1, 1, 1), PointM.new(2, 2, 2)])
      ...> ])
      %GeometryCollectionM{geometries: MapSet.new([
        %PointM{x: 1, y: 2, m: 4},
        %LineStringM{points: [
          %PointM{x: 1, y: 1, m: 1},
          %PointM{x: 2, y: 2, m: 2}
        ]}
      ])}
  """
  @spec new([Geometry.t()]) :: t()
  def new(geometries), do: %GeometryCollectionM{geometries: MapSet.new(geometries)}

  @doc """
  Returns `true` if the given `GeometryCollectionM` is empty.

  ## Examples

      iex> GeometryCollectionM.empty?(GeometryCollectionM.new())
      true

      iex> GeometryCollectionM.empty?(GeometryCollectionM.new([PointM.new(1, 2, 4)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%GeometryCollectionM{geometries: geometries}), do: Enum.empty?(geometries)

  @doc """
  Returns the WKT representation for a `GeometryCollectionM`. With option
  `:srid` an EWKT representation with the SRID is returned.

  ## Examples

      iex> GeometryCollectionM.to_wkt(GeometryCollectionM.new())
      "GeometryCollection M EMPTY"

      iex> GeometryCollectionM.to_wkt(GeometryCollectionM.new([PointM.new(1.1, 2.2, 4.4)]))
      "GeometryCollection M (Point M (1.1 2.2 4.4))"

      iex> GeometryCollectionM.to_wkt(
      ...>   GeometryCollectionM.new([PointM.new(1.1, 2.2, 4.4)]),
      ...>   srid: 4711)
      "SRID=4711;GeometryCollection M (Point M (1.1 2.2 4.4))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%GeometryCollectionM{geometries: geometries}, opts \\ []) do
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
  Returns an `:ok` tuple with the `GeometryCollectionM` from the given WKT
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> GeometryCollectionM.from_wkt(
      ...>   "GeometryCollection M (Point M (1.1 2.2 4.4))")
      {
        :ok,
        %GeometryCollectionM{
          geometries: MapSet.new([%PointM{x: 1.1, y: 2.2, m: 4.4}])
        }
      }

      iex> GeometryCollectionM.from_wkt(
      ...>   "SRID=123;GeometryCollection M (Point M (1.1 2.2 4.4))")
      {
        :ok,
        %GeometryCollectionM{
          geometries: MapSet.new([%PointM{x: 1.1, y: 2.2, m: 4.4}])
        },
        123
      }

      iex> GeometryCollectionM.from_wkt("GeometryCollection M EMPTY")
      {:ok, %GeometryCollectionM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, GeometryCollectionM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, GeometryCollectionM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `GeometryCollectionM`.

  ## Examples

      iex> GeometryCollectionM.to_geo_json(
      ...> GeometryCollectionM.new([PointM.new(1.1, 2.2, 4.4)]))
      %{
        "type" => "GeometryCollection",
        "geometries" => [
          %{
            "type" => "Point",
            "coordinates" => [1.1, 2.2, 4.4]
          }
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%GeometryCollectionM{geometries: geometries}) do
    %{
      "type" => "GeometryCollection",
      "geometries" =>
        Enum.map(geometries, fn geometry ->
          Geometry.to_geo_json(geometry)
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `GeometryCollectionM` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({
      ...>   "type": "GeometryCollection",
      ...>   "geometries": [
      ...>     {"type": "Point", "coordinates": [1.1, 2.2, 4.4]}
      ...>   ]
      ...> })
      iex> |> Jason.decode!()
      iex> |> GeometryCollectionM.from_geo_json()
      {
        :ok,
        %GeometryCollectionM{
          geometries: MapSet.new([%PointM{x: 1.1, y: 2.2, m: 4.4}])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json) do
    GeoJson.to_geometry_collection(json, GeometryCollectionM, type: :m)
  end

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_geometry_collection(json, GeometryCollectionM, type: :m) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKB representation for a `GeometryCollectionM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%GeometryCollectionM{} = geometry_collection, opts \\ []) do
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
  Returns an `:ok` tuple with the `GeometryCollectionM` from the given WKB
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, GeometryCollectionM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, GeometryCollectionM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `GeometryCollectionM`.

  ## Examples

      iex> GeometryCollectionM.size(
      ...>   GeometryCollectionM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     LineStringM.new([
      ...>       PointM.new(21, 22, 24),
      ...>       PointM.new(31, 32, 34)
      ...>     ])
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%GeometryCollectionM{geometries: geometries}), do: MapSet.size(geometries)

  @doc """
  Checks if `GeometryCollectionM` contains `geometry`.

  ## Examples

      iex> GeometryCollectionM.member?(
      ...>   GeometryCollectionM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     LineStringM.new([
      ...>       PointM.new(21, 22, 24),
      ...>       PointM.new(31, 32, 34)
      ...>     ])
      ...>   ]),
      ...>   PointM.new(11, 12, 14)
      ...> )
      true

      iex> GeometryCollectionM.member?(
      ...>   GeometryCollectionM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     LineStringM.new([
      ...>       PointM.new(21, 22, 24),
      ...>       PointM.new(31, 32, 34)
      ...>     ])
      ...>   ]),
      ...>   PointM.new(1, 2, 4)
      ...> )
      false
  """
  @spec member?(t(), Geometry.t()) :: boolean()
  def member?(%GeometryCollectionM{geometries: geometries}, geometry),
    do: MapSet.member?(geometries, geometry)

  @doc """
  Converts `GeometryCollectionM` to a list.

  ## Examples

      iex> GeometryCollectionM.to_list(
      ...>   GeometryCollectionM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     LineStringM.new([
      ...>       PointM.new(21, 22, 24),
      ...>       PointM.new(31, 32, 34)
      ...>     ])
      ...>   ])
      ...> )
      [
        %LineStringM{
          points: [
            %PointM{x: 21, y: 22, m: 24},
            %PointM{x: 31, y: 32, m: 34}
          ]
        },
        %PointM{x: 11, y: 12, m: 14}
      ]
  """
  @spec to_list(t()) :: [Geometry.t()]
  def to_list(%GeometryCollectionM{geometries: geometries}), do: MapSet.to_list(geometries)

  @compile {:inline, to_wkt_geometry_collection: 1}
  defp to_wkt_geometry_collection(wkt), do: <<"GeometryCollection M ", wkt::binary()>>

  @compile {:inline, to_wkt_geometries: 1}
  defp to_wkt_geometries(geometries) do
    geometries
    |> Enum.map(fn geometry -> Geometry.to_wkt(geometry) end)
    |> Enum.join(", ")
  end

  @compile {:inline, to_wkb_geometry_collection: 2}
  defp to_wkb_geometry_collection(%GeometryCollectionM{geometries: geometries}, endian) do
    data =
      geometries
      |> Enum.map(fn geometry -> Geometry.to_wkb(geometry, endian: endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(geometries, endian)::binary(), data::binary()>>
  end

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "40000007"
      {:ndr, false} -> "07000040"
      {:xdr, true} -> "60000007"
      {:ndr, true} -> "07000060"
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(geometry_collection) do
      {:ok, GeometryCollectionM.size(geometry_collection)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(geometry_collection, val) do
      {:ok, GeometryCollectionM.member?(geometry_collection, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(geometry_collection) do
      size = GeometryCollectionM.size(geometry_collection)

      {:ok, size,
       &Enumerable.List.slice(GeometryCollectionM.to_list(geometry_collection), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(geometry_collection, acc, fun) do
      Enumerable.List.reduce(GeometryCollectionM.to_list(geometry_collection), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%GeometryCollectionM{geometries: geometries}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          %GeometryCollectionM{
            geometries: %{geometries | map: Map.merge(geometries.map, Map.new(list))}
          }

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
