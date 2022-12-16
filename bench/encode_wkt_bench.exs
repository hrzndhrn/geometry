defmodule EncodeWktBench do
  use BencheeDsl.Benchmark

  import Support

  formatter Benchee.Formatters.Markdown,
    file: file(__MODULE__),
    title: "Encode WKT"

  inputs data(:elixir)

  job geo({_geometry, geos}) do
    Enum.map(geos, fn geo -> Geo.WKT.encode!(geo) end)
  end

  job geometry({geometries, _geo}) do
    Enum.map(geometries, fn geometry -> Geometry.to_wkt(geometry) end)
  end
end
