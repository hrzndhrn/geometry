# Geometry Project Memory

## Project Overview
Elixir library for WKT/WKB/GeoJSON encoding/decoding of geometry types.
Each geometry type has 4 variants: base (XY), Z, M, ZM.

## Architecture

### Key Files
- `lib/geometry.ex` - Main module: aliases, @type t(), documentation
- `lib/geometry/protocols.ex` - Code-gen macros for all protocol implementations
- `lib/geometry/decoder/wkb.ex` - WKB binary decoder (compile-time generated)
- `lib/geometry/decoder/wkt.ex` - WKT text decoder (geometry struct construction)
- `lib/geometry/decoder/wkt/parser.ex` - WKT parser logic (NimbleParsec-based)
- `lib/geometry/decoder/wkt/parser/combinators.ex` - NimbleParsec combinators + @geometries list

### Adding a New Geometry Type (checklist)
1. Create 4 struct files: `lib/geometry/multi_foo.ex`, `_z.ex`, `_m.ex`, `_zm.ex`
   - `use Geometry.Protocols` auto-generates all protocol impls
2. `lib/geometry/protocols.ex`:
   - Add to `@codes` (next integer)
   - Add to `@geometry_keys` (field name)
   - Add to `@multi` if it's a collection (enables Enumerable)
   - Add `defmacro wkb(:multi_foo, dim)` after existing wkb macros
   - Add `defmacro wkt(:multi_foo, dim)` after existing wkt macros
3. `lib/geometry/decoder/wkb.ex`:
   - Add aliases
   - Add to geos list (determines WKB type code via index)
   - Add entries to `endian_code_bin` map if sub-geometry dispatch needed
   - Add `defp foo/4` and `defp foo_items/6` decoder functions
4. `lib/geometry/decoder/wkt.ex`:
   - Add aliases
   - Add `defp geometry(:foo, dim, ...)` clauses
5. `lib/geometry/decoder/wkt/parser/combinators.ex`:
   - Add `"FooName"` to `@geometries` list (enables WKT keyword parsing)
6. `lib/geometry/decoder/wkt/parser.ex`:
   - Add `:foo` to the `for parser <- [...]` list
   - Add `foo_item/2`, `foo_item_text/2` helper functions
   - Add `for foo <- [:foo_xy, :foo_xyz, :foo_xyzm]` parser loop
7. `lib/geometry.ex`:
   - Add aliases
   - Add to `@type t()`
   - Update `@moduledoc`

### WKB Type Codes
Type codes are sequential (1-indexed) from the geos list in decoder/wkb.ex:
point=1, line_string=2, polygon=3, multi_point=4, multi_line_string=5,
multi_polygon=6, geometry_collection=7, circular_string=8, compound_curve=9,
curve_polygon=10, multi_curve=11

Dimension flags (added to code): xy=0, xym=0x40, xyz=0x80, xyzm=0xC0, +srid=+0x20

### Collections with Heterogeneous Sub-geometries
For collections like CurvePolygon, CompoundCurve, MultiCurve:
- WKB encoder: use `Enum.map(items, fn g -> Geometry.to_wkb(g, endian) end)`
- WKB decoder: use custom loop function matching on prefix bytes
- WKT encoder: use `Enum.map_join(items, ", ", fn g -> Geometry.to_wkt(g) end)`
- WKT parser: bare `(...)` input accepted as LineString via `geometry_or_line_string`

### Test Pattern
- Tests in `test/geometry/foo_test.exs` follow curve_polygon_test.exs pattern
- Use `Enum.each([...modules...], fn ... -> describe/test blocks end)`
- WKB data from hex strings (matching zzz/*.md reference data)
- Helper functions: `wkt/5` (with `expand` for to_wkt vs from_wkt differences)
