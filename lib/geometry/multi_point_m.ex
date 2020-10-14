defmodule Geometry.MultiPointM do
  @moduledoc """
  A collection set of geometries restricted to `Geometry.PointM`.
  """

  alias Geometry.{GeoJson, MultiPointM, PointM, WKB, WKT}

  defstruct geometries: MapSet.new()

  @type t :: %MultiPointM{geometries: MapSet.t(PointM.t())}

  @doc """
  Creates an empty `MultiPointM`.

  ## Examples

      iex> MultiPointM.new()
      %MultiPointM{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPointM{}

  @doc """
  Creates a `MultiPointM` from the given `Geometry.PointM`s.

  ## Examples

      iex> MultiPointM.new([
      ...>   PointM.new(1, 2, 4),
      ...>   PointM.new(1, 2, 4),
      ...>   PointM.new(3, 4, 6)
      ...> ])
      %MultiPointM{geometries: MapSet.new([
        %PointM{x: 1, y: 2, m: 4},
        %PointM{x: 3, y: 4, m: 6}
      ])}

      iex> MultiPointM.new([])
      %MultiPointM{geometries: MapSet.new()}
  """
  @spec new([PointM.t()]) :: t()
  def new([]), do: %MultiPointM{}
  def new(points), do: %MultiPointM{geometries: MapSet.new(points)}

  @doc """
  Returns `true` if the given `MultiPointM` is empty.

  ## Examples

      iex> MultiPointM.empty?(MultiPointM.new())
      true

      iex> MultiPointM.empty?(
      ...>   MultiPointM.new(
      ...>     [PointM.new(1, 2, 4), PointM.new(3, 4, 6)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPointM{} = multi_point), do: Enum.empty?(multi_point.geometries)

  @doc """
  Creates a `MultiPointM` from the given coordinates.

  ## Examples

      iex> MultiPointM.from_coordinates([
      ...>   [-1, 1, 1], [-2, 2, 2], [-3, 3, 3]])
      %MultiPointM{
        geometries: MapSet.new([
          %PointM{x: -1, y: 1, m: 1},
          %PointM{x: -2, y: 2, m: 2},
          %PointM{x: -3, y: 3, m: 3}
        ])
      }

      iex> MultiPointM.from_coordinates(
      ...>   [{-1, 1, 1}, {-2, 2, 2}, {-3, 3, 3}])
      %MultiPointM{
        geometries: MapSet.new([
          %PointM{x: -1, y: 1, m: 1},
          %PointM{x: -2, y: 2, m: 2},
          %PointM{x: -3, y: 3, m: 3}
        ])
      }
  """
  @spec from_coordinates([Geometry.coordinate_m()]) :: t()
  def from_coordinates(coordinates) do
    %MultiPointM{geometries: coordinates |> Enum.map(&PointM.new/1) |> MapSet.new()}
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiPoint",
      ...>     "coordinates": [
      ...>       [1.1, 1.2, 1.4],
      ...>       [20.1, 20.2, 20.4]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> MultiPointM.from_geo_json()
      {:ok, %MultiPointM{geometries: MapSet.new([
        %PointM{x: 1.1, y: 1.2, m: 1.4},
        %PointM{x: 20.1, y: 20.2, m: 20.4}
      ])}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_point(json, MultiPointM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_point(json, MultiPointM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiPointM`.

  There are no guarantees about the order of points in the returned
  `coordinates`.

  ## Examples

  ```elixir
  MultiPointM.to_geo_json(
    MultiPointM.new([
      PointM.new(-1.1, -2.2, -4.4),
      PointM.new(1.1, 2.2, 4.4)
    ])
  )
  # =>
  # %{
  #   "type" => "MultiPoint",
  #   "coordinates" => [
  #     [-1.1, -2.2, -4.4],
  #     [1.1, 2.2, 4.4]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPointM{geometries: points}) do
    %{
      "type" => "MultiPoint",
      "coordinates" => Enum.map(points, &PointM.to_list/1)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPointM.from_wkt(
      ...>   "MultiPoint M (-5.1 7.8 1, 0.1 0.2 2)")
      {:ok, %MultiPointM{
        geometries: MapSet.new([
          %PointM{x: -5.1, y: 7.8, m: 1},
          %PointM{x: 0.1, y: 0.2, m: 2}
        ])
      }}

      iex> MultiPointM.from_wkt(
      ...>   "SRID=7219;MultiPoint M (-5.1 7.8 1, 0.1 0.2 2)")
      {:ok, %MultiPointM{
        geometries: MapSet.new([
          %PointM{x: -5.1, y: 7.8, m: 1},
          %PointM{x: 0.1, y: 0.2, m: 2}
        ])
      }, 7219}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPointM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPointM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiPointM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of points in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiPointM.to_wkt(MultiPointM.new())
  # => "MultiPoint M EMPTY"

  MultiPointM.to_wkt(
    MultiPointM.new([
      PointM.new(7.1, 8.1, 1),
      PointM.new(9.2, 5.2, 2)
    ]
  )
  # => "MultiPoint M (7.1 8.1 1, 9.2 5.2 2)"

  MultiPointM.to_wkt(
    MultiPointM.new([
      PointM.new(7.1, 8.1, 1),
      PointM.new(9.2, 5.2, 2)
    ]),
    srid: 123
  )
  # => "SRID=123;MultiPoint M (7.1 8.1 1, 9.2 5.2 2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(line_string, opts \\ [])

  def to_wkt(%MultiPointM{geometries: points}, opts) do
    points
    |> Enum.empty?()
    |> case do
      true -> "EMPTY"
      false -> to_wkt_points(points)
    end
    |> to_wkt_multi_point()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `MultiPointM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiPointM{} = multi_point, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_multi_point(multi_point, endian)::binary()
    >>
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiPointM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiPointM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  defp to_wkt_points(points) do
    wkt =
      points
      |> Enum.map(fn point -> PointM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkt_multi_point(wkt), do: <<"MultiPoint M ", wkt::binary()>>

  defp to_wkb_multi_point(%MultiPointM{geometries: geometries}, endian) do
    data =
      Enum.reduce(geometries, [], fn point, acc ->
        [PointM.to_wkb(point, endian: endian) | acc]
      end)

    <<WKB.length(geometries, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "40000004"
      {:ndr, false} -> "04000040"
      {:xdr, true} -> "60000004"
      {:ndr, true} -> "04000060"
    end
  end
end
