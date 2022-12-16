defmodule EncodeWkbXdrHexBench do
  use BencheeDsl.Benchmark

  import Support

  @endian :xdr

  formatter Benchee.Formatters.Markdown,
    file: file(__MODULE__),
    title: "Encode WKB (XDR/hex)"

  inputs data(:elixir)

  job geo({_geometry, geos}) do
    Enum.map(geos, fn geo -> Geo.WKB.encode!(geo, @endian) end)
  end

  job geometry({geometries, _geo}) do
    Enum.map(geometries, fn geometry ->
      geometry |> Geometry.to_wkb(@endian) |> Base.encode16()
    end)
  end
end
