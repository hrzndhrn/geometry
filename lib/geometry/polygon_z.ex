defmodule Geometry.PolygonZ do
  @moduledoc """
  A polygon struct, representing a 3D polygon.

  A none empty line-string requires at least one ring with four points.
  """

  import Geometry.Guards

  alias Geometry.{GeoJson, PointZ, PolygonZ, WKB, WKT}

  defstruct exterior: [], interiors: []

  @type t :: %PolygonZ{
          exterior: [PointZ.t()],
          interiors: [PointZ.t()]
        }

  @doc """
  Creates an empty `PolygonZ`.

  ## Examples

      iex> PolygonZ.new()
      %PolygonZ{exterior: [], interiors: []}
  """
  @spec new :: t()
  def new, do: %PolygonZ{}

  @doc """
  Creates a `PolygonZ` from the given `Geometry.PointZ`s.

  ## Examples

      iex> PolygonZ.new([
      ...>   PointZ.new(11, 12, 13),
      ...>   PointZ.new(21, 22, 23),
      ...>   PointZ.new(31, 32, 33),
      ...>   PointZ.new(41, 42, 43)
      ...> ])
      %PolygonZ{
        exterior: [
          %PointZ{x: 11, y: 12, z: 13},
          %PointZ{x: 21, y: 22, z: 23},
          %PointZ{x: 31, y: 32, z: 33},
          %PointZ{x: 41, y: 42, z: 43}
        ],
        interiors: []
      }

      iex> PolygonZ.new([])
      %PolygonZ{exterior: [], interiors: []}
  """
  @spec new([PointZ.t()]) :: t()
  def new([]), do: %PolygonZ{}
  def new([_, _, _, _ | _] = exterior), do: %PolygonZ{exterior: exterior}

  @doc """
  Creates a `PolygonZ` with holes from the given `PointZ`s.

  ## Examples
  POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),
  (20 30, 35 35, 30 20, 20 30))
      iex> PolygonZ.new(
      ...>   [
      ...>     PointZ.new(35, 10, 13),
      ...>     PointZ.new(45, 45, 23),
      ...>     PointZ.new(10, 20, 33),
      ...>     PointZ.new(35, 10, 13)
      ...>   ], [
      ...>     [
      ...>       PointZ.new(20, 30, 13),
      ...>       PointZ.new(35, 35, 23),
      ...>       PointZ.new(30, 20, 33),
      ...>       PointZ.new(20, 30, 13)
      ...>     ]
      ...>   ]
      ...> )
      %PolygonZ{
        exterior: [
          %PointZ{x: 35, y: 10, z: 13},
          %PointZ{x: 45, y: 45, z: 23},
          %PointZ{x: 10, y: 20, z: 33},
          %PointZ{x: 35, y: 10, z: 13}
        ],
        interiors: [[
          %PointZ{x: 20, y: 30, z: 13},
          %PointZ{x: 35, y: 35, z: 23},
          %PointZ{x: 30, y: 20, z: 33},
          %PointZ{x: 20, y: 30, z: 13},
        ]]
      }

      iex> PolygonZ.new([], [])
      %PolygonZ{exterior: [], interiors: []}
  """
  @spec new([PointZ.t()], [[PointZ.t()]]) :: t()
  def new([], []), do: %PolygonZ{}

  def new([_, _, _, _ | _] = exterior, [[_, _, _, _ | _] | _] = interiors),
    do: %PolygonZ{exterior: exterior, interiors: interiors}

  @doc """
  Returns `true` if the given `PolygonZ` is empty.

  ## Examples

      iex> PolygonZ.empty?(PolygonZ.new())
      true

      iex> [[1, 1, 1], [2, 1, 2], [2, 2, 3], [1, 1, 1]]
      ...> |> PolygonZ.from_coordinates()
      ...> |> PolygonZ.empty?()
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PolygonZ{} = polygon), do: Enum.empty?(polygon.exterior)

  @doc """
  Creates a `PolygonZ` from the given coordinates.

  ## Examples

      iex> PolygonZ.from_coordinates([
      ...>   {1, 1, 1},
      ...>   {2, 1, 2},
      ...>   {2, 2, 3},
      ...>   {1, 1, 1}
      ...> ])
      %PolygonZ{
        exterior: [
          %PointZ{x: 1, y: 1, z: 1},
          %PointZ{x: 2, y: 1, z: 2},
          %PointZ{x: 2, y: 2, z: 3},
          %PointZ{x: 1, y: 1, z: 1}
        ],
        interiors: []
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates([[x, y, z] | _] = coordinates) when is_coordinate(x, y, z) do
    %PolygonZ{exterior: Enum.map(coordinates, &PointZ.new/1)}
  end

  def from_coordinates([{x, y, z} | _] = coordinates) when is_coordinate(x, y, z) do
    %PolygonZ{exterior: Enum.map(coordinates, &PointZ.new/1)}
  end

  def from_coordinates([exterior | interiors]) do
    %PolygonZ{
      exterior: Enum.map(exterior, &PointZ.new/1),
      interiors: Enum.map(interiors, fn cs -> Enum.map(cs, &PointZ.new/1) end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonZ` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "Polygon",
      ...>     "coordinates": [
      ...>       [[35, 10, 11],
      ...>        [45, 45, 21],
      ...>        [15, 40, 31],
      ...>        [10, 20, 11],
      ...>        [35, 10, 11]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> PolygonZ.from_geo_json()
      {:ok, %PolygonZ{
        exterior: [
          %PointZ{x: 35, y: 10, z: 11},
          %PointZ{x: 45, y: 45, z: 21},
          %PointZ{x: 15, y: 40, z: 31},
          %PointZ{x: 10, y: 20, z: 11},
          %PointZ{x: 35, y: 10, z: 11}
        ],
        interiors: []
      }}

      iex> ~s(
      ...>   {
      ...>     "type": "Polygon",
      ...>     "coordinates": [
      ...>       [[35, 10, 11],
      ...>        [45, 45, 21],
      ...>        [15, 40, 31],
      ...>        [10, 20, 11],
      ...>        [35, 10, 11]],
      ...>       [[20, 30, 11],
      ...>        [35, 35, 14],
      ...>        [30, 20, 12],
      ...>        [20, 30, 11]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> PolygonZ.from_geo_json()
      {:ok, %PolygonZ{
        exterior: [
          %PointZ{x: 35, y: 10, z: 11},
          %PointZ{x: 45, y: 45, z: 21},
          %PointZ{x: 15, y: 40, z: 31},
          %PointZ{x: 10, y: 20, z: 11},
          %PointZ{x: 35, y: 10, z: 11}
        ],
        interiors: [
          [
            %PointZ{x: 20, y: 30, z: 11},
            %PointZ{x: 35, y: 35, z: 14},
            %PointZ{x: 30, y: 20, z: 12},
            %PointZ{x: 20, y: 30, z: 11}
          ]
        ]
      }}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_polygon(json, PolygonZ)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_polygon(json, PolygonZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `PolygonZ`.

  ## Examples

      iex> PolygonZ.new(
      ...>   [
      ...>     PointZ.new(35, 10, 13),
      ...>     PointZ.new(45, 45, 23),
      ...>     PointZ.new(10, 20, 33),
      ...>     PointZ.new(35, 10, 13)
      ...>   ], [
      ...>     [
      ...>       PointZ.new(20, 30, 13),
      ...>       PointZ.new(35, 35, 23),
      ...>       PointZ.new(30, 20, 33),
      ...>       PointZ.new(20, 30, 13)
      ...>     ]
      ...>   ]
      ...> )
      ...> |> PolygonZ.to_geo_json()
      %{
        "type" => "Polygon",
        "coordinates" => [
          [[35, 10, 13], [45, 45, 23], [10, 20, 33], [35, 10, 13]],
          [[20, 30, 13], [35, 35, 23], [30, 20, 33], [20, 30, 13]]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PolygonZ{exterior: exterior, interiors: interiors}) do
    %{
      "type" => "Polygon",
      "coordinates" => [
        Enum.map(exterior, &PointZ.to_list/1)
        | Enum.map(interiors, fn interior -> Enum.map(interior, &PointZ.to_list/1) end)
      ]
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonZ` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> "
      ...>   POLYGON Z (
      ...>     (35 10 11, 45 45 22, 15 40 33, 10 20 55, 35 10 11),
      ...>     (20 30 22, 35 35 33, 30 20 88, 20 30 22)
      ...>   )
      ...> "
      iex> |> PolygonZ.from_wkt()
      {:ok,
       %PolygonZ{
         exterior: [
           %PointZ{x: 35, y: 10, z: 11},
           %PointZ{x: 45, y: 45, z: 22},
           %PointZ{x: 15, y: 40, z: 33},
           %PointZ{x: 10, y: 20, z: 55},
           %PointZ{x: 35, y: 10, z: 11}
         ],
         interiors: [
           [
             %PointZ{x: 20, y: 30, z: 22},
             %PointZ{x: 35, y: 35, z: 33},
             %PointZ{x: 30, y: 20, z: 88},
             %PointZ{x: 20, y: 30, z: 22}
           ]
         ]
       }}

      iex> "
      ...>   SRID=789;
      ...>   POLYGON Z (
      ...>     (35 10 11, 45 45 22, 15 40 33, 10 20 55, 35 10 11),
      ...>     (20 30 22, 35 35 33, 30 20 88, 20 30 22)
      ...>   )
      ...> "
      iex> |> PolygonZ.from_wkt()
      {:ok,
       %PolygonZ{
         exterior: [
           %PointZ{x: 35, y: 10, z: 11},
           %PointZ{x: 45, y: 45, z: 22},
           %PointZ{x: 15, y: 40, z: 33},
           %PointZ{x: 10, y: 20, z: 55},
           %PointZ{x: 35, y: 10, z: 11}
         ],
         interiors: [
           [
             %PointZ{x: 20, y: 30, z: 22},
             %PointZ{x: 35, y: 35, z: 33},
             %PointZ{x: 30, y: 20, z: 88},
             %PointZ{x: 20, y: 30, z: 22}
           ]
         ]
       }, 789}

      iex> PolygonZ.from_wkt("Polygon Z EMPTY")
      {:ok, %PolygonZ{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, PolygonZ)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, PolygonZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `PolygonZ`. With option `:srid` an
  EWKT representation with the SRID is returned.

  ## Examples

      iex> PolygonZ.to_wkt(PolygonZ.new())
      "Polygon Z EMPTY"

      iex> PolygonZ.to_wkt(PolygonZ.new(), srid: 1123)
      "SRID=1123;Polygon Z EMPTY"

      iex> PolygonZ.new(
      ...>   [
      ...>     PointZ.new(35, 10, 13),
      ...>     PointZ.new(45, 45, 23),
      ...>     PointZ.new(10, 20, 33),
      ...>     PointZ.new(35, 10, 13)
      ...>   ], [
      ...>     [
      ...>       PointZ.new(20, 30, 13),
      ...>       PointZ.new(35, 35, 23),
      ...>       PointZ.new(30, 20, 33),
      ...>       PointZ.new(20, 30, 13)
      ...>     ]
      ...>   ]
      ...> )
      ...> |> PolygonZ.to_wkt()
      "Polygon Z " <>
      "((35 10 13, 45 45 23, 10 20 33, 35 10 13)" <>
      ", (20 30 13, 35 35 23, 30 20 33, 20 30 13))"

  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(polygon, opts \\ [])

  def to_wkt(%PolygonZ{exterior: []}, opts) do
    "EMPTY"
    |> to_wkt_polygon()
    |> WKT.to_ewkt(opts)
  end

  def to_wkt(%PolygonZ{exterior: exterior, interiors: interiors}, opts) do
    exterior
    |> to_wkt_points(interiors)
    |> to_wkt_polygon()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `PolygonZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PolygonZ{} = polygon, opts \\ []) do
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
  Returns an `:ok` tuple with the `PolygonZ` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, PolygonZ)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, PolygonZ) do
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
      |> Enum.map(fn point -> PointZ.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkt_polygon(wkt), do: <<"Polygon Z ", wkt::binary()>>

  defp to_wkb_polygon(%PolygonZ{exterior: exterior, interiors: interiors}, endian) do
    rings = [exterior | interiors]

    data =
      rings
      |> Enum.map(fn ring -> to_wkb_ring(ring, endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(rings, endian)::binary(), data::binary()>>
  end

  defp to_wkb_ring(ring, endian) do
    data = Enum.map(ring, fn coordinate -> PointZ.to_wkb_coordinate(coordinate, endian) end)

    [WKB.length(ring, endian) | data]
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "80000003"
      {:ndr, false} -> "03000080"
      {:xdr, true} -> "A0000003"
      {:ndr, true} -> "030000A0"
    end
  end
end
