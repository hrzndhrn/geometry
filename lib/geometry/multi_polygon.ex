defmodule Geometry.MultiPolygon do
  @moduledoc """
  A set of polygons from type `Geometry.Polygon`

  `MultiPoint` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(11, 12),
      ...>         Point.new(11, 22),
      ...>         Point.new(31, 22),
      ...>         Point.new(11, 12)
      ...>       ]),
      ...>     ]),
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(35, 10),
      ...>         Point.new(45, 45),
      ...>         Point.new(10, 20),
      ...>         Point.new(35, 10)
      ...>       ]),
      ...>       LineString.new([
      ...>         Point.new(20, 30),
      ...>         Point.new(35, 35),
      ...>         Point.new(30, 20),
      ...>         Point.new(20, 30)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   fn polygon -> length(polygon) == 1 end
      ...> )
      [true, false]

      iex> Enum.into(
      ...>   [
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(11, 12),
      ...>         Point.new(11, 22),
      ...>         Point.new(31, 22),
      ...>         Point.new(11, 12)
      ...>       ])
      ...>     ])
      ...>   ],
      ...>   MultiPolygon.new())
      %MultiPolygon{
        polygons:
          MapSet.new([
            [
              [
                [11, 12],
                [11, 22],
                [31, 22],
                [11, 12]
              ]
            ]
          ])
      }
  """

  alias Geometry.{GeoJson, MultiPolygon, Polygon, WKB, WKT}

  defstruct polygons: MapSet.new()

  @type t :: %MultiPolygon{polygons: MapSet.t([Geometry.coordinates()])}

  @doc """
  Creates an empty `MultiPolygon`.

  ## Examples

      iex> MultiPolygon.new()
      %MultiPolygon{polygons: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPolygon{}

  @doc """
  Creates a `MultiPolygon` from the given `Geometry.MultiPolygon`s.

  ## Examples

      iex> MultiPolygon.new([
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(6, 2),
      ...>       Point.new(8, 2),
      ...>       Point.new(8, 4),
      ...>       Point.new(6, 2)
      ...>     ]),
      ...>   ]),
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(1, 1),
      ...>       Point.new(9, 1),
      ...>       Point.new(9, 8),
      ...>       Point.new(1, 1)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(6, 2),
      ...>       Point.new(7, 2),
      ...>       Point.new(7, 3),
      ...>       Point.new(6, 2)
      ...>     ])
      ...>   ])
      ...> ])
      %MultiPolygon{
        polygons:
          MapSet.new([
            [
              [[1, 1], [9, 1], [9, 8], [1, 1]],
              [[6, 2], [7, 2], [7, 3], [6, 2]]
            ],
            [[[6, 2], [8, 2], [8, 4], [6, 2]]]
          ])
      }

      iex> MultiPolygon.new([])
      %MultiPolygon{}
  """
  @spec new([Polygon.t()]) :: t()
  def new([]), do: %MultiPolygon{}

  def new(polygons),
    do: %MultiPolygon{
      polygons: Enum.into(polygons, MapSet.new(), fn polygon -> polygon.rings end)
    }

  @doc """
  Returns `true` if the given `MultiPolygon` is empty.

  ## Examples

      iex> MultiPolygon.empty?(MultiPolygon.new())
      true

      iex> MultiPolygon.empty?(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>         LineString.new([
      ...>           Point.new(1, 1),
      ...>           Point.new(1, 5),
      ...>           Point.new(5, 4),
      ...>           Point.new(1, 1)
      ...>        ])
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPolygon{} = multi_polygon),
    do: Enum.empty?(multi_polygon.polygons)

  @doc """
  Creates a `MultiPolygon` from the given coordinates.

  ## Examples

      iex> MultiPolygon.from_coordinates([
      ...>   [
      ...>     [[6, 2], [8, 2], [8, 4], [6, 2]]
      ...>   ], [
      ...>     [[1, 1], [9, 1], [9, 8], [1, 1]],
      ...>     [[6, 2], [7, 2], [7, 3], [6, 2]]
      ...>   ]
      ...> ])
      %MultiPolygon{
        polygons:
          MapSet.new([
            [
              [[6, 2], [8, 2], [8, 4], [6, 2]],
            ], [
              [[1, 1], [9, 1], [9, 8], [1, 1]],
              [[6, 2], [7, 2], [7, 3], [6, 2]]
            ]
          ])
      }
  """
  @spec from_coordinates([[Geometry.coordinates()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiPolygon{
      polygons: MapSet.new(coordinates)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygon` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiPolygon",
      ...>     "coordinates": [
      ...>       [
      ...>         [[6, 2], [8, 2], [8, 4], [6, 2]]
      ...>       ], [
      ...>         [[1, 1], [9, 1], [9, 8], [1, 1]],
      ...>         [[6, 2], [7, 2], [7, 3], [6, 2]]
      ...>       ]
      ...>     ]
      ...>   }
      ...> )
      ...> |> Jason.decode!()
      ...> |> MultiPolygon.from_geo_json()
      {:ok,
       %MultiPolygon{
         polygons:
           MapSet.new([
             [
               [[1, 1], [9, 1], [9, 8], [1, 1]],
               [[6, 2], [7, 2], [7, 3], [6, 2]]
             ], [
               [[6, 2], [8, 2], [8, 4], [6, 2]]
             ]
           ])
       }}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_polygon(json, MultiPolygon)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_polygon(json, MultiPolygon) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiPolygon`.

  There are no guarantees about the order of polygons in the returned
  `coordinates`.

  ## Examples

  ```elixir
  MultiPolygon.to_list(
    MultiPolygon.new([
      Polygon.new([
        LineString.new([
          Point.new(111, 112),
          Point.new(111, 122),
          Point.new(131, 122),
          Point.new(111, 112)
        ])
      ]),
      Polygon.new([
        LineString.new([
          Point.new(211, 212),
          Point.new(211, 222),
          Point.new(231, 222),
          Point.new(211, 212)
        ])
      ])
    ])
  )
  # =>
  # %{
  #   "type" => "MultiPolygon",
  #   "coordinates" => [
  #     [
  #       [
  #         [11, 12],
  #         [11, 22],
  #         [31, 22],
  #         [11, 12]
  #       ]
  #     ], [
  #       [
  #         [21, 22],
  #         [21, 22],
  #         [21, 22],
  #         [21, 22]
  #       ]
  #     ]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPolygon{polygons: polygons}) do
    %{
      "type" => "MultiPolygon",
      "coordinates" => MapSet.to_list(polygons)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygon` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPolygon.from_wkt("
      ...>   SRID=1234;MULTIPOLYGON (
      ...>     (
      ...>        (40 40, 20 45, 45 30, 40 40)
      ...>     ), (
      ...>        (20 35, 10 30, 10 10, 30 5, 45 20, 20 35),
      ...>        (30 20, 20 15, 20 25, 30 20)
      ...>     )
      ...>   )
      ...> ")
      {:ok, {
        %MultiPolygon{
          polygons:
            MapSet.new([
              [
                [
                  [20, 35],
                  [10, 30],
                  [10, 10],
                  [30, 5],
                  [45, 20],
                  [20, 35]
                ],
                [
                  [30, 20],
                  [20, 15],
                  [20, 25],
                  [30, 20]
                ]
              ],
              [
                [
                  [40, 40],
                  [20, 45],
                  [45, 30],
                  [40, 40]
                ]
              ]
            ])
        },
        1234
      }}

      iex> MultiPolygon.from_wkt("MultiPolygon EMPTY")
      {:ok, %MultiPolygon{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPolygon)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPolygon) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiPolygon`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of polygons in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiPolygon.to_wkt(
    MultiPolygon.new([
      Polygon.new([
        LineStrinZM.new([
          Point.new(20, 35),
          Point.new(10, 30),
          Point.new(10, 10),
          Point.new(30, 5),
          Point.new(45, 20),
          Point.new(20, 35)
        ]),
        LineString.new([
          Point.new(30, 20),
          Point.new(20, 15),
          Point.new(20, 25),
          Point.new(30, 20)
        ])
      ]),
      Polygon.new([
        LineString.new([
          Point.new(40, 40),
          Point.new(20, 45),
          Point.new(45, 30),
          Point.new(40, 40)
        ])
      ])
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # SRID=478;MultiPolygon (
  #   (
  #     (20 35, 10 30, 10 10, 30 5, 45 20, 20 35),
  #     (30 20, 20 15, 20 25, 30 20)
  #   ), (
  #     (40 40, 20 45, 45 30, 40 40)
  #   )
  # )
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%MultiPolygon{polygons: polygons}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiPolygon ",
        polygons |> MapSet.to_list() |> to_wkt_polygons()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiPolygon`.

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
  def to_wkb(%MultiPolygon{} = multi_polygon, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_polygon, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygon` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, MultiPolygon)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, MultiPolygon) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiPolygon`.

  ## Examples

      iex> MultiPolygon.size(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(11, 12),
      ...>         Point.new(11, 22),
      ...>         Point.new(31, 22),
      ...>         Point.new(11, 12)
      ...>       ])
      ...>     ])
      ...>   ])
      ...> )
      1
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiPolygon{polygons: polygons}), do: MapSet.size(polygons)

  @doc """
  Checks if `MultiPolygon` contains `point`.

  ## Examples

      iex> MultiPolygon.member?(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(11, 12),
      ...>         Point.new(11, 22),
      ...>         Point.new(31, 22),
      ...>         Point.new(11, 12)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(11, 22),
      ...>       Point.new(31, 22),
      ...>       Point.new(11, 12)
      ...>     ])
      ...>   ])
      ...> )
      true

      iex> MultiPolygon.member?(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(11, 12),
      ...>         Point.new(11, 22),
      ...>         Point.new(31, 22),
      ...>         Point.new(11, 12)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(11, 22),
      ...>       Point.new(33, 22),
      ...>       Point.new(11, 12)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec member?(t(), Polygon.t()) :: boolean()
  def member?(%MultiPolygon{polygons: polygons}, %Polygon{rings: rings}),
    do: MapSet.member?(polygons, rings)

  @doc """
  Converts `MultiPolygon` to a list.

  ## Examples

      iex> MultiPolygon.to_list(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       LineString.new([
      ...>         Point.new(11, 12),
      ...>         Point.new(11, 22),
      ...>         Point.new(31, 22),
      ...>         Point.new(11, 12)
      ...>       ])
      ...>     ])
      ...>   ])
      ...> )
      [
        [
          [
            [11, 12],
            [11, 22],
            [31, 22],
            [11, 12]
          ]
        ]
      ]
  """
  @spec to_list(t()) :: [Polygon.t()]
  def to_list(%MultiPolygon{polygons: polygons}), do: MapSet.to_list(polygons)

  @compile {:inline, to_wkt_polygons: 1}
  defp to_wkt_polygons([]), do: "EMPTY"

  defp to_wkt_polygons([polygon | polygons]) do
    <<"(",
      Enum.reduce(polygons, Polygon.to_wkt_rings(polygon), fn polygon, acc ->
        <<acc::binary(), ", ", Polygon.to_wkt_rings(polygon)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(t(), srid, endian, mode) :: wkb
        when srid: Geometry.srid() | nil,
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb(%MultiPolygon{polygons: polygons}, srid, endian, mode) do
    <<
      WKB.byte_order(endian, mode)::binary(),
      wkb_code(endian, not is_nil(srid), mode)::binary(),
      WKB.srid(srid, endian, mode)::binary(),
      to_wkb_polygons(MapSet.to_list(polygons), endian, mode)::binary()
    >>
  end

  @compile {:inline, to_wkb_polygons: 3}
  defp to_wkb_polygons(polygons, endian, mode) do
    Enum.reduce(polygons, WKB.length(polygons, endian, mode), fn polygon, acc ->
      <<acc::binary(), Polygon.to_wkb(polygon, nil, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "00000006"
      {:ndr, false} -> "06000000"
      {:xdr, true} -> "20000006"
      {:ndr, true} -> "06000020"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x00000006::big-integer-size(32)>>
      {:ndr, false} -> <<0x00000006::little-integer-size(32)>>
      {:xdr, true} -> <<0x20000006::big-integer-size(32)>>
      {:ndr, true} -> <<0x20000006::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_polygon) do
      {:ok, MultiPolygon.size(multi_polygon)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_polygon, val) do
      {:ok, MultiPolygon.member?(multi_polygon, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_polygon) do
      size = MultiPolygon.size(multi_polygon)
      {:ok, size, &Enumerable.List.slice(MultiPolygon.to_list(multi_polygon), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_polygon, acc, fun) do
      Enumerable.List.reduce(MultiPolygon.to_list(multi_polygon), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiPolygon{polygons: polygons}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          map =
            Map.merge(
              polygons.map,
              Enum.into(list, %{}, fn {polygon, []} -> {polygon.rings, []} end)
            )

          %MultiPolygon{polygons: %{polygons | map: map}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
