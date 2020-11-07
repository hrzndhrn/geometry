defmodule Geometry.GeometryCollectionZ do
  @moduledoc """
  A collection set of 3D geometries.

  `GeometryCollectionZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   GeometryCollectionZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     LineStringZ.new([
      ...>       PointZ.new(21, 22, 23),
      ...>       PointZ.new(31, 32, 33)
      ...>     ])
      ...>   ]),
      ...>   fn
      ...>     %PointZ{} -> :point
      ...>     %LineStringZ{} -> :line_string
      ...>   end
      ...> ) |> Enum.sort()
      [:line_string, :point]

      iex> Enum.into([PointZ.new(1, 2, 3)], GeometryCollectionZ.new())
      %GeometryCollectionZ{
        geometries: MapSet.new([%PointZ{coordinate: [1, 2, 3]}])
      }
  """

  alias Geometry.{
    GeoJson,
    GeometryCollectionZ,
    WKB,
    WKT
  }

  defstruct geometries: MapSet.new()

  @type t :: %GeometryCollectionZ{geometries: MapSet.t(Geometry.t())}

  @doc """
  Creates an empty `GeometryCollectionZ`.

  ## Examples

      iex> GeometryCollectionZ.new()
      %GeometryCollectionZ{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %GeometryCollectionZ{}

  @doc """
  Creates an empty `GeometryCollectionZ`.

  ## Examples

      iex> GeometryCollectionZ.new([
      ...>   PointZ.new(1, 2, 3),
      ...>   LineStringZ.new([PointZ.new(1, 1, 1), PointZ.new(2, 2, 2)])
      ...> ])
      %GeometryCollectionZ{geometries: MapSet.new([
        %PointZ{coordinate: [1, 2, 3]},
        %LineStringZ{points: [[1, 1, 1], [2, 2, 2]]}
      ])}
  """
  @spec new([Geometry.t()]) :: t()
  def new(geometries), do: %GeometryCollectionZ{geometries: MapSet.new(geometries)}

  @doc """
  Returns `true` if the given `GeometryCollectionZ` is empty.

  ## Examples

      iex> GeometryCollectionZ.empty?(GeometryCollectionZ.new())
      true

      iex> GeometryCollectionZ.empty?(GeometryCollectionZ.new([PointZ.new(1, 2, 3)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%GeometryCollectionZ{geometries: geometries}), do: Enum.empty?(geometries)

  @doc """
  Returns the WKT representation for a `GeometryCollectionZ`. With option
  `:srid` an EWKT representation with the SRID is returned.

  ## Examples

      iex> GeometryCollectionZ.to_wkt(GeometryCollectionZ.new())
      "GeometryCollection Z EMPTY"

      iex> GeometryCollectionZ.to_wkt(
      ...>   GeometryCollectionZ.new([
      ...>     PointZ.new(1.1, 1.2, 1.3),
      ...>     PointZ.new(2.1, 2.2, 2.3)
      ...>   ])
      ...> )
      "GeometryCollection Z (Point Z (1.1 1.2 1.3), Point Z (2.1 2.2 2.3))"

      iex> GeometryCollectionZ.to_wkt(
      ...>   GeometryCollectionZ.new([PointZ.new(1.1, 2.2, 3.3)]),
      ...>   srid: 4711)
      "SRID=4711;GeometryCollection Z (Point Z (1.1 2.2 3.3))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%GeometryCollectionZ{geometries: geometries}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "GeometryCollection Z ",
        geometries |> MapSet.to_list() |> to_wkt_geometries()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns an `:ok` tuple with the `GeometryCollectionZ` from the given WKT
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> GeometryCollectionZ.from_wkt(
      ...>   "GeometryCollection Z (Point Z (1.1 2.2 3.3))")
      {
        :ok,
        %GeometryCollectionZ{
          geometries: MapSet.new([%PointZ{coordinate: [1.1, 2.2, 3.3]}])
        }
      }

      iex> GeometryCollectionZ.from_wkt(
      ...>   "SRID=123;GeometryCollection Z (Point Z (1.1 2.2 3.3))")
      {
        :ok,
        %GeometryCollectionZ{
          geometries: MapSet.new([%PointZ{coordinate: [1.1, 2.2, 3.3]}])
        },
        123
      }

      iex> GeometryCollectionZ.from_wkt("GeometryCollection Z EMPTY")
      {:ok, %GeometryCollectionZ{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, GeometryCollectionZ)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, GeometryCollectionZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `GeometryCollectionZ`.

  ## Examples

      iex> GeometryCollectionZ.to_geo_json(
      ...> GeometryCollectionZ.new([PointZ.new(1.1, 2.2, 3.3)]))
      %{
        "type" => "GeometryCollection",
        "geometries" => [
          %{
            "type" => "Point",
            "coordinates" => [1.1, 2.2, 3.3]
          }
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%GeometryCollectionZ{geometries: geometries}) do
    %{
      "type" => "GeometryCollection",
      "geometries" =>
        Enum.map(geometries, fn geometry ->
          Geometry.to_geo_json(geometry)
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `GeometryCollectionZ` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({
      ...>   "type": "GeometryCollection",
      ...>   "geometries": [
      ...>     {"type": "Point", "coordinates": [1.1, 2.2, 3.3]}
      ...>   ]
      ...> })
      iex> |> Jason.decode!()
      iex> |> GeometryCollectionZ.from_geo_json()
      {
        :ok,
        %GeometryCollectionZ{
          geometries: MapSet.new([%PointZ{coordinate: [1.1, 2.2, 3.3]}])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json) do
    GeoJson.to_geometry_collection(json, GeometryCollectionZ, type: :z)
  end

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_geometry_collection(json, GeometryCollectionZ, type: :z) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKB representation for a `GeometryCollectionZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%GeometryCollectionZ{geometries: geometries}, opts \\ []) do
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
  Returns an `:ok` tuple with the `GeometryCollectionZ` from the given WKB
  string. Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, GeometryCollectionZ)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, GeometryCollectionZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `GeometryCollectionZ`.

  ## Examples

      iex> GeometryCollectionZ.size(
      ...>   GeometryCollectionZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     LineStringZ.new([
      ...>       PointZ.new(21, 22, 23),
      ...>       PointZ.new(31, 32, 33)
      ...>     ])
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%GeometryCollectionZ{geometries: geometries}), do: MapSet.size(geometries)

  @doc """
  Checks if `GeometryCollectionZ` contains `geometry`.

  ## Examples

      iex> GeometryCollectionZ.member?(
      ...>   GeometryCollectionZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     LineStringZ.new([
      ...>       PointZ.new(21, 22, 23),
      ...>       PointZ.new(31, 32, 33)
      ...>     ])
      ...>   ]),
      ...>   PointZ.new(11, 12, 13)
      ...> )
      true

      iex> GeometryCollectionZ.member?(
      ...>   GeometryCollectionZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     LineStringZ.new([
      ...>       PointZ.new(21, 22, 23),
      ...>       PointZ.new(31, 32, 33)
      ...>     ])
      ...>   ]),
      ...>   PointZ.new(1, 2, 3)
      ...> )
      false
  """
  @spec member?(t(), Geometry.t()) :: boolean()
  def member?(%GeometryCollectionZ{geometries: geometries}, geometry),
    do: MapSet.member?(geometries, geometry)

  @doc """
  Converts `GeometryCollectionZ` to a list.

  ## Examples

      iex> GeometryCollectionZ.to_list(
      ...>   GeometryCollectionZ.new([
      ...>     PointZ.new(11, 12, 13)
      ...>   ])
      ...> )
      [%PointZ{coordinate: [11, 12, 13]}]
  """
  @spec to_list(t()) :: [Geometry.t()]
  def to_list(%GeometryCollectionZ{geometries: geometries}), do: MapSet.to_list(geometries)

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
      {:xdr, false} -> "80000007"
      {:ndr, false} -> "07000080"
      {:xdr, true} -> "A0000007"
      {:ndr, true} -> "070000A0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x80000007::big-integer-size(32)>>
      {:ndr, false} -> <<0x80000007::little-integer-size(32)>>
      {:xdr, true} -> <<0xA0000007::big-integer-size(32)>>
      {:ndr, true} -> <<0xA0000007::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(geometry_collection) do
      {:ok, GeometryCollectionZ.size(geometry_collection)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(geometry_collection, val) do
      {:ok, GeometryCollectionZ.member?(geometry_collection, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(geometry_collection) do
      size = GeometryCollectionZ.size(geometry_collection)

      {:ok, size,
       &Enumerable.List.slice(GeometryCollectionZ.to_list(geometry_collection), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(geometry_collection, acc, fun) do
      Enumerable.List.reduce(GeometryCollectionZ.to_list(geometry_collection), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%GeometryCollectionZ{geometries: geometries}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          %GeometryCollectionZ{
            geometries: %{geometries | map: Map.merge(geometries.map, Map.new(list))}
          }

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
