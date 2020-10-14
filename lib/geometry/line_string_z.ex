defmodule Geometry.LineStringZ do
  @moduledoc """
  A line-string struct, representing a 3D line.

  A none empty line-string requires at least two points.
  """

  alias Geometry.{GeoJson, LineStringZ, PointZ, WKB, WKT}

  defstruct points: []

  @type t :: %LineStringZ{points: [PointZ.t()]}

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
      %LineStringZ{points: [
        %PointZ{x: 1, y: 2, z: 3},
        %PointZ{x: 3, y: 4, z: 5}
      ]}
  """
  @spec new([PointZ.t()]) :: t()
  def new([]), do: %LineStringZ{}
  def new([_, _ | _] = points), do: %LineStringZ{points: points}

  @doc """
  Returns `true` if the given `LineStringZ` is empty.

  ## Examples

      iex> LineStringZ.empty?(LineStringZ.new())
      true

      iex> LineStringZ.empty?(
      ...>   LineStringZ.new(
      ...>     [PointZ.new(1, 2, 3), PointZ.new(3, 4, 5)]))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%LineStringZ{} = line_string), do: Enum.empty?(line_string.points)

  @doc """
  Creates a `LineStringZ` from the given coordinates.

  ## Examples

      iex> LineStringZ.from_coordinates(
      ...>   [{-1, 1, 1}, {-2, 2, 2}, {-3, 3, 3}])
      %LineStringZ{
        points: [
          %PointZ{x: -1, y: 1, z: 1},
          %PointZ{x: -2, y: 2, z: 2},
          %PointZ{x: -3, y: 3, z: 3}
        ]
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates) do
    %LineStringZ{points: Enum.map(coordinates, &PointZ.new/1)}
  end

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
        %PointZ{x: 1.1, y: 1.2, z: 1.3},
        %PointZ{x: 20.1, y: 20.2, z: 20.3}
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
      ...>   ]))
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
      "coordinates" => Enum.map(points, &PointZ.to_list/1)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `LineStringZ` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> LineStringZ.from_wkt(
      ...>   "LineString Z (-5.1 7.8 1.1, 0.1 0.2 2.2)")
      {:ok, %LineStringZ{
        points: [
          %PointZ{x: -5.1, y: 7.8, z: 1.1},
          %PointZ{x: 0.1, y: 0.2, z: 2.2}
        ]
      }}

      iex> LineStringZ.from_wkt(
      ...>   "SRID=7219;LineString Z (-5.1 7.8 1.1, 0.1 0.2 2.2)")
      {:ok, %LineStringZ{
        points: [
          %PointZ{x: -5.1, y: 7.8, z: 1.1},
          %PointZ{x: 0.1, y: 0.2, z: 2.2}
        ]
      }, 7219}
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
      {:ok, geometry, srid} -> {geometry, srid}
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
  def to_wkt(line_string, opts \\ [])

  def to_wkt(%LineStringZ{points: []}, opts) do
    "EMPTY"
    |> to_wkt_line_string()
    |> WKT.to_ewkt(opts)
  end

  def to_wkt(%LineStringZ{points: points}, opts) do
    points
    |> to_wkt_points()
    |> to_wkt_line_string()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `LineStringZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%LineStringZ{} = line_string, opts \\ []) do
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
  Returns an `:ok` tuple with the `LineStringZ` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, LineStringZ)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, LineStringZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  defp to_wkt_line_string(wkt), do: <<"LineString Z ", wkt::binary()>>

  defp to_wkt_points(points) do
    wkt =
      points
      |> Enum.map(fn point -> PointZ.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    <<"(", wkt::binary(), ")">>
  end

  defp to_wkb_line_string(%LineStringZ{points: points}, endian) do
    data =
      points
      |> Enum.map(fn point -> PointZ.to_wkb_coordinate(point, endian) end)
      |> IO.iodata_to_binary()

    <<WKB.length(points, endian)::binary(), data::binary()>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "80000002"
      {:ndr, false} -> "02000080"
      {:xdr, true} -> "A0000002"
      {:ndr, true} -> "020000A0"
    end
  end
end
