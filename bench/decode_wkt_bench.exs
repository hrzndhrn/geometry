defmodule DecodeWktBench do
  use BencheeDsl.Benchmark

  import Support

  formatter Benchee.Formatters.Markdown,
    file: file(__MODULE__),
    title: "Decode WKT"

  inputs data(:wkt)

  job geo(wkts) do
    Enum.map(wkts, fn wkt -> Geo.WKT.decode!(wkt) end)
  end

  job geometry(wkts) do
    Enum.map(wkts, fn wkt -> Geometry.from_wkt!(wkt) end)
  end
end
