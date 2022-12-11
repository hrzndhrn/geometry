defmodule Geometry.GeometryCollectionZM do
  @moduledoc """
  A collection set of 3D geometries with a measurement.

  `GeometryCollectionZM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   GeometryCollectionZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     LineStringZM.new([
      ...>       PointZM.new(21, 22, 23, 24),
      ...>       PointZM.new(31, 32, 33, 34)
      ...>     ])
      ...>   ]),
      ...>   fn
      ...>     %PointZM{} -> :point
      ...>     %LineStringZM{} -> :line_string
      ...>   end
      ...> ) |> Enum.sort()
      [:line_string, :point]

      iex> Enum.into([PointZM.new(1, 2, 3, 4)], GeometryCollectionZM.new())
      %GeometryCollectionZM{
        geometries: MapSet.new([%PointZM{coordinate: [1, 2, 3, 4]}])
      }
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
        %PointZM{coordinate: [1, 2, 3, 4]},
        %LineStringZM{points: [[1, 1, 1, 1], [2, 2, 2, 2]]}
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

      iex> GeometryCollectionZM.to_wkt(
      ...>   GeometryCollectionZM.new([
      ...>     PointZM.new(1.1, 1.2, 1.3, 1.4),
      ...>     PointZM.new(2.1, 2.2, 2.3, 2.4)
      ...>   ])
      ...> )
      "GeometryCollection ZM (Point ZM (1.1 1.2 1.3 1.4), Point ZM (2.1 2.2 2.3 2.4))"

      iex> GeometryCollectionZM.to_wkt(
      ...>   GeometryCollectionZM.new([PointZM.new(1.1, 2.2, 3.3, 4.4)]),
      ...>   srid: 4711)
      "SRID=4711;GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%GeometryCollectionZM{geometries: geometries}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "GeometryCollection ZM ",
        geometries |> MapSet.to_list() |> to_wkt_geometries()::binary
      >>,
      opts
    )
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
        %GeometryCollectionZM{
          geometries: MapSet.new([%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}])
        }
      }

      iex> GeometryCollectionZM.from_wkt(
      ...>   "SRID=123;GeometryCollection ZM (Point ZM (1.1 2.2 3.3 4.4))")
      {:ok, {
        %GeometryCollectionZM{
          geometries: MapSet.new([%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}])
        },
        123
      }}

      iex> GeometryCollectionZM.from_wkt("GeometryCollection ZM EMPTY")
      {:ok, %GeometryCollectionZM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, GeometryCollectionZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, GeometryCollectionZM) do
      {:ok, geometry} -> geometry
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
          geometries: MapSet.new([%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}])
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

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%GeometryCollectionZM{geometries: geometries}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian, mode)::binary,
      wkb_code(endian, not is_nil(srid), mode)::binary,
      WKB.srid(srid, endian, mode)::binary,
      to_wkb_geometries(geometries, endian, mode)::binary
    >>
  end

  @doc """
  Returns an `:ok` tuple with the `GeometryCollectionZM` from the given WKB
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, GeometryCollectionZM)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, GeometryCollectionZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `GeometryCollectionZM`.

  ## Examples

      iex> GeometryCollectionZM.size(
      ...>   GeometryCollectionZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     LineStringZM.new([
      ...>       PointZM.new(21, 22, 23, 24),
      ...>       PointZM.new(31, 32, 33, 34)
      ...>     ])
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%GeometryCollectionZM{geometries: geometries}), do: MapSet.size(geometries)

  @doc """
  Checks if `GeometryCollectionZM` contains `geometry`.

  ## Examples

      iex> GeometryCollectionZM.member?(
      ...>   GeometryCollectionZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     LineStringZM.new([
      ...>       PointZM.new(21, 22, 23, 24),
      ...>       PointZM.new(31, 32, 33, 34)
      ...>     ])
      ...>   ]),
      ...>   PointZM.new(11, 12, 13, 14)
      ...> )
      true

      iex> GeometryCollectionZM.member?(
      ...>   GeometryCollectionZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     LineStringZM.new([
      ...>       PointZM.new(21, 22, 23, 24),
      ...>       PointZM.new(31, 32, 33, 34)
      ...>     ])
      ...>   ]),
      ...>   PointZM.new(1, 2, 3, 4)
      ...> )
      false
  """
  @spec member?(t(), Geometry.t()) :: boolean()
  def member?(%GeometryCollectionZM{geometries: geometries}, geometry),
    do: MapSet.member?(geometries, geometry)

  @doc """
  Converts `GeometryCollectionZM` to a list.

  ## Examples

      iex> GeometryCollectionZM.to_list(
      ...>   GeometryCollectionZM.new([
      ...>     PointZM.new(11, 12, 13, 14)
      ...>   ])
      ...> )
      [%PointZM{coordinate: [11, 12, 13, 14]}]
  """
  @spec to_list(t()) :: [Geometry.t()]
  def to_list(%GeometryCollectionZM{geometries: geometries}), do: MapSet.to_list(geometries)

  @compile {:inline, to_wkt_geometries: 1}
  defp to_wkt_geometries([]), do: "EMPTY"

  defp to_wkt_geometries([geometry | geometries]) do
    <<"(",
      Enum.reduce(geometries, Geometry.to_wkt(geometry), fn %module{} = geometry, acc ->
        <<acc::binary, ", ", module.to_wkt(geometry)::binary>>
      end)::binary, ")">>
  end

  @compile {:inline, to_wkb_geometries: 3}
  defp to_wkb_geometries(geometries, endian, mode) do
    Enum.reduce(geometries, WKB.length(geometries, endian, mode), fn %module{} = geometry, acc ->
      <<acc::binary, module.to_wkb(geometry, endian: endian, mode: mode)::binary>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000007"
      {:ndr, false} -> "070000C0"
      {:xdr, true} -> "E0000007"
      {:ndr, true} -> "070000E0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0xC0000007::big-integer-size(32)>>
      {:ndr, false} -> <<0xC0000007::little-integer-size(32)>>
      {:xdr, true} -> <<0xE0000007::big-integer-size(32)>>
      {:ndr, true} -> <<0xE0000007::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(geometry_collection) do
      {:ok, GeometryCollectionZM.size(geometry_collection)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(geometry_collection, val) do
      {:ok, GeometryCollectionZM.member?(geometry_collection, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(geometry_collection) do
      size = GeometryCollectionZM.size(geometry_collection)

      {:ok, size, &GeometryCollectionZM.to_list/1}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(geometry_collection, acc, fun) do
      Enumerable.List.reduce(GeometryCollectionZM.to_list(geometry_collection), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%GeometryCollectionZM{geometries: geometries}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          %GeometryCollectionZM{
            geometries: %{geometries | map: Map.merge(geometries.map, Map.new(list))}
          }

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
