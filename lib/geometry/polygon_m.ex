defmodule Geometry.PolygonM do
  @moduledoc """
  A polygon struct, representing a 2D polygon with a measurement.

  A none empty line-string requires at least one ring with four points.
  """

  import Geometry.Guards

  alias Geometry.{GeoJson, PointM, PolygonM, WKB, WKT}

  defstruct exterior: [], interiors: []

  @type t :: %PolygonM{
          exterior: [PointM.t()],
          interiors: [PointM.t()]
        }

  @doc """
  Creates an empty `PolygonM`.

  ## Examples

      iex> PolygonM.new()
      %PolygonM{exterior: [], interiors: []}
  """
  @spec new :: t()
  def new, do: %PolygonM{}

  @doc """
  Creates a `PolygonM` from the given `Geometry.PointM`s.

  ## Examples

      iex> PolygonM.new([
      ...>   PointM.new(11, 12, 14),
      ...>   PointM.new(21, 22, 24),
      ...>   PointM.new(31, 32, 34),
      ...>   PointM.new(41, 42, 44)
      ...> ])
      %PolygonM{
        exterior: [
          %PointM{x: 11, y: 12, m: 14},
          %PointM{x: 21, y: 22, m: 24},
          %PointM{x: 31, y: 32, m: 34},
          %PointM{x: 41, y: 42, m: 44}
        ],
        interiors: []
      }

      iex> PolygonM.new([])
      %PolygonM{exterior: [], interiors: []}
  """
  @spec new([PointM.t()]) :: t()
  def new([]), do: %PolygonM{}
  def new([_, _, _, _ | _] = exterior), do: %PolygonM{exterior: exterior}

  @doc """
  Creates a `PolygonM` with holes from the given `PointM`s.

  ## Examples
  POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),
  (20 30, 35 35, 30 20, 20 30))
      iex> PolygonM.new(
      ...>   [
      ...>     PointM.new(35, 10, 14),
      ...>     PointM.new(45, 45, 24),
      ...>     PointM.new(10, 20, 34),
      ...>     PointM.new(35, 10, 14)
      ...>   ], [
      ...>     [
      ...>       PointM.new(20, 30, 14),
      ...>       PointM.new(35, 35, 24),
      ...>       PointM.new(30, 20, 34),
      ...>       PointM.new(20, 30, 14)
      ...>     ]
      ...>   ]
      ...> )
      %PolygonM{
        exterior: [
          %PointM{x: 35, y: 10, m: 14},
          %PointM{x: 45, y: 45, m: 24},
          %PointM{x: 10, y: 20, m: 34},
          %PointM{x: 35, y: 10, m: 14}
        ],
        interiors: [[
          %PointM{x: 20, y: 30, m: 14},
          %PointM{x: 35, y: 35, m: 24},
          %PointM{x: 30, y: 20, m: 34},
          %PointM{x: 20, y: 30, m: 14},
        ]]
      }

      iex> PolygonM.new([], [])
      %PolygonM{exterior: [], interiors: []}
  """
  @spec new([PointM.t()], [[PointM.t()]]) :: t()
  def new([], []), do: %PolygonM{}

  def new([_, _, _, _ | _] = exterior, [[_, _, _, _ | _] | _] = interiors),
    do: %PolygonM{exterior: exterior, interiors: interiors}

  @doc """
  Returns `true` if the given `PolygonM` is empty.

  ## Examples

      iex> PolygonM.empty?(PolygonM.new())
      true

      iex> [[1, 1, 1], [2, 1, 3], [2, 2, 2], [1, 1, 1]]
      ...> |> PolygonM.from_coordinates()
      ...> |> PolygonM.empty?()
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PolygonM{} = polygon), do: Enum.empty?(polygon.exterior)

  @doc """
  Creates a `PolygonM` from the given coordinates.

  ## Examples

      iex> PolygonM.from_coordinates([
      ...>   {1, 1, 1},
      ...>   {2, 1, 3},
      ...>   {2, 2, 2},
      ...>   {1, 1, 1}
      ...> ])
      %PolygonM{
        exterior: [
          %PointM{x: 1, y: 1, m: 1},
          %PointM{x: 2, y: 1, m: 3},
          %PointM{x: 2, y: 2, m: 2},
          %PointM{x: 1, y: 1, m: 1}
        ],
        interiors: []
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates([[x, y, m] | _] = coordinates) when is_coordinate(x, y, m) do
    %PolygonM{exterior: Enum.map(coordinates, &PointM.new/1)}
  end

  def from_coordinates([{x, y, m} | _] = coordinates) when is_coordinate(x, y, m) do
    %PolygonM{exterior: Enum.map(coordinates, &PointM.new/1)}
  end

  def from_coordinates([exterior | interiors]) do
    %PolygonM{
      exterior: Enum.map(exterior, &PointM.new/1),
      interiors: Enum.map(interiors, fn cs -> Enum.map(cs, &PointM.new/1) end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "Polygon",
      ...>     "coordinates": [
      ...>       [[35, 10, 12],
      ...>        [45, 45, 22],
      ...>        [15, 40, 33],
      ...>        [10, 20, 55],
      ...>        [35, 10, 12]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> PolygonM.from_geo_json()
      {:ok, %PolygonM{
        exterior: [
          %PointM{x: 35, y: 10, m: 12},
          %PointM{x: 45, y: 45, m: 22},
          %PointM{x: 15, y: 40, m: 33},
          %PointM{x: 10, y: 20, m: 55},
          %PointM{x: 35, y: 10, m: 12}
        ],
        interiors: []
      }}

      iex> ~s(
      ...>   {
      ...>     "type": "Polygon",
      ...>     "coordinates": [
      ...>       [[35, 10, 12],
      ...>        [45, 45, 22],
      ...>        [15, 40, 33],
      ...>        [10, 20, 55],
      ...>        [35, 10, 12]],
      ...>       [[20, 30, 11],
      ...>        [35, 35, 55],
      ...>        [30, 20, 45],
      ...>        [20, 30, 11]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> PolygonM.from_geo_json()
      {:ok, %PolygonM{
        exterior: [
          %PointM{x: 35, y: 10, m: 12},
          %PointM{x: 45, y: 45, m: 22},
          %PointM{x: 15, y: 40, m: 33},
          %PointM{x: 10, y: 20, m: 55},
          %PointM{x: 35, y: 10, m: 12}
        ],
        interiors: [
          [
            %PointM{x: 20, y: 30, m: 11},
            %PointM{x: 35, y: 35, m: 55},
            %PointM{x: 30, y: 20, m: 45},
            %PointM{x: 20, y: 30, m: 11}
          ]
        ]
      }}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_polygon(json, PolygonM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_polygon(json, PolygonM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `PolygonM`.

  ## Examples

      iex> PolygonM.new(
      ...>   [
      ...>     PointM.new(35, 10, 14),
      ...>     PointM.new(45, 45, 24),
      ...>     PointM.new(10, 20, 34),
      ...>     PointM.new(35, 10, 14)
      ...>   ], [
      ...>     [
      ...>       PointM.new(20, 30, 14),
      ...>       PointM.new(35, 35, 24),
      ...>       PointM.new(30, 20, 34),
      ...>       PointM.new(20, 30, 14)
      ...>     ]
      ...>   ]
      ...> )
      ...> |> PolygonM.to_geo_json()
      %{
        "type" => "Polygon",
        "coordinates" => [
          [[35, 10, 14], [45, 45, 24], [10, 20, 34], [35, 10, 14]],
          [[20, 30, 14], [35, 35, 24], [30, 20, 34], [20, 30, 14]]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PolygonM{exterior: exterior, interiors: interiors}) do
    %{
      "type" => "Polygon",
      "coordinates" => [
        Enum.map(exterior, &PointM.to_list/1)
        | Enum.map(interiors, fn interior -> Enum.map(interior, &PointM.to_list/1) end)
      ]
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> "
      ...>   POLYGON M (
      ...>     (35 10 22, 45 45 33, 15 40 44, 10 20 66, 35 10 22),
      ...>     (20 30 55, 35 35 66, 30 20 99, 20 30 55)
      ...>   )
      ...> "
      iex> |> PolygonM.from_wkt()
      {:ok,
       %PolygonM{
         exterior: [
           %PointM{x: 35, y: 10, m: 22},
           %PointM{x: 45, y: 45, m: 33},
           %PointM{x: 15, y: 40, m: 44},
           %PointM{x: 10, y: 20, m: 66},
           %PointM{x: 35, y: 10, m: 22}
         ],
         interiors: [
           [
             %PointM{x: 20, y: 30, m: 55},
             %PointM{x: 35, y: 35, m: 66},
             %PointM{x: 30, y: 20, m: 99},
             %PointM{x: 20, y: 30, m: 55}
           ]
         ]
       }}

      iex> "
      ...>   SRID=789;
      ...>   POLYGON M (
      ...>     (35 10 22, 45 45 33, 15 40 44, 10 20 66, 35 10 22),
      ...>     (20 30 55, 35 35 66, 30 20 99, 20 30 55)
      ...>   )
      ...> "
      iex> |> PolygonM.from_wkt()
      {:ok,
       %PolygonM{
         exterior: [
           %PointM{x: 35, y: 10, m: 22},
           %PointM{x: 45, y: 45, m: 33},
           %PointM{x: 15, y: 40, m: 44},
           %PointM{x: 10, y: 20, m: 66},
           %PointM{x: 35, y: 10, m: 22}
         ],
         interiors: [
           [
             %PointM{x: 20, y: 30, m: 55},
             %PointM{x: 35, y: 35, m: 66},
             %PointM{x: 30, y: 20, m: 99},
             %PointM{x: 20, y: 30, m: 55}
           ]
         ]
       }, 789}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, PolygonM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, PolygonM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `PolygonM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  ## Examples

      iex> PolygonM.to_wkt(PolygonM.new())
      "Polygon M EMPTY"

      iex> PolygonM.to_wkt(PolygonM.new(), srid: 1123)
      "SRID=1123;Polygon M EMPTY"

      iex> PolygonM.new(
      ...>   [
      ...>     PointM.new(35, 10, 14),
      ...>     PointM.new(45, 45, 24),
      ...>     PointM.new(10, 20, 34),
      ...>     PointM.new(35, 10, 14)
      ...>   ], [
      ...>     [
      ...>       PointM.new(20, 30, 14),
      ...>       PointM.new(35, 35, 24),
      ...>       PointM.new(30, 20, 34),
      ...>       PointM.new(20, 30, 14)
      ...>     ]
      ...>   ]
      ...> )
      ...> |> PolygonM.to_wkt()
      "Polygon M " <>
      "((35 10 14, 45 45 24, 10 20 34, 35 10 14)" <>
      ", (20 30 14, 35 35 24, 30 20 34, 20 30 14))"

  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(polygon, opts \\ [])

  def to_wkt(%PolygonM{exterior: []}, opts) do
    "EMPTY"
    |> to_wkt_polygon()
    |> WKT.to_ewkt(opts)
  end

  def to_wkt(%PolygonM{exterior: exterior, interiors: interiors}, opts) do
    exterior
    |> to_wkt_points(interiors)
    |> to_wkt_polygon()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `PolygonM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PolygonM{} = polygon, opts \\ []) do
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
  Returns an `:ok` tuple with the `PolygonM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, PolygonM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, PolygonM) do
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
      |> Enum.map(fn point -> PointM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkt_polygon(wkt), do: <<"Polygon M ", wkt::binary()>>

  defp to_wkb_polygon(%PolygonM{exterior: exterior, interiors: interiors}, endian) do
    rings = [exterior | interiors]

    data =
      rings
      |> Enum.map(fn ring -> to_wkb_ring(ring, endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(rings, endian)::binary(), data::binary()>>
  end

  defp to_wkb_ring(ring, endian) do
    data = Enum.map(ring, fn coordinate -> PointM.to_wkb_coordinate(coordinate, endian) end)

    [WKB.length(ring, endian) | data]
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "40000003"
      {:ndr, false} -> "03000040"
      {:xdr, true} -> "60000003"
      {:ndr, true} -> "03000060"
    end
  end
end
