defmodule Geometry.LineString do
  @moduledoc """
  A line-string struct, representing a 2D line.

  A none empty line-string requires at least two points.
  """

  alias Geometry.{GeoJson, LineString, Point, WKB, WKT}

  defstruct points: []

  @type t :: %LineString{points: Geometry.coordinates()}

  @doc """
  Creates an empty `LineString`.

  ## Examples

      iex> LineString.new()
      %LineString{points: []}
  """
  @spec new :: t()
  def new, do: %LineString{}

  @doc """
  Creates a `LineString` from the given `Geometry.Point`s.

  ## Examples

      iex> LineString.new([Point.new(1, 2), Point.new(3, 4)])
      %LineString{points: [[1, 2], [3, 4]]}
  """
  @spec new([Point.t()]) :: t()
  def new([]), do: %LineString{}

  def new([_, _ | _] = points) do
    %LineString{points: Enum.map(points, fn point -> point.coordinate end)}
  end

  @doc """
  Returns `true` if the given `LineString` is empty.

  ## Examples

      iex> LineString.empty?(LineString.new())
      true

      iex> LineString.empty?(
      ...>   LineString.new(
      ...>     [Point.new(1, 2), Point.new(3, 4)]
      ...>   )
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%LineString{} = line_string), do: Enum.empty?(line_string.points)

  @doc """
  Creates a `LineString` from the given coordinates.

  ## Examples

      iex> LineString.from_coordinates(
      ...>   [[-1, 1], [-2, 2], [-3, 3]]
      ...> )
      %LineString{
        points: [
          [-1, 1],
          [-2, 2],
          [-3, 3]
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates), do: %LineString{points: coordinates}

  @doc """
  Returns an `:ok` tuple with the `LineString` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "LineString",
      ...>     "coordinates": [
      ...>       [1.1, 1.2],
      ...>       [20.1, 20.2]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> LineString.from_geo_json()
      {:ok, %LineString{points: [
         [1.1, 1.2],
         [20.1, 20.2]
      ]}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_line_string(json, LineString)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_line_string(json, LineString) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `LineString`.

  ## Examples

      iex> LineString.to_geo_json(
      ...>   LineString.new([
      ...>     Point.new(-1.1, -2.2),
      ...>     Point.new(1.1, 2.2)
      ...>   ])
      ...> )
      %{
        "type" => "LineString",
        "coordinates" => [
          [-1.1, -2.2],
          [1.1, 2.2]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%LineString{points: points}) do
    %{
      "type" => "LineString",
      "coordinates" => points
    }
  end

  @doc """
  Returns an `:ok` tuple with the `LineString` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> LineString.from_wkt(
      ...>   "LineString (-5.1 7.8, 0.1 0.2)"
      ...> )
      {:ok, %LineString{
        points: [
          [-5.1, 7.8],
          [0.1, 0.2]
        ]
      }}

      iex> LineString.from_wkt(
      ...>   "SRID=7219;LineString (-5.1 7.8, 0.1 0.2)"
      ...> )
      {:ok, %LineString{
        points: [
          [-5.1, 7.8],
          [0.1, 0.2]
        ]
      }, 7219}

      iex> LineString.from_wkt("LineString EMPTY")
      {:ok, %LineString{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, LineString)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, LineString) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `LineString`. With option `:srid` an
  EWKT representation with the SRID is returned.

  ## Examples

      iex> LineString.to_wkt(LineString.new())
      "LineString EMPTY"

      iex> LineString.to_wkt(
      ...>   LineString.new([
      ...>     Point.new(7.1, 8.1),
      ...>     Point.new(9.2, 5.2)
      ...>   ])
      ...> )
      "LineString (7.1 8.1, 9.2 5.2)"

      iex> LineString.to_wkt(
      ...>   LineString.new([
      ...>     Point.new(7.1, 8.1),
      ...>     Point.new(9.2, 5.2)
      ...>   ]),
      ...>   srid: 123
      ...> )
      "SRID=123;LineString (7.1 8.1, 9.2 5.2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%LineString{points: points}, opts \\ []) do
    WKT.to_ewkt(<<"LineString ", to_wkt_points(points)::binary()>>, opts)
  end

  @doc """
  Returns the WKB representation for a `LineString`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t() | Geometry.coordinates(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%LineString{points: points}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    to_wkb(points, srid, endian)
  end

  @doc """
  Returns an `:ok` tuple with the `LineString` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, LineString)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, LineString) do
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
      Enum.reduce(points, Point.to_wkt_coordinate(coordinate), fn coordinate, acc ->
        <<acc::binary(), ", ", Point.to_wkt_coordinate(coordinate)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 2}
  @spec to_wkb(Geometry.coordinates(), Geometry.srid() | nil, Geometry.endian()) :: Geometry.wkb()
  def to_wkb(points, srid, endian) do
    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_points(points, endian)::binary()
    >>
  end

  @doc false
  @compile {:inline, to_wkb_points: 2}
  @spec to_wkb_points(Geometry.coordinates(), Geometry.endian()) :: Geometry.wkt()
  def to_wkb_points(points, endian) do
    Enum.reduce(points, WKB.length(points, endian), fn coordinate, acc ->
      <<acc::binary(), Point.to_wkb_coordinate(coordinate, endian)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "00000002"
      {:ndr, false} -> "02000000"
      {:xdr, true} -> "20000002"
      {:ndr, true} -> "02000020"
    end
  end
end
