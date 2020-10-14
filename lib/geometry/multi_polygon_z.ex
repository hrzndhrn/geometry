defmodule Geometry.MultiPolygonZ do
  @moduledoc """
  A collection set of geometries restricted to `Geometry.MultiPolygonZ`.
  """

  alias Geometry.{GeoJson, MultiPolygonZ, PointZ, PolygonZ, WKB, WKT}

  defstruct geometries: MapSet.new()

  @type t :: %MultiPolygonZ{geometries: MapSet.t(PolygonZ.t())}

  @doc """
  Creates an empty `MultiPolygonZ`.

  ## Examples

      iex> MultiPolygonZ.new()
      %MultiPolygonZ{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiPolygonZ{}

  @doc """
  Creates a `MultiPolygonZ` from the given `Geometry.MultiPolygonZ`s.

  ## Examples

      iex> MultiPolygonZ.new([
      ...>   PolygonZ.new([
      ...>     PointZ.new(6, 2, 3),
      ...>     PointZ.new(8, 2, 4),
      ...>     PointZ.new(8, 4, 5),
      ...>     PointZ.new(6, 2, 3)
      ...>   ]),
      ...>   PolygonZ.new([
      ...>     PointZ.new(1, 1, 3),
      ...>     PointZ.new(9, 1, 4),
      ...>     PointZ.new(9, 8, 5),
      ...>     PointZ.new(1, 1, 3)
      ...>   ], [[
      ...>     PointZ.new(6, 2, 3),
      ...>     PointZ.new(7, 2, 4),
      ...>     PointZ.new(7, 3, 5),
      ...>     PointZ.new(6, 2, 3)
      ...>   ]])
      ...> ])
      %MultiPolygonZ{
        geometries:
          MapSet.new([
            %PolygonZ{
              exterior: [
                %PointZ{x: 1, y: 1, z: 3},
                %PointZ{x: 9, y: 1, z: 4},
                %PointZ{x: 9, y: 8, z: 5},
                %PointZ{x: 1, y: 1, z: 3}
              ],
              interiors: [
                [
                  %PointZ{x: 6, y: 2, z: 3},
                  %PointZ{x: 7, y: 2, z: 4},
                  %PointZ{x: 7, y: 3, z: 5},
                  %PointZ{x: 6, y: 2, z: 3}
                ]
              ]
            },
            %PolygonZ{
              exterior: [
                %PointZ{x: 6, y: 2, z: 3},
                %PointZ{x: 8, y: 2, z: 4},
                %PointZ{x: 8, y: 4, z: 5},
                %PointZ{x: 6, y: 2, z: 3}
              ],
              interiors: []
            }
          ])
      }

      iex> MultiPolygonZ.new([])
      %MultiPolygonZ{}
  """
  @spec new([PolygonZ.t()]) :: t()
  def new([]), do: %MultiPolygonZ{}
  def new(polygon), do: %MultiPolygonZ{geometries: MapSet.new(polygon)}

  @doc """
  Returns `true` if the given `MultiPolygonZ` is empty.

  ## Examples

      iex> MultiPolygonZ.empty?(MultiPolygonZ.new())
      true

      iex> MultiPolygonZ.empty?(
      ...>   MultiPolygonZ.new([
      ...>     PolygonZ.new([
      ...>         PointZ.new(1, 1, 3),
      ...>         PointZ.new(1, 5, 4),
      ...>         PointZ.new(5, 4, 2),
      ...>         PointZ.new(1, 1, 3)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiPolygonZ{} = multi_polygon),
    do: Enum.empty?(multi_polygon.geometries)

  @doc """
  Creates a `MultiPolygonZ` from the given coordinates.

  ## Examples

      iex> MultiPolygonZ.from_coordinates([
      ...>   [
      ...>     {6, 2, 3}, {8, 2, 4}, {8, 4, 5}, {6, 2, 3}
      ...>   ], [
      ...>     [{1, 1, 3}, {9, 1, 4}, {9, 8, 5}, {1, 1, 3}],
      ...>     [{6, 2, 4}, {7, 2, 6}, {7, 3, 3}, {6, 2, 4}]
      ...>   ]
      ...> ])
      %MultiPolygonZ{
        geometries:
          MapSet.new([
            %PolygonZ{
              exterior: [
                %PointZ{x: 1, y: 1, z: 3},
                %PointZ{x: 9, y: 1, z: 4},
                %PointZ{x: 9, y: 8, z: 5},
                %PointZ{x: 1, y: 1, z: 3}
              ],
              interiors: [
                [
                  %PointZ{x: 6, y: 2, z: 4},
                  %PointZ{x: 7, y: 2, z: 6},
                  %PointZ{x: 7, y: 3, z: 3},
                  %PointZ{x: 6, y: 2, z: 4}
                ]
              ]
            },
            %PolygonZ{
              exterior: [
                %PointZ{x: 6, y: 2, z: 3},
                %PointZ{x: 8, y: 2, z: 4},
                %PointZ{x: 8, y: 4, z: 5},
                %PointZ{x: 6, y: 2, z: 3}
              ],
              interiors: []
            }
          ])
      }
  """
  @spec from_coordinates([[Geometry.coordinate_z()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiPolygonZ{
      geometries: coordinates |> Enum.map(&PolygonZ.from_coordinates/1) |> MapSet.new()
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygonZ` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiPolygon",
      ...>     "coordinates": [
      ...>       [
      ...>         [[6, 2, 3], [8, 2, 4], [8, 4, 5], [6, 2, 3]]
      ...>       ], [
      ...>         [[1, 1, 3], [9, 1, 4], [9, 8, 5], [1, 1, 3]],
      ...>         [[6, 2, 4], [7, 2, 6], [7, 3, 3], [6, 2, 4]]
      ...>       ]
      ...>     ]
      ...>   }
      ...> )
      ...> |> Jason.decode!()
      ...> |> MultiPolygonZ.from_geo_json()
      {
        :ok,
        %MultiPolygonZ{
          geometries:
            MapSet.new([
              %PolygonZ{
                exterior: [
                  %PointZ{x: 1, y: 1, z: 3},
                  %PointZ{x: 9, y: 1, z: 4},
                  %PointZ{x: 9, y: 8, z: 5},
                  %PointZ{x: 1, y: 1, z: 3}
                ],
                interiors: [
                  [
                    %PointZ{x: 6, y: 2, z: 4},
                    %PointZ{x: 7, y: 2, z: 6},
                    %PointZ{x: 7, y: 3, z: 3},
                    %PointZ{x: 6, y: 2, z: 4}
                  ]
                ]
              },
              %PolygonZ{
                exterior: [
                  %PointZ{x: 6, y: 2, z: 3},
                  %PointZ{x: 8, y: 2, z: 4},
                  %PointZ{x: 8, y: 4, z: 5},
                  %PointZ{x: 6, y: 2, z: 3}
                ],
                interiors: []
              }
            ])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_polygon(json, MultiPolygonZ)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_polygon(json, MultiPolygonZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiPolygonZ`.

  There are no guarantees about the order of polygons in the returned
  `coordinates`.

  ## Examples

  ```elixir
  [
    [
      {6, 2, 3}, {8, 2, 4}, {8, 4, 5}, {6, 2, 3}
    ], [
      [{1, 1, 3}, {9, 1, 4}, {9, 8, 5}, {1, 1, 3}],
      [{6, 2, 4}, {7, 2, 6}, {7, 3, 3}, {6, 2, 4}]
    ]
  ]
  |> MultiPolygonZ.from_coordinates()
  |> MultiPolygonZ.to_geo_json()
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
  def to_geo_json(%MultiPolygonZ{geometries: polygons}) do
    %{
      "type" => "MultiPolygon",
      "coordinates" =>
        Enum.map(polygons, fn %PolygonZ{exterior: exterior, interiors: interiors} ->
          [
            Enum.map(exterior, &PointZ.to_list/1)
            | Enum.map(interiors, fn interior -> Enum.map(interior, &PointZ.to_list/1) end)
          ]
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiPolygonZ` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiPolygonZ.from_wkt("
      ...>   SRID=1234;MULTIPOLYGON Z (
      ...>     (
      ...>        (40 40 10, 20 45 20, 45 30 15, 40 40 10)
      ...>     ), (
      ...>        (20 35 20, 10 30 10, 10 10 30, 30 5 10, 45 20 10, 20 35 20),
      ...>        (30 20 10, 20 15 20, 20 25 15, 30 20 10)
      ...>     )
      ...>   )
      ...> ")
      {
        :ok,
        %MultiPolygonZ{
          geometries:
            MapSet.new([
              %PolygonZ{
                exterior: [
                  %PointZ{x: 20, y: 35, z: 20},
                  %PointZ{x: 10, y: 30, z: 10},
                  %PointZ{x: 10, y: 10, z: 30},
                  %PointZ{x: 30, y: 5, z: 10},
                  %PointZ{x: 45, y: 20, z: 10},
                  %PointZ{x: 20, y: 35, z: 20}
                ],
                interiors: [
                  [
                    %PointZ{x: 30, y: 20, z: 10},
                    %PointZ{x: 20, y: 15, z: 20},
                    %PointZ{x: 20, y: 25, z: 15},
                    %PointZ{x: 30, y: 20, z: 10}
                  ]
                ]
              },
              %PolygonZ{
                exterior: [
                  %PointZ{x: 40, y: 40, z: 10},
                  %PointZ{x: 20, y: 45, z: 20},
                  %PointZ{x: 45, y: 30, z: 15},
                  %PointZ{x: 40, y: 40, z: 10}
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
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiPolygonZ)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiPolygonZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiPolygonZ`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of polygons in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiPolygonZ.to_wkt(
    %MultiPolygonZ{
      geometries:
        MapSet.new([
          %PolygonZ{
            exterior: [
              %PointZ{x: 20, y: 35, z: 20},
              %PointZ{x: 10, y: 30, z: 10},
              %PointZ{x: 10, y: 10, z: 30},
              %PointZ{x: 30, y: 5, z: 10},
              %PointZ{x: 45, y: 20, z: 10},
              %PointZ{x: 20, y: 35, z: 20}
            ],
            interiors: [
              [
                %PointZ{x: 30, y: 20, z: 10},
                %PointZ{x: 20, y: 15, z: 20},
                %PointZ{x: 20, y: 25, z: 15},
                %PointZ{x: 30, y: 20, z: 10}
              ]
            ]
          },
          %PolygonZ{
            exterior: [
              %PointZ{x: 40, y: 40, z: 10},
              %PointZ{x: 20, y: 45, z: 20},
              %PointZ{x: 45, y: 30, z: 15},
              %PointZ{x: 40, y: 40, z: 10}
            ],
            interiors: []
          }
        ])
    }
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # SRID=478;MultiPolygon Z (
  #   (
  #     (20 35 20, 10 30 10, 10 10 30, 30 5 10, 45 20 10, 20 35 20),
  #     (30 20 10, 20 15 20, 20 25 15, 30 20 10)
  #   ), (
  #     (40 40 10, 20 45 20, 45 30 15, 40 40 10)
  #   )
  # )
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(polygons, opts \\ [])

  def to_wkt(%MultiPolygonZ{geometries: polygons}, opts) do
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
  Returns the WKB representation for a `MultiPolygonZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiPolygonZ{} = multi_polygon, opts \\ []) do
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
  Returns an `:ok` tuple with the `MultiPolygonZ` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiPolygonZ)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiPolygonZ) do
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

  defp to_wkt_polygon(%PolygonZ{exterior: exterior, interiors: interiors}) do
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
      |> Enum.map(fn point -> PointZ.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_multi_polygon(wkt), do: "MultiPolygon Z #{wkt}"

  defp to_wkb_multi_polygon(%MultiPolygonZ{geometries: geometries}, endian) do
    data =
      Enum.reduce(geometries, [], fn polygon, acc ->
        [PolygonZ.to_wkb(polygon, endian: endian) | acc]
      end)

    <<WKB.length(geometries, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "80000006"
      {:ndr, false} -> "06000080"
      {:xdr, true} -> "A0000006"
      {:ndr, true} -> "060000A0"
    end
  end
end
