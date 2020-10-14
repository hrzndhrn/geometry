defmodule Geometry.PolygonZM do
  @moduledoc """
  A polygon struct, representing a 3D polygon with a measurement.

  A none empty line-string requires at least one ring with four points.
  """

  import Geometry.Guards

  alias Geometry.{GeoJson, PointZM, PolygonZM, WKB, WKT}

  defstruct exterior: [], interiors: []

  @type t :: %PolygonZM{
          exterior: [PointZM.t()],
          interiors: [PointZM.t()]
        }

  @doc """
  Creates an empty `PolygonZM`.

  ## Examples

      iex> PolygonZM.new()
      %PolygonZM{exterior: [], interiors: []}
  """
  @spec new :: t()
  def new, do: %PolygonZM{}

  @doc """
  Creates a `PolygonZM` from the given `Geometry.PointZM`s.

  ## Examples

      iex> PolygonZM.new([
      ...>   PointZM.new(11, 12, 13, 14),
      ...>   PointZM.new(21, 22, 23, 24),
      ...>   PointZM.new(31, 32, 33, 34),
      ...>   PointZM.new(41, 42, 43, 44)
      ...> ])
      %PolygonZM{
        exterior: [
          %PointZM{x: 11, y: 12, z: 13, m: 14},
          %PointZM{x: 21, y: 22, z: 23, m: 24},
          %PointZM{x: 31, y: 32, z: 33, m: 34},
          %PointZM{x: 41, y: 42, z: 43, m: 44}
        ],
        interiors: []
      }

      iex> PolygonZM.new([])
      %PolygonZM{exterior: [], interiors: []}
  """
  @spec new([PointZM.t()]) :: t()
  def new([]), do: %PolygonZM{}
  def new([_, _, _, _ | _] = exterior), do: %PolygonZM{exterior: exterior}

  @doc """
  Creates a `PolygonZM` with holes from the given `PointZM`s.

  ## Examples
  POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),
  (20 30, 35 35, 30 20, 20 30))
      iex> PolygonZM.new(
      ...>   [
      ...>     PointZM.new(35, 10, 13, 14),
      ...>     PointZM.new(45, 45, 23, 24),
      ...>     PointZM.new(10, 20, 33, 34),
      ...>     PointZM.new(35, 10, 13, 14)
      ...>   ], [
      ...>     [
      ...>       PointZM.new(20, 30, 13, 14),
      ...>       PointZM.new(35, 35, 23, 24),
      ...>       PointZM.new(30, 20, 33, 34),
      ...>       PointZM.new(20, 30, 13, 14)
      ...>     ]
      ...>   ]
      ...> )
      %PolygonZM{
        exterior: [
          %PointZM{x: 35, y: 10, z: 13, m: 14},
          %PointZM{x: 45, y: 45, z: 23, m: 24},
          %PointZM{x: 10, y: 20, z: 33, m: 34},
          %PointZM{x: 35, y: 10, z: 13, m: 14}
        ],
        interiors: [[
          %PointZM{x: 20, y: 30, z: 13, m: 14},
          %PointZM{x: 35, y: 35, z: 23, m: 24},
          %PointZM{x: 30, y: 20, z: 33, m: 34},
          %PointZM{x: 20, y: 30, z: 13, m: 14},
        ]]
      }

      iex> PolygonZM.new([], [])
      %PolygonZM{exterior: [], interiors: []}
  """
  @spec new([PointZM.t()], [[PointZM.t()]]) :: t()
  def new([], []), do: %PolygonZM{}

  def new([_, _, _, _ | _] = exterior, [[_, _, _, _ | _] | _] = interiors),
    do: %PolygonZM{exterior: exterior, interiors: interiors}

  @doc """
  Returns `true` if the given `PolygonZM` is empty.

  ## Examples

      iex> PolygonZM.empty?(PolygonZM.new())
      true

      iex> [[1, 1, 1, 1], [2, 1, 2, 3], [2, 2, 3, 2], [1, 1, 1, 1]]
      ...> |> PolygonZM.from_coordinates()
      ...> |> PolygonZM.empty?()
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PolygonZM{} = polygon), do: Enum.empty?(polygon.exterior)

  @doc """
  Creates a `PolygonZM` from the given coordinates.

  ## Examples

      iex> PolygonZM.from_coordinates([
      ...>   {1, 1, 1, 1},
      ...>   {2, 1, 2, 3},
      ...>   {2, 2, 3, 2},
      ...>   {1, 1, 1, 1}
      ...> ])
      %PolygonZM{
        exterior: [
          %PointZM{x: 1, y: 1, z: 1, m: 1},
          %PointZM{x: 2, y: 1, z: 2, m: 3},
          %PointZM{x: 2, y: 2, z: 3, m: 2},
          %PointZM{x: 1, y: 1, z: 1, m: 1}
        ],
        interiors: []
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates([[x, y, z, m] | _] = coordinates) when is_coordinate(x, y, z, m) do
    %PolygonZM{exterior: Enum.map(coordinates, &PointZM.new/1)}
  end

  def from_coordinates([{x, y, z, m} | _] = coordinates) when is_coordinate(x, y, z, m) do
    %PolygonZM{exterior: Enum.map(coordinates, &PointZM.new/1)}
  end

  def from_coordinates([exterior | interiors]) do
    %PolygonZM{
      exterior: Enum.map(exterior, &PointZM.new/1),
      interiors: Enum.map(interiors, fn cs -> Enum.map(cs, &PointZM.new/1) end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonZM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "Polygon",
      ...>     "coordinates": [
      ...>       [[35, 10, 11, 12],
      ...>        [45, 45, 21, 22],
      ...>        [15, 40, 31, 33],
      ...>        [10, 20, 11, 55],
      ...>        [35, 10, 11, 12]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> PolygonZM.from_geo_json()
      {:ok, %PolygonZM{
        exterior: [
          %PointZM{x: 35, y: 10, z: 11, m: 12},
          %PointZM{x: 45, y: 45, z: 21, m: 22},
          %PointZM{x: 15, y: 40, z: 31, m: 33},
          %PointZM{x: 10, y: 20, z: 11, m: 55},
          %PointZM{x: 35, y: 10, z: 11, m: 12}
        ],
        interiors: []
      }}

      iex> ~s(
      ...>   {
      ...>     "type": "Polygon",
      ...>     "coordinates": [
      ...>       [[35, 10, 11, 12],
      ...>        [45, 45, 21, 22],
      ...>        [15, 40, 31, 33],
      ...>        [10, 20, 11, 55],
      ...>        [35, 10, 11, 12]],
      ...>       [[20, 30, 11, 11],
      ...>        [35, 35, 14, 55],
      ...>        [30, 20, 12, 45],
      ...>        [20, 30, 11, 11]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> PolygonZM.from_geo_json()
      {:ok, %PolygonZM{
        exterior: [
          %PointZM{x: 35, y: 10, z: 11, m: 12},
          %PointZM{x: 45, y: 45, z: 21, m: 22},
          %PointZM{x: 15, y: 40, z: 31, m: 33},
          %PointZM{x: 10, y: 20, z: 11, m: 55},
          %PointZM{x: 35, y: 10, z: 11, m: 12}
        ],
        interiors: [
          [
            %PointZM{x: 20, y: 30, z: 11, m: 11},
            %PointZM{x: 35, y: 35, z: 14, m: 55},
            %PointZM{x: 30, y: 20, z: 12, m: 45},
            %PointZM{x: 20, y: 30, z: 11, m: 11}
          ]
        ]
      }}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_polygon(json, PolygonZM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_polygon(json, PolygonZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `PolygonZM`.

  ## Examples

      iex> PolygonZM.new(
      ...>   [
      ...>     PointZM.new(35, 10, 13, 14),
      ...>     PointZM.new(45, 45, 23, 24),
      ...>     PointZM.new(10, 20, 33, 34),
      ...>     PointZM.new(35, 10, 13, 14)
      ...>   ], [
      ...>     [
      ...>       PointZM.new(20, 30, 13, 14),
      ...>       PointZM.new(35, 35, 23, 24),
      ...>       PointZM.new(30, 20, 33, 34),
      ...>       PointZM.new(20, 30, 13, 14)
      ...>     ]
      ...>   ]
      ...> )
      ...> |> PolygonZM.to_geo_json()
      %{
        "type" => "Polygon",
        "coordinates" => [
          [[35, 10, 13, 14], [45, 45, 23, 24], [10, 20, 33, 34], [35, 10, 13, 14]],
          [[20, 30, 13, 14], [35, 35, 23, 24], [30, 20, 33, 34], [20, 30, 13, 14]]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PolygonZM{exterior: exterior, interiors: interiors}) do
    %{
      "type" => "Polygon",
      "coordinates" => [
        Enum.map(exterior, &PointZM.to_list/1)
        | Enum.map(interiors, fn interior -> Enum.map(interior, &PointZM.to_list/1) end)
      ]
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonZM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> "
      ...>   POLYGON ZM (
      ...>     (35 10 11 22, 45 45 22 33, 15 40 33 44, 10 20 55 66, 35 10 11 22),
      ...>     (20 30 22 55, 35 35 33 66, 30 20 88 99, 20 30 22 55)
      ...>   )
      ...> "
      iex> |> PolygonZM.from_wkt()
      {:ok,
       %PolygonZM{
         exterior: [
           %PointZM{x: 35, y: 10, z: 11, m: 22},
           %PointZM{x: 45, y: 45, z: 22, m: 33},
           %PointZM{x: 15, y: 40, z: 33, m: 44},
           %PointZM{x: 10, y: 20, z: 55, m: 66},
           %PointZM{x: 35, y: 10, z: 11, m: 22}
         ],
         interiors: [
           [
             %PointZM{x: 20, y: 30, z: 22, m: 55},
             %PointZM{x: 35, y: 35, z: 33, m: 66},
             %PointZM{x: 30, y: 20, z: 88, m: 99},
             %PointZM{x: 20, y: 30, z: 22, m: 55}
           ]
         ]
       }}

      iex> "
      ...>   SRID=789;
      ...>   POLYGON ZM (
      ...>     (35 10 11 22, 45 45 22 33, 15 40 33 44, 10 20 55 66, 35 10 11 22),
      ...>     (20 30 22 55, 35 35 33 66, 30 20 88 99, 20 30 22 55)
      ...>   )
      ...> "
      iex> |> PolygonZM.from_wkt()
      {:ok,
       %PolygonZM{
         exterior: [
           %PointZM{x: 35, y: 10, z: 11, m: 22},
           %PointZM{x: 45, y: 45, z: 22, m: 33},
           %PointZM{x: 15, y: 40, z: 33, m: 44},
           %PointZM{x: 10, y: 20, z: 55, m: 66},
           %PointZM{x: 35, y: 10, z: 11, m: 22}
         ],
         interiors: [
           [
             %PointZM{x: 20, y: 30, z: 22, m: 55},
             %PointZM{x: 35, y: 35, z: 33, m: 66},
             %PointZM{x: 30, y: 20, z: 88, m: 99},
             %PointZM{x: 20, y: 30, z: 22, m: 55}
           ]
         ]
       }, 789}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, PolygonZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, PolygonZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `PolygonZM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  ## Examples

      iex> PolygonZM.to_wkt(PolygonZM.new())
      "Polygon ZM EMPTY"

      iex> PolygonZM.to_wkt(PolygonZM.new(), srid: 1123)
      "SRID=1123;Polygon ZM EMPTY"

      iex> PolygonZM.new(
      ...>   [
      ...>     PointZM.new(35, 10, 13, 14),
      ...>     PointZM.new(45, 45, 23, 24),
      ...>     PointZM.new(10, 20, 33, 34),
      ...>     PointZM.new(35, 10, 13, 14)
      ...>   ], [
      ...>     [
      ...>       PointZM.new(20, 30, 13, 14),
      ...>       PointZM.new(35, 35, 23, 24),
      ...>       PointZM.new(30, 20, 33, 34),
      ...>       PointZM.new(20, 30, 13, 14)
      ...>     ]
      ...>   ]
      ...> )
      ...> |> PolygonZM.to_wkt()
      "Polygon ZM " <>
      "((35 10 13 14, 45 45 23 24, 10 20 33 34, 35 10 13 14)" <>
      ", (20 30 13 14, 35 35 23 24, 30 20 33 34, 20 30 13 14))"

  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(polygon, opts \\ [])

  def to_wkt(%PolygonZM{exterior: []}, opts) do
    "EMPTY"
    |> to_wkt_polygon()
    |> WKT.to_ewkt(opts)
  end

  def to_wkt(%PolygonZM{exterior: exterior, interiors: interiors}, opts) do
    exterior
    |> to_wkt_points(interiors)
    |> to_wkt_polygon()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `PolygonZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PolygonZM{} = polygon, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_polygon(polygon, endian)::binary()
    >>
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonZM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, PolygonZM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, PolygonZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  defp to_wkt_points(exterior, interiors) do
    wkt =
      [exterior | interiors]
      |> Enum.map(&to_wkt_points/1)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkt_points(points) do
    wkt =
      points
      |> Enum.map(fn point -> PointZM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkt_polygon(wkt), do: <<"Polygon ZM ", wkt::binary()>>

  defp to_wkb_polygon(%PolygonZM{exterior: exterior, interiors: interiors}, endian) do
    rings = [exterior | interiors]

    data =
      rings
      |> Enum.map(fn ring -> to_wkb_ring(ring, endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(rings, endian)::binary(), data::binary()>>
  end

  defp to_wkb_ring(ring, endian) do
    data = Enum.map(ring, fn coordinate -> PointZM.to_wkb_coordinate(coordinate, endian) end)

    [WKB.length(ring, endian) | data]
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000003"
      {:ndr, false} -> "030000C0"
      {:xdr, true} -> "E0000003"
      {:ndr, true} -> "030000E0"
    end
  end
end
