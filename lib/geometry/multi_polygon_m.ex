defmodule Geometry.MultiPolygonM do
  @moduledoc """
  A collection set of geometries restricted to `Geometry.MultiPolygonM`.
  """

  alias Geometry.{GeoJson, MultiPolygonM, PointM, PolygonM, WKB, WKT}

  defstruct geometries: MapSet.new()

  @type t :: %MultiPolygonM{geometries: MapSet.t(PolygonM.t())}

  @doc """
  Creates an empty `MultiPolygonM`.

  ## Examples

      iex> MultiPolygonM.new()
      %MultiPolygonM{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPolygonM{}

  @doc """
  Creates a `MultiPolygonM` from the given `Geometry.MultiPolygonM`s.

  ## Examples

      iex> MultiPolygonM.new([
      ...>   PolygonM.new([
      ...>     PointM.new(6, 2, 4),
      ...>     PointM.new(8, 2, 5),
      ...>     PointM.new(8, 4, 6),
      ...>     PointM.new(6, 2, 4)
      ...>   ]),
      ...>   PolygonM.new([
      ...>     PointM.new(1, 1, 4),
      ...>     PointM.new(9, 1, 5),
      ...>     PointM.new(9, 8, 6),
      ...>     PointM.new(1, 1, 4)
      ...>   ], [[
      ...>     PointM.new(6, 2, 4),
      ...>     PointM.new(7, 2, 5),
      ...>     PointM.new(7, 3, 6),
      ...>     PointM.new(6, 2, 4)
      ...>   ]])
      ...> ])
      %MultiPolygonM{
        geometries:
          MapSet.new([
            %PolygonM{
              exterior: [
                %PointM{x: 1, y: 1, m: 4},
                %PointM{x: 9, y: 1, m: 5},
                %PointM{x: 9, y: 8, m: 6},
                %PointM{x: 1, y: 1, m: 4}
              ],
              interiors: [
                [
                  %PointM{x: 6, y: 2, m: 4},
                  %PointM{x: 7, y: 2, m: 5},
                  %PointM{x: 7, y: 3, m: 6},
                  %PointM{x: 6, y: 2, m: 4}
                ]
              ]
            },
            %PolygonM{
              exterior: [
                %PointM{x: 6, y: 2, m: 4},
                %PointM{x: 8, y: 2, m: 5},
                %PointM{x: 8, y: 4, m: 6},
                %PointM{x: 6, y: 2, m: 4}
              ],
              interiors: []
            }
          ])
      }

      iex> MultiPolygonM.new([])
      %MultiPolygonM{}
  """
  @spec new([PolygonM.t()]) :: t()
  def new([]), do: %MultiPolygonM{}
  def new(polygon), do: %MultiPolygonM{geometries: MapSet.new(polygon)}

  @doc """
  Returns `true` if the given `MultiPolygonM` is empty.

  ## Examples

      iex> MultiPolygonM.empty?(MultiPolygonM.new())
      true

      iex> MultiPolygonM.empty?(
      ...>   MultiPolygonM.new([
      ...>     PolygonM.new([
      ...>         PointM.new(1, 1, 4),
      ...>         PointM.new(1, 5, 8),
      ...>         PointM.new(5, 4, 6),
      ...>         PointM.new(1, 1, 4)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPolygonM{} = multi_polygon),
    do: Enum.empty?(multi_polygon.geometries)

  @doc """
  Creates a `MultiPolygonM` from the given coordinates.

  ## Examples

      iex> MultiPolygonM.from_coordinates([
      ...>   [
      ...>     {6, 2, 4}, {8, 2, 5}, {8, 4, 6}, {6, 2, 4}
      ...>   ], [
      ...>     [{1, 1, 4}, {9, 1, 5}, {9, 8, 6}, {1, 1, 4}],
      ...>     [{6, 2, 3}, {7, 2, 7}, {7, 3, 4}, {6, 2, 3}]
      ...>   ]
      ...> ])
      %MultiPolygonM{
        geometries:
          MapSet.new([
            %PolygonM{
              exterior: [
                %PointM{x: 1, y: 1, m: 4},
                %PointM{x: 9, y: 1, m: 5},
                %PointM{x: 9, y: 8, m: 6},
                %PointM{x: 1, y: 1, m: 4}
              ],
              interiors: [
                [
                  %PointM{x: 6, y: 2, m: 3},
                  %PointM{x: 7, y: 2, m: 7},
                  %PointM{x: 7, y: 3, m: 4},
                  %PointM{x: 6, y: 2, m: 3}
                ]
              ]
            },
            %PolygonM{
              exterior: [
                %PointM{x: 6, y: 2, m: 4},
                %PointM{x: 8, y: 2, m: 5},
                %PointM{x: 8, y: 4, m: 6},
                %PointM{x: 6, y: 2, m: 4}
              ],
              interiors: []
            }
          ])
      }
  """
  @spec from_coordinates([[Geometry.coordinate_m()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiPolygonM{
      geometries: coordinates |> Enum.map(&PolygonM.from_coordinates/1) |> MapSet.new()
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
      {
        :ok,
        %MultiPolygonM{
          geometries:
            MapSet.new([
              %PolygonM{
                exterior: [
                  %PointM{x: 1, y: 1, m: 4},
                  %PointM{x: 9, y: 1, m: 5},
                  %PointM{x: 9, y: 8, m: 6},
                  %PointM{x: 1, y: 1, m: 4}
                ],
                interiors: [
                  [
                    %PointM{x: 6, y: 2, m: 3},
                    %PointM{x: 7, y: 2, m: 7},
                    %PointM{x: 7, y: 3, m: 4},
                    %PointM{x: 6, y: 2, m: 3}
                  ]
                ]
              },
              %PolygonM{
                exterior: [
                  %PointM{x: 6, y: 2, m: 4},
                  %PointM{x: 8, y: 2, m: 5},
                  %PointM{x: 8, y: 4, m: 6},
                  %PointM{x: 6, y: 2, m: 4}
                ],
                interiors: []
              }
            ])
        }
      }
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
  [
    [
      {6, 2, 4}, {8, 2, 5}, {8, 4, 6}, {6, 2, 4}
    ], [
      [{1, 1, 4}, {9, 1, 5}, {9, 8, 6}, {1, 1, 4}],
      [{6, 2, 3}, {7, 2, 7}, {7, 3, 4}, {6, 2, 3}]
    ]
  ]
  |> MultiPolygonM.from_coordinates()
  |> MultiPolygonM.to_geo_json()
  # =>
  # %{
  #   "type" => "MultiPolygon",
  #   "coordinates" => [
  #     [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
  #     [[-10, 10, 10], [-20, 20, 20]]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPolygonM{geometries: polygons}) do
    %{
      "type" => "MultiPolygon",
      "coordinates" =>
        Enum.map(polygons, fn %PolygonM{exterior: exterior, interiors: interiors} ->
          [
            Enum.map(exterior, &PointM.to_list/1)
            | Enum.map(interiors, fn interior -> Enum.map(interior, &PointM.to_list/1) end)
          ]
        end)
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
      {
        :ok,
        %MultiPolygonM{
          geometries:
            MapSet.new([
              %PolygonM{
                exterior: [
                  %PointM{x: 20, y: 35, m: 10},
                  %PointM{x: 10, y: 30, m: 20},
                  %PointM{x: 10, y: 10, m: 15},
                  %PointM{x: 30, y: 5, m: 15},
                  %PointM{x: 45, y: 20, m: 16},
                  %PointM{x: 20, y: 35, m: 10}
                ],
                interiors: [
                  [
                    %PointM{x: 30, y: 20, m: 15},
                    %PointM{x: 20, y: 15, m: 10},
                    %PointM{x: 20, y: 25, m: 25},
                    %PointM{x: 30, y: 20, m: 15}
                  ]
                ]
              },
              %PolygonM{
                exterior: [
                  %PointM{x: 40, y: 40, m: 20},
                  %PointM{x: 20, y: 45, m: 10},
                  %PointM{x: 45, y: 30, m: 30},
                  %PointM{x: 40, y: 40, m: 20}
                ],
                interiors: []
              }
            ])
        },
        1234
      }
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPolygonM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPolygonM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
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
    %MultiPolygonM{
      geometries:
        MapSet.new([
          %PolygonM{
            exterior: [
              %PointM{x: 20, y: 35, m: 10},
              %PointM{x: 10, y: 30, m: 20},
              %PointM{x: 10, y: 10, m: 15},
              %PointM{x: 30, y: 5, m: 15},
              %PointM{x: 45, y: 20, m: 16},
              %PointM{x: 20, y: 35, m: 10}
            ],
            interiors: [
              [
                %PointM{x: 30, y: 20, m: 15},
                %PointM{x: 20, y: 15, m: 10},
                %PointM{x: 20, y: 25, m: 25},
                %PointM{x: 30, y: 20, m: 15}
              ]
            ]
          },
          %PolygonM{
            exterior: [
              %PointM{x: 40, y: 40, m: 20},
              %PointM{x: 20, y: 45, m: 10},
              %PointM{x: 45, y: 30, m: 30},
              %PointM{x: 40, y: 40, m: 20}
            ],
            interiors: []
          }
        ])
    }
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
  def to_wkt(polygons, opts \\ [])

  def to_wkt(%MultiPolygonM{geometries: polygons}, opts) do
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
  Returns the WKB representation for a `MultiPolygonM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiPolygonM{} = multi_polygon, opts \\ []) do
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
  Returns an `:ok` tuple with the `MultiPolygonM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiPolygonM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiPolygonM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  defp to_wkt_polygons(polygons) do
    wkt =
      polygons
      |> Enum.map(&to_wkt_polygon/1)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_polygon(%PolygonM{exterior: exterior, interiors: interiors}) do
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
      |> Enum.map(fn point -> PointM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_multi_polygon(wkt), do: "MultiPolygon M #{wkt}"

  defp to_wkb_multi_polygon(%MultiPolygonM{geometries: geometries}, endian) do
    data =
      Enum.reduce(geometries, [], fn polygon, acc ->
        [PolygonM.to_wkb(polygon, endian: endian) | acc]
      end)

    <<WKB.length(geometries, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "40000006"
      {:ndr, false} -> "06000040"
      {:xdr, true} -> "60000006"
      {:ndr, true} -> "06000060"
    end
  end
end
