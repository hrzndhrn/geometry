defmodule Geometry.MultiPointZ do
  @moduledoc """
  A set of points from type `Geometry.PointZ`.

  `MultiPointZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPointZ.new([
      ...>     PointZ.new(1, 2, 3),
      ...>     PointZ.new(3, 4, 5)
      ...>   ]),
      ...>   fn [x, _y, _z] -> x end
      ...> )
      [1, 3]

      iex> Enum.into([PointZ.new(1, 2, 3)], MultiPointZ.new())
      %MultiPointZ{
        points:
          MapSet.new([
            [1, 2, 3]
          ])
      }
  """

  alias Geometry.{GeoJson, MultiPointZ, PointZ, WKB, WKT}

  defstruct points: MapSet.new()

  @type t :: %MultiPointZ{points: MapSet.t(Geometry.coordinate())}

  @doc """
  Creates an empty `MultiPointZ`.

  ## Examples

      iex> MultiPointZ.new()
      %MultiPointZ{points: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPointZ{}

  @doc """
  Creates a `MultiPointZ` from the given `Geometry.PointZ`s.

  ## Examples

      iex> MultiPointZ.new([
      ...>   PointZ.new(1, 2, 3),
      ...>   PointZ.new(1, 2, 3),
      ...>   PointZ.new(3, 4, 5)
      ...> ])
      %MultiPointZ{points: MapSet.new([
        [1, 2, 3],
        [3, 4, 5]
      ])}

      iex> MultiPointZ.new([])
      %MultiPointZ{points: MapSet.new()}
  """
  @spec new([PointZ.t()]) :: t()
  def new([]), do: %MultiPointZ{}

  def new(points) do
    %MultiPointZ{points: Enum.into(points, MapSet.new(), fn point -> point.coordinate end)}
  end

  @doc """
  Returns `true` if the given `MultiPointZ` is empty.

  ## Examples

      iex> MultiPointZ.empty?(MultiPointZ.new())
      true

      iex> MultiPointZ.empty?(
      ...>   MultiPointZ.new(
      ...>     [PointZ.new(1, 2, 3), PointZ.new(3, 4, 5)]
      ...>   )
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPointZ{} = multi_point), do: Enum.empty?(multi_point.points)

  @doc """
  Creates a `MultiPointZ` from the given coordinates.

  ## Examples

      iex> MultiPointZ.from_coordinates(
      ...>   [[-1, 1, 1], [-2, 2, 2], [-3, 3, 3]]
      ...> )
      %MultiPointZ{
        points: MapSet.new([
          [-1, 1, 1],
          [-2, 2, 2],
          [-3, 3, 3]
        ])
      }

      iex> MultiPointZ.from_coordinates(
      ...>   [[-1, 1, 1], [-2, 2, 2], [-3, 3, 3]]
      ...> )
      %MultiPointZ{
        points: MapSet.new([
          [-1, 1, 1],
          [-2, 2, 2],
          [-3, 3, 3]
        ])
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates), do: %MultiPointZ{points: MapSet.new(coordinates)}

  @doc """
  Returns an `:ok` tuple with the `MultiPointZ` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiPoint",
      ...>     "coordinates": [
      ...>       [1.1, 1.2, 1.3],
      ...>       [20.1, 20.2, 20.3]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> MultiPointZ.from_geo_json()
      {:ok, %MultiPointZ{points: MapSet.new([
        [1.1, 1.2, 1.3],
        [20.1, 20.2, 20.3]
      ])}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_point(json, MultiPointZ)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_point(json, MultiPointZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiPointZ`.

  There are no guarantees about the order of points in the returned
  `coordinates`.

  ## Examples

  ```elixir
  MultiPointZ.to_geo_json(
    MultiPointZ.new([
      PointZ.new(-1.1, -2.2, -3.3),
      PointZ.new(1.1, 2.2, 3.3)
    ])
  )
  # =>
  # %{
  #   "type" => "MultiPoint",
  #   "coordinates" => [
  #     [-1.1, -2.2, -3.3],
  #     [1.1, 2.2, 3.3]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPointZ{points: points}) do
    %{
      "type" => "MultiPoint",
      "coordinates" => MapSet.to_list(points)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointZ` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPointZ.from_wkt(
      ...>   "MultiPoint Z (-5.1 7.8 1.1, 0.1 0.2 2.2)"
      ...> )
      {:ok, %MultiPointZ{
        points: MapSet.new([
          [-5.1, 7.8, 1.1],
          [0.1, 0.2, 2.2]
        ])
      }}

      iex> MultiPointZ.from_wkt(
      ...>   "SRID=7219;MultiPoint Z (-5.1 7.8 1.1, 0.1 0.2 2.2)"
      ...> )
      {:ok, {
        %MultiPointZ{
          points: MapSet.new([
            [-5.1, 7.8, 1.1],
            [0.1, 0.2, 2.2]
          ])
        },
        7219
      }}

      iex> MultiPointZ.from_wkt("MultiPoint Z EMPTY")
      ...> {:ok, %MultiPointZ{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPointZ)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPointZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiPointZ`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of points in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiPointZ.to_wkt(MultiPointZ.new())
  # => "MultiPoint Z EMPTY"

  MultiPointZ.to_wkt(
    MultiPointZ.new([
      PointZ.new(7.1, 8.1, 1.1),
      PointZ.new(9.2, 5.2, 2.2)
    ]
  )
  # => "MultiPoint Z (7.1 8.1 1.1, 9.2 5.2 2.2)"

  MultiPointZ.to_wkt(
    MultiPointZ.new([
      PointZ.new(7.1, 8.1, 1.1),
      PointZ.new(9.2, 5.2, 2.2)
    ]),
    srid: 123
  )
  # => "SRID=123;MultiPoint Z (7.1 8.1 1.1, 9.2 5.2 2.2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%MultiPointZ{points: points}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiPoint Z ",
        points |> MapSet.to_list() |> to_wkt_points()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiPointZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%MultiPointZ{} = multi_point, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_point, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointZ` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, MultiPointZ)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, MultiPointZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiPointZ`.

  ## Examples

      iex> MultiPointZ.size(
      ...>   MultiPointZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     PointZ.new(21, 22, 23)
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiPointZ{points: points}), do: MapSet.size(points)

  @doc """
  Checks if `MulitPointZ` contains `point`.

  ## Examples

      iex> MultiPointZ.member?(
      ...>   MultiPointZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     PointZ.new(21, 22, 23)
      ...>   ]),
      ...>   PointZ.new(11, 12, 13)
      ...> )
      true

      iex> MultiPointZ.member?(
      ...>   MultiPointZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     PointZ.new(21, 22, 23)
      ...>   ]),
      ...>   PointZ.new(1, 2, 3)
      ...> )
      false
  """
  @spec member?(t(), PointZ.t()) :: boolean()
  def member?(%MultiPointZ{points: points}, %PointZ{coordinate: coordinate}),
    do: MapSet.member?(points, coordinate)

  @doc """
  Converts `MultiPointZ` to a list.

  ## Examples

      iex> MultiPointZ.to_list(
      ...>   MultiPointZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     PointZ.new(21, 22, 23)
      ...>   ])
      ...> )
      [
        [11, 12, 13],
        [21, 22, 23]
      ]
  """
  @spec to_list(t()) :: [PointZ.t()]
  def to_list(%MultiPointZ{points: points}), do: MapSet.to_list(points)

  @compile {:inline, to_wkt_points: 1}
  defp to_wkt_points([]), do: "EMPTY"

  defp to_wkt_points([coordinate | points]) do
    <<"(",
      Enum.reduce(points, PointZ.to_wkt_coordinate(coordinate), fn coordinate, acc ->
        <<acc::binary(), ", ", PointZ.to_wkt_coordinate(coordinate)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(t(), Geometry.srid(), Geometry.endian(), Geometry.mode()) :: Geometry.wkb()
  def to_wkb(%MultiPointZ{points: points}, srid, endian, mode) do
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
      <<acc::binary(), PointZ.to_wkb(point, nil, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "80000004"
      {:ndr, false} -> "04000080"
      {:xdr, true} -> "A0000004"
      {:ndr, true} -> "040000A0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x80000004::big-integer-size(32)>>
      {:ndr, false} -> <<0x80000004::little-integer-size(32)>>
      {:xdr, true} -> <<0xA0000004::big-integer-size(32)>>
      {:ndr, true} -> <<0xA0000004::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_point) do
      {:ok, MultiPointZ.size(multi_point)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_point, val) do
      {:ok, MultiPointZ.member?(multi_point, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_point) do
      size = MultiPointZ.size(multi_point)
      {:ok, size, &Enumerable.List.slice(MultiPointZ.to_list(multi_point), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_point, acc, fun) do
      Enumerable.List.reduce(MultiPointZ.to_list(multi_point), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiPointZ{points: points}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          new = Enum.into(list, %{}, fn {point, []} -> {point.coordinate, []} end)
          %MultiPointZ{points: %{points | map: Map.merge(points.map, Map.new(new))}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
