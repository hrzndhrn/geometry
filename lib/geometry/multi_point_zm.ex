defmodule Geometry.MultiPointZM do
  @moduledoc """
  A set of points from type `Geometry.PointZM`
  """

  alias Geometry.{GeoJson, MultiPointZM, PointZM, WKB, WKT}

  defstruct points: MapSet.new()

  @type t :: %MultiPointZM{points: MapSet.t(PointZM.t())}

  @doc """
  Creates an empty `MultiPointZM`.

  ## Examples

      iex> MultiPointZM.new()
      %MultiPointZM{points: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPointZM{}

  @doc """
  Creates a `MultiPointZM` from the given `Geometry.PointZM`s.

  ## Examples

      iex> MultiPointZM.new([
      ...>   PointZM.new(1, 2, 3, 4),
      ...>   PointZM.new(1, 2, 3, 4),
      ...>   PointZM.new(3, 4, 5, 6)
      ...> ])
      %MultiPointZM{points: MapSet.new([
        %PointZM{x: 1, y: 2, z: 3, m: 4},
        %PointZM{x: 3, y: 4, z: 5, m: 6}
      ])}

      iex> MultiPointZM.new([])
      %MultiPointZM{points: MapSet.new()}
  """
  @spec new([PointZM.t()]) :: t()
  def new([]), do: %MultiPointZM{}
  def new(points), do: %MultiPointZM{points: MapSet.new(points)}

  @doc """
  Returns `true` if the given `MultiPointZM` is empty.

  ## Examples

      iex> MultiPointZM.empty?(MultiPointZM.new())
      true

      iex> MultiPointZM.empty?(
      ...>   MultiPointZM.new(
      ...>     [PointZM.new(1, 2, 3, 4), PointZM.new(3, 4, 5, 6)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPointZM{} = multi_point), do: Enum.empty?(multi_point.points)

  @doc """
  Creates a `MultiPointZM` from the given coordinates.

  ## Examples

      iex> MultiPointZM.from_coordinates([
      ...>   [-1, 1, 1, 1], [-2, 2, 2, 2], [-3, 3, 3, 3]])
      %MultiPointZM{
        points: MapSet.new([
          %PointZM{x: -1, y: 1, z: 1, m: 1},
          %PointZM{x: -2, y: 2, z: 2, m: 2},
          %PointZM{x: -3, y: 3, z: 3, m: 3}
        ])
      }

      iex> MultiPointZM.from_coordinates(
      ...>   [{-1, 1, 1, 1}, {-2, 2, 2, 2}, {-3, 3, 3, 3}])
      %MultiPointZM{
        points: MapSet.new([
          %PointZM{x: -1, y: 1, z: 1, m: 1},
          %PointZM{x: -2, y: 2, z: 2, m: 2},
          %PointZM{x: -3, y: 3, z: 3, m: 3}
        ])
      }
  """
  @spec from_coordinates([Geometry.coordinate_zm()]) :: t()
  def from_coordinates(coordinates) do
    %MultiPointZM{points: coordinates |> Enum.map(&PointZM.new/1) |> MapSet.new()}
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointZM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiPoint",
      ...>     "coordinates": [
      ...>       [1.1, 1.2, 1.3, 1.4],
      ...>       [20.1, 20.2, 20.3, 20.4]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> MultiPointZM.from_geo_json()
      {:ok, %MultiPointZM{points: MapSet.new([
        %PointZM{x: 1.1, y: 1.2, z: 1.3, m: 1.4},
        %PointZM{x: 20.1, y: 20.2, z: 20.3, m: 20.4}
      ])}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_point(json, MultiPointZM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_point(json, MultiPointZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiPointZM`.

  There are no guarantees about the order of points in the returned
  `coordinates`.

  ## Examples

  ```elixir
  MultiPointZM.to_geo_json(
    MultiPointZM.new([
      PointZM.new(-1.1, -2.2, -3.3, -4.4),
      PointZM.new(1.1, 2.2, 3.3, 4.4)
    ])
  )
  # =>
  # %{
  #   "type" => "MultiPoint",
  #   "coordinates" => [
  #     [-1.1, -2.2, -3.3, -4.4],
  #     [1.1, 2.2, 3.3, 4.4]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPointZM{points: points}) do
    %{
      "type" => "MultiPoint",
      "coordinates" => Enum.map(points, &PointZM.to_list/1)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointZM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPointZM.from_wkt(
      ...>   "MultiPoint ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)")
      {:ok, %MultiPointZM{
        points: MapSet.new([
          %PointZM{x: -5.1, y: 7.8, z: 1.1, m: 1},
          %PointZM{x: 0.1, y: 0.2, z: 2.2, m: 2}
        ])
      }}

      iex> MultiPointZM.from_wkt(
      ...>   "SRID=7219;MultiPoint ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)")
      {:ok, %MultiPointZM{
        points: MapSet.new([
          %PointZM{x: -5.1, y: 7.8, z: 1.1, m: 1},
          %PointZM{x: 0.1, y: 0.2, z: 2.2, m: 2}
        ])
      }, 7219}

      iex> MultiPointZM.from_wkt("MultiPoint ZM EMPTY")
      ...> {:ok, %MultiPointZM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPointZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPointZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiPointZM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of points in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiPointZM.to_wkt(MultiPointZM.new())
  # => "MultiPoint ZM EMPTY"

  MultiPointZM.to_wkt(
    MultiPointZM.new([
      PointZM.new(7.1, 8.1, 1.1, 1),
      PointZM.new(9.2, 5.2, 2.2, 2)
    ]
  )
  # => "MultiPoint ZM (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"

  MultiPointZM.to_wkt(
    MultiPointZM.new([
      PointZM.new(7.1, 8.1, 1.1, 1),
      PointZM.new(9.2, 5.2, 2.2, 2)
    ]),
    srid: 123
  )
  # => "SRID=123;MultiPoint ZM (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(line_string, opts \\ [])

  def to_wkt(%MultiPointZM{points: points}, opts) do
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
  Returns the WKB representation for a `MultiPointZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiPointZM{} = multi_point, opts \\ []) do
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
  Returns an `:ok` tuple with the `MultiPointZM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiPointZM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiPointZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  defp to_wkt_points(points) do
    wkt =
      points
      |> Enum.map(fn point -> PointZM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkt_multi_point(wkt), do: <<"MultiPoint ZM ", wkt::binary()>>

  defp to_wkb_multi_point(%MultiPointZM{points: points}, endian) do
    data =
      Enum.reduce(points, [], fn point, acc ->
        [PointZM.to_wkb(point, endian: endian) | acc]
      end)

    <<WKB.length(points, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000004"
      {:ndr, false} -> "040000C0"
      {:xdr, true} -> "E0000004"
      {:ndr, true} -> "040000E0"
    end
  end
end
