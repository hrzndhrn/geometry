defmodule Geometry.MultiPointZM do
  @moduledoc """
  A set of points from type `Geometry.PointZM`.

  `MultiPointZM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPointZM.new([
      ...>     PointZM.new(1, 2, 3, 4),
      ...>     PointZM.new(3, 4, 5, 6)
      ...>   ]),
      ...>   fn [x, _y, _z, _m] -> x end
      ...> )
      [1, 3]

      iex> Enum.into([PointZM.new(1, 2, 3, 4)], MultiPointZM.new())
      %MultiPointZM{
        points:
          MapSet.new([
            [1, 2, 3, 4]
          ])
      }
  """

  alias Geometry.{GeoJson, MultiPointZM, PointZM, WKB, WKT}

  defstruct points: MapSet.new()

  @type t :: %MultiPointZM{points: MapSet.t(Geometry.coordinate())}

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
        [1, 2, 3, 4],
        [3, 4, 5, 6]
      ])}

      iex> MultiPointZM.new([])
      %MultiPointZM{points: MapSet.new()}
  """
  @spec new([PointZM.t()]) :: t()
  def new([]), do: %MultiPointZM{}

  def new(points) do
    %MultiPointZM{points: Enum.into(points, MapSet.new(), fn point -> point.coordinate end)}
  end

  @doc """
  Returns `true` if the given `MultiPointZM` is empty.

  ## Examples

      iex> MultiPointZM.empty?(MultiPointZM.new())
      true

      iex> MultiPointZM.empty?(
      ...>   MultiPointZM.new(
      ...>     [PointZM.new(1, 2, 3, 4), PointZM.new(3, 4, 5, 6)]
      ...>   )
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPointZM{} = multi_point), do: Enum.empty?(multi_point.points)

  @doc """
  Creates a `MultiPointZM` from the given coordinates.

  ## Examples

      iex> MultiPointZM.from_coordinates(
      ...>   [[-1, 1, 1, 1], [-2, 2, 2, 2], [-3, 3, 3, 3]]
      ...> )
      %MultiPointZM{
        points: MapSet.new([
          [-1, 1, 1, 1],
          [-2, 2, 2, 2],
          [-3, 3, 3, 3]
        ])
      }

      iex> MultiPointZM.from_coordinates(
      ...>   [[-1, 1, 1, 1], [-2, 2, 2, 2], [-3, 3, 3, 3]]
      ...> )
      %MultiPointZM{
        points: MapSet.new([
          [-1, 1, 1, 1],
          [-2, 2, 2, 2],
          [-3, 3, 3, 3]
        ])
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates), do: %MultiPointZM{points: MapSet.new(coordinates)}

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
        [1.1, 1.2, 1.3, 1.4],
        [20.1, 20.2, 20.3, 20.4]
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
      "coordinates" => MapSet.to_list(points)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPointZM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPointZM.from_wkt(
      ...>   "MultiPoint ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)"
      ...> )
      {:ok, %MultiPointZM{
        points: MapSet.new([
          [-5.1, 7.8, 1.1, 1],
          [0.1, 0.2, 2.2, 2]
        ])
      }}

      iex> MultiPointZM.from_wkt(
      ...>   "SRID=7219;MultiPoint ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)"
      ...> )
      {:ok, %MultiPointZM{
        points: MapSet.new([
          [-5.1, 7.8, 1.1, 1],
          [0.1, 0.2, 2.2, 2]
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
  def to_wkt(%MultiPointZM{points: points}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiPoint ZM ",
        points |> MapSet.to_list() |> to_wkt_points()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiPointZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiPointZM{} = multi_point, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_point, srid, endian)
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

  @doc """
  Returns the number of elements in `MultiPointZM`.

  ## Examples

      iex> MultiPointZM.size(
      ...>   MultiPointZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     PointZM.new(21, 22, 23, 24)
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiPointZM{points: points}), do: MapSet.size(points)

  @doc """
  Checks if `MulitPointZM` contains `point`.

  ## Examples

      iex> MultiPointZM.member?(
      ...>   MultiPointZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     PointZM.new(21, 22, 23, 24)
      ...>   ]),
      ...>   PointZM.new(11, 12, 13, 14)
      ...> )
      true

      iex> MultiPointZM.member?(
      ...>   MultiPointZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     PointZM.new(21, 22, 23, 24)
      ...>   ]),
      ...>   PointZM.new(1, 2, 3, 4)
      ...> )
      false
  """
  @spec member?(t(), PointZM.t()) :: boolean()
  def member?(%MultiPointZM{points: points}, %PointZM{coordinate: coordinate}),
    do: MapSet.member?(points, coordinate)

  @doc """
  Converts `MultiPointZM` to a list.

  ## Examples

      iex> MultiPointZM.to_list(
      ...>   MultiPointZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     PointZM.new(21, 22, 23, 24)
      ...>   ])
      ...> )
      [
        [11, 12, 13, 14],
        [21, 22, 23, 24]
      ]
  """
  @spec to_list(t()) :: [PointZM.t()]
  def to_list(%MultiPointZM{points: points}), do: MapSet.to_list(points)

  @compile {:inline, to_wkt_points: 1}
  defp to_wkt_points([]), do: "EMPTY"

  defp to_wkt_points([coordinate | points]) do
    <<"(",
      Enum.reduce(points, PointZM.to_wkt_coordinate(coordinate), fn coordinate, acc ->
        <<acc::binary(), ", ", PointZM.to_wkt_coordinate(coordinate)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 3}
  @spec to_wkb(t(), Geometry.srid(), Geometry.endian()) :: binary()
  def to_wkb(%MultiPointZM{points: points}, srid, endian) do
    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_points(MapSet.to_list(points), endian)::binary()
    >>
  end

  @compile {:inline, to_wkb_points: 2}
  defp to_wkb_points(points, endian) do
    Enum.reduce(points, WKB.length(points, endian), fn point, acc ->
      <<acc::binary(), PointZM.to_wkb(point, nil, endian)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000004"
      {:ndr, false} -> "040000C0"
      {:xdr, true} -> "E0000004"
      {:ndr, true} -> "040000E0"
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_point) do
      {:ok, MultiPointZM.size(multi_point)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_point, val) do
      {:ok, MultiPointZM.member?(multi_point, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_point) do
      size = MultiPointZM.size(multi_point)
      {:ok, size, &Enumerable.List.slice(MultiPointZM.to_list(multi_point), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_point, acc, fun) do
      Enumerable.List.reduce(MultiPointZM.to_list(multi_point), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiPointZM{points: points}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          new = Enum.into(list, %{}, fn {point, []} -> {point.coordinate, []} end)
          %MultiPointZM{points: %{points | map: Map.merge(points.map, Map.new(new))}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
