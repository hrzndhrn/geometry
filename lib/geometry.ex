defmodule Geometry do
  @moduledoc """
  A set of geometry types for WKT/WKB and GeoJson.
  """

  alias Geometry.Decoder
  alias Geometry.Encoder
  alias Geometry.Protocol

  alias Geometry.DecodeError

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
          GeometryCollection.t()
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
  An n-dimensional coordinate.
  """
  @type coordinate :: [number(), ...]

  @typedoc """
  A list of n-dimensional coordinates.
  """
  @type coordinates :: [coordinate()]

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

  If the `srid` is nil a WKB is returned.

  The optional `:endian` argument indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  ## Examples

      iex> PointZ.new(1, 2, 3)
      ...> |> Geometry.to_ewkb(3825)
      ...> |> Base.encode16()
      "01010000A0F10E0000000000000000F03F00000000000000400000000000000840"

      iex> PointZ.new(1, 2, 3)
      ...> |> Geometry.to_ewkb(nil)
      ...> |> Base.encode16()
      "0101000080000000000000F03F00000000000000400000000000000840"

      iex> Point.new(1, 2)
      ...> |> Geometry.to_ewkb(3825, :xdr)
      ...> |> Base.encode16()
      "002000000100000EF13FF00000000000004000000000000000"
  """
  @spec to_ewkb(t(), srid() | nil, endian()) :: wkb()
  def to_ewkb(geometry, srid, endian \\ @default_endian)

  def to_ewkb(geometry, nil, endian) when endian in [:xdr, :ndr] do
    to_wkb(geometry, endian)
  end

  def to_ewkb(geometry, srid, endian) when endian in [:xdr, :ndr] do
    Encoder.WKB.to_ewkb(geometry, srid, endian)
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

  If the given binary is a `t:wkb/0` a nil for the SRID is returned.

  ## Examples

      iex> "0020000001000012673FF00000000000004000000000000000"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_ewkb()
      {:ok, {%Point{coordinate: [1.0, 2.0]}, 4711}}

      iex> "0101000080000000000000F03F00000000000000400000000000000840"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_ewkb()
      {:ok, {%PointZ{coordinate: [1.0, 2.0, 3.0]}, nil}}
  """
  @spec from_ewkb(wkb()) :: {:ok, {t(), srid() | nil}} | {:error, DecodeError.t()}
  def from_ewkb(wkb) do
    with {:ok, geometry, srid} <- Decoder.WKB.decode(wkb) do
      {:ok, {geometry, srid}}
    end
  end

  @doc """
  The same as `from_ewkb/1`, but raises a `Geometry.DecodeError` exception if it fails.
  """
  @spec from_ewkb!(wkb()) :: {t(), srid() | nil}
  def from_ewkb!(wkb) do
    case from_ewkb(wkb) do
      {:ok, geometry} -> geometry
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns an `:ok` tuple with the geometry from the given WKB binary.

  Otherwise returns an `:error` tuple.

  If the given binary is a `t:ewkb/0` the SRID is ignored.

  ## Examples

      iex> "0020000001000012673FF00000000000004000000000000000"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_wkb()
      {:ok, %Point{coordinate: [1.0, 2.0]}}

      iex> "0101000080000000000000F03F00000000000000400000000000000840"
      ...> |> Base.decode16!()
      ...> |> Geometry.from_wkb()
      {:ok, %PointZ{coordinate: [1.0, 2.0, 3.0]}}

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
  def from_wkb(wkb) do
    with {:ok, geometry, _srid} <- Decoder.WKB.decode(wkb) do
      {:ok, geometry}
    end
  end

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

  If the `srid` is `nil` a `t:wkt/0` is returned.

  ## Examples

      iex> Geometry.to_ewkt(PointZ.new(1.1, 2.2, 3.3), 4211)
      "SRID=4211;Point Z (1.1 2.2 3.3)"

      iex> Geometry.to_ewkt(LineString.new([Point.new(1, 2), Point.new(3, 4)]), 3825)
      "SRID=3825;LineString (1 2, 3 4)"

      iex> Geometry.to_ewkt(Point.new(1, 2), nil)
      "Point (1 2)"
  """
  @spec to_ewkt(Geometry.t(), Geometry.srid() | nil) :: wkt()
  def to_ewkt(geometry, nil) do
    Encoder.WKT.to_wkt(geometry)
  end

  def to_ewkt(geometry, srid) when is_integer(srid) do
    Encoder.WKT.to_ewkt(geometry, srid)
  end

  @doc """
  Returns the WKT representation of the given `geometry`.

  ## Examples

      iex> Geometry.to_wkt(PointZ.new(1.1, 2.2, 3.3))
      "Point Z (1.1 2.2 3.3)"

      iex> Geometry.to_wkt(LineString.new([Point.new(1, 2), Point.new(3, 4)]))
      "LineString (1 2, 3 4)"

      iex> Geometry.to_wkt(Point.new(1, 2))
      "Point (1 2)"
  """
  @spec to_wkt(Geometry.t()) :: wkt()
  def to_wkt(geometry) do
    Encoder.WKT.to_wkt(geometry)
  end

  @doc """
  Returns an `:ok` tuple with the geometry from the given EWKT string.

  Otherwise returns an `:error` tuple.

  If the given string is a `t:wkt/0` a nil for the SRID is returned.

  ## Examples

      iex> Geometry.from_ewkt("SRID=42;Point (1.1 2.2)")
      {:ok, {%Point{coordinate: [1.1, 2.2]}, 42}}

      iex> Geometry.from_ewkt("Point ZM (1 2 3 4)")
      {:ok, {%PointZM{coordinate: [1, 2, 3, 4]}, nil}}

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
  @spec from_ewkt(wkt()) :: {:ok, {t(), srid() | nil}} | {:error, DecodeError.t()}
  def from_ewkt(wkt) do
    with {:ok, geometry, srid} <- Decoder.WKT.decode(wkt) do
      {:ok, {geometry, srid}}
    end
  end

  @doc """
  The same as `from_ewkt/1`, but raises a `Geometry.DecodeError` exception if it fails.
  """
  @spec from_ewkt!(wkt()) :: {t(), srid() | nil}
  def from_ewkt!(wkt) do
    case from_ewkt(wkt) do
      {:ok, geometry} -> geometry
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns an `:ok` tuple with the geometry from the given WKT string.

  Otherwise returns an `:error` tuple.

  If the given string is a `t:ewkt/0` the SRID is ignored.

  ## Examples

      iex> Geometry.from_wkt("SRID=42;Point (1.1 2.2)")
      {:ok, %Point{coordinate: [1.1, 2.2]}}

      iex> Geometry.from_wkt("Point ZM (1 2 3 4)")
      {:ok, %PointZM{coordinate: [1, 2, 3, 4]}}

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
  def from_wkt(wkt) do
    with {:ok, geometry, _srid} <- Decoder.WKT.decode(wkt) do
      {:ok, geometry}
    end
  end

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
      {:ok, %Point{coordinate: [1, 2]}}

      iex> ~s({"type": "Point", "coordinates": [1, 2, 3, 4]})
      iex> |> Jason.decode!()
      iex> |> Geometry.from_geo_json(:xyzm)
      {:ok, %PointZM{coordinate: [1, 2, 3, 4]}}

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
  The same as `from_geo_josn/1`, but raises a `Geometry.DecodeError` exception if it
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
