defmodule EncodeGeoJsonBench do
  use BencheeDsl.Benchmark

  @title "Decode"
  @description "Generating structs from WKT, WKB and GeoJson"

  formatter(Benchee.Formatters.Markdown,
    file: Path.join("bench", Macro.underscore(__MODULE__) <> ".md"),
    description: @description
  )

  @geometries %{
    point: "POINT(1 2)",
    line_string: "LINESTRING(30 10,10 30,40 40)",
    long_line_string: "LINESTRING(30 10#{String.duplicate(", 1 1", 1_000)})",
    polygon: """
    POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10), (20 30, 35 35, 30 20, 20 30))\
    """
  }

  inputs(%{
    "Point" => decode!(@geometries.point),
    "LineString" => decode!(@geometries.line_string),
    "LineString (long)" => decode!(@geometries.long_line_string),
    "Polygon" => decode!(@geometries.polygon)
  })

  job geometry({geometry, _geo}) do
    Geometry.to_geo_json(geometry)
  end

  job geo({_geometry, geo}) do
    Geo.JSON.encode!(geo)
  end

  defp decode!(wkt) do
    {Geometry.from_wkt!(wkt), Geo.WKT.decode!(wkt)}
  end
end
