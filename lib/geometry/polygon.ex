defmodule Geometry.Polygon do
  @moduledoc """
  A polygon struct, representing a 2D polygon.

  A none empty line-string requires at least one ring with four points.
  """

  import Geometry.Guards

  alias Geometry.{GeoJson, Point, Polygon, WKB, WKT}

  defstruct exterior: [], interiors: []

  @type t :: %Polygon{
          exterior: [Point.t()],
          interiors: [Point.t()]
        }

  @doc """
  Creates an empty `Polygon`.

  ## Examples

      iex> Polygon.new()
      %Polygon{exterior: [], interiors: []}
  """
  @spec new :: t()
  def new, do: %Polygon{}

  @doc """
  Creates a `Polygon` from the given `Geometry.Point`s.

  ## Examples

      iex> Polygon.new([
      ...>   Point.new(11, 12),
      ...>   Point.new(21, 22),
      ...>   Point.new(31, 32),
      ...>   Point.new(41, 42)
      ...> ])
      %Polygon{
        exterior: [
          %Point{x: 11, y: 12},
          %Point{x: 21, y: 22},
          %Point{x: 31, y: 32},
          %Point{x: 41, y: 42}
        ],
        interiors: []
      }

      iex> Polygon.new([])
      %Polygon{exterior: [], interiors: []}
  """
  @spec new([Point.t()]) :: t()
  def new([]), do: %Polygon{}
  def new([_, _, _, _ | _] = exterior), do: %Polygon{exterior: exterior}

  @doc """
  Creates a `Polygon` with holes from the given `Point`s.

  ## Examples
  POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),
  (20 30, 35 35, 30 20, 20 30))
      iex> Polygon.new(
      ...>   [
      ...>     Point.new(35, 10),
      ...>     Point.new(45, 45),
      ...>     Point.new(10, 20),
      ...>     Point.new(35, 10)
      ...>   ], [
      ...>     [
      ...>       Point.new(20, 30),
      ...>       Point.new(35, 35),
      ...>       Point.new(30, 20),
      ...>       Point.new(20, 30)
      ...>     ]
      ...>   ]
      ...> )
      %Polygon{
        exterior: [
          %Point{x: 35, y: 10},
          %Point{x: 45, y: 45},
          %Point{x: 10, y: 20},
          %Point{x: 35, y: 10}
        ],
        interiors: [[
          %Point{x: 20, y: 30},
          %Point{x: 35, y: 35},
          %Point{x: 30, y: 20},
          %Point{x: 20, y: 30},
        ]]
      }

      iex> Polygon.new([], [])
      %Polygon{exterior: [], interiors: []}
  """
  @spec new([Point.t()], [[Point.t()]]) :: t()
  def new([], []), do: %Polygon{}

  def new([_, _, _, _ | _] = exterior, [[_, _, _, _ | _] | _] = interiors),
    do: %Polygon{exterior: exterior, interiors: interiors}

  @doc """
  Returns `true` if the given `Polygon` is empty.

  ## Examples

      iex> Polygon.empty?(Polygon.new())
      true

      iex> [[1, 1], [2, 1], [2, 2], [1, 1]]
      ...> |> Polygon.from_coordinates()
      ...> |> Polygon.empty?()
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%Polygon{} = polygon), do: Enum.empty?(polygon.exterior)

  @doc """
  Creates a `Polygon` from the given coordinates.

  ## Examples

      iex> Polygon.from_coordinates([
      ...>   {1, 1},
      ...>   {2, 1},
      ...>   {2, 2},
      ...>   {1, 1}
      ...> ])
      %Polygon{
        exterior: [
          %Point{x: 1, y: 1},
          %Point{x: 2, y: 1},
          %Point{x: 2, y: 2},
          %Point{x: 1, y: 1}
        ],
        interiors: []
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates([[x, y] | _] = coordinates) when is_coordinate(x, y) do
    %Polygon{exterior: Enum.map(coordinates, &Point.new/1)}
  end

  def from_coordinates([{x, y} | _] = coordinates) when is_coordinate(x, y) do
    %Polygon{exterior: Enum.map(coordinates, &Point.new/1)}
  end

  def from_coordinates([exterior | interiors]) do
    %Polygon{
      exterior: Enum.map(exterior, &Point.new/1),
      interiors: Enum.map(interiors, fn cs -> Enum.map(cs, &Point.new/1) end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `Polygon` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "Polygon",
      ...>     "coordinates": [
      ...>       [[35, 10],
      ...>        [45, 45],
      ...>        [15, 40],
      ...>        [10, 20],
      ...>        [35, 10]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> Polygon.from_geo_json()
      {:ok, %Polygon{
        exterior: [
          %Point{x: 35, y: 10},
          %Point{x: 45, y: 45},
          %Point{x: 15, y: 40},
          %Point{x: 10, y: 20},
          %Point{x: 35, y: 10}
        ],
        interiors: []
      }}

      iex> ~s(
      ...>   {
      ...>     "type": "Polygon",
      ...>     "coordinates": [
      ...>       [[35, 10],
      ...>        [45, 45],
      ...>        [15, 40],
      ...>        [10, 20],
      ...>        [35, 10]],
      ...>       [[20, 30],
      ...>        [35, 35],
      ...>        [30, 20],
      ...>        [20, 30]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> Polygon.from_geo_json()
      {:ok, %Polygon{
        exterior: [
          %Point{x: 35, y: 10},
          %Point{x: 45, y: 45},
          %Point{x: 15, y: 40},
          %Point{x: 10, y: 20},
          %Point{x: 35, y: 10}
        ],
        interiors: [
          [
            %Point{x: 20, y: 30},
            %Point{x: 35, y: 35},
            %Point{x: 30, y: 20},
            %Point{x: 20, y: 30}
          ]
        ]
      }}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_polygon(json, Polygon)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_polygon(json, Polygon) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `Polygon`.

  ## Examples

      iex> Polygon.new(
      ...>   [
      ...>     Point.new(35, 10),
      ...>     Point.new(45, 45),
      ...>     Point.new(10, 20),
      ...>     Point.new(35, 10)
      ...>   ], [
      ...>     [
      ...>       Point.new(20, 30),
      ...>       Point.new(35, 35),
      ...>       Point.new(30, 20),
      ...>       Point.new(20, 30)
      ...>     ]
      ...>   ]
      ...> )
      ...> |> Polygon.to_geo_json()
      %{
        "type" => "Polygon",
        "coordinates" => [
          [[35, 10], [45, 45], [10, 20], [35, 10]],
          [[20, 30], [35, 35], [30, 20], [20, 30]]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%Polygon{exterior: exterior, interiors: interiors}) do
    %{
      "type" => "Polygon",
      "coordinates" => [
        Enum.map(exterior, &Point.to_list/1)
        | Enum.map(interiors, fn interior -> Enum.map(interior, &Point.to_list/1) end)
      ]
    }
  end

  @doc """
  Returns an `:ok` tuple with the `Polygon` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> "
      ...>   POLYGON (
      ...>     (35 10, 45 45, 15 40, 10 20, 35 10),
      ...>     (20 30, 35 35, 30 20, 20 30)
      ...>   )
      ...> "
      iex> |> Polygon.from_wkt()
      {:ok,
       %Polygon{
         exterior: [
           %Point{x: 35, y: 10},
           %Point{x: 45, y: 45},
           %Point{x: 15, y: 40},
           %Point{x: 10, y: 20},
           %Point{x: 35, y: 10}
         ],
         interiors: [
           [
             %Point{x: 20, y: 30},
             %Point{x: 35, y: 35},
             %Point{x: 30, y: 20},
             %Point{x: 20, y: 30}
           ]
         ]
       }}

      iex> "
      ...>   SRID=789;
      ...>   POLYGON (
      ...>     (35 10, 45 45, 15 40, 10 20, 35 10),
      ...>     (20 30, 35 35, 30 20, 20 30)
      ...>   )
      ...> "
      iex> |> Polygon.from_wkt()
      {:ok,
       %Polygon{
         exterior: [
           %Point{x: 35, y: 10},
           %Point{x: 45, y: 45},
           %Point{x: 15, y: 40},
           %Point{x: 10, y: 20},
           %Point{x: 35, y: 10}
         ],
         interiors: [
           [
             %Point{x: 20, y: 30},
             %Point{x: 35, y: 35},
             %Point{x: 30, y: 20},
             %Point{x: 20, y: 30}
           ]
         ]
       }, 789}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, Polygon)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, Polygon) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `Polygon`. With option `:srid` an
  EWKT representation with the SRID is returned.

  ## Examples

      iex> Polygon.to_wkt(Polygon.new())
      "Polygon EMPTY"

      iex> Polygon.to_wkt(Polygon.new(), srid: 1123)
      "SRID=1123;Polygon EMPTY"

      iex> Polygon.new(
      ...>   [
      ...>     Point.new(35, 10),
      ...>     Point.new(45, 45),
      ...>     Point.new(10, 20),
      ...>     Point.new(35, 10)
      ...>   ], [
      ...>     [
      ...>       Point.new(20, 30),
      ...>       Point.new(35, 35),
      ...>       Point.new(30, 20),
      ...>       Point.new(20, 30)
      ...>     ]
      ...>   ]
      ...> )
      ...> |> Polygon.to_wkt()
      "Polygon " <>
      "((35 10, 45 45, 10 20, 35 10)" <>
      ", (20 30, 35 35, 30 20, 20 30))"

  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(polygon, opts \\ [])

  def to_wkt(%Polygon{exterior: []}, opts) do
    "EMPTY"
    |> to_wkt_polygon()
    |> WKT.to_ewkt(opts)
  end

  def to_wkt(%Polygon{exterior: exterior, interiors: interiors}, opts) do
    exterior
    |> to_wkt_points(interiors)
    |> to_wkt_polygon()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `Polygon`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%Polygon{} = polygon, opts \\ []) do
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
  Returns an `:ok` tuple with the `Polygon` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, Polygon)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, Polygon) do
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
      |> Enum.map(fn point -> Point.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkt_polygon(wkt), do: <<"Polygon ", wkt::binary()>>

  defp to_wkb_polygon(%Polygon{exterior: exterior, interiors: interiors}, endian) do
    rings = [exterior | interiors]

    data =
      rings
      |> Enum.map(fn ring -> to_wkb_ring(ring, endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(rings, endian)::binary(), data::binary()>>
  end

  defp to_wkb_ring(ring, endian) do
    data = Enum.map(ring, fn coordinate -> Point.to_wkb_coordinate(coordinate, endian) end)

    [WKB.length(ring, endian) | data]
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "00000003"
      {:ndr, false} -> "03000000"
      {:xdr, true} -> "20000003"
      {:ndr, true} -> "03000020"
    end
  end
end
