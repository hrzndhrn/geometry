# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

```bash
mix test                                    # run all tests
mix test test/geometry/foo_test.exs         # run a single test file
mix carp                                    # run tests with --seed 0 --max-failures 1
mix format                                  # format code
mix credo                                   # lint
mix coveralls                               # test coverage
```

## Architecture

Elixir library for WKT/EWKT, WKB/EWKB, and GeoJSON encoding/decoding of geometry types.

### Geometry Variants

Every geometry type exists in 4 dimension variants: base (XY), Z (XYZ), M (XYM), ZM (XYZM). For example: `Point`, `PointZ`, `PointM`, `PointZM`. Each is its own struct file in `lib/geometry/`.

### Code Generation via `use Geometry.Protocols`

Each struct file contains only the struct definition and `use Geometry.Protocols`. The macro in `lib/geometry/protocols.ex` generates all protocol implementations (WKB encoder/decoder, WKT encoder, GeoJSON encoder, `Enumerable`, `Collectable`, `empty?`) at compile time.

`lib/geometry/protocols.ex` contains:
- `@codes` — sequential WKB type codes (1-indexed): point=1, line_string=2, polygon=3, multi_point=4, multi_line_string=5, multi_polygon=6, geometry_collection=7, circular_string=8, compound_curve=9, curve_polygon=10, multi_curve=11
- `@geometry_keys` — field names for each type
- `@multi` — list of collection types (enables `Enumerable`/`Collectable`)
- `defmacro wkb/2` and `defmacro wkt/2` — code-gen entry points

### WKB Encoding

WKB type codes use dimension flags: xy=0x00, xym=0x40, xyz=0x80, xyzm=0xC0 (added to base code). SRID flag adds 0x20. Endian prefix: XDR (big-endian) = `0x00`, NDR (little-endian) = `0x01`.

### Decoder Pipeline

- `lib/geometry/decoder/wkb.ex` — binary WKB decoder; most dispatch functions are compile-time generated. Uses a `geos` list to map type codes to modules by index.
- `lib/geometry/decoder/wkt.ex` — constructs geometry structs from parsed WKT tokens
- `lib/geometry/decoder/wkt/parser.ex` — NimbleParsec-based WKT parser logic
- `lib/geometry/decoder/wkt/parser/combinators.ex` — NimbleParsec combinators; `@geometries` list controls which WKT keywords are recognized

### Encoder Pipeline

- `lib/geometry/encoder/wkb.ex` — WKB binary encoder
- `lib/geometry/encoder/wkt.ex` — WKT text encoder
- `lib/geometry/encoder/geo_json.ex` — GeoJSON encoder

### Collections with Heterogeneous Sub-geometries

For types like `CurvePolygon`, `CompoundCurve`, `MultiCurve`:
- WKB decoder uses a custom loop matching on prefix bytes to dispatch to sub-geometry decoders
- WKT parser accepts bare `(...)` coordinates as `LineString` via `geometry_or_line_string`

## Adding a New Geometry Type

1. Create 4 struct files: `lib/geometry/foo.ex`, `foo_z.ex`, `foo_m.ex`, `foo_zm.ex` using `use Geometry.Protocols`
2. `lib/geometry/protocols.ex`: add to `@codes`, `@geometry_keys`, `@multi` (if collection), add `defmacro wkb(:foo, dim)` and `defmacro wkt(:foo, dim)`
3. `lib/geometry/decoder/wkb.ex`: add aliases, add to `geos` list, add decoder functions
4. `lib/geometry/decoder/wkt.ex`: add aliases, add `defp geometry(:foo, dim, ...)` clauses
5. `lib/geometry/decoder/wkt/parser/combinators.ex`: add name string to `@geometries`
6. `lib/geometry/decoder/wkt/parser.ex`: add to `for parser <- [...]` list, add helper functions
7. `lib/geometry.ex`: add aliases, add to `@type t()`, update `@moduledoc`

## Test Conventions

Tests in `test/geometry/foo_test.exs` use `Enum.each` over 4 module configs to generate tests for all dimension variants at compile time via `unquote`.

**Two data-key patterns exist across test files:**
- Files for curve types (multi_curve, compound_curve, curve_polygon) use `data[:wkb_xdr]` / `data[:wkb_ndr]` and have `unexpected_wkb_xdr` / `unexpected_wkb_ndr` for error cases.
- Files for other types (circular_string, multi_point, multi_line_string, multi_polygon) use `data[:xdr]` / `data[:ndr]` and need explicit `invalid_wkb_xdr` / `invalid_wkb_ndr` entries.

**Test helpers in `test/support/`:**
- `Binary` — `replace/3`, `take/2`, `drop/2` for manipulating binary WKB data
- `Assertions` — custom assertions for geometry comparisons
- `GeoJsonValidator` — validates GeoJSON output against schema

Reference WKB hex data is in `zzz/*.md` files.
