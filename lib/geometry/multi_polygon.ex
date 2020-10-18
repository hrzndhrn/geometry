defmodule Geometry.MultiPolygon do
  @moduledoc """
  A set of polygons from type `Geometry.Polygon`

  `MultiPoint` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(11, 22),
      ...>       Point.new(31, 22),
      ...>       Point.new(11, 12)
      ...>     ]),
      ...>     Polygon.new([
      ...>       Point.new(35, 10),
      ...>       Point.new(45, 45),
      ...>       Point.new(10, 20),
      ...>       Point.new(35, 10)
      ...>     ], [
      ...>       [
      ...>         Point.new(20, 30),
      ...>         Point.new(35, 35),
      ...>         Point.new(30, 20),
      ...>         Point.new(20, 30)
      ...>       ]
      ...>     ])
      ...>   ]),
      ...>   fn polygon -> Enum.empty?(polygon.interiors) end
      ...> )
      [true, false]

      iex> Enum.into(
      ...>   [
      ...>     Polygon.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(11, 22),
      ...>       Point.new(31, 22),
      ...>       Point.new(11, 12)
      ...>     ]),
      ...>   ],
      ...>   MultiPolygon.new())
      %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 11, y: 12},
                %Point{x: 11, y: 22},
                %Point{x: 31, y: 22},
                %Point{x: 11, y: 12}
              ],
              interiors: []
            }
          ])
      }
  """

  alias Geometry.{GeoJson, MultiPolygon, Point, Polygon, WKB, WKT}

  defstruct polygons: MapSet.new()

  @type t :: %MultiPolygon{polygons: MapSet.t(Polygon.t())}

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
      ...>     Point.new(6, 2),
      ...>     Point.new(8, 2),
      ...>     Point.new(8, 4),
      ...>     Point.new(6, 2)
      ...>   ]),
      ...>   Polygon.new([
      ...>     Point.new(1, 1),
      ...>     Point.new(9, 1),
      ...>     Point.new(9, 8),
      ...>     Point.new(1, 1)
      ...>   ], [[
      ...>     Point.new(6, 2),
      ...>     Point.new(7, 2),
      ...>     Point.new(7, 3),
      ...>     Point.new(6, 2)
      ...>   ]])
      ...> ])
      %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 1, y: 1},
                %Point{x: 9, y: 1},
                %Point{x: 9, y: 8},
                %Point{x: 1, y: 1}
              ],
              interiors: [
                [
                  %Point{x: 6, y: 2},
                  %Point{x: 7, y: 2},
                  %Point{x: 7, y: 3},
                  %Point{x: 6, y: 2}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 6, y: 2},
                %Point{x: 8, y: 2},
                %Point{x: 8, y: 4},
                %Point{x: 6, y: 2}
              ],
              interiors: []
            }
          ])
      }

      iex> MultiPolygon.new([])
      %MultiPolygon{}
  """
  @spec new([Polygon.t()]) :: t()
  def new([]), do: %MultiPolygon{}
  def new(polygon), do: %MultiPolygon{polygons: MapSet.new(polygon)}

  @doc """
  Returns `true` if the given `MultiPolygon` is empty.

  ## Examples

      iex> MultiPolygon.empty?(MultiPolygon.new())
      true

      iex> MultiPolygon.empty?(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>         Point.new(1, 1),
      ...>         Point.new(1, 5),
      ...>         Point.new(5, 4),
      ...>         Point.new(1, 1)
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
      ...>     {6, 2}, {8, 2}, {8, 4}, {6, 2}
      ...>   ], [
      ...>     [{1, 1}, {9, 1}, {9, 8}, {1, 1}],
      ...>     [{6, 2}, {7, 2}, {7, 3}, {6, 2}]
      ...>   ]
      ...> ])
      %MultiPolygon{
        polygons:
          MapSet.new([
            %Polygon{
              exterior: [
                %Point{x: 1, y: 1},
                %Point{x: 9, y: 1},
                %Point{x: 9, y: 8},
                %Point{x: 1, y: 1}
              ],
              interiors: [
                [
                  %Point{x: 6, y: 2},
                  %Point{x: 7, y: 2},
                  %Point{x: 7, y: 3},
                  %Point{x: 6, y: 2}
                ]
              ]
            },
            %Polygon{
              exterior: [
                %Point{x: 6, y: 2},
                %Point{x: 8, y: 2},
                %Point{x: 8, y: 4},
                %Point{x: 6, y: 2}
              ],
              interiors: []
            }
          ])
      }
  """
  @spec from_coordinates([[Geometry.coordinate()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiPolygon{
      polygons: coordinates |> Enum.map(&Polygon.from_coordinates/1) |> MapSet.new()
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
      {
        :ok,
        %MultiPolygon{
          polygons:
            MapSet.new([
              %Polygon{
                exterior: [
                  %Point{x: 1, y: 1},
                  %Point{x: 9, y: 1},
                  %Point{x: 9, y: 8},
                  %Point{x: 1, y: 1}
                ],
                interiors: [
                  [
                    %Point{x: 6, y: 2},
                    %Point{x: 7, y: 2},
                    %Point{x: 7, y: 3},
                    %Point{x: 6, y: 2}
                  ]
                ]
              },
              %Polygon{
                exterior: [
                  %Point{x: 6, y: 2},
                  %Point{x: 8, y: 2},
                  %Point{x: 8, y: 4},
                  %Point{x: 6, y: 2}
                ],
                interiors: []
              }
            ])
        }
      }
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
  [
    [
      {6, 2}, {8, 2}, {8, 4}, {6, 2}
    ], [
      [{1, 1}, {9, 1}, {9, 8}, {1, 1}],
      [{6, 2}, {7, 2}, {7, 3}, {6, 2}]
    ]
  ]
  |> MultiPolygon.from_coordinates()
  |> MultiPolygon.to_geo_json()
  # =>
  # %{
  #   "type" => "MultiPolygon",
  #   "coordinates" => [
  #     [[-1, 1], [2, 2], [-3, 3]],
  #     [[-10, 10], [-20, 20]]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPolygon{polygons: polygons}) do
    %{
      "type" => "MultiPolygon",
      "coordinates" =>
        Enum.map(polygons, fn %Polygon{exterior: exterior, interiors: interiors} ->
          [
            Enum.map(exterior, &Point.to_list/1)
            | Enum.map(interiors, fn interior -> Enum.map(interior, &Point.to_list/1) end)
          ]
        end)
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
      {
        :ok,
        %MultiPolygon{
          polygons:
            MapSet.new([
              %Polygon{
                exterior: [
                  %Point{x: 20, y: 35},
                  %Point{x: 10, y: 30},
                  %Point{x: 10, y: 10},
                  %Point{x: 30, y: 5},
                  %Point{x: 45, y: 20},
                  %Point{x: 20, y: 35}
                ],
                interiors: [
                  [
                    %Point{x: 30, y: 20},
                    %Point{x: 20, y: 15},
                    %Point{x: 20, y: 25},
                    %Point{x: 30, y: 20}
                  ]
                ]
              },
              %Polygon{
                exterior: [
                  %Point{x: 40, y: 40},
                  %Point{x: 20, y: 45},
                  %Point{x: 45, y: 30},
                  %Point{x: 40, y: 40}
                ],
                interiors: []
              }
            ])
        },
        1234
      }

      iex> MultiPolygon.from_wkt("MultiPolygon EMPTY")
      {:ok, %MultiPolygon{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPolygon)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPolygon) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
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
    %MultiPolygon{
      polygons:
        MapSet.new([
          %Polygon{
            exterior: [
              %Point{x: 20, y: 35},
              %Point{x: 10, y: 30},
              %Point{x: 10, y: 10},
              %Point{x: 30, y: 5},
              %Point{x: 45, y: 20},
              %Point{x: 20, y: 35}
            ],
            interiors: [
              [
                %Point{x: 30, y: 20},
                %Point{x: 20, y: 15},
                %Point{x: 20, y: 25},
                %Point{x: 30, y: 20}
              ]
            ]
          },
          %Polygon{
            exterior: [
              %Point{x: 40, y: 40},
              %Point{x: 20, y: 45},
              %Point{x: 45, y: 30},
              %Point{x: 40, y: 40}
            ],
            interiors: []
          }
        ])
    }
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
  def to_wkt(polygons, opts \\ [])

  def to_wkt(%MultiPolygon{polygons: polygons}, opts) do
    polygons
    |> Enum.empty?()
    |> case do
      true -> "EMPTY"
      false -> to_wkt_polygons(polygons)
    end
    |> to_wkt_multi_polygon()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `MultiPolygon`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiPolygon{} = multi_polygon, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_multi_polygon(multi_polygon, endian)::binary()
    >>
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygon` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiPolygon)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiPolygon) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiPolygon`.

  ## Examples

      iex> MultiPolygon.size(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(11, 22),
      ...>       Point.new(31, 22),
      ...>       Point.new(11, 12)
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
      ...>       Point.new(11, 12),
      ...>       Point.new(11, 22),
      ...>       Point.new(31, 22),
      ...>       Point.new(11, 12)
      ...>     ])
      ...>   ]),
      ...>   Polygon.new([
      ...>     Point.new(11, 12),
      ...>     Point.new(11, 22),
      ...>     Point.new(31, 22),
      ...>     Point.new(11, 12)
      ...>   ])
      ...> )
      true

      iex> MultiPolygon.member?(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(11, 22),
      ...>       Point.new(31, 22),
      ...>       Point.new(11, 12)
      ...>     ])
      ...>   ]),
      ...>   Polygon.new([
      ...>     Point.new(11, 12),
      ...>     Point.new(11, 22),
      ...>     Point.new(33, 22),
      ...>     Point.new(11, 12)
      ...>   ])
      ...> )
      false
  """
  @spec member?(t(), Polygon.t()) :: boolean()
  def member?(%MultiPolygon{polygons: polygons}, %Polygon{} = polygon),
    do: MapSet.member?(polygons, polygon)

  @doc """
  Converts `MultiPolygon` to a list.

  ## Examples

      iex> MultiPolygon.to_list(
      ...>   MultiPolygon.new([
      ...>     Polygon.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(11, 22),
      ...>       Point.new(31, 22),
      ...>       Point.new(11, 12)
      ...>     ])
      ...>   ])
      ...> )
      [
        %Polygon{
          exterior: [
            %Point{x: 11, y: 12},
            %Point{x: 11, y: 22},
            %Point{x: 31, y: 22},
            %Point{x: 11, y: 12}
          ],
          interiors: []
        }
      ]
  """

  @spec to_list(t()) :: [Polygon.t()]
  def to_list(%MultiPolygon{polygons: polygons}), do: MapSet.to_list(polygons)

  defp to_wkt_polygons(polygons) do
    wkt =
      polygons
      |> Enum.map(&to_wkt_polygon/1)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_polygon(%Polygon{exterior: exterior, interiors: interiors}) do
    to_wkt_points(exterior, interiors)
  end

  defp to_wkt_points(exterior, interiors) do
    wkt =
      [exterior | interiors]
      |> Enum.map(&to_wkt_points/1)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_points(points) do
    wkt =
      points
      |> Enum.map(fn point -> Point.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_multi_polygon(wkt), do: "MultiPolygon #{wkt}"

  defp to_wkb_multi_polygon(%MultiPolygon{polygons: polygons}, endian) do
    data =
      Enum.reduce(polygons, [], fn polygon, acc ->
        [Polygon.to_wkb(polygon, endian: endian) | acc]
      end)

    <<WKB.length(polygons, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "00000006"
      {:ndr, false} -> "06000000"
      {:xdr, true} -> "20000006"
      {:ndr, true} -> "06000020"
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
          %MultiPolygon{polygons: %{polygons | map: Map.merge(polygons.map, Map.new(list))}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
