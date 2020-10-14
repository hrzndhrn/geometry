defmodule Geometry.LineStringZM do
  @moduledoc """
  A line-string struct, representing a 3D line with a measurement.

  A none empty line-string requires at least two points.
  """

  alias Geometry.{GeoJson, LineStringZM, PointZM, WKB, WKT}

  defstruct points: []

  @type t :: %LineStringZM{points: [PointZM.t()]}

  @doc """
  Creates an empty `LineStringZM`.

  ## Examples

      iex> LineStringZM.new()
      %LineStringZM{points: []}
  """
  @spec new :: t()
  def new, do: %LineStringZM{}

  @doc """
  Creates a `LineStringZM` from the given `Geometry.PointZM`s.

  ## Examples

      iex> LineStringZM.new([PointZM.new(1, 2, 3, 4), PointZM.new(3, 4, 5, 6)])
      %LineStringZM{points: [
        %PointZM{x: 1, y: 2, z: 3, m: 4},
        %PointZM{x: 3, y: 4, z: 5, m: 6}
      ]}
  """
  @spec new([PointZM.t()]) :: t()
  def new([]), do: %LineStringZM{}
  def new([_, _ | _] = points), do: %LineStringZM{points: points}

  @doc """
  Returns `true` if the given `LineStringZM` is empty.

  ## Examples

      iex> LineStringZM.empty?(LineStringZM.new())
      true

      iex> LineStringZM.empty?(
      ...>   LineStringZM.new(
      ...>     [PointZM.new(1, 2, 3, 4), PointZM.new(3, 4, 5, 6)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%LineStringZM{} = line_string), do: Enum.empty?(line_string.points)

  @doc """
  Creates a `LineStringZM` from the given coordinates.

  ## Examples

      iex> LineStringZM.from_coordinates(
      ...>   [{-1, 1, 1, 1}, {-2, 2, 2, 2}, {-3, 3, 3, 3}])
      %LineStringZM{
        points: [
          %PointZM{x: -1, y: 1, z: 1, m: 1},
          %PointZM{x: -2, y: 2, z: 2, m: 2},
          %PointZM{x: -3, y: 3, z: 3, m: 3}
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates) do
    %LineStringZM{points: Enum.map(coordinates, &PointZM.new/1)}
  end

  @doc """
  Returns an `:ok` tuple with the `LineStringZM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "LineString",
      ...>     "coordinates": [
      ...>       [1.1, 1.2, 1.3, 1.4],
      ...>       [20.1, 20.2, 20.3, 20.4]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> LineStringZM.from_geo_json()
      {:ok, %LineStringZM{points: [
        %PointZM{x: 1.1, y: 1.2, z: 1.3, m: 1.4},
        %PointZM{x: 20.1, y: 20.2, z: 20.3, m: 20.4}
      ]}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_line_string(json, LineStringZM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_line_string(json, LineStringZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `LineStringZM`.

  ## Examples

      iex> LineStringZM.to_geo_json(
      ...>   LineStringZM.new([
      ...>     PointZM.new(-1.1, -2.2, -3.3, -4.4),
      ...>     PointZM.new(1.1, 2.2, 3.3, 4.4)
      ...>   ]))
      %{
        "type" => "LineString",
        "coordinates" => [
          [-1.1, -2.2, -3.3, -4.4],
          [1.1, 2.2, 3.3, 4.4]
        ]
      }
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%LineStringZM{points: points}) do
    %{
      "type" => "LineString",
      "coordinates" => Enum.map(points, &PointZM.to_list/1)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `LineStringZM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> LineStringZM.from_wkt(
      ...>   "LineString ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)")
      {:ok, %LineStringZM{
        points: [
          %PointZM{x: -5.1, y: 7.8, z: 1.1, m: 1},
          %PointZM{x: 0.1, y: 0.2, z: 2.2, m: 2}
        ]
      }}

      iex> LineStringZM.from_wkt(
      ...>   "SRID=7219;LineString ZM (-5.1 7.8 1.1 1, 0.1 0.2 2.2 2)")
      {:ok, %LineStringZM{
        points: [
          %PointZM{x: -5.1, y: 7.8, z: 1.1, m: 1},
          %PointZM{x: 0.1, y: 0.2, z: 2.2, m: 2}
        ]
      }, 7219}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, LineStringZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, LineStringZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `LineStringZM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  ## Examples

      iex> LineStringZM.to_wkt(LineStringZM.new())
      "LineString ZM EMPTY"

      iex> LineStringZM.to_wkt(
      ...>   LineStringZM.new([
      ...>     PointZM.new(7.1, 8.1, 1.1, 1),
      ...>     PointZM.new(9.2, 5.2, 2.2, 2)
      ...>   ])
      ...> )
      "LineString ZM (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"

      iex> LineStringZM.to_wkt(
      ...>   LineStringZM.new([
      ...>     PointZM.new(7.1, 8.1, 1.1, 1),
      ...>     PointZM.new(9.2, 5.2, 2.2, 2)
      ...>   ]),
      ...>   srid: 123
      ...> )
      "SRID=123;LineString ZM (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(line_string, opts \\ [])

  def to_wkt(%LineStringZM{points: []}, opts) do
    "EMPTY"
    |> to_wkt_line_string()
    |> WKT.to_ewkt(opts)
  end

  def to_wkt(%LineStringZM{points: points}, opts) do
    points
    |> to_wkt_points()
    |> to_wkt_line_string()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `LineStringZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%LineStringZM{} = line_string, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_line_string(line_string, endian)::binary()
    >>
  end

  @doc """
  Returns an `:ok` tuple with the `LineStringZM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, LineStringZM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, LineStringZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  defp to_wkt_line_string(wkt), do: <<"LineString ZM ", wkt::binary()>>

  defp to_wkt_points(points) do
    wkt =
      points
      |> Enum.map(fn point -> PointZM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkb_line_string(%LineStringZM{points: points}, endian) do
    data =
      points
      |> Enum.map(fn point -> PointZM.to_wkb_coordinate(point, endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(points, endian)::binary(), data::binary()>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000002"
      {:ndr, false} -> "020000C0"
      {:xdr, true} -> "E0000002"
      {:ndr, true} -> "020000E0"
    end
  end
end
