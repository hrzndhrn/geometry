defmodule Geometry.MultiPolygonZM do
  @moduledoc """
  A collection set of geometries restricted to `Geometry.MultiPolygonZM`.
  """

  alias Geometry.{GeoJson, MultiPolygonZM, PointZM, PolygonZM, WKB, WKT}

  defstruct geometries: MapSet.new()

  @type t :: %MultiPolygonZM{geometries: MapSet.t(PolygonZM.t())}

  @doc """
  Creates an empty `MultiPolygonZM`.

  ## Examples

      iex> MultiPolygonZM.new()
      %MultiPolygonZM{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPolygonZM{}

  @doc """
  Creates a `MultiPolygonZM` from the given `Geometry.MultiPolygonZM`s.

  ## Examples

      iex> MultiPolygonZM.new([
      ...>   PolygonZM.new([
      ...>     PointZM.new(6, 2, 3, 4),
      ...>     PointZM.new(8, 2, 4, 5),
      ...>     PointZM.new(8, 4, 5, 6),
      ...>     PointZM.new(6, 2, 3, 4)
      ...>   ]),
      ...>   PolygonZM.new([
      ...>     PointZM.new(1, 1, 3, 4),
      ...>     PointZM.new(9, 1, 4, 5),
      ...>     PointZM.new(9, 8, 5, 6),
      ...>     PointZM.new(1, 1, 3, 4)
      ...>   ], [[
      ...>     PointZM.new(6, 2, 3, 4),
      ...>     PointZM.new(7, 2, 4, 5),
      ...>     PointZM.new(7, 3, 5, 6),
      ...>     PointZM.new(6, 2, 3, 4)
      ...>   ]])
      ...> ])
      %MultiPolygonZM{
        geometries:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 1, y: 1, z: 3, m: 4},
                %PointZM{x: 9, y: 1, z: 4, m: 5},
                %PointZM{x: 9, y: 8, z: 5, m: 6},
                %PointZM{x: 1, y: 1, z: 3, m: 4}
              ],
              interiors: [
                [
                  %PointZM{x: 6, y: 2, z: 3, m: 4},
                  %PointZM{x: 7, y: 2, z: 4, m: 5},
                  %PointZM{x: 7, y: 3, z: 5, m: 6},
                  %PointZM{x: 6, y: 2, z: 3, m: 4}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 6, y: 2, z: 3, m: 4},
                %PointZM{x: 8, y: 2, z: 4, m: 5},
                %PointZM{x: 8, y: 4, z: 5, m: 6},
                %PointZM{x: 6, y: 2, z: 3, m: 4}
              ],
              interiors: []
            }
          ])
      }

      iex> MultiPolygonZM.new([])
      %MultiPolygonZM{}
  """
  @spec new([PolygonZM.t()]) :: t()
  def new([]), do: %MultiPolygonZM{}
  def new(polygon), do: %MultiPolygonZM{geometries: MapSet.new(polygon)}

  @doc """
  Returns `true` if the given `MultiPolygonZM` is empty.

  ## Examples

      iex> MultiPolygonZM.empty?(MultiPolygonZM.new())
      true

      iex> MultiPolygonZM.empty?(
      ...>   MultiPolygonZM.new([
      ...>     PolygonZM.new([
      ...>         PointZM.new(1, 1, 3, 4),
      ...>         PointZM.new(1, 5, 4, 8),
      ...>         PointZM.new(5, 4, 2, 6),
      ...>         PointZM.new(1, 1, 3, 4)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPolygonZM{} = multi_polygon),
    do: Enum.empty?(multi_polygon.geometries)

  @doc """
  Creates a `MultiPolygonZM` from the given coordinates.

  ## Examples

      iex> MultiPolygonZM.from_coordinates([
      ...>   [
      ...>     {6, 2, 3, 4}, {8, 2, 4, 5}, {8, 4, 5, 6}, {6, 2, 3, 4}
      ...>   ], [
      ...>     [{1, 1, 3, 4}, {9, 1, 4, 5}, {9, 8, 5, 6}, {1, 1, 3, 4}],
      ...>     [{6, 2, 4, 3}, {7, 2, 6, 7}, {7, 3, 3, 4}, {6, 2, 4, 3}]
      ...>   ]
      ...> ])
      %MultiPolygonZM{
        geometries:
          MapSet.new([
            %PolygonZM{
              exterior: [
                %PointZM{x: 1, y: 1, z: 3, m: 4},
                %PointZM{x: 9, y: 1, z: 4, m: 5},
                %PointZM{x: 9, y: 8, z: 5, m: 6},
                %PointZM{x: 1, y: 1, z: 3, m: 4}
              ],
              interiors: [
                [
                  %PointZM{x: 6, y: 2, z: 4, m: 3},
                  %PointZM{x: 7, y: 2, z: 6, m: 7},
                  %PointZM{x: 7, y: 3, z: 3, m: 4},
                  %PointZM{x: 6, y: 2, z: 4, m: 3}
                ]
              ]
            },
            %PolygonZM{
              exterior: [
                %PointZM{x: 6, y: 2, z: 3, m: 4},
                %PointZM{x: 8, y: 2, z: 4, m: 5},
                %PointZM{x: 8, y: 4, z: 5, m: 6},
                %PointZM{x: 6, y: 2, z: 3, m: 4}
              ],
              interiors: []
            }
          ])
      }
  """
  @spec from_coordinates([[Geometry.coordinate_zm()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiPolygonZM{
      geometries: coordinates |> Enum.map(&PolygonZM.from_coordinates/1) |> MapSet.new()
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
      {
        :ok,
        %MultiPolygonZM{
          geometries:
            MapSet.new([
              %PolygonZM{
                exterior: [
                  %PointZM{x: 1, y: 1, z: 3, m: 4},
                  %PointZM{x: 9, y: 1, z: 4, m: 5},
                  %PointZM{x: 9, y: 8, z: 5, m: 6},
                  %PointZM{x: 1, y: 1, z: 3, m: 4}
                ],
                interiors: [
                  [
                    %PointZM{x: 6, y: 2, z: 4, m: 3},
                    %PointZM{x: 7, y: 2, z: 6, m: 7},
                    %PointZM{x: 7, y: 3, z: 3, m: 4},
                    %PointZM{x: 6, y: 2, z: 4, m: 3}
                  ]
                ]
              },
              %PolygonZM{
                exterior: [
                  %PointZM{x: 6, y: 2, z: 3, m: 4},
                  %PointZM{x: 8, y: 2, z: 4, m: 5},
                  %PointZM{x: 8, y: 4, z: 5, m: 6},
                  %PointZM{x: 6, y: 2, z: 3, m: 4}
                ],
                interiors: []
              }
            ])
        }
      }
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
  [
    [
      {6, 2, 3, 4}, {8, 2, 4, 5}, {8, 4, 5, 6}, {6, 2, 3, 4}
    ], [
      [{1, 1, 3, 4}, {9, 1, 4, 5}, {9, 8, 5, 6}, {1, 1, 3, 4}],
      [{6, 2, 4, 3}, {7, 2, 6, 7}, {7, 3, 3, 4}, {6, 2, 4, 3}]
    ]
  ]
  |> MultiPolygonZM.from_coordinates()
  |> MultiPolygonZM.to_geo_json()
  # =>
  # %{
  #   "type" => "MultiPolygon",
  #   "coordinates" => [
  #     [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
  #     [[-10, 10, 10, 10], [-20, 20, 20, 20]]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiPolygonZM{geometries: polygons}) do
    %{
      "type" => "MultiPolygon",
      "coordinates" =>
        Enum.map(polygons, fn %PolygonZM{exterior: exterior, interiors: interiors} ->
          [
            Enum.map(exterior, &PointZM.to_list/1)
            | Enum.map(interiors, fn interior -> Enum.map(interior, &PointZM.to_list/1) end)
          ]
        end)
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
      {
        :ok,
        %MultiPolygonZM{
          geometries:
            MapSet.new([
              %PolygonZM{
                exterior: [
                  %PointZM{x: 20, y: 35, z: 20, m: 10},
                  %PointZM{x: 10, y: 30, z: 10, m: 20},
                  %PointZM{x: 10, y: 10, z: 30, m: 15},
                  %PointZM{x: 30, y: 5, z: 10, m: 15},
                  %PointZM{x: 45, y: 20, z: 10, m: 16},
                  %PointZM{x: 20, y: 35, z: 20, m: 10}
                ],
                interiors: [
                  [
                    %PointZM{x: 30, y: 20, z: 10, m: 15},
                    %PointZM{x: 20, y: 15, z: 20, m: 10},
                    %PointZM{x: 20, y: 25, z: 15, m: 25},
                    %PointZM{x: 30, y: 20, z: 10, m: 15}
                  ]
                ]
              },
              %PolygonZM{
                exterior: [
                  %PointZM{x: 40, y: 40, z: 10, m: 20},
                  %PointZM{x: 20, y: 45, z: 20, m: 10},
                  %PointZM{x: 45, y: 30, z: 15, m: 30},
                  %PointZM{x: 40, y: 40, z: 10, m: 20}
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
    %MultiPolygonZM{
      geometries:
        MapSet.new([
          %PolygonZM{
            exterior: [
              %PointZM{x: 20, y: 35, z: 20, m: 10},
              %PointZM{x: 10, y: 30, z: 10, m: 20},
              %PointZM{x: 10, y: 10, z: 30, m: 15},
              %PointZM{x: 30, y: 5, z: 10, m: 15},
              %PointZM{x: 45, y: 20, z: 10, m: 16},
              %PointZM{x: 20, y: 35, z: 20, m: 10}
            ],
            interiors: [
              [
                %PointZM{x: 30, y: 20, z: 10, m: 15},
                %PointZM{x: 20, y: 15, z: 20, m: 10},
                %PointZM{x: 20, y: 25, z: 15, m: 25},
                %PointZM{x: 30, y: 20, z: 10, m: 15}
              ]
            ]
          },
          %PolygonZM{
            exterior: [
              %PointZM{x: 40, y: 40, z: 10, m: 20},
              %PointZM{x: 20, y: 45, z: 20, m: 10},
              %PointZM{x: 45, y: 30, z: 15, m: 30},
              %PointZM{x: 40, y: 40, z: 10, m: 20}
            ],
            interiors: []
          }
        ])
    }
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
  def to_wkt(polygons, opts \\ [])

  def to_wkt(%MultiPolygonZM{geometries: polygons}, opts) do
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
  Returns the WKB representation for a `MultiPolygonZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiPolygonZM{} = multi_polygon, opts \\ []) do
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

  defp to_wkt_polygons(polygons) do
    wkt =
      polygons
      |> Enum.map(&to_wkt_polygon/1)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_polygon(%PolygonZM{exterior: exterior, interiors: interiors}) do
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
      |> Enum.map(fn point -> PointZM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_multi_polygon(wkt), do: "MultiPolygon ZM #{wkt}"

  defp to_wkb_multi_polygon(%MultiPolygonZM{geometries: geometries}, endian) do
    data =
      Enum.reduce(geometries, [], fn polygon, acc ->
        [PolygonZM.to_wkb(polygon, endian: endian) | acc]
      end)

    <<WKB.length(geometries, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000006"
      {:ndr, false} -> "060000C0"
      {:xdr, true} -> "E0000006"
      {:ndr, true} -> "060000E0"
    end
  end
end
