defmodule Geometry.PolygonM do
  @moduledoc """
  A polygon struct, representing a 2D polygon with a measurement.

  A none empty line-string requires at least one ring with four points.
  """

  alias Geometry.{GeoJson, LineStringM, PolygonM, WKB, WKT}

  defstruct rings: []

  @type t :: %PolygonM{rings: [Geometry.coordinates()]}

  @doc """
  Creates an empty `PolygonM`.

  ## Examples

      iex> PolygonM.new()
      %PolygonM{rings: []}
  """
  @spec new :: t()
  def new, do: %PolygonM{}

  @doc """
  Creates a `PolygonM` from the given `rings`.

  ## Examples

      iex> PolygonM.new([
      ...>   LineStringM.new([
      ...>     PointM.new(35, 10, 14),
      ...>     PointM.new(45, 45, 24),
      ...>     PointM.new(10, 20, 34),
      ...>     PointM.new(35, 10, 14)
      ...>   ]),
      ...>   LineStringM.new([
      ...>     PointM.new(20, 30, 14),
      ...>     PointM.new(35, 35, 24),
      ...>     PointM.new(30, 20, 34),
      ...>     PointM.new(20, 30, 14)
      ...>   ])
      ...> ])
      %PolygonM{
        rings: [
          [[35, 10, 14], [45, 45, 24], [10, 20, 34], [35, 10, 14]],
          [[20, 30, 14], [35, 35, 24], [30, 20, 34], [20, 30, 14]]
        ]
      }

      iex> PolygonM.new()
      %PolygonM{}
  """
  @spec new([LineStringM.t()]) :: t()
  def new(rings) when is_list(rings) do
    %PolygonM{rings: Enum.map(rings, fn line_string -> line_string.points end)}
  end

  @doc """
  Returns `true` if the given `PolygonM` is empty.

  ## Examples

      iex> PolygonM.empty?(PolygonM.new())
      true

      iex> PolygonM.empty?(
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(35, 10, 14),
      ...>       PointM.new(45, 45, 24),
      ...>       PointM.new(10, 20, 34),
      ...>       PointM.new(35, 10, 14)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PolygonM{rings: rings}), do: Enum.empty?(rings)

  @doc """
  Creates a `PolygonM` from the given coordinates.

  ## Examples

      iex> PolygonM.from_coordinates([
      ...>   [[1, 1, 1], [2, 1, 3], [2, 2, 2], [1, 1, 1]]
      ...> ])
      %PolygonM{
        rings: [
          [[1, 1, 1], [2, 1, 3], [2, 2, 2], [1, 1, 1]]
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(rings) when is_list(rings), do: %PolygonM{rings: rings}

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
        rings: [
          [
            [35, 10, 12],
            [45, 45, 22],
            [15, 40, 33],
            [10, 20, 55],
            [35, 10, 12]
          ]
        ]
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
        rings: [[
          [35, 10, 12],
          [45, 45, 22],
          [15, 40, 33],
          [10, 20, 55],
          [35, 10, 12]
        ], [
          [20, 30, 11],
          [35, 35, 55],
          [30, 20, 45],
          [20, 30, 11]
        ]]
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

      iex> PolygonM.to_geo_json(
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(35, 10, 14),
      ...>       PointM.new(45, 45, 24),
      ...>       PointM.new(10, 20, 34),
      ...>       PointM.new(35, 10, 14)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(20, 30, 14),
      ...>       PointM.new(35, 35, 24),
      ...>       PointM.new(30, 20, 34),
      ...>       PointM.new(20, 30, 14)
      ...>     ])
      ...>   ])
      ...> )
      %{
        "type" => "Polygon",
        "coordinates" => [
          [
            [35, 10, 14],
            [45, 45, 24],
            [10, 20, 34],
            [35, 10, 14]
          ], [
            [20, 30, 14],
            [35, 35, 24],
            [30, 20, 34],
            [20, 30, 14]
          ]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PolygonM{rings: rings}) do
    %{
      "type" => "Polygon",
      "coordinates" => rings
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PolygonM.from_wkt("
      ...>   POLYGON M (
      ...>     (35 10 22, 45 45 33, 15 40 44, 10 20 66, 35 10 22),
      ...>     (20 30 55, 35 35 66, 30 20 99, 20 30 55)
      ...>   )
      ...> ")
      {:ok,
       %PolygonM{
         rings: [
           [
             [35, 10, 22],
             [45, 45, 33],
             [15, 40, 44],
             [10, 20, 66],
             [35, 10, 22]
           ], [
             [20, 30, 55],
             [35, 35, 66],
             [30, 20, 99],
             [20, 30, 55]
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
         rings: [
           [
             [35, 10, 22],
             [45, 45, 33],
             [15, 40, 44],
             [10, 20, 66],
             [35, 10, 22]
           ], [
             [20, 30, 55],
             [35, 35, 66],
             [30, 20, 99],
             [20, 30, 55]
           ]
         ]
       }, 789}

      iex> PolygonM.from_wkt("Polygon M EMPTY")
      {:ok, %PolygonM{}}
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

      iex> PolygonM.to_wkt(
      ...>   PolygonM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(35, 10, 14),
      ...>       PointM.new(45, 45, 24),
      ...>       PointM.new(10, 20, 34),
      ...>       PointM.new(35, 10, 14)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(20, 30, 14),
      ...>       PointM.new(35, 35, 24),
      ...>       PointM.new(30, 20, 34),
      ...>       PointM.new(20, 30, 14)
      ...>     ])
      ...>   ])
      ...> )
      "Polygon M ((35 10 14, 45 45 24, 10 20 34, 35 10 14), (20 30 14, 35 35 24, 30 20 34, 20 30 14))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%PolygonM{rings: rings}, opts \\ []) do
    WKT.to_ewkt(<<"Polygon M ", to_wkt_rings(rings)::binary()>>, opts)
  end

  @doc """
  Returns the WKB representation for a `PolygonM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(t()[[Geometry.coordinates()]], opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PolygonM{rings: rings}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    to_wkb(rings, srid, endian)
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

  @doc false
  @compile {:inline, to_wkt_rings: 1}
  @spec to_wkt_rings(list()) :: String.t()
  def to_wkt_rings([]), do: "EMPTY"

  def to_wkt_rings([ring | rings]) do
    <<
      "(",
      LineStringM.to_wkt_points(ring)::binary(),
      Enum.reduce(rings, "", fn ring, acc ->
        <<acc::binary(), ", ", LineStringM.to_wkt_points(ring)::binary()>>
      end)::binary(),
      ")"
    >>
  end

  @doc false
  @compile {:inline, to_wkb: 3}
  @spec to_wkb([Geometry.coordinates()], Geometry.srid() | nil, Geometry.endian()) ::
          Geometry.wkb()
  def to_wkb(rings, srid, endian) do
    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_rings(rings, endian)::binary()
    >>
  end

  @compile {:inline, to_wkb_rings: 2}
  defp to_wkb_rings(rings, endian) do
    Enum.reduce(rings, WKB.length(rings, endian), fn ring, acc ->
      <<acc::binary(), LineStringM.to_wkb_points(ring, endian)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "40000003"
      {:ndr, false} -> "03000040"
      {:xdr, true} -> "60000003"
      {:ndr, true} -> "03000060"
    end
  end
end
