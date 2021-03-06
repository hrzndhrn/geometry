defmodule Geometry.MultiPointM do
  @moduledoc """
  A set of points from type `Geometry.PointM`.

  `MultiPointM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPointM.new([
      ...>     PointM.new(1, 2, 4),
      ...>     PointM.new(3, 4, 6)
      ...>   ]),
      ...>   fn [x, _y, _m] -> x end
      ...> )
      [1, 3]

      iex> Enum.into([PointM.new(1, 2, 4)], MultiPointM.new())
      %MultiPointM{
        points:
          MapSet.new([
            [1, 2, 4]
          ])
      }
  """

  alias Geometry.{GeoJson, MultiPointM, PointM, WKB, WKT}

  defstruct points: MapSet.new()

  @type t :: %MultiPointM{points: MapSet.t(Geometry.coordinate())}

  @doc """
  Creates an empty `MultiPointM`.

  ## Examples

      iex> MultiPointM.new()
      %MultiPointM{points: MapSet.new()}
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
      %MultiPointM{points: MapSet.new([
        [1, 2, 4],
        [3, 4, 6]
      ])}

      iex> MultiPointM.new([])
      %MultiPointM{points: MapSet.new()}
  """
  @spec new([PointM.t()]) :: t()
  def new([]), do: %MultiPointM{}

  def new(points) do
    %MultiPointM{points: Enum.into(points, MapSet.new(), fn point -> point.coordinate end)}
  end

  @doc """
  Returns `true` if the given `MultiPointM` is empty.

  ## Examples

      iex> MultiPointM.empty?(MultiPointM.new())
      true

      iex> MultiPointM.empty?(
      ...>   MultiPointM.new(
      ...>     [PointM.new(1, 2, 4), PointM.new(3, 4, 6)]
      ...>   )
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPointM{} = multi_point), do: Enum.empty?(multi_point.points)

  @doc """
  Creates a `MultiPointM` from the given coordinates.

  ## Examples

      iex> MultiPointM.from_coordinates(
      ...>   [[-1, 1, 1], [-2, 2, 2], [-3, 3, 3]]
      ...> )
      %MultiPointM{
        points: MapSet.new([
          [-1, 1, 1],
          [-2, 2, 2],
          [-3, 3, 3]
        ])
      }

      iex> MultiPointM.from_coordinates(
      ...>   [[-1, 1, 1], [-2, 2, 2], [-3, 3, 3]]
      ...> )
      %MultiPointM{
        points: MapSet.new([
          [-1, 1, 1],
          [-2, 2, 2],
          [-3, 3, 3]
        ])
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates), do: %MultiPointM{points: MapSet.new(coordinates)}

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
      {:ok, %MultiPointM{points: MapSet.new([
        [1.1, 1.2, 1.4],
        [20.1, 20.2, 20.4]
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
  def to_geo_json(%MultiPointM{points: points}) do
    %{
      "type" => "MultiPoint",
      "coordinates" => MapSet.to_list(points)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPointM.from_wkt(
      ...>   "MultiPoint M (-5.1 7.8 1, 0.1 0.2 2)"
      ...> )
      {:ok, %MultiPointM{
        points: MapSet.new([
          [-5.1, 7.8, 1],
          [0.1, 0.2, 2]
        ])
      }}

      iex> MultiPointM.from_wkt(
      ...>   "SRID=7219;MultiPoint M (-5.1 7.8 1, 0.1 0.2 2)"
      ...> )
      {:ok, {
        %MultiPointM{
          points: MapSet.new([
            [-5.1, 7.8, 1],
            [0.1, 0.2, 2]
          ])
        },
        7219
      }}

      iex> MultiPointM.from_wkt("MultiPoint M EMPTY")
      ...> {:ok, %MultiPointM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPointM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPointM) do
      {:ok, geometry} -> geometry
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
  def to_wkt(%MultiPointM{points: points}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiPoint M ",
        points |> MapSet.to_list() |> to_wkt_points()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiPointM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%MultiPointM{} = multi_point, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_point, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, MultiPointM)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, MultiPointM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiPointM`.

  ## Examples

      iex> MultiPointM.size(
      ...>   MultiPointM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     PointM.new(21, 22, 24)
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiPointM{points: points}), do: MapSet.size(points)

  @doc """
  Checks if `MulitPointM` contains `point`.

  ## Examples

      iex> MultiPointM.member?(
      ...>   MultiPointM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     PointM.new(21, 22, 24)
      ...>   ]),
      ...>   PointM.new(11, 12, 14)
      ...> )
      true

      iex> MultiPointM.member?(
      ...>   MultiPointM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     PointM.new(21, 22, 24)
      ...>   ]),
      ...>   PointM.new(1, 2, 4)
      ...> )
      false
  """
  @spec member?(t(), PointM.t()) :: boolean()
  def member?(%MultiPointM{points: points}, %PointM{coordinate: coordinate}),
    do: MapSet.member?(points, coordinate)

  @doc """
  Converts `MultiPointM` to a list.

  ## Examples

      iex> MultiPointM.to_list(
      ...>   MultiPointM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     PointM.new(21, 22, 24)
      ...>   ])
      ...> )
      [
        [11, 12, 14],
        [21, 22, 24]
      ]
  """
  @spec to_list(t()) :: [PointM.t()]
  def to_list(%MultiPointM{points: points}), do: MapSet.to_list(points)

  @compile {:inline, to_wkt_points: 1}
  defp to_wkt_points([]), do: "EMPTY"

  defp to_wkt_points([coordinate | points]) do
    <<"(",
      Enum.reduce(points, PointM.to_wkt_coordinate(coordinate), fn coordinate, acc ->
        <<acc::binary(), ", ", PointM.to_wkt_coordinate(coordinate)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(t(), Geometry.srid(), Geometry.endian(), Geometry.mode()) :: Geometry.wkb()
  def to_wkb(%MultiPointM{points: points}, srid, endian, mode) do
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
      <<acc::binary(), PointM.to_wkb(point, nil, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "40000004"
      {:ndr, false} -> "04000040"
      {:xdr, true} -> "60000004"
      {:ndr, true} -> "04000060"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x40000004::big-integer-size(32)>>
      {:ndr, false} -> <<0x40000004::little-integer-size(32)>>
      {:xdr, true} -> <<0x60000004::big-integer-size(32)>>
      {:ndr, true} -> <<0x60000004::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_point) do
      {:ok, MultiPointM.size(multi_point)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_point, val) do
      {:ok, MultiPointM.member?(multi_point, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_point) do
      size = MultiPointM.size(multi_point)
      {:ok, size, &Enumerable.List.slice(MultiPointM.to_list(multi_point), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_point, acc, fun) do
      Enumerable.List.reduce(MultiPointM.to_list(multi_point), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiPointM{points: points}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          new = Enum.into(list, %{}, fn {point, []} -> {point.coordinate, []} end)
          %MultiPointM{points: %{points | map: Map.merge(points.map, Map.new(new))}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
