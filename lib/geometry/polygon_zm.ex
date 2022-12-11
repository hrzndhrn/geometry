defmodule Geometry.PolygonZM do
  @moduledoc """
  A polygon struct, representing a 3D polygon with a measurement.

  A none empty line-string requires at least one ring with four points.
  """

  alias Geometry.{GeoJson, LineStringZM, PolygonZM, WKB, WKT}

  defstruct rings: []

  @type t :: %PolygonZM{rings: [Geometry.coordinates()]}

  @doc """
  Creates an empty `PolygonZM`.

  ## Examples

      iex> PolygonZM.new()
      %PolygonZM{rings: []}
  """
  @spec new :: t()
  def new, do: %PolygonZM{}

  @doc """
  Creates a `PolygonZM` from the given `rings`.

  ## Examples

      iex> PolygonZM.new([
      ...>   LineStringZM.new([
      ...>     PointZM.new(35, 10, 13, 14),
      ...>     PointZM.new(45, 45, 23, 24),
      ...>     PointZM.new(10, 20, 33, 34),
      ...>     PointZM.new(35, 10, 13, 14)
      ...>   ]),
      ...>   LineStringZM.new([
      ...>     PointZM.new(20, 30, 13, 14),
      ...>     PointZM.new(35, 35, 23, 24),
      ...>     PointZM.new(30, 20, 33, 34),
      ...>     PointZM.new(20, 30, 13, 14)
      ...>   ])
      ...> ])
      %PolygonZM{
        rings: [
          [[35, 10, 13, 14], [45, 45, 23, 24], [10, 20, 33, 34], [35, 10, 13, 14]],
          [[20, 30, 13, 14], [35, 35, 23, 24], [30, 20, 33, 34], [20, 30, 13, 14]]
        ]
      }

      iex> PolygonZM.new()
      %PolygonZM{}
  """
  @spec new([LineStringZM.t()]) :: t()
  def new(rings) when is_list(rings) do
    %PolygonZM{rings: Enum.map(rings, fn line_string -> line_string.points end)}
  end

  @doc """
  Returns `true` if the given `PolygonZM` is empty.

  ## Examples

      iex> PolygonZM.empty?(PolygonZM.new())
      true

      iex> PolygonZM.empty?(
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(35, 10, 13, 14),
      ...>       PointZM.new(45, 45, 23, 24),
      ...>       PointZM.new(10, 20, 33, 34),
      ...>       PointZM.new(35, 10, 13, 14)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PolygonZM{rings: rings}), do: Enum.empty?(rings)

  @doc """
  Creates a `PolygonZM` from the given coordinates.

  ## Examples

      iex> PolygonZM.from_coordinates([
      ...>   [[1, 1, 1, 1], [2, 1, 2, 3], [2, 2, 3, 2], [1, 1, 1, 1]]
      ...> ])
      %PolygonZM{
        rings: [
          [[1, 1, 1, 1], [2, 1, 2, 3], [2, 2, 3, 2], [1, 1, 1, 1]]
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(rings) when is_list(rings), do: %PolygonZM{rings: rings}

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
        rings: [
          [
            [35, 10, 11, 12],
            [45, 45, 21, 22],
            [15, 40, 31, 33],
            [10, 20, 11, 55],
            [35, 10, 11, 12]
          ]
        ]
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
        rings: [[
          [35, 10, 11, 12],
          [45, 45, 21, 22],
          [15, 40, 31, 33],
          [10, 20, 11, 55],
          [35, 10, 11, 12]
        ], [
          [20, 30, 11, 11],
          [35, 35, 14, 55],
          [30, 20, 12, 45],
          [20, 30, 11, 11]
        ]]
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

      iex> PolygonZM.to_geo_json(
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(35, 10, 13, 14),
      ...>       PointZM.new(45, 45, 23, 24),
      ...>       PointZM.new(10, 20, 33, 34),
      ...>       PointZM.new(35, 10, 13, 14)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(20, 30, 13, 14),
      ...>       PointZM.new(35, 35, 23, 24),
      ...>       PointZM.new(30, 20, 33, 34),
      ...>       PointZM.new(20, 30, 13, 14)
      ...>     ])
      ...>   ])
      ...> )
      %{
        "type" => "Polygon",
        "coordinates" => [
          [
            [35, 10, 13, 14],
            [45, 45, 23, 24],
            [10, 20, 33, 34],
            [35, 10, 13, 14]
          ], [
            [20, 30, 13, 14],
            [35, 35, 23, 24],
            [30, 20, 33, 34],
            [20, 30, 13, 14]
          ]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PolygonZM{rings: rings}) do
    %{
      "type" => "Polygon",
      "coordinates" => rings
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonZM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PolygonZM.from_wkt("
      ...>   POLYGON ZM (
      ...>     (35 10 11 22, 45 45 22 33, 15 40 33 44, 10 20 55 66, 35 10 11 22),
      ...>     (20 30 22 55, 35 35 33 66, 30 20 88 99, 20 30 22 55)
      ...>   )
      ...> ")
      {:ok,
       %PolygonZM{
         rings: [
           [
             [35, 10, 11, 22],
             [45, 45, 22, 33],
             [15, 40, 33, 44],
             [10, 20, 55, 66],
             [35, 10, 11, 22]
           ], [
             [20, 30, 22, 55],
             [35, 35, 33, 66],
             [30, 20, 88, 99],
             [20, 30, 22, 55]
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
      {:ok, {
        %PolygonZM{
          rings: [
            [
              [35, 10, 11, 22],
              [45, 45, 22, 33],
              [15, 40, 33, 44],
              [10, 20, 55, 66],
              [35, 10, 11, 22]
            ], [
              [20, 30, 22, 55],
              [35, 35, 33, 66],
              [30, 20, 88, 99],
              [20, 30, 22, 55]
            ]
          ]
        },
        789
      }}

      iex> PolygonZM.from_wkt("Polygon ZM EMPTY")
      {:ok, %PolygonZM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, PolygonZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, PolygonZM) do
      {:ok, geometry} -> geometry
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

      iex> PolygonZM.to_wkt(
      ...>   PolygonZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(35, 10, 13, 14),
      ...>       PointZM.new(45, 45, 23, 24),
      ...>       PointZM.new(10, 20, 33, 34),
      ...>       PointZM.new(35, 10, 13, 14)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(20, 30, 13, 14),
      ...>       PointZM.new(35, 35, 23, 24),
      ...>       PointZM.new(30, 20, 33, 34),
      ...>       PointZM.new(20, 30, 13, 14)
      ...>     ])
      ...>   ])
      ...> )
      "Polygon ZM ((35 10 13 14, 45 45 23 24, 10 20 33 34, 35 10 13 14), (20 30 13 14, 35 35 23 24, 30 20 33 34, 20 30 13 14))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%PolygonZM{rings: rings}, opts \\ []) do
    WKT.to_ewkt(<<"Polygon ZM ", to_wkt_rings(rings)::binary>>, opts)
  end

  @doc """
  Returns the WKB representation for a `PolygonZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%PolygonZM{rings: rings}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(rings, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `PolygonZM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  The optional second argument determines if a `:hex`-string or a `:binary`
  input is expected. The default is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, PolygonZM)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, PolygonZM) do
      {:ok, geometry} -> geometry
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
      LineStringZM.to_wkt_points(ring)::binary,
      Enum.reduce(rings, "", fn ring, acc ->
        <<acc::binary, ", ", LineStringZM.to_wkt_points(ring)::binary>>
      end)::binary,
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
      WKB.byte_order(endian, mode)::binary,
      wkb_code(endian, not is_nil(srid), mode)::binary,
      WKB.srid(srid, endian, mode)::binary,
      to_wkb_rings(rings, endian, mode)::binary
    >>
  end

  @compile {:inline, to_wkb_rings: 3}
  defp to_wkb_rings(rings, endian, mode) do
    Enum.reduce(rings, WKB.length(rings, endian, mode), fn ring, acc ->
      <<acc::binary, LineStringZM.to_wkb_points(ring, endian, mode)::binary>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000003"
      {:ndr, false} -> "030000C0"
      {:xdr, true} -> "E0000003"
      {:ndr, true} -> "030000E0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0xC0000003::big-integer-size(32)>>
      {:ndr, false} -> <<0xC0000003::little-integer-size(32)>>
      {:xdr, true} -> <<0xE0000003::big-integer-size(32)>>
      {:ndr, true} -> <<0xE0000003::little-integer-size(32)>>
    end
  end
end
