# Geometry
[![Hex.pm: version](https://img.shields.io/hexpm/v/geometry.svg?style=flat-square)](https://hex.pm/packages/geometry)
[![GitHub: CI status](https://img.shields.io/github/actions/workflow/status/hrzndhrn/geometry/ci.yml?branch=main&style=flat-square)](https://github.com/hrzndhrn/geometry/actions)
[![Coveralls: coverage](https://img.shields.io/coveralls/github/hrzndhrn/geometry?style=flat-square)](https://coveralls.io/github/hrzndhrn/geometry)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://github.com/hrzndhrn/geometry/blob/main/LICENSE.md)

A set of geometry types for WKT/WKB, EWKT/EWKB and GeoJson.

## Installation

The package can be installed by adding `geometry` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:geometry, "~> 0.3"}
  ]
end
```

## Examples

```elixir
iex> wkb = "00000000013FF0000000000000400199999999999A"
"00000000013FF0000000000000400199999999999A"
iex> point = Geo
Geo         Geometry
iex> point = Geometry.from_wk
from_wkb!/1    from_wkb/1     from_wkt!/1    from_wkt/1
iex> point = Geometry.from_wkb
from_wkb!/1    from_wkb/1
iex> point = Geometry.from_wkb(Base.decode16!(wkb))
{:ok, %Geometry.Point{coordinate: [1.0, 2.2]}}
iex> point = Geometry.from_wkb!(Base.decode16!(wkb))
%Geometry.Point{coordinate: [1.0, 2.2]}
iex> Geometry.to_wkt(point)
"Point (1.0 2.2)"
iex> line_string = Geometry.from_wkt!("LineString Z (1 2 3, 4 5 6, 9 9 9)")
%Geometry.LineStringZ{points: [[1, 2, 3], [4, 5, 6], [9, 9, 9]]}
iex> Geometry.to_wkb(line_string) |> Base.encode16()
"010200008003000000000000000000F03F00000000000000400000000000000840000000000000104000000000000014400000000000001840000000000000224000000000000022400000000000002240"
iex> Geometry.to_wkb(line_string, :xdr) |> Base.encode16()
"0080000002000000033FF000000000000040000000000000004008000000000000401000000000000040140000000000004018000000000000402200000000000040220000000000004022000000000000"
iex> polygon = Geometry.from_wkt!("POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10), (20 30, 35 35, 30 20, 20 30))")
%Geometry.Polygon{
  rings: [
    [[35, 10], [45, 45], [15, 40], [10, 20], [35, 10]],
    [[20, 30], [35, 35], [30, 20], [20, 30]]
  ]
}
iex> polygon |> Geometry.to_geo_json() |> Jason.encode!() |> IO.puts()
{"coordinates":[[[35,10],[45,45],[15,40],[10,20],[35,10]],[[20,30],[35,35],[30,20],[20,30]]],"type":"Polygon"}
:ok
```
