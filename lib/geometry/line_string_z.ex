defmodule Geometry.LineStringZ do
  @moduledoc """
  A line-string struct, representing a 3D line.

  A none empty line-string requires at least two points.
  """

  alias Geometry.{GeoJson, LineStringZ, PointZ, WKB, WKT}

  defstruct points: []

  @type t :: %LineStringZ{points: Geometry.coordinates()}

  @doc """
  Creates an empty `LineStringZ`.

  ## Examples

      iex> LineStringZ.new()
      %LineStringZ{points: []}
  """
  @spec new :: t()
  def new, do: %LineStringZ{}

  @doc """
  Creates a `LineStringZ` from the given `Geometry.PointZ`s.

  ## Examples

      iex> LineStringZ.new([PointZ.new(1, 2, 3), PointZ.new(3, 4, 5)])
      %LineStringZ{points: [[1, 2, 3], [3, 4, 5]]}
  """
  @spec new([PointZ.t()]) :: t()
  def new([]), do: %LineStringZ{}

  def new([_, _ | _] = points) do
    %LineStringZ{points: Enum.map(points, fn point -> point.coordinate end)}
  end

  @doc """
  Returns `true` if the given `LineStringZ` is empty.

  ## Examples

      iex> LineStringZ.empty?(LineStringZ.new())
      true

      iex> LineStringZ.empty?(
      ...>   LineStringZ.new(
      ...>     [PointZ.new(1, 2, 3), PointZ.new(3, 4, 5)]
      ...>   )
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%LineStringZ{} = line_string), do: Enum.empty?(line_string.points)

  @doc """
  Creates a `LineStringZ` from the given coordinates.

  ## Examples

      iex> LineStringZ.from_coordinates(
      ...>   [[-1, 1, 1], [-2, 2, 2], [-3, 3, 3]]
      ...> )
      %LineStringZ{
        points: [
          [-1, 1, 1],
          [-2, 2, 2],
          [-3, 3, 3]
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates), do: %LineStringZ{points: coordinates}

  @doc """
  Returns an `:ok` tuple with the `LineStringZ` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "LineString",
      ...>     "coordinates": [
      ...>       [1.1, 1.2, 1.3],
      ...>       [20.1, 20.2, 20.3]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> LineStringZ.from_geo_json()
      {:ok, %LineStringZ{points: [
         [1.1, 1.2, 1.3],
         [20.1, 20.2, 20.3]
      ]}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_line_string(json, LineStringZ)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_line_string(json, LineStringZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `LineStringZ`.

  ## Examples

      iex> LineStringZ.to_geo_json(
      ...>   LineStringZ.new([
      ...>     PointZ.new(-1.1, -2.2, -3.3),
      ...>     PointZ.new(1.1, 2.2, 3.3)
      ...>   ])
      ...> )
      %{
        "type" => "LineString",
        "coordinates" => [
          [-1.1, -2.2, -3.3],
          [1.1, 2.2, 3.3]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%LineStringZ{points: points}) do
    %{
      "type" => "LineString",
      "coordinates" => points
    }
  end

  @doc """
  Returns an `:ok` tuple with the `LineStringZ` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> LineStringZ.from_wkt(
      ...>   "LineString Z (-5.1 7.8 1.1, 0.1 0.2 2.2)"
      ...> )
      {:ok, %LineStringZ{
        points: [
          [-5.1, 7.8, 1.1],
          [0.1, 0.2, 2.2]
        ]
      }}

      iex> LineStringZ.from_wkt(
      ...>   "SRID=7219;LineString Z (-5.1 7.8 1.1, 0.1 0.2 2.2)"
      ...> )
      {:ok, {
        %LineStringZ{
          points: [
            [-5.1, 7.8, 1.1],
            [0.1, 0.2, 2.2]
          ]
        },
        7219
      }}

      iex> LineStringZ.from_wkt("LineString Z EMPTY")
      {:ok, %LineStringZ{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, LineStringZ)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, LineStringZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `LineStringZ`. With option `:srid` an
  EWKT representation with the SRID is returned.

  ## Examples

      iex> LineStringZ.to_wkt(LineStringZ.new())
      "LineString Z EMPTY"

      iex> LineStringZ.to_wkt(
      ...>   LineStringZ.new([
      ...>     PointZ.new(7.1, 8.1, 1.1),
      ...>     PointZ.new(9.2, 5.2, 2.2)
      ...>   ])
      ...> )
      "LineString Z (7.1 8.1 1.1, 9.2 5.2 2.2)"

      iex> LineStringZ.to_wkt(
      ...>   LineStringZ.new([
      ...>     PointZ.new(7.1, 8.1, 1.1),
      ...>     PointZ.new(9.2, 5.2, 2.2)
      ...>   ]),
      ...>   srid: 123
      ...> )
      "SRID=123;LineString Z (7.1 8.1 1.1, 9.2 5.2 2.2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%LineStringZ{points: points}, opts \\ []) do
    WKT.to_ewkt(<<"LineString Z ", to_wkt_points(points)::binary()>>, opts)
  end

  @doc """
  Returns the WKB representation for a `LineStringZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(line_string, opts) :: wkb
        when line_string: t() | Geometry.coordinates(),
             opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()],
             wkb: Geometry.wkb()
  def to_wkb(%LineStringZ{points: points}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(points, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `LineStringZ` from the given WKB string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  The optional second argument determines if a `:hex`-string or a `:binary`
  input is expected. The default is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, LineStringZ)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, LineStringZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc false
  @compile {:inline, to_wkt_points: 1}
  @spec to_wkt_points(Geometry.coordinates()) :: Geometry.wkt()
  def to_wkt_points([]), do: "EMPTY"

  def to_wkt_points([coordinate | points]) do
    <<"(",
      Enum.reduce(points, PointZ.to_wkt_coordinate(coordinate), fn coordinate, acc ->
        <<acc::binary(), ", ", PointZ.to_wkt_coordinate(coordinate)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 2}
  @spec to_wkb(coordinates, srid, endian, mode) :: wkb
        when coordinates: Geometry.coordinates(),
             srid: Geometry.srid() | nil,
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb(points, srid, endian, mode) do
    <<
      WKB.byte_order(endian, mode)::binary(),
      wkb_code(endian, not is_nil(srid), mode)::binary(),
      WKB.srid(srid, endian, mode)::binary(),
      to_wkb_points(points, endian, mode)::binary()
    >>
  end

  @doc false
  @compile {:inline, to_wkb_points: 3}
  @spec to_wkb_points(coordinates, endian, mode) :: wkb
        when coordinates: Geometry.coordinates(),
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb_points(points, endian, mode) do
    Enum.reduce(points, WKB.length(points, endian, mode), fn coordinate, acc ->
      <<acc::binary(), PointZ.to_wkb_coordinate(coordinate, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "80000002"
      {:ndr, false} -> "02000080"
      {:xdr, true} -> "A0000002"
      {:ndr, true} -> "020000A0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x80000002::big-integer-size(32)>>
      {:ndr, false} -> <<0x80000002::little-integer-size(32)>>
      {:xdr, true} -> <<0xA0000002::big-integer-size(32)>>
      {:ndr, true} -> <<0xA0000002::little-integer-size(32)>>
    end
  end
end
