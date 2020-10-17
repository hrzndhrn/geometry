defmodule Geometry.MultiPoint do
  @moduledoc """
  A set of points from type `Geometry.Point`
  """

  alias Geometry.{GeoJson, MultiPoint, Point, WKB, WKT}

  defstruct points: MapSet.new()

  @type t :: %MultiPoint{points: MapSet.t(Point.t())}

  @doc """
  Creates an empty `MultiPoint`.

  ## Examples

      iex> MultiPoint.new()
      %MultiPoint{points: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPoint{}

  @doc """
  Creates a `MultiPoint` from the given `Geometry.Point`s.

  ## Examples

      iex> MultiPoint.new([
      ...>   Point.new(1, 2),
      ...>   Point.new(1, 2),
      ...>   Point.new(3, 4)
      ...> ])
      %MultiPoint{points: MapSet.new([
        %Point{x: 1, y: 2},
        %Point{x: 3, y: 4}
      ])}

      iex> MultiPoint.new([])
      %MultiPoint{points: MapSet.new()}
  """
  @spec new([Point.t()]) :: t()
  def new([]), do: %MultiPoint{}
  def new(points), do: %MultiPoint{points: MapSet.new(points)}

  @doc """
  Returns `true` if the given `MultiPoint` is empty.

  ## Examples

      iex> MultiPoint.empty?(MultiPoint.new())
      true

      iex> MultiPoint.empty?(
      ...>   MultiPoint.new(
      ...>     [Point.new(1, 2), Point.new(3, 4)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPoint{} = multi_point), do: Enum.empty?(multi_point.points)

  @doc """
  Creates a `MultiPoint` from the given coordinates.

  ## Examples

      iex> MultiPoint.from_coordinates([
      ...>   [-1, 1], [-2, 2], [-3, 3]])
      %MultiPoint{
        points: MapSet.new([
          %Point{x: -1, y: 1},
          %Point{x: -2, y: 2},
          %Point{x: -3, y: 3}
        ])
      }

      iex> MultiPoint.from_coordinates(
      ...>   [{-1, 1}, {-2, 2}, {-3, 3}])
      %MultiPoint{
        points: MapSet.new([
          %Point{x: -1, y: 1},
          %Point{x: -2, y: 2},
          %Point{x: -3, y: 3}
        ])
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates) do
    %MultiPoint{points: coordinates |> Enum.map(&Point.new/1) |> MapSet.new()}
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPoint` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiPoint",
      ...>     "coordinates": [
      ...>       [1.1, 1.2],
      ...>       [20.1, 20.2]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> MultiPoint.from_geo_json()
      {:ok, %MultiPoint{points: MapSet.new([
        %Point{x: 1.1, y: 1.2},
        %Point{x: 20.1, y: 20.2}
      ])}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_point(json, MultiPoint)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_point(json, MultiPoint) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiPoint`.

  There are no guarantees about the order of points in the returned
  `coordinates`.

  ## Examples

  ```elixir
  MultiPoint.to_geo_json(
    MultiPoint.new([
      Point.new(-1.1, -2.2),
      Point.new(1.1, 2.2)
    ])
  )
  # =>
  # %{
  #   "type" => "MultiPoint",
  #   "coordinates" => [
  #     [-1.1, -2.2],
  #     [1.1, 2.2]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPoint{points: points}) do
    %{
      "type" => "MultiPoint",
      "coordinates" => Enum.map(points, &Point.to_list/1)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPoint` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPoint.from_wkt(
      ...>   "MultiPoint (-5.1 7.8, 0.1 0.2)")
      {:ok, %MultiPoint{
        points: MapSet.new([
          %Point{x: -5.1, y: 7.8},
          %Point{x: 0.1, y: 0.2}
        ])
      }}

      iex> MultiPoint.from_wkt(
      ...>   "SRID=7219;MultiPoint (-5.1 7.8, 0.1 0.2)")
      {:ok, %MultiPoint{
        points: MapSet.new([
          %Point{x: -5.1, y: 7.8},
          %Point{x: 0.1, y: 0.2}
        ])
      }, 7219}

      iex> MultiPoint.from_wkt("MultiPoint EMPTY")
      ...> {:ok, %MultiPoint{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPoint)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPoint) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiPoint`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of points in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiPoint.to_wkt(MultiPoint.new())
  # => "MultiPoint EMPTY"

  MultiPoint.to_wkt(
    MultiPoint.new([
      Point.new(7.1, 8.1),
      Point.new(9.2, 5.2)
    ]
  )
  # => "MultiPoint (7.1 8.1, 9.2 5.2)"

  MultiPoint.to_wkt(
    MultiPoint.new([
      Point.new(7.1, 8.1),
      Point.new(9.2, 5.2)
    ]),
    srid: 123
  )
  # => "SRID=123;MultiPoint (7.1 8.1, 9.2 5.2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(line_string, opts \\ [])

  def to_wkt(%MultiPoint{points: points}, opts) do
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
  Returns the WKB representation for a `MultiPoint`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiPoint{} = multi_point, opts \\ []) do
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
  Returns an `:ok` tuple with the `MultiPoint` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiPoint)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiPoint) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  defp to_wkt_points(points) do
    wkt =
      points
      |> Enum.map(fn point -> Point.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkt_multi_point(wkt), do: <<"MultiPoint ", wkt::binary()>>

  defp to_wkb_multi_point(%MultiPoint{points: points}, endian) do
    data =
      Enum.reduce(points, [], fn point, acc ->
        [Point.to_wkb(point, endian: endian) | acc]
      end)

    <<WKB.length(points, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "00000004"
      {:ndr, false} -> "04000000"
      {:xdr, true} -> "20000004"
      {:ndr, true} -> "04000020"
    end
  end
end
