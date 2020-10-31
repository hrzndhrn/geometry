defmodule Geometry.GeometryCollection do
  @moduledoc """
  A collection set of 2D geometries.

  `GeometryCollection` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   GeometryCollection.new([
      ...>     Point.new(11, 12),
      ...>     LineString.new([
      ...>       Point.new(21, 22),
      ...>       Point.new(31, 32)
      ...>     ])
      ...>   ]),
      ...>   fn
      ...>     %Point{} -> :point
      ...>     %LineString{} -> :line_string
      ...>   end
      ...> ) |> Enum.sort()
      [:line_string, :point]

      iex> Enum.into([Point.new(1, 2)], GeometryCollection.new())
      %GeometryCollection{
        geometries: MapSet.new([%Point{coordinate: [1, 2]}])
      }
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
        %Point{coordinate: [1, 2]},
        %LineString{points: [[1, 1], [2, 2]]}
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

      iex> GeometryCollection.to_wkt(
      ...>   GeometryCollection.new([
      ...>     Point.new(1.1, 1.2),
      ...>     Point.new(2.1, 2.2)
      ...>   ])
      ...> )
      "GeometryCollection (Point (1.1 1.2), Point (2.1 2.2))"

      iex> GeometryCollection.to_wkt(
      ...>   GeometryCollection.new([Point.new(1.1, 2.2)]),
      ...>   srid: 4711)
      "SRID=4711;GeometryCollection (Point (1.1 2.2))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%GeometryCollection{geometries: geometries}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "GeometryCollection ",
        geometries |> MapSet.to_list() |> to_wkt_geometries()::binary()
      >>,
      opts
    )
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
        %GeometryCollection{
          geometries: MapSet.new([%Point{coordinate: [1.1, 2.2]}])
        }
      }

      iex> GeometryCollection.from_wkt(
      ...>   "SRID=123;GeometryCollection (Point (1.1 2.2))")
      {
        :ok,
        %GeometryCollection{
          geometries: MapSet.new([%Point{coordinate: [1.1, 2.2]}])
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
          geometries: MapSet.new([%Point{coordinate: [1.1, 2.2]}])
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

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%GeometryCollection{geometries: geometries}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian, mode)::binary(),
      wkb_code(endian, not is_nil(srid), mode)::binary(),
      WKB.srid(srid, endian, mode)::binary(),
      to_wkb_geometries(geometries, endian, mode)::binary()
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

  @doc """
  Returns the number of elements in `GeometryCollection`.

  ## Examples

      iex> GeometryCollection.size(
      ...>   GeometryCollection.new([
      ...>     Point.new(11, 12),
      ...>     LineString.new([
      ...>       Point.new(21, 22),
      ...>       Point.new(31, 32)
      ...>     ])
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%GeometryCollection{geometries: geometries}), do: MapSet.size(geometries)

  @doc """
  Checks if `GeometryCollection` contains `geometry`.

  ## Examples

      iex> GeometryCollection.member?(
      ...>   GeometryCollection.new([
      ...>     Point.new(11, 12),
      ...>     LineString.new([
      ...>       Point.new(21, 22),
      ...>       Point.new(31, 32)
      ...>     ])
      ...>   ]),
      ...>   Point.new(11, 12)
      ...> )
      true

      iex> GeometryCollection.member?(
      ...>   GeometryCollection.new([
      ...>     Point.new(11, 12),
      ...>     LineString.new([
      ...>       Point.new(21, 22),
      ...>       Point.new(31, 32)
      ...>     ])
      ...>   ]),
      ...>   Point.new(1, 2)
      ...> )
      false
  """
  @spec member?(t(), Geometry.t()) :: boolean()
  def member?(%GeometryCollection{geometries: geometries}, geometry),
    do: MapSet.member?(geometries, geometry)

  @doc """
  Converts `GeometryCollection` to a list.

  ## Examples

      iex> GeometryCollection.to_list(
      ...>   GeometryCollection.new([
      ...>     Point.new(11, 12)
      ...>   ])
      ...> )
      [%Point{coordinate: [11, 12]}]
  """
  @spec to_list(t()) :: [Geometry.t()]
  def to_list(%GeometryCollection{geometries: geometries}), do: MapSet.to_list(geometries)

  @compile {:inline, to_wkt_geometries: 1}
  defp to_wkt_geometries([]), do: "EMPTY"

  defp to_wkt_geometries([geometry | geometries]) do
    <<"(",
      Enum.reduce(geometries, Geometry.to_wkt(geometry), fn %module{} = geometry, acc ->
        <<acc::binary(), ", ", module.to_wkt(geometry)::binary()>>
      end)::binary(), ")">>
  end

  @compile {:inline, to_wkb_geometries: 3}
  defp to_wkb_geometries(geometries, endian, mode) do
    Enum.reduce(geometries, WKB.length(geometries, endian, mode), fn %module{} = geometry, acc ->
      <<acc::binary(), module.to_wkb(geometry, endian: endian, mode: mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "00000007"
      {:ndr, false} -> "07000000"
      {:xdr, true} -> "20000007"
      {:ndr, true} -> "07000020"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x00000007::big-integer-size(32)>>
      {:ndr, false} -> <<0x00000007::little-integer-size(32)>>
      {:xdr, true} -> <<0x20000007::big-integer-size(32)>>
      {:ndr, true} -> <<0x20000007::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(geometry_collection) do
      {:ok, GeometryCollection.size(geometry_collection)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(geometry_collection, val) do
      {:ok, GeometryCollection.member?(geometry_collection, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(geometry_collection) do
      size = GeometryCollection.size(geometry_collection)

      {:ok, size,
       &Enumerable.List.slice(GeometryCollection.to_list(geometry_collection), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(geometry_collection, acc, fun) do
      Enumerable.List.reduce(GeometryCollection.to_list(geometry_collection), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%GeometryCollection{geometries: geometries}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          %GeometryCollection{
            geometries: %{geometries | map: Map.merge(geometries.map, Map.new(list))}
          }

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
