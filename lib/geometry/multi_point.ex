defmodule Geometry.MultiPoint do
  @moduledoc """
  A set of points from type `Geometry.Point`.

  `MultiPoint` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPoint.new([
      ...>     Point.new(1, 2),
      ...>     Point.new(3, 4)
      ...>   ]),
      ...>   fn [x, _y] -> x end
      ...> )
      [1, 3]

      iex> Enum.into([Point.new(1, 2)], MultiPoint.new())
      %MultiPoint{
        points:
          MapSet.new([
            [1, 2]
          ])
      }
  """

  alias Geometry.{GeoJson, MultiPoint, Point, WKB, WKT}

  defstruct points: MapSet.new()

  @type t :: %MultiPoint{points: MapSet.t(Geometry.coordinate())}

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
        [1, 2],
        [3, 4]
      ])}

      iex> MultiPoint.new([])
      %MultiPoint{points: MapSet.new()}
  """
  @spec new([Point.t()]) :: t()
  def new([]), do: %MultiPoint{}

  def new(points) do
    %MultiPoint{points: Enum.into(points, MapSet.new(), fn point -> point.coordinate end)}
  end

  @doc """
  Returns `true` if the given `MultiPoint` is empty.

  ## Examples

      iex> MultiPoint.empty?(MultiPoint.new())
      true

      iex> MultiPoint.empty?(
      ...>   MultiPoint.new(
      ...>     [Point.new(1, 2), Point.new(3, 4)]
      ...>   )
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPoint{} = multi_point), do: Enum.empty?(multi_point.points)

  @doc """
  Creates a `MultiPoint` from the given coordinates.

  ## Examples

      iex> MultiPoint.from_coordinates(
      ...>   [[-1, 1], [-2, 2], [-3, 3]]
      ...> )
      %MultiPoint{
        points: MapSet.new([
          [-1, 1],
          [-2, 2],
          [-3, 3]
        ])
      }

      iex> MultiPoint.from_coordinates(
      ...>   [[-1, 1], [-2, 2], [-3, 3]]
      ...> )
      %MultiPoint{
        points: MapSet.new([
          [-1, 1],
          [-2, 2],
          [-3, 3]
        ])
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates), do: %MultiPoint{points: MapSet.new(coordinates)}

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
        [1.1, 1.2],
        [20.1, 20.2]
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
      "coordinates" => MapSet.to_list(points)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPoint` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPoint.from_wkt(
      ...>   "MultiPoint (-5.1 7.8, 0.1 0.2)"
      ...> )
      {:ok, %MultiPoint{
        points: MapSet.new([
          [-5.1, 7.8],
          [0.1, 0.2]
        ])
      }}

      iex> MultiPoint.from_wkt(
      ...>   "SRID=7219;MultiPoint (-5.1 7.8, 0.1 0.2)"
      ...> )
      {:ok, {
        %MultiPoint{
          points: MapSet.new([
            [-5.1, 7.8],
            [0.1, 0.2]
          ])
        },
        7219
      }}

      iex> MultiPoint.from_wkt("MultiPoint EMPTY")
      ...> {:ok, %MultiPoint{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPoint)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPoint) do
      {:ok, geometry} -> geometry
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
  def to_wkt(%MultiPoint{points: points}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiPoint ",
        points |> MapSet.to_list() |> to_wkt_points()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiPoint`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%MultiPoint{} = multi_point, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_point, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPoint` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, MultiPoint)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, MultiPoint) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiPoint`.

  ## Examples

      iex> MultiPoint.size(
      ...>   MultiPoint.new([
      ...>     Point.new(11, 12),
      ...>     Point.new(21, 22)
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiPoint{points: points}), do: MapSet.size(points)

  @doc """
  Checks if `MulitPoint` contains `point`.

  ## Examples

      iex> MultiPoint.member?(
      ...>   MultiPoint.new([
      ...>     Point.new(11, 12),
      ...>     Point.new(21, 22)
      ...>   ]),
      ...>   Point.new(11, 12)
      ...> )
      true

      iex> MultiPoint.member?(
      ...>   MultiPoint.new([
      ...>     Point.new(11, 12),
      ...>     Point.new(21, 22)
      ...>   ]),
      ...>   Point.new(1, 2)
      ...> )
      false
  """
  @spec member?(t(), Point.t()) :: boolean()
  def member?(%MultiPoint{points: points}, %Point{coordinate: coordinate}),
    do: MapSet.member?(points, coordinate)

  @doc """
  Converts `MultiPoint` to a list.

  ## Examples

      iex> MultiPoint.to_list(
      ...>   MultiPoint.new([
      ...>     Point.new(11, 12),
      ...>     Point.new(21, 22)
      ...>   ])
      ...> )
      [
        [11, 12],
        [21, 22]
      ]
  """
  @spec to_list(t()) :: [Point.t()]
  def to_list(%MultiPoint{points: points}), do: MapSet.to_list(points)

  @compile {:inline, to_wkt_points: 1}
  defp to_wkt_points([]), do: "EMPTY"

  defp to_wkt_points([coordinate | points]) do
    <<"(",
      Enum.reduce(points, Point.to_wkt_coordinate(coordinate), fn coordinate, acc ->
        <<acc::binary(), ", ", Point.to_wkt_coordinate(coordinate)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(t(), Geometry.srid(), Geometry.endian(), Geometry.mode()) :: Geometry.wkb()
  def to_wkb(%MultiPoint{points: points}, srid, endian, mode) do
    <<
      WKB.byte_order(endian, mode)::binary(),
      wkb_code(endian, not is_nil(srid), mode)::binary(),
      WKB.srid(srid, endian, mode)::binary(),
      to_wkb_points(MapSet.to_list(points), endian, mode)::binary()
    >>
  end

  @compile {:inline, to_wkb_points: 3}
  defp to_wkb_points(points, endian, mode) do
    Enum.reduce(points, WKB.length(points, endian, mode), fn point, acc ->
      <<acc::binary(), Point.to_wkb(point, nil, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "00000004"
      {:ndr, false} -> "04000000"
      {:xdr, true} -> "20000004"
      {:ndr, true} -> "04000020"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x00000004::big-integer-size(32)>>
      {:ndr, false} -> <<0x00000004::little-integer-size(32)>>
      {:xdr, true} -> <<0x20000004::big-integer-size(32)>>
      {:ndr, true} -> <<0x20000004::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_point) do
      {:ok, MultiPoint.size(multi_point)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_point, val) do
      {:ok, MultiPoint.member?(multi_point, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_point) do
      size = MultiPoint.size(multi_point)
      {:ok, size, &Enumerable.List.slice(MultiPoint.to_list(multi_point), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_point, acc, fun) do
      Enumerable.List.reduce(MultiPoint.to_list(multi_point), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiPoint{points: points}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          new = Enum.into(list, %{}, fn {point, []} -> {point.coordinate, []} end)
          %MultiPoint{points: %{points | map: Map.merge(points.map, Map.new(new))}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
