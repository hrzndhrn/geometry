defmodule Geometry.Polygon do
  @moduledoc """
  A polygon struct, representing a 2D polygon.

  A none empty line-string requires at least one ring with four points.
  """

  alias Geometry.{GeoJson, LineString, Polygon, WKB, WKT}

  defstruct rings: []

  @type t :: %Polygon{rings: [Geometry.coordinates()]}

  @doc """
  Creates an empty `Polygon`.

  ## Examples

      iex> Polygon.new()
      %Polygon{rings: []}
  """
  @spec new :: t()
  def new, do: %Polygon{}

  @doc """
  Creates a `Polygon` from the given `rings`.

  ## Examples

      iex> Polygon.new([
      ...>   LineString.new([
      ...>     Point.new(35, 10),
      ...>     Point.new(45, 45),
      ...>     Point.new(10, 20),
      ...>     Point.new(35, 10)
      ...>   ]),
      ...>   LineString.new([
      ...>     Point.new(20, 30),
      ...>     Point.new(35, 35),
      ...>     Point.new(30, 20),
      ...>     Point.new(20, 30)
      ...>   ])
      ...> ])
      %Polygon{
        rings: [
          [[35, 10], [45, 45], [10, 20], [35, 10]],
          [[20, 30], [35, 35], [30, 20], [20, 30]]
        ]
      }

      iex> Polygon.new()
      %Polygon{}
  """
  @spec new([LineString.t()]) :: t()
  def new(rings) when is_list(rings) do
    %Polygon{rings: Enum.map(rings, fn line_string -> line_string.points end)}
  end

  @doc """
  Returns `true` if the given `Polygon` is empty.

  ## Examples

      iex> Polygon.empty?(Polygon.new())
      true

      iex> Polygon.empty?(
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(35, 10),
      ...>       Point.new(45, 45),
      ...>       Point.new(10, 20),
      ...>       Point.new(35, 10)
      ...>     ])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%Polygon{rings: rings}), do: Enum.empty?(rings)

  @doc """
  Creates a `Polygon` from the given coordinates.

  ## Examples

      iex> Polygon.from_coordinates([
      ...>   [[1, 1], [2, 1], [2, 2], [1, 1]]
      ...> ])
      %Polygon{
        rings: [
          [[1, 1], [2, 1], [2, 2], [1, 1]]
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(rings) when is_list(rings), do: %Polygon{rings: rings}

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
        rings: [
          [
            [35, 10],
            [45, 45],
            [15, 40],
            [10, 20],
            [35, 10]
          ]
        ]
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
        rings: [[
          [35, 10],
          [45, 45],
          [15, 40],
          [10, 20],
          [35, 10]
        ], [
          [20, 30],
          [35, 35],
          [30, 20],
          [20, 30]
        ]]
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

      iex> Polygon.to_geo_json(
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(35, 10),
      ...>       Point.new(45, 45),
      ...>       Point.new(10, 20),
      ...>       Point.new(35, 10)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(20, 30),
      ...>       Point.new(35, 35),
      ...>       Point.new(30, 20),
      ...>       Point.new(20, 30)
      ...>     ])
      ...>   ])
      ...> )
      %{
        "type" => "Polygon",
        "coordinates" => [
          [
            [35, 10],
            [45, 45],
            [10, 20],
            [35, 10]
          ], [
            [20, 30],
            [35, 35],
            [30, 20],
            [20, 30]
          ]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%Polygon{rings: rings}) do
    %{
      "type" => "Polygon",
      "coordinates" => rings
    }
  end

  @doc """
  Returns an `:ok` tuple with the `Polygon` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> Polygon.from_wkt("
      ...>   POLYGON (
      ...>     (35 10, 45 45, 15 40, 10 20, 35 10),
      ...>     (20 30, 35 35, 30 20, 20 30)
      ...>   )
      ...> ")
      {:ok,
       %Polygon{
         rings: [
           [
             [35, 10],
             [45, 45],
             [15, 40],
             [10, 20],
             [35, 10]
           ], [
             [20, 30],
             [35, 35],
             [30, 20],
             [20, 30]
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
      {:ok, {
        %Polygon{
          rings: [
            [
              [35, 10],
              [45, 45],
              [15, 40],
              [10, 20],
              [35, 10]
            ], [
              [20, 30],
              [35, 35],
              [30, 20],
              [20, 30]
            ]
          ]
        },
        789
      }}

      iex> Polygon.from_wkt("Polygon EMPTY")
      {:ok, %Polygon{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, Polygon)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, Polygon) do
      {:ok, geometry} -> geometry
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

      iex> Polygon.to_wkt(
      ...>   Polygon.new([
      ...>     LineString.new([
      ...>       Point.new(35, 10),
      ...>       Point.new(45, 45),
      ...>       Point.new(10, 20),
      ...>       Point.new(35, 10)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(20, 30),
      ...>       Point.new(35, 35),
      ...>       Point.new(30, 20),
      ...>       Point.new(20, 30)
      ...>     ])
      ...>   ])
      ...> )
      "Polygon ((35 10, 45 45, 10 20, 35 10), (20 30, 35 35, 30 20, 20 30))"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%Polygon{rings: rings}, opts \\ []) do
    WKT.to_ewkt(<<"Polygon ", to_wkt_rings(rings)::binary()>>, opts)
  end

  @doc """
  Returns the WKB representation for a `Polygon`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%Polygon{rings: rings}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(rings, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `Polygon` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  The optional second argument determines if a `:hex`-string or a `:binary`
  input is expected. The default is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, Polygon)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, Polygon) do
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
      LineString.to_wkt_points(ring)::binary(),
      Enum.reduce(rings, "", fn ring, acc ->
        <<acc::binary(), ", ", LineString.to_wkt_points(ring)::binary()>>
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
      <<acc::binary(), LineString.to_wkb_points(ring, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "00000003"
      {:ndr, false} -> "03000000"
      {:xdr, true} -> "20000003"
      {:ndr, true} -> "03000020"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x00000003::big-integer-size(32)>>
      {:ndr, false} -> <<0x00000003::little-integer-size(32)>>
      {:xdr, true} -> <<0x20000003::big-integer-size(32)>>
      {:ndr, true} -> <<0x20000003::little-integer-size(32)>>
    end
  end
end
