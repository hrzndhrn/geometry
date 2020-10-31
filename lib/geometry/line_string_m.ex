defmodule Geometry.LineStringM do
  @moduledoc """
  A line-string struct, representing a 2D line with a measurement.

  A none empty line-string requires at least two points.
  """

  alias Geometry.{GeoJson, LineStringM, PointM, WKB, WKT}

  defstruct points: []

  @type t :: %LineStringM{points: Geometry.coordinates()}

  @doc """
  Creates an empty `LineStringM`.

  ## Examples

      iex> LineStringM.new()
      %LineStringM{points: []}
  """
  @spec new :: t()
  def new, do: %LineStringM{}

  @doc """
  Creates a `LineStringM` from the given `Geometry.PointM`s.

  ## Examples

      iex> LineStringM.new([PointM.new(1, 2, 4), PointM.new(3, 4, 6)])
      %LineStringM{points: [[1, 2, 4], [3, 4, 6]]}
  """
  @spec new([PointM.t()]) :: t()
  def new([]), do: %LineStringM{}

  def new([_, _ | _] = points) do
    %LineStringM{points: Enum.map(points, fn point -> point.coordinate end)}
  end

  @doc """
  Returns `true` if the given `LineStringM` is empty.

  ## Examples

      iex> LineStringM.empty?(LineStringM.new())
      true

      iex> LineStringM.empty?(
      ...>   LineStringM.new(
      ...>     [PointM.new(1, 2, 4), PointM.new(3, 4, 6)]
      ...>   )
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%LineStringM{} = line_string), do: Enum.empty?(line_string.points)

  @doc """
  Creates a `LineStringM` from the given coordinates.

  ## Examples

      iex> LineStringM.from_coordinates(
      ...>   [[-1, 1, 1], [-2, 2, 2], [-3, 3, 3]]
      ...> )
      %LineStringM{
        points: [
          [-1, 1, 1],
          [-2, 2, 2],
          [-3, 3, 3]
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates), do: %LineStringM{points: coordinates}

  @doc """
  Returns an `:ok` tuple with the `LineStringM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "LineString",
      ...>     "coordinates": [
      ...>       [1.1, 1.2, 1.4],
      ...>       [20.1, 20.2, 20.4]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> LineStringM.from_geo_json()
      {:ok, %LineStringM{points: [
         [1.1, 1.2, 1.4],
         [20.1, 20.2, 20.4]
      ]}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_line_string(json, LineStringM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_line_string(json, LineStringM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `LineStringM`.

  ## Examples

      iex> LineStringM.to_geo_json(
      ...>   LineStringM.new([
      ...>     PointM.new(-1.1, -2.2, -4.4),
      ...>     PointM.new(1.1, 2.2, 4.4)
      ...>   ])
      ...> )
      %{
        "type" => "LineString",
        "coordinates" => [
          [-1.1, -2.2, -4.4],
          [1.1, 2.2, 4.4]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%LineStringM{points: points}) do
    %{
      "type" => "LineString",
      "coordinates" => points
    }
  end

  @doc """
  Returns an `:ok` tuple with the `LineStringM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> LineStringM.from_wkt(
      ...>   "LineString M (-5.1 7.8 1, 0.1 0.2 2)"
      ...> )
      {:ok, %LineStringM{
        points: [
          [-5.1, 7.8, 1],
          [0.1, 0.2, 2]
        ]
      }}

      iex> LineStringM.from_wkt(
      ...>   "SRID=7219;LineString M (-5.1 7.8 1, 0.1 0.2 2)"
      ...> )
      {:ok, %LineStringM{
        points: [
          [-5.1, 7.8, 1],
          [0.1, 0.2, 2]
        ]
      }, 7219}

      iex> LineStringM.from_wkt("LineString M EMPTY")
      {:ok, %LineStringM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()}
          | {:ok, t(), Geometry.srid()}
          | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, LineStringM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, LineStringM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `LineStringM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  ## Examples

      iex> LineStringM.to_wkt(LineStringM.new())
      "LineString M EMPTY"

      iex> LineStringM.to_wkt(
      ...>   LineStringM.new([
      ...>     PointM.new(7.1, 8.1, 1),
      ...>     PointM.new(9.2, 5.2, 2)
      ...>   ])
      ...> )
      "LineString M (7.1 8.1 1, 9.2 5.2 2)"

      iex> LineStringM.to_wkt(
      ...>   LineStringM.new([
      ...>     PointM.new(7.1, 8.1, 1),
      ...>     PointM.new(9.2, 5.2, 2)
      ...>   ]),
      ...>   srid: 123
      ...> )
      "SRID=123;LineString M (7.1 8.1 1, 9.2 5.2 2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%LineStringM{points: points}, opts \\ []) do
    WKT.to_ewkt(<<"LineString M ", to_wkt_points(points)::binary()>>, opts)
  end

  @doc """
  Returns the WKB representation for a `LineStringM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(line_string, opts) :: wkb
        when line_string: t() | Geometry.coordinates(),
             opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()],
             wkb: Geometry.wkb()
  def to_wkb(%LineStringM{points: points}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(points, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `LineStringM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()}
          | {:ok, t(), Geometry.srid()}
          | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, LineStringM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, LineStringM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc false
  @compile {:inline, to_wkt_points: 1}
  @spec to_wkt_points(Geometry.coordinates()) :: Geometry.wkt()
  def to_wkt_points([]), do: "EMPTY"

  def to_wkt_points([coordinate | points]) do
    <<"(",
      Enum.reduce(points, PointM.to_wkt_coordinate(coordinate), fn coordinate, acc ->
        <<acc::binary(), ", ", PointM.to_wkt_coordinate(coordinate)::binary()>>
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
      <<acc::binary(), PointM.to_wkb_coordinate(coordinate, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "40000002"
      {:ndr, false} -> "02000040"
      {:xdr, true} -> "60000002"
      {:ndr, true} -> "02000060"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x40000002::big-integer-size(32)>>
      {:ndr, false} -> <<0x40000002::little-integer-size(32)>>
      {:xdr, true} -> <<0x60000002::big-integer-size(32)>>
      {:ndr, true} -> <<0x60000002::little-integer-size(32)>>
    end
  end
end
