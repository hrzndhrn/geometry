defmodule Geometry do
  @moduledoc """
  A set of geometry types.
  """

  # TODO LIST
  # [open] add Geometry.Feature (GeoJson)
  # [open] add Geometry.FeatureCollection (GeoJson)
  # [open] add benchee to rewrite wkt/parser, maybe wkb/parser
  #
  # [done] add Geometry.GeometryCollection
  # [done] add tests for empty geometries from wkt
  # [done] check labels in wkt/parser
  #
  # [wont] (don't do this) check new inputs in multi

  alias Geometry.{
    GeoJson,
    GeometryCollection,
    GeometryCollectionM,
    GeometryCollectionZ,
    GeometryCollectionZM,
    LineString,
    LineStringM,
    LineStringZ,
    LineStringZM,
    MultiLineString,
    MultiLineStringM,
    MultiLineStringZ,
    MultiLineStringZM,
    MultiPoint,
    MultiPointM,
    MultiPointZ,
    MultiPointZM,
    MultiPolygon,
    MultiPolygonM,
    MultiPolygonZ,
    MultiPolygonZM,
    Point,
    PointM,
    PointZ,
    PointZM,
    Polygon,
    PolygonM,
    PolygonZ,
    PolygonZM
  }

  alias Geometry.{WKB, WKT}

  @geometries [
    GeometryCollection,
    GeometryCollectionM,
    GeometryCollectionZ,
    GeometryCollectionZM,
    LineString,
    LineStringM,
    LineStringZ,
    LineStringZM,
    MultiLineString,
    MultiLineStringM,
    MultiLineStringZ,
    MultiLineStringZM,
    MultiPoint,
    MultiPointM,
    MultiPointZ,
    MultiPointZM,
    MultiPolygon,
    MultiPolygonM,
    MultiPolygonZ,
    MultiPolygonZM,
    Polygon,
    PolygonM,
    PolygonZ,
    PolygonZM,
    Point,
    PointM,
    PointZ,
    PointZM
  ]

  @typedoc """
  A geometry is one of the provided geometries or geometry-collections.
  """
  @type t ::
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
  The `x` part of a `coordinate`. In a GIS context, this is the longitude
  specifying the east-west position.
  """
  @type x :: number()

  @typedoc """
  The `y` part of a `coordinate`. In a GIS context, this is the latitude
  specifying the east-west position.
  """
  @type y :: number()

  @typedoc """
  The `z` part of a `coordinate`. In a GIS context, this is the elevation.
  """
  @type z :: number()

  @typedoc """
  A user-defined measurement.
  """
  @type m :: number()

  @typedoc """
  A 2D coordinate.
  """
  @type coordinate :: {x(), y()} | [number(), ...]

  @typedoc """
  A 2D coordinate with a measurement.
  """
  @type coordinate_m :: {x(), y(), m()} | [number(), ...]

  @typedoc """
  A 3D coordinate.
  """
  @type coordinate_z :: {x(), y(), z()} | [number(), ...]

  @typedoc """
  A 2D coordinate with a measurement.
  """
  @type coordinate_zm :: {x(), y(), z(), m()} | [number(), ...]

  @typedoc """
  The Spatial Reference System Identifier to identify projected, unprojected,
  and local spatial coordinate system definitions.
  """
  @type srid :: integer()

  @typedoc """
  [Well-known text](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry)
  (WKT) is a text markup language for representing vector geometry objects.
  """
  @type wkt :: String.t()

  @typedoc """
  [Well-known binary]
  (https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry#Well-known_binary)
  The binary representation of WKT.
  """
  @type wkb :: binary()

  @typedoc """
  Errors that can occur when a geometry is generating from WKT.
  """
  @type wkt_error ::
          {:error, :unexpected, %{expected: t(), got: t()}}
          | {
              :error,
              message :: String.t(),
              rest :: String.t(),
              {line :: pos_integer(), offset :: non_neg_integer()},
              offset :: non_neg_integer()
            }

  @typedoc """
  Errors that can occur when a geometry is generating from WKT.
  """
  @type wkb_error ::
          {:error, :unexpected, %{expected: t(), got: t()}}
          | {:error, message :: String.t(), rest :: binary(), offset :: non_neg_integer()}

  @typedoc """
  A [GeoJson](https://geojson.org) term.
  """
  @type geo_json_term :: term()

  @typedoc """
  Errors that can occur when a geometry is generating from GeoJson.
  """
  @type geo_json_error ::
          {:error,
           :coordinates_not_found
           | :geometries_not_found
           | :invalid_data
           | :type_not_found
           | :unknown_type}

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
  def empty?(%module{} = geometry) when module in @geometries, do: module.empty?(geometry)

  @doc """
  Returns the WKB representation of a geometry. An optional `:srid` can be set
  in the options.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  ## Examples

      iex> Geometry.to_wkb(PointZ.new(1, 2, 3))
      "0101000080000000000000F03F00000000000000400000000000000840"

      iex> Geometry.to_wkb(Point.new(1, 2), srid: 4711, endian: :xdr)
      "0020000001000012673FF00000000000004000000000000000"
  """
  @spec to_wkb(t(), opts) :: String.t()
        when opts: [endian: endian(), srid: srid()]
  def to_wkb(%module{} = geometry, opts \\ []) when module in @geometries do
    module.to_wkb(geometry, opts)
  end

  @doc """
  Returns an `:ok` tuple with the geometry from the given WKT string. Otherwise
  returns an `:error` tuple.

  If WKB contains an SRID the tuple is extended by the id.

  ## Examples

      iex> Geometry.from_wkb("0101000080000000000000F03F00000000000000400000000000000840")
      {:ok, %PointZ{x: 1.0, y: 2.0, z: 3.0}}

      iex> Geometry.from_wkb("0020000001000012673FF00000000000004000000000000000")
      {:ok, %Point{x: 1.0, y: 2.0}, 4711}
  """
  @spec from_wkb(wkb()) :: {:ok, t()} | {:ok, t(), srid()} | wkb_error
  def from_wkb(wkb), do: WKB.Parser.parse(wkb)

  @doc """
  The same as `from_wkb/1, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(wkb()) :: t() | {t(), srid()}
  def from_wkb!(wkb) do
    case WKB.Parser.parse(wkb) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation of a geometry. An optional `:srid` can be set
  in the options.

  ## Examples

      iex> Geometry.to_wkt(Point.new(1, 2))
      "Point (1 2)"

      iex> Geometry.to_wkt(PointZ.new(1.1, 2.2, 3.3), srid: 4211)
      "SRID=4211;Point Z (1.1 2.2 3.3)"

      iex> Geometry.to_wkt(LineString.new([Point.new(1, 2), Point.new(3, 4)]))
      "LineString (1 2, 3 4)"
  """
  @spec to_wkt(t(), opts) :: String.t()
        when opts: [srid: srid()]
  def to_wkt(%module{} = geometry, opts \\ []) when module in @geometries do
    module.to_wkt(geometry, opts)
  end

  @doc """
  Returns an `:ok` tuple with the geometry from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> Geometry.from_wkt("Point ZM (1 2 3 4)")
      {:ok, %PointZM{x: 1, y: 2, z: 3, m: 4}}

      iex> Geometry.from_wkt("SRID=42;Point (1.1 2.2)")
      {:ok, %Point{x: 1.1, y: 2.2}, 42}
  """
  @spec from_wkt(wkt()) :: {:ok, t()} | {:ok, t(), srid()} | wkt_error
  def from_wkt(wkt), do: WKT.Parser.parse(wkt)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(wkt()) :: t() | {t(), srid()}
  def from_wkt!(wkt) do
    case WKT.Parser.parse(wkt) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
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
  def to_geo_json(%module{} = geometry) when module in @geometries,
    do: module.to_geo_json(geometry)

  @doc """
  Returns an `:ok` tuple with the geometry from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  The `:type` option specifies which type is expected. The
  possible values are `:z`, `:m`, and `:zm`.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1, 2]})
      iex> |> Jason.decode!()
      iex> |> Geometry.from_geo_json()
      {:ok, %Point{x: 1, y: 2}}

      iex> ~s({"type": "Point", "coordinates": [1, 2, 3, 4]})
      iex> |> Jason.decode!()
      iex> |> Geometry.from_geo_json(type: :zm)
      {:ok, %PointZM{x: 1, y: 2, z: 3, m: 4}}
  """
  @spec from_geo_json(geo_json_term(), opts) :: {:ok, t()} | geo_json_error
        when opts: [type: :z | :m | :zm]
  def from_geo_json(json, opts \\ []), do: GeoJson.to_geometry(json, opts)

  @doc """
  The same as `from_geo_josn/1, but raises a `Geometry.Error` exception if it
  fails.
  """
  @spec from_geo_json!(geo_json_term(), opts) :: t()
        when opts: [type: :z | :m | :zm]
  def from_geo_json!(json, opts \\ []) do
    case GeoJson.to_geometry(json, opts) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc false
  def default_endian, do: :ndr
end
