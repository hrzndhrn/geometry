defmodule DecodeBench do
  use BencheeDsl.Benchmark


  formatter(Benchee.Formatters.Markdown,
    file: Path.join("bench", Macro.underscore(__MODULE__) <> ".md"),
    title: "Decode",
    description: "Generating structs from WKT, WKB and GeoJson"
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
    "WKT Point" => wkt(@geometries.point),
    "WKT LineString" => wkt(@geometries.line_string),
    "WKT LineString (long)" => wkt(@geometries.long_line_string),
    "WKT Polygon" => wkt(@geometries.polygon),
    "WKB Point" => wkb(@geometries.point),
    "WKB LineString" => wkb(@geometries.line_string),
    "WKB LineString (long)" => wkb(@geometries.long_line_string),
    "WKB Polygon" => wkb(@geometries.polygon),
    "GeoJson Point" => geo_json(@geometries.point),
    "GeoJson LineString" => geo_json(@geometries.line_string),
    "GeoJson LineString (long)" => geo_json(@geometries.long_line_string),
    "GeoJson Polygon" => geo_json(@geometries.polygon)
  })

  job geometry({type, geometry}) do
    case type do
      :wkt -> Geometry.from_wkt!(geometry)
      :wkb -> Geometry.from_wkb!(geometry, :hex)
      :geo_json -> Geometry.from_geo_json!(geometry)
    end
  end

  job geo({type, geometry}) do
    case type do
      :wkt -> Geo.WKT.decode!(geometry)
      :wkb -> Geo.WKB.decode!(geometry)
      :geo_json -> Geo.JSON.decode!(geometry)
    end
  end

  defp wkt(wkt), do: {:wkt, wkt}

  defp wkb(wkt) do
    {:wkb, wkt |> Geometry.from_wkt!() |> Geometry.to_wkb(mode: :hex)}
  end

  defp geo_json(wkt) do
    {:geo_json, wkt |> Geometry.from_wkt!() |> Geometry.to_geo_json()}
  end
end
