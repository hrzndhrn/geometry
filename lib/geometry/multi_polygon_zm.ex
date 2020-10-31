defmodule Geometry.MultiPolygonZM do
  @moduledoc """
  A set of polygons from type `Geometry.PolygonZM`

  `MultiPointZM` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPolygonZM.new([
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(11, 12, 13, 14),
      ...>         PointZM.new(11, 22, 23, 24),
      ...>         PointZM.new(31, 22, 33, 34),
      ...>         PointZM.new(11, 12, 13, 14)
      ...>       ]),
      ...>     ]),
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(35, 10, 13, 14),
      ...>         PointZM.new(45, 45, 23, 24),
      ...>         PointZM.new(10, 20, 33, 34),
      ...>         PointZM.new(35, 10, 13, 14)
      ...>       ]),
      ...>       LineStringZM.new([
      ...>         PointZM.new(20, 30, 13, 14),
      ...>         PointZM.new(35, 35, 23, 24),
      ...>         PointZM.new(30, 20, 33, 34),
      ...>         PointZM.new(20, 30, 13, 14)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   fn polygon -> length(polygon) == 1 end
      ...> )
      [true, false]

      iex> Enum.into(
      ...>   [
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(11, 12, 13, 14),
      ...>         PointZM.new(11, 22, 23, 24),
      ...>         PointZM.new(31, 22, 33, 34),
      ...>         PointZM.new(11, 12, 13, 14)
      ...>       ])
      ...>     ])
      ...>   ],
      ...>   MultiPolygonZM.new())
      %MultiPolygonZM{
        polygons:
          MapSet.new([
            [
              [
                [11, 12, 13, 14],
                [11, 22, 23, 24],
                [31, 22, 33, 34],
                [11, 12, 13, 14]
              ]
            ]
          ])
      }
  """

  alias Geometry.{GeoJson, MultiPolygonZM, PolygonZM, WKB, WKT}

  defstruct polygons: MapSet.new()

  @type t :: %MultiPolygonZM{polygons: MapSet.t([Geometry.coordinates()])}

  @doc """
  Creates an empty `MultiPolygonZM`.

  ## Examples

      iex> MultiPolygonZM.new()
      %MultiPolygonZM{polygons: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPolygonZM{}

  @doc """
  Creates a `MultiPolygonZM` from the given `Geometry.MultiPolygonZM`s.

  ## Examples

      iex> MultiPolygonZM.new([
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(6, 2, 3, 4),
      ...>       PointZM.new(8, 2, 4, 5),
      ...>       PointZM.new(8, 4, 5, 6),
      ...>       PointZM.new(6, 2, 3, 4)
      ...>     ]),
      ...>   ]),
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(1, 1, 3, 4),
      ...>       PointZM.new(9, 1, 4, 5),
      ...>       PointZM.new(9, 8, 5, 6),
      ...>       PointZM.new(1, 1, 3, 4)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(6, 2, 3, 4),
      ...>       PointZM.new(7, 2, 4, 5),
      ...>       PointZM.new(7, 3, 5, 6),
      ...>       PointZM.new(6, 2, 3, 4)
      ...>     ])
      ...>   ])
      ...> ])
      %MultiPolygonZM{
        polygons:
          MapSet.new([
            [
              [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
              [[6, 2, 3, 4], [7, 2, 4, 5], [7, 3, 5, 6], [6, 2, 3, 4]]
            ],
            [[[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]]]
          ])
      }

      iex> MultiPolygonZM.new([])
      %MultiPolygonZM{}
  """
  @spec new([PolygonZM.t()]) :: t()
  def new([]), do: %MultiPolygonZM{}

  def new(polygons),
    do: %MultiPolygonZM{
      polygons: Enum.into(polygons, MapSet.new(), fn polygon -> polygon.rings end)
    }

  @doc """
  Returns `true` if the given `MultiPolygonZM` is empty.

  ## Examples

      iex> MultiPolygonZM.empty?(MultiPolygonZM.new())
      true

      iex> MultiPolygonZM.empty?(
      ...>   MultiPolygonZM.new([
      ...>     PolygonZM.new([
      ...>         LineStringZM.new([
      ...>           PointZM.new(1, 1, 3, 4),
      ...>           PointZM.new(1, 5, 4, 8),
      ...>           PointZM.new(5, 4, 2, 6),
      ...>           PointZM.new(1, 1, 3, 4)
      ...>        ])
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPolygonZM{} = multi_polygon),
    do: Enum.empty?(multi_polygon.polygons)

  @doc """
  Creates a `MultiPolygonZM` from the given coordinates.

  ## Examples

      iex> MultiPolygonZM.from_coordinates([
      ...>   [
      ...>     [[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]]
      ...>   ], [
      ...>     [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
      ...>     [[6, 2, 4, 3], [7, 2, 6, 7], [7, 3, 3, 4], [6, 2, 4, 3]]
      ...>   ]
      ...> ])
      %MultiPolygonZM{
        polygons:
          MapSet.new([
            [
              [[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]],
            ], [
              [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
              [[6, 2, 4, 3], [7, 2, 6, 7], [7, 3, 3, 4], [6, 2, 4, 3]]
            ]
          ])
      }
  """
  @spec from_coordinates([[Geometry.coordinates()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiPolygonZM{
      polygons: MapSet.new(coordinates)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygonZM` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiPolygon",
      ...>     "coordinates": [
      ...>       [
      ...>         [[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]]
      ...>       ], [
      ...>         [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
      ...>         [[6, 2, 4, 3], [7, 2, 6, 7], [7, 3, 3, 4], [6, 2, 4, 3]]
      ...>       ]
      ...>     ]
      ...>   }
      ...> )
      ...> |> Jason.decode!()
      ...> |> MultiPolygonZM.from_geo_json()
      {:ok,
       %MultiPolygonZM{
         polygons:
           MapSet.new([
             [
               [[1, 1, 3, 4], [9, 1, 4, 5], [9, 8, 5, 6], [1, 1, 3, 4]],
               [[6, 2, 4, 3], [7, 2, 6, 7], [7, 3, 3, 4], [6, 2, 4, 3]]
             ], [
               [[6, 2, 3, 4], [8, 2, 4, 5], [8, 4, 5, 6], [6, 2, 3, 4]]
             ]
           ])
       }}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_polygon(json, MultiPolygonZM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_polygon(json, MultiPolygonZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiPolygonZM`.

  There are no guarantees about the order of polygons in the returned
  `coordinates`.

  ## Examples

  ```elixir
  MultiPolygonZM.to_list(
    MultiPolygonZM.new([
      PolygonZM.new([
        LineStringZM.new([
          PointZM.new(111, 112, 113, 114),
          PointZM.new(111, 122, 123, 124),
          PointZM.new(131, 122, 133, 134),
          PointZM.new(111, 112, 113, 114)
        ])
      ]),
      PolygonZM.new([
        LineStringZM.new([
          PointZM.new(211, 212, 213, 214),
          PointZM.new(211, 222, 223, 224),
          PointZM.new(231, 222, 233, 234),
          PointZM.new(211, 212, 213, 214)
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
  #         [11, 12, 13, 14],
  #         [11, 22, 23, 24],
  #         [31, 22, 33, 34],
  #         [11, 12, 13, 14]
  #       ]
  #     ], [
  #       [
  #         [21, 22, 23, 24],
  #         [21, 22, 23, 24],
  #         [21, 22, 23, 24],
  #         [21, 22, 23, 24]
  #       ]
  #     ]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPolygonZM{polygons: polygons}) do
    %{
      "type" => "MultiPolygon",
      "coordinates" => MapSet.to_list(polygons)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygonZM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPolygonZM.from_wkt("
      ...>   SRID=1234;MULTIPOLYGON ZM (
      ...>     (
      ...>        (40 40 10 20, 20 45 20 10, 45 30 15 30, 40 40 10 20)
      ...>     ), (
      ...>        (20 35 20 10, 10 30 10 20, 10 10 30 15, 30 5 10 15, 45 20 10 16, 20 35 20 10),
      ...>        (30 20 10 15, 20 15 20 10, 20 25 15 25, 30 20 10 15)
      ...>     )
      ...>   )
      ...> ")
      {:ok,
       %MultiPolygonZM{
         polygons:
           MapSet.new([
             [
               [
                 [20, 35, 20, 10],
                 [10, 30, 10, 20],
                 [10, 10, 30, 15],
                 [30, 5, 10, 15],
                 [45, 20, 10, 16],
                 [20, 35, 20, 10]
               ],
               [
                 [30, 20, 10, 15],
                 [20, 15, 20, 10],
                 [20, 25, 15, 25],
                 [30, 20, 10, 15]
               ]
             ],
             [
               [
                 [40, 40, 10, 20],
                 [20, 45, 20, 10],
                 [45, 30, 15, 30],
                 [40, 40, 10, 20]
               ]
             ]
           ])
       }, 1234}

      iex> MultiPolygonZM.from_wkt("MultiPolygon ZM EMPTY")
      {:ok, %MultiPolygonZM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPolygonZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPolygonZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiPolygonZM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of polygons in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiPolygonZM.to_wkt(
    MultiPolygonZM.new([
      PolygonZM.new([
        LineStrinZM.new([
          PointZM.new(20, 35, 20, 10),
          PointZM.new(10, 30, 10, 20),
          PointZM.new(10, 10, 30, 15),
          PointZM.new(30, 5, 10, 15),
          PointZM.new(45, 20, 10, 16),
          PointZM.new(20, 35, 20, 10)
        ]),
        LineStringZM.new([
          PointZM.new(30, 20, 10, 15),
          PointZM.new(20, 15, 20, 10),
          PointZM.new(20, 25, 15, 25),
          PointZM.new(30, 20, 10, 15)
        ])
      ]),
      PolygonZM.new([
        LineStringZM.new([
          PointZM.new(40, 40, 10, 20),
          PointZM.new(20, 45, 20, 10),
          PointZM.new(45, 30, 15, 30),
          PointZM.new(40, 40, 10, 20)
        ])
      ])
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # SRID=478;MultiPolygon ZM (
  #   (
  #     (20 35 20 10, 10 30 10 20, 10 10 30 15, 30 5 10 15, 45 20 10 16, 20 35 20 10),
  #     (30 20 10 15, 20 15 20 10, 20 25 15 25, 30 20 10 15)
  #   ), (
  #     (40 40 10 20, 20 45 20 10, 45 30 15 30, 40 40 10 20)
  #   )
  # )
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%MultiPolygonZM{polygons: polygons}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiPolygon ZM ",
        polygons |> MapSet.to_list() |> to_wkt_polygons()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiPolygonZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%MultiPolygonZM{} = multi_polygon, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_polygon, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygonZM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiPolygonZM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiPolygonZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiPolygonZM`.

  ## Examples

      iex> MultiPolygonZM.size(
      ...>   MultiPolygonZM.new([
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(11, 12, 13, 14),
      ...>         PointZM.new(11, 22, 23, 24),
      ...>         PointZM.new(31, 22, 33, 34),
      ...>         PointZM.new(11, 12, 13, 14)
      ...>       ])
      ...>     ])
      ...>   ])
      ...> )
      1
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiPolygonZM{polygons: polygons}), do: MapSet.size(polygons)

  @doc """
  Checks if `MultiPolygonZM` contains `point`.

  ## Examples

      iex> MultiPolygonZM.member?(
      ...>   MultiPolygonZM.new([
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(11, 12, 13, 14),
      ...>         PointZM.new(11, 22, 23, 24),
      ...>         PointZM.new(31, 22, 33, 34),
      ...>         PointZM.new(11, 12, 13, 14)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(11, 12, 13, 14),
      ...>       PointZM.new(11, 22, 23, 24),
      ...>       PointZM.new(31, 22, 33, 34),
      ...>       PointZM.new(11, 12, 13, 14)
      ...>     ])
      ...>   ])
      ...> )
      true

      iex> MultiPolygonZM.member?(
      ...>   MultiPolygonZM.new([
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(11, 12, 13, 14),
      ...>         PointZM.new(11, 22, 23, 24),
      ...>         PointZM.new(31, 22, 33, 34),
      ...>         PointZM.new(11, 12, 13, 14)
      ...>       ])
      ...>     ])
      ...>   ]),
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(11, 12, 13, 14),
      ...>       PointZM.new(11, 22, 23, 24),
      ...>       PointZM.new(33, 22, 33, 34),
      ...>       PointZM.new(11, 12, 13, 14)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec member?(t(), PolygonZM.t()) :: boolean()
  def member?(%MultiPolygonZM{polygons: polygons}, %PolygonZM{rings: rings}),
    do: MapSet.member?(polygons, rings)

  @doc """
  Converts `MultiPolygonZM` to a list.

  ## Examples

      iex> MultiPolygonZM.to_list(
      ...>   MultiPolygonZM.new([
      ...>     PolygonZM.new([
      ...>       LineStringZM.new([
      ...>         PointZM.new(11, 12, 13, 14),
      ...>         PointZM.new(11, 22, 23, 24),
      ...>         PointZM.new(31, 22, 33, 34),
      ...>         PointZM.new(11, 12, 13, 14)
      ...>       ])
      ...>     ])
      ...>   ])
      ...> )
      [
        [
          [
            [11, 12, 13, 14],
            [11, 22, 23, 24],
            [31, 22, 33, 34],
            [11, 12, 13, 14]
          ]
        ]
      ]
  """
  @spec to_list(t()) :: [PolygonZM.t()]
  def to_list(%MultiPolygonZM{polygons: polygons}), do: MapSet.to_list(polygons)

  @compile {:inline, to_wkt_polygons: 1}
  defp to_wkt_polygons([]), do: "EMPTY"

  defp to_wkt_polygons([polygon | polygons]) do
    <<"(",
      Enum.reduce(polygons, PolygonZM.to_wkt_rings(polygon), fn polygon, acc ->
        <<acc::binary(), ", ", PolygonZM.to_wkt_rings(polygon)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(t(), srid, endian, mode) :: wkb
        when srid: Geometry.srid() | nil,
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb(%MultiPolygonZM{polygons: polygons}, srid, endian, mode) do
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
      <<acc::binary(), PolygonZM.to_wkb(polygon, nil, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000006"
      {:ndr, false} -> "060000C0"
      {:xdr, true} -> "E0000006"
      {:ndr, true} -> "060000E0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0xC0000006::big-integer-size(32)>>
      {:ndr, false} -> <<0xC0000006::little-integer-size(32)>>
      {:xdr, true} -> <<0xE0000006::big-integer-size(32)>>
      {:ndr, true} -> <<0xE0000006::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_polygon) do
      {:ok, MultiPolygonZM.size(multi_polygon)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_polygon, val) do
      {:ok, MultiPolygonZM.member?(multi_polygon, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_polygon) do
      size = MultiPolygonZM.size(multi_polygon)
      {:ok, size, &Enumerable.List.slice(MultiPolygonZM.to_list(multi_polygon), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_polygon, acc, fun) do
      Enumerable.List.reduce(MultiPolygonZM.to_list(multi_polygon), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiPolygonZM{polygons: polygons}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          map =
            Map.merge(
              polygons.map,
              Enum.into(list, %{}, fn {polygon, []} -> {polygon.rings, []} end)
            )

          %MultiPolygonZM{polygons: %{polygons | map: map}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
