defmodule Geometry.PolygonZ do
  @moduledoc """
  A polygon struct, representing a 3D polygon.

  A none empty line-string requires at least one ring with four points.
  """

  alias Geometry.{GeoJson, LineStringZ, PolygonZ, WKB, WKT}

  defstruct rings: []

  @type t :: %PolygonZ{rings: [Geometry.coordinates()]}

  @doc """
  Creates an empty `PolygonZ`.

  ## Examples

      iex> PolygonZ.new()
      %PolygonZ{rings: []}
  """
  @spec new :: t()
  def new, do: %PolygonZ{}

  @doc """
  Creates a `PolygonZ` from the given `rings`.

  ## Examples

      iex> PolygonZ.new([
      ...>   LineStringZ.new([
      ...>     PointZ.new(35, 10, 13),
      ...>     PointZ.new(45, 45, 23),
      ...>     PointZ.new(10, 20, 33),
      ...>     PointZ.new(35, 10, 13)
      ...>   ]),
      ...>   LineStringZ.new([
      ...>     PointZ.new(20, 30, 13),
      ...>     PointZ.new(35, 35, 23),
      ...>     PointZ.new(30, 20, 33),
      ...>     PointZ.new(20, 30, 13)
      ...>   ])
      ...> ])
      %PolygonZ{
        rings: [
          [[35, 10, 13], [45, 45, 23], [10, 20, 33], [35, 10, 13]],
          [[20, 30, 13], [35, 35, 23], [30, 20, 33], [20, 30, 13]]
        ]
      }

      iex> PolygonZ.new()
      %PolygonZ{}
  """
  @spec new([LineStringZ.t()]) :: t()
  def new(rings) when is_list(rings) do
    %PolygonZ{rings: Enum.map(rings, fn line_string -> line_string.points end)}
  end

  @doc """
  Returns `true` if the given `PolygonZ` is empty.

  ## Examples

      iex> PolygonZ.empty?(PolygonZ.new())
      true

      iex> PolygonZ.empty?(
      ...>   PolygonZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(35, 10, 13),
      ...>       PointZ.new(45, 45, 23),
      ...>       PointZ.new(10, 20, 33),
      ...>       PointZ.new(35, 10, 13)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PolygonZ{rings: rings}), do: Enum.empty?(rings)

  @doc """
  Creates a `PolygonZ` from the given coordinates.

  ## Examples

      iex> PolygonZ.from_coordinates([
      ...>   [[1, 1, 1], [2, 1, 2], [2, 2, 3], [1, 1, 1]]
      ...> ])
      %PolygonZ{
        rings: [
          [[1, 1, 1], [2, 1, 2], [2, 2, 3], [1, 1, 1]]
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(rings) when is_list(rings), do: %PolygonZ{rings: rings}

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
        rings: [
          [
            [35, 10, 11],
            [45, 45, 21],
            [15, 40, 31],
            [10, 20, 11],
            [35, 10, 11]
          ]
        ]
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
        rings: [[
          [35, 10, 11],
          [45, 45, 21],
          [15, 40, 31],
          [10, 20, 11],
          [35, 10, 11]
        ], [
          [20, 30, 11],
          [35, 35, 14],
          [30, 20, 12],
          [20, 30, 11]
        ]]
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

      iex> PolygonZ.to_geo_json(
      ...>   PolygonZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(35, 10, 13),
      ...>       PointZ.new(45, 45, 23),
      ...>       PointZ.new(10, 20, 33),
      ...>       PointZ.new(35, 10, 13)
      ...>     ]),
      ...>     LineStringZ.new([
      ...>       PointZ.new(20, 30, 13),
      ...>       PointZ.new(35, 35, 23),
      ...>       PointZ.new(30, 20, 33),
      ...>       PointZ.new(20, 30, 13)
      ...>     ])
      ...>   ])
      ...> )
      %{
        "type" => "Polygon",
        "coordinates" => [
          [
            [35, 10, 13],
            [45, 45, 23],
            [10, 20, 33],
            [35, 10, 13]
          ], [
            [20, 30, 13],
            [35, 35, 23],
            [30, 20, 33],
            [20, 30, 13]
          ]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PolygonZ{rings: rings}) do
    %{
      "type" => "Polygon",
      "coordinates" => rings
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonZ` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PolygonZ.from_wkt("
      ...>   POLYGON Z (
      ...>     (35 10 11, 45 45 22, 15 40 33, 10 20 55, 35 10 11),
      ...>     (20 30 22, 35 35 33, 30 20 88, 20 30 22)
      ...>   )
      ...> ")
      {:ok,
       %PolygonZ{
         rings: [
           [
             [35, 10, 11],
             [45, 45, 22],
             [15, 40, 33],
             [10, 20, 55],
             [35, 10, 11]
           ], [
             [20, 30, 22],
             [35, 35, 33],
             [30, 20, 88],
             [20, 30, 22]
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
         rings: [
           [
             [35, 10, 11],
             [45, 45, 22],
             [15, 40, 33],
             [10, 20, 55],
             [35, 10, 11]
           ], [
             [20, 30, 22],
             [35, 35, 33],
             [30, 20, 88],
             [20, 30, 22]
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

      iex> PolygonZ.to_wkt(
      ...>   PolygonZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(35, 10, 13),
      ...>       PointZ.new(45, 45, 23),
      ...>       PointZ.new(10, 20, 33),
      ...>       PointZ.new(35, 10, 13)
      ...>     ]),
      ...>     LineStringZ.new([
      ...>       PointZ.new(20, 30, 13),
      ...>       PointZ.new(35, 35, 23),
      ...>       PointZ.new(30, 20, 33),
      ...>       PointZ.new(20, 30, 13)
      ...>     ])
      ...>   ])
      ...> )
      "Polygon Z ((35 10 13, 45 45 23, 10 20 33, 35 10 13), (20 30 13, 35 35 23, 30 20 33, 20 30 13))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%PolygonZ{rings: rings}, opts \\ []) do
    WKT.to_ewkt(<<"Polygon Z ", to_wkt_rings(rings)::binary()>>, opts)
  end

  @doc """
  Returns the WKB representation for a `PolygonZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%PolygonZ{rings: rings}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(rings, srid, endian, mode)
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

  @doc false
  @compile {:inline, to_wkt_rings: 1}
  @spec to_wkt_rings(list()) :: String.t()
  def to_wkt_rings([]), do: "EMPTY"

  def to_wkt_rings([ring | rings]) do
    <<
      "(",
      LineStringZ.to_wkt_points(ring)::binary(),
      Enum.reduce(rings, "", fn ring, acc ->
        <<acc::binary(), ", ", LineStringZ.to_wkt_points(ring)::binary()>>
      end)::binary(),
      ")"
    >>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(coordinates, srid, endian, mode) :: wkb
        when coordinates: [Geometry.coordinates()],
             srid: Geometry.srid() | nil,
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb(rings, srid, endian, mode) do
    <<
      WKB.byte_order(endian, mode)::binary(),
      wkb_code(endian, not is_nil(srid), mode)::binary(),
      WKB.srid(srid, endian, mode)::binary(),
      to_wkb_rings(rings, endian, mode)::binary()
    >>
  end

  @compile {:inline, to_wkb_rings: 3}
  defp to_wkb_rings(rings, endian, mode) do
    Enum.reduce(rings, WKB.length(rings, endian, mode), fn ring, acc ->
      <<acc::binary(), LineStringZ.to_wkb_points(ring, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "80000003"
      {:ndr, false} -> "03000080"
      {:xdr, true} -> "A0000003"
      {:ndr, true} -> "030000A0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x80000003::big-integer-size(32)>>
      {:ndr, false} -> <<0x80000003::little-integer-size(32)>>
      {:xdr, true} -> <<0xA0000003::big-integer-size(32)>>
      {:ndr, true} -> <<0xA0000003::little-integer-size(32)>>
    end
  end
end
