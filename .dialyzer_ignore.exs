[
  # Ignore warnings caused by the following problem:
  # https://github.com/elixir-lang/elixir/issues/6738
  {"lib/geometry.ex", :pattern_match},
  {"lib/geometry.ex", :no_return},
  {"lib/geometry/decoder/wkt.ex", :pattern_match},
  {"lib/geometry/decoder/wkt.ex", :unused_fun},
  # ignore errros for Geometry.from_wkt! and Geometry.to_ewkt!
  {"lib/geometry.ex", :invalid_contract}
]
