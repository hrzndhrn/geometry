defmodule Geometry.MultiPolygonM do
  @moduledoc """
  A set of polygons from type `Geometry.PolygonM`

  `MultiPointM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPolygonM.new([
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(11, 12, 14),
      ...>         PointM.new(11, 22, 24),
      ...>         PointM.new(31, 22, 34),
      ...>         PointM.new(11, 12, 14)
      ...>       ]),
      ...>     ]),
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(35, 10, 14),
      ...>         PointM.new(45, 45, 24),
      ...>         PointM.new(10, 20, 34),
      ...>         PointM.new(35, 10, 14)
      ...>       ]),
      ...>       LineStringM.new([
      ...>         PointM.new(20, 30, 14),
      ...>         PointM.new(35, 35, 24),
      ...>         PointM.new(30, 20, 34),
      ...>         PointM.new(20, 30, 14)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   fn polygon -> length(polygon) == 1 end
      ...> )
      [true, false]

      iex> Enum.into(
      ...>   [
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(11, 12, 14),
      ...>         PointM.new(11, 22, 24),
      ...>         PointM.new(31, 22, 34),
      ...>         PointM.new(11, 12, 14)
      ...>       ])
      ...>     ])
      ...>   ],
      ...>   MultiPolygonM.new())
      %MultiPolygonM{
        polygons:
          MapSet.new([
            [
              [
                [11, 12, 14],
                [11, 22, 24],
                [31, 22, 34],
                [11, 12, 14]
              ]
            ]
          ])
      }
  """

  alias Geometry.{GeoJson, MultiPolygonM, PolygonM, WKB, WKT}

  defstruct polygons: MapSet.new()

  @type t :: %MultiPolygonM{polygons: MapSet.t([Geometry.coordinates()])}

  @doc """
  Creates an empty `MultiPolygonM`.

  ## Examples

      iex> MultiPolygonM.new()
      %MultiPolygonM{polygons: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPolygonM{}

  @doc """
  Creates a `MultiPolygonM` from the given `Geometry.MultiPolygonM`s.

  ## Examples

      iex> MultiPolygonM.new([
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(6, 2, 4),
      ...>       PointM.new(8, 2, 5),
      ...>       PointM.new(8, 4, 6),
      ...>       PointM.new(6, 2, 4)
      ...>     ]),
      ...>   ]),
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(1, 1, 4),
      ...>       PointM.new(9, 1, 5),
      ...>       PointM.new(9, 8, 6),
      ...>       PointM.new(1, 1, 4)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(6, 2, 4),
      ...>       PointM.new(7, 2, 5),
      ...>       PointM.new(7, 3, 6),
      ...>       PointM.new(6, 2, 4)
      ...>     ])
      ...>   ])
      ...> ])
      %MultiPolygonM{
        polygons:
          MapSet.new([
            [
              [[1, 1, 4], [9, 1, 5], [9, 8, 6], [1, 1, 4]],
              [[6, 2, 4], [7, 2, 5], [7, 3, 6], [6, 2, 4]]
            ],
            [[[6, 2, 4], [8, 2, 5], [8, 4, 6], [6, 2, 4]]]
          ])
      }

      iex> MultiPolygonM.new([])
      %MultiPolygonM{}
  """
  @spec new([PolygonM.t()]) :: t()
  def new([]), do: %MultiPolygonM{}

  def new(polygons),
    do: %MultiPolygonM{
      polygons: Enum.into(polygons, MapSet.new(), fn polygon -> polygon.rings end)
    }

  @doc """
  Returns `true` if the given `MultiPolygonM` is empty.

  ## Examples

      iex> MultiPolygonM.empty?(MultiPolygonM.new())
      true

      iex> MultiPolygonM.empty?(
      ...>   MultiPolygonM.new([
      ...>     PolygonM.new([
      ...>         LineStringM.new([
      ...>           PointM.new(1, 1, 4),
      ...>           PointM.new(1, 5, 8),
      ...>           PointM.new(5, 4, 6),
      ...>           PointM.new(1, 1, 4)
      ...>        ])
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPolygonM{} = multi_polygon),
    do: Enum.empty?(multi_polygon.polygons)

  @doc """
  Creates a `MultiPolygonM` from the given coordinates.

  ## Examples

      iex> MultiPolygonM.from_coordinates([
      ...>   [
      ...>     [[6, 2, 4], [8, 2, 5], [8, 4, 6], [6, 2, 4]]
      ...>   ], [
      ...>     [[1, 1, 4], [9, 1, 5], [9, 8, 6], [1, 1, 4]],
      ...>     [[6, 2, 3], [7, 2, 7], [7, 3, 4], [6, 2, 3]]
      ...>   ]
      ...> ])
      %MultiPolygonM{
        polygons:
          MapSet.new([
            [
              [[6, 2, 4], [8, 2, 5], [8, 4, 6], [6, 2, 4]],
            ], [
              [[1, 1, 4], [9, 1, 5], [9, 8, 6], [1, 1, 4]],
              [[6, 2, 3], [7, 2, 7], [7, 3, 4], [6, 2, 3]]
            ]
          ])
      }
  """
  @spec from_coordinates([[Geometry.coordinates()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiPolygonM{
      polygons: MapSet.new(coordinates)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygonM` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiPolygon",
      ...>     "coordinates": [
      ...>       [
      ...>         [[6, 2, 4], [8, 2, 5], [8, 4, 6], [6, 2, 4]]
      ...>       ], [
      ...>         [[1, 1, 4], [9, 1, 5], [9, 8, 6], [1, 1, 4]],
      ...>         [[6, 2, 3], [7, 2, 7], [7, 3, 4], [6, 2, 3]]
      ...>       ]
      ...>     ]
      ...>   }
      ...> )
      ...> |> Jason.decode!()
      ...> |> MultiPolygonM.from_geo_json()
      {:ok,
       %MultiPolygonM{
         polygons:
           MapSet.new([
             [
               [[1, 1, 4], [9, 1, 5], [9, 8, 6], [1, 1, 4]],
               [[6, 2, 3], [7, 2, 7], [7, 3, 4], [6, 2, 3]]
             ], [
               [[6, 2, 4], [8, 2, 5], [8, 4, 6], [6, 2, 4]]
             ]
           ])
       }}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_polygon(json, MultiPolygonM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_polygon(json, MultiPolygonM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiPolygonM`.

  There are no guarantees about the order of polygons in the returned
  `coordinates`.

  ## Examples

  ```elixir
  MultiPolygonM.to_list(
    MultiPolygonM.new([
      PolygonM.new([
        LineStringM.new([
          PointM.new(111, 112, 114),
          PointM.new(111, 122, 124),
          PointM.new(131, 122, 134),
          PointM.new(111, 112, 114)
        ])
      ]),
      PolygonM.new([
        LineStringM.new([
          PointM.new(211, 212, 214),
          PointM.new(211, 222, 224),
          PointM.new(231, 222, 234),
          PointM.new(211, 212, 214)
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
  #         [11, 12, 14],
  #         [11, 22, 24],
  #         [31, 22, 34],
  #         [11, 12, 14]
  #       ]
  #     ], [
  #       [
  #         [21, 22, 24],
  #         [21, 22, 24],
  #         [21, 22, 24],
  #         [21, 22, 24]
  #       ]
  #     ]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPolygonM{polygons: polygons}) do
    %{
      "type" => "MultiPolygon",
      "coordinates" => MapSet.to_list(polygons)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygonM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPolygonM.from_wkt("
      ...>   SRID=1234;MULTIPOLYGON M (
      ...>     (
      ...>        (40 40 20, 20 45 10, 45 30 30, 40 40 20)
      ...>     ), (
      ...>        (20 35 10, 10 30 20, 10 10 15, 30 5 15, 45 20 16, 20 35 10),
      ...>        (30 20 15, 20 15 10, 20 25 25, 30 20 15)
      ...>     )
      ...>   )
      ...> ")
      {:ok, {
        %MultiPolygonM{
          polygons:
            MapSet.new([
              [
                [
                  [20, 35, 10],
                  [10, 30, 20],
                  [10, 10, 15],
                  [30, 5, 15],
                  [45, 20, 16],
                  [20, 35, 10]
                ],
                [
                  [30, 20, 15],
                  [20, 15, 10],
                  [20, 25, 25],
                  [30, 20, 15]
                ]
              ],
              [
                [
                  [40, 40, 20],
                  [20, 45, 10],
                  [45, 30, 30],
                  [40, 40, 20]
                ]
              ]
            ])
        },
        1234
      }}

      iex> MultiPolygonM.from_wkt("MultiPolygon M EMPTY")
      {:ok, %MultiPolygonM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPolygonM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPolygonM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiPolygonM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of polygons in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiPolygonM.to_wkt(
    MultiPolygonM.new([
      PolygonM.new([
        LineStrinZM.new([
          PointM.new(20, 35, 10),
          PointM.new(10, 30, 20),
          PointM.new(10, 10, 15),
          PointM.new(30, 5, 15),
          PointM.new(45, 20, 16),
          PointM.new(20, 35, 10)
        ]),
        LineStringM.new([
          PointM.new(30, 20, 15),
          PointM.new(20, 15, 10),
          PointM.new(20, 25, 25),
          PointM.new(30, 20, 15)
        ])
      ]),
      PolygonM.new([
        LineStringM.new([
          PointM.new(40, 40, 20),
          PointM.new(20, 45, 10),
          PointM.new(45, 30, 30),
          PointM.new(40, 40, 20)
        ])
      ])
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # SRID=478;MultiPolygon M (
  #   (
  #     (20 35 10, 10 30 20, 10 10 15, 30 5 15, 45 20 16, 20 35 10),
  #     (30 20 15, 20 15 10, 20 25 25, 30 20 15)
  #   ), (
  #     (40 40 20, 20 45 10, 45 30 30, 40 40 20)
  #   )
  # )
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%MultiPolygonM{polygons: polygons}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiPolygon M ",
        polygons |> MapSet.to_list() |> to_wkt_polygons()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiPolygonM`.

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
  def to_wkb(%MultiPolygonM{} = multi_polygon, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_polygon, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygonM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, MultiPolygonM)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, MultiPolygonM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiPolygonM`.

  ## Examples

      iex> MultiPolygonM.size(
      ...>   MultiPolygonM.new([
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(11, 12, 14),
      ...>         PointM.new(11, 22, 24),
      ...>         PointM.new(31, 22, 34),
      ...>         PointM.new(11, 12, 14)
      ...>       ])
      ...>     ])
      ...>   ])
      ...> )
      1
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiPolygonM{polygons: polygons}), do: MapSet.size(polygons)

  @doc """
  Checks if `MultiPolygonM` contains `point`.

  ## Examples

      iex> MultiPolygonM.member?(
      ...>   MultiPolygonM.new([
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(11, 12, 14),
      ...>         PointM.new(11, 22, 24),
      ...>         PointM.new(31, 22, 34),
      ...>         PointM.new(11, 12, 14)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(11, 12, 14),
      ...>       PointM.new(11, 22, 24),
      ...>       PointM.new(31, 22, 34),
      ...>       PointM.new(11, 12, 14)
      ...>     ])
      ...>   ])
      ...> )
      true

      iex> MultiPolygonM.member?(
      ...>   MultiPolygonM.new([
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(11, 12, 14),
      ...>         PointM.new(11, 22, 24),
      ...>         PointM.new(31, 22, 34),
      ...>         PointM.new(11, 12, 14)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(11, 12, 14),
      ...>       PointM.new(11, 22, 24),
      ...>       PointM.new(33, 22, 34),
      ...>       PointM.new(11, 12, 14)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec member?(t(), PolygonM.t()) :: boolean()
  def member?(%MultiPolygonM{polygons: polygons}, %PolygonM{rings: rings}),
    do: MapSet.member?(polygons, rings)

  @doc """
  Converts `MultiPolygonM` to a list.

  ## Examples

      iex> MultiPolygonM.to_list(
      ...>   MultiPolygonM.new([
      ...>     PolygonM.new([
      ...>       LineStringM.new([
      ...>         PointM.new(11, 12, 14),
      ...>         PointM.new(11, 22, 24),
      ...>         PointM.new(31, 22, 34),
      ...>         PointM.new(11, 12, 14)
      ...>       ])
      ...>     ])
      ...>   ])
      ...> )
      [
        [
          [
            [11, 12, 14],
            [11, 22, 24],
            [31, 22, 34],
            [11, 12, 14]
          ]
        ]
      ]
  """
  @spec to_list(t()) :: [PolygonM.t()]
  def to_list(%MultiPolygonM{polygons: polygons}), do: MapSet.to_list(polygons)

  @compile {:inline, to_wkt_polygons: 1}
  defp to_wkt_polygons([]), do: "EMPTY"

  defp to_wkt_polygons([polygon | polygons]) do
    <<"(",
      Enum.reduce(polygons, PolygonM.to_wkt_rings(polygon), fn polygon, acc ->
        <<acc::binary(), ", ", PolygonM.to_wkt_rings(polygon)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(t(), srid, endian, mode) :: wkb
        when srid: Geometry.srid() | nil,
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb(%MultiPolygonM{polygons: polygons}, srid, endian, mode) do
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
      <<acc::binary(), PolygonM.to_wkb(polygon, nil, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "40000006"
      {:ndr, false} -> "06000040"
      {:xdr, true} -> "60000006"
      {:ndr, true} -> "06000060"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x40000006::big-integer-size(32)>>
      {:ndr, false} -> <<0x40000006::little-integer-size(32)>>
      {:xdr, true} -> <<0x60000006::big-integer-size(32)>>
      {:ndr, true} -> <<0x60000006::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_polygon) do
      {:ok, MultiPolygonM.size(multi_polygon)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_polygon, val) do
      {:ok, MultiPolygonM.member?(multi_polygon, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_polygon) do
      size = MultiPolygonM.size(multi_polygon)
      {:ok, size, &Enumerable.List.slice(MultiPolygonM.to_list(multi_polygon), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_polygon, acc, fun) do
      Enumerable.List.reduce(MultiPolygonM.to_list(multi_polygon), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiPolygonM{polygons: polygons}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          map =
            Map.merge(
              polygons.map,
              Enum.into(list, %{}, fn {polygon, []} -> {polygon.rings, []} end)
            )

          %MultiPolygonM{polygons: %{polygons | map: map}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
