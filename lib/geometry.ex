defmodule Geometry do
  @moduledoc """
  A set of geometry types for
  [WKT](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry)/
  [WKB](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry#Well-known_binary)
  and [GeoJson](https://geojson.org/).

  `Geometry` provide the decoding and encoding for geometires of type WKT/EWKT,
  WKB/EWKB and GeoJon.

  The following gemetries are supported:
  + Point
    + `Geometry.Point`, `Geometry.PointM`, `Geometry.PointZ`, `Geometry.PointZM`
  + LineString
    + `Geometry.LineString`, `Geometry.LineStringM`, `Geometry.LineStringZ`,
      `Geometry.LineStringZM`
  + Polygon
    + `Geometry.Polygon`, `Geometry.PolygonM`, `Geometry.PolygonZ`,
      `Geometry.PolygonZM`

  Geometry subtypes containing curves:
  + CircularString
    + `Geometry.CircularString`, `Geometry.CircularStringM`,
      `Geometry.CircularStringZ`, `Geometry.CircularStringZM`

  Collections:
  + MultiPoint
    + `Geometry.MultiPoint`, `Geometry.MultiPointM`, `Geometry.MultiPointZ`,
      `Geometry.MultiPointZM`
  + MultiLineString
    + `Geometry.MultiLineString`, `Geometry.MultiLineStringM`,
      `Geometry.MultiLineStringZ`, `Geometry.MultiLineStringZM`
  + MultiPolyogon
    + `Geometry.MultiPolygon`, `Geometry.MultiPolygonM`,
      `Geometry.MultiPolygonZ`, `Geometry.MultiPolygonZM`
  + GeometryCollection
    + `Geometry.GeometryCollection`, `Geometry.GeometryCollectionM`,
      `Geometry.GeometryCollectionZ`, `Geometry.GeometryCollectionZM`

  For GeoJson also `Geometry.Feature` and `Geometry.FeatureCollection` are
  supported.
  """

  alias Geometry.Decoder
  alias Geometry.Encoder
  alias Geometry.Protocol

  alias Geometry.DecodeError

  alias Geometry.CircularString
  alias Geometry.CircularStringM
  alias Geometry.CircularStringZ
  alias Geometry.CircularStringZM
  alias Geometry.Feature
  alias Geometry.FeatureCollection
  alias Geometry.GeometryCollection
  alias Geometry.GeometryCollectionM
  alias Geometry.GeometryCollectionZ
  alias Geometry.GeometryCollectionZM
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.MultiLineString
  alias Geometry.MultiLineStringM
  alias Geometry.MultiLineStringZ
  alias Geometry.MultiLineStringZM
  alias Geometry.MultiPoint
  alias Geometry.MultiPointM
  alias Geometry.MultiPointZ
  alias Geometry.MultiPointZM
  alias Geometry.MultiPolygon
  alias Geometry.MultiPolygonM
  alias Geometry.MultiPolygonZ
  alias Geometry.MultiPolygonZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM
  alias Geometry.Polygon
  alias Geometry.PolygonM
  alias Geometry.PolygonZ
  alias Geometry.PolygonZM

  @default_endian :ndr

  @typedoc """
  The supported geometries.
  """
  @type t() ::
          CircularString.t()
          | CircularStringM.t()
          | CircularStringZ.t()
          | CircularStringZM.t()
          | GeometryCollection.t()
          | GeometryCollectionM.t()
          | GeometryCollectionZ.t()
          | GeometryCollectionZM.t()
          | LineString.t()
          | LineStringM.t()
          | LineStringZ.t()
          | LineStringZM.t()
          | MultiLineString.t()
          | MultiLineStringM.t()
          | MultiLineStringZ.t()
          | MultiLineStringZM.t()
          | MultiPoint.t()
          | MultiPointM.t()
          | MultiPointZ.t()
          | MultiPointZM.t()
          | MultiPolygon.t()
          | MultiPolygonM.t()
          | MultiPolygonZ.t()
          | MultiPolygonZM.t()
          | Polygon.t()
          | PolygonM.t()
          | PolygonZ.t()
          | PolygonZM.t()
          | Point.t()
          | PointM.t()
          | PointZ.t()
          | PointZM.t()

  @typedoc """
  An n-dimensional point.
  """
  @type coordinates :: [number(), ...]

  @typedoc """
  A list of n-dimensional coordinates.
  """
  @type path :: [coordinates()]

  @typedoc """
  A list of n-dimensional coordinates.
  """
  @type arcs :: [coordinates()]

  @typedoc """
  A list of n-dimensional coordinates where the first and last point are equal, creating a ring.
  """
  @type ring :: [coordinates()]

  @typedoc """
  The Spatial Reference System Identifier to identify projected, unprojected,
  and local spatial coordinate system definitions.
  """
  @type srid :: non_neg_integer()

  @typedoc """
  [Well-Known Text](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry)
  (WKT) is a text markup language for representing vector geometry objects.
  """
  @type wkt :: String.t()

  @typedoc """
  [Well-Known Binary](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry#Well-known_binary)
  (WKB) is the binary representation of WKT.
  """
  @type wkb :: binary()

  @typedoc """
  A [GeoJson](https://geojson.org) term.
  """
  @type geo_json_term :: map()

  @typedoc """
  Byte order.

  - `:ndr`: Little endian byte order encoding
  - `:xdr`: Big endian byte order encoding
  """
  @type endian :: :ndr | :xdr

  @doc """
  Returns true if a geometry is empty.

  ## Examples

      iex> Geometry.empty?(Point.new(1, 2))
      false
      iex> Geometry.empty?(Point.new())
      true
      iex> Geometry.empty?(LineString.new([]))
      true
  """
  @spec empty?(t()) :: boolean
  def empty?(geometry), do: Protocol.empty?(geometry)

  @doc """
  Returns the EWKB representation of a geometry.

  If the `srid` of the geometry is 0, a WKB is returned.

  The optional `:endian` argument indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  ## Examples

      iex> PointZ.new(1, 2, 3, 3825)
      ...> |> Geometry.to_ewkb()
      ...> |> Base.encode16()
      "01010000A0F10E0000000000000000F03F00000000000000400000000000000840"

      iex> PointZ.new(1, 2, 3, 0)
      ...> |> Geometry.to_ewkb()
      ...> |> Base.encode16()
      "0101000080000000000000F03F00000000000000400000000000000840"

      iex> Point.new(1, 2, 3825)
      ...> |> Geometry.to_ewkb(:xdr)
      ...> |> Base.encode16()
      "002000000100000EF13FF00000000000004000000000000000"
  """
  @spec to_ewkb(t(), endian()) :: wkb()
  def to_ewkb(geometry, endian \\ @default_endian)

  def to_ewkb(%{srid: 0} = geometry, endian) when endian in [:xdr, :ndr] do
    to_wkb(geometry, endian)
  end

  def to_ewkb(geometry, endian) when endian in [:xdr, :ndr] do
    Encoder.WKB.to_ewkb(geometry, endian)
  end

  @doc """
  Returns the WKB representation of a geometry.

  The optional `:endian` argument indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  ## Examples

      iex> PointZ.new(1, 2, 3)
      ...> |> Geometry.to_wkb()
      ...> |> Base.encode16()
      "0101000080000000000000F03F00000000000000400000000000000840"

      iex> PointZ.new(1, 2, 3)
      ...> |> Geometry.to_wkb(:xdr)
      ...> |> Base.encode16()
      "00800000013FF000000000000040000000000000004008000000000000"
  """
  @spec to_wkb(t(), endian()) :: wkb()
  def to_wkb(geometry, endian \\ @default_endian) when endian in [:xdr, :ndr] do
    Encoder.WKB.to_wkb(geometry, endian)
  end

  @doc """
  Returns an `:ok` tuple with the geometry from the given EWKB binary.

  Otherwise returns an `:error` tuple.

  If the given binary not an extended `t:wkb/0` a nil for the SRID is returned.

  ## Examples

      iex> "0020000001000012673FF00000000000004000000000000000"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_ewkb()
      {:ok, %Point{coordinates: [1.0, 2.0], srid: 4711}}

      iex> "0101000080000000000000F03F00000000000000400000000000000840"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_ewkb()
      {:ok, %PointZ{coordinates: [1.0, 2.0, 3.0], srid: 0}}
  """
  @spec from_ewkb(wkb()) :: {:ok, t()} | {:error, DecodeError.t()}
  def from_ewkb(wkb), do: Decoder.WKB.decode(wkb)

  @doc """
  The same as `from_ewkb/1`, but raises a `Geometry.DecodeError` exception if it fails.
  """
  @spec from_ewkb!(wkb()) :: t()
  def from_ewkb!(wkb) do
    case from_ewkb(wkb) do
      {:ok, geometry} -> geometry
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns an `:ok` tuple with the geometry from the given WKB binary.

  Otherwise returns an `:error` tuple.

  If the given binary is an extended `t:wkb/0` the SRID is ignored.

  ## Examples

      iex> "0020000001000012673FF00000000000004000000000000000"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_wkb()
      {:ok, %Point{coordinates: [1.0, 2.0], srid: 4711}}

      iex> "0101000080000000000000F03F00000000000000400000000000000840"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_wkb()
      {:ok, %PointZ{coordinates: [1.0, 2.0, 3.0]}}

      iex> "FF"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_wkb()
      {
        :error,
        %Geometry.DecodeError{
          from: :wkb,
          offset: 0,
          reason: [expected_endian: :flag],
          rest: <<255>>
        }
      }
  """
  @spec from_wkb(wkb()) :: {:ok, t()} | {:error, DecodeError.t()}
  def from_wkb(wkb), do: Decoder.WKB.decode(wkb)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.DecodeError` exception if it fails.
  """
  @spec from_wkb!(wkb()) :: t()
  def from_wkb!(wkb) do
    case from_wkb(wkb) do
      {:ok, geometry} -> geometry
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns the EWKT representation of the given `geometry`.

  If the `srid` of the geometry is `0`, a WKT is returned.

  ## Examples

      iex> Geometry.to_ewkt(PointZ.new(1.1, 2.2, 3.3, 4211))
      "SRID=4211;POINT Z (1.1 2.2 3.3)"

      iex> Geometry.to_ewkt(LineString.new([Point.new(1, 2), Point.new(3, 4)], 3825))
      "SRID=3825;LINESTRING (1 2, 3 4)"

      iex> Geometry.to_ewkt(Point.new(1, 2))
      "POINT (1 2)"
  """
  @spec to_ewkt(Geometry.t()) :: wkt()
  def to_ewkt(%{srid: 0} = geometry), do: to_wkt(geometry)

  def to_ewkt(geometry), do: Encoder.WKT.to_ewkt(geometry)

  @doc """
  Returns the WKT representation of the given `geometry`.

  ## Examples

      iex> Geometry.to_wkt(PointZ.new(1.1, 2.2, 3.3))
      "POINT Z (1.1 2.2 3.3)"

      iex> Geometry.to_wkt(LineString.new([Point.new(1, 2), Point.new(3, 4)]))
      "LINESTRING (1 2, 3 4)"

      iex> Geometry.to_wkt(Point.new(1, 2))
      "POINT (1 2)"
  """
  @spec to_wkt(Geometry.t()) :: wkt()
  def to_wkt(geometry), do: Encoder.WKT.to_wkt(geometry)

  @doc """
  Returns an `:ok` tuple with the geometry from the given EWKT string.

  Otherwise returns an `:error` tuple.

  If the given string not an extended `t:wkt/0` a nil for the SRID is returned.

  ## Examples

      iex> Geometry.from_ewkt("SRID=42;Point (1.1 2.2)")
      {:ok, %Point{coordinates: [1.1, 2.2], srid: 42}}

      iex> Geometry.from_ewkt("Point ZM (1 2 3 4)")
      {:ok, %PointZM{coordinates: [1, 2, 3, 4], srid: 0}}

      iex> Geometry.from_ewkt("Point XY (1 2 3 4)")
      {:error, "expected Point data", "XY (1 2 3 4)", {1, 0}, 6}
      {
        :error,
        %Geometry.DecodeError{
          from: :wkt,
          line: {1, 0},
          message: "expected Point data",
          offset: 6,
          rest: "XY (1 2 3 4)"
        }
      }
  """
  @spec from_ewkt(wkt()) :: {:ok, t()} | {:error, DecodeError.t()}
  def from_ewkt(wkt), do: Decoder.WKT.decode(wkt)

  @doc """
  The same as `from_ewkt/1`, but raises a `Geometry.DecodeError` exception if it fails.
  """
  @spec from_ewkt!(wkt()) :: t()
  def from_ewkt!(wkt) do
    case from_ewkt(wkt) do
      {:ok, geometry} -> geometry
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns an `:ok` tuple with the geometry from the given WKT string.

  Otherwise returns an `:error` tuple.

  If the given string is an extended `t:wkt/0` the SRID is ignored.

  ## Examples

      iex> Geometry.from_wkt("SRID=42;Point (1.1 2.2)")
      {:ok, %Point{coordinates: [1.1, 2.2], srid: 42}}

      iex> Geometry.from_wkt("Point ZM (1 2 3 4)")
      {:ok, %PointZM{coordinates: [1, 2, 3, 4], srid: 0}}

      iex> Geometry.from_wkt("Point XY (1 2 3 4)")
      {:error,  %Geometry.DecodeError{
        from: :wkt,
        line: {1, 0},
        message: "expected Point data",
        offset: 6,
        rest: "XY (1 2 3 4)"}
      }
  """
  @spec from_wkt(wkt()) :: {:ok, t()} | {:error, DecodeError.t()}
  def from_wkt(wkt), do: Decoder.WKT.decode(wkt)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.DecodeError` exception if it fails.
  """
  @spec from_wkt!(wkt()) :: t()
  def from_wkt!(wkt) do
    case from_wkt(wkt) do
      {:ok, geometry} -> geometry
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns the GeoJSON term representation of a geometry.

  ## Examples

      iex> Geometry.to_geo_json(PointZ.new(1.2, 3.4, 5.6))
      %{"type" => "Point", "coordinates" => [1.2, 3.4, 5.6]}

      iex> Geometry.to_geo_json(LineString.new([Point.new(1, 2), Point.new(3, 4)]))
      %{"type" => "LineString", "coordinates" => [[1, 2], [3, 4]]}
  """
  @spec to_geo_json(t()) :: geo_json_term
  def to_geo_json(geometry), do: Encoder.GeoJson.to_geo_json(geometry)

  @doc """
  Returns an `:ok` tuple with the geometry from the given GeoJSON term.

  Otherwise returns an `:error` tuple.

  The optional second argument specifies which type is expected. The
  possible values are `:xy`, `:xym`, `xyz`, and `:xyzm`. Defaults to `:xy`.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1, 2]})
      iex> |> Jason.decode!()
      iex> |> Geometry.from_geo_json()
      {:ok, %Point{coordinates: [1, 2], srid: 4326}}

      iex> ~s({"type": "Point", "coordinates": [1, 2, 3, 4]})
      iex> |> Jason.decode!()
      iex> |> Geometry.from_geo_json(:xyzm)
      {:ok, %PointZM{coordinates: [1, 2, 3, 4], srid: 4326}}

      iex> ~s({"type": "Dot", "coordinates": [1, 2]})
      iex> |> Jason.decode!()
      iex> |> Geometry.from_geo_json()
      {
        :error,
        %Geometry.DecodeError{
          from: :geo_json,
          reason: [unknown_type: "Dot"]
        }
      }
  """
  @spec from_geo_json(geo_json_term(), :xy | :xyz | :xym | :xyzm) ::
          {:ok, t() | Feature.t() | FeatureCollection.t()} | {:error, DecodeError.t()}
  def from_geo_json(json, dim \\ :xy) when dim in [:xy, :xyz, :xym, :xyzm] do
    Decoder.GeoJson.decode(json, dim)
  end

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.DecodeError` exception if it
  fails.
  """
  @spec from_geo_json!(geo_json_term(), type :: :xy | :xyz | :xym | :xyzm) ::
          t() | Feature.t() | FeatureCollection.t()
  def from_geo_json!(json, dim \\ :xy) when dim in [:xy, :xyz, :xym, :xyzm] do
    case Decoder.GeoJson.decode(json, dim) do
      {:ok, geometry} -> geometry
      {:error, error} -> raise error
    end
  end
end
