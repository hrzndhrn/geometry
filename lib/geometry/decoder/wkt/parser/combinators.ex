defmodule Geometry.Decoder.WKT.Parser.Combinators do
  @moduledoc false

  import NimbleParsec
  import Geometry.Decoder.WKT.Parser.CombinatorDefs

  @geometries [
    "Point",
    "LineString",
    "Polygon",
    "CircularString",
    "CompoundCurve",
    "MultiPoint",
    "MultiLineString",
    "MultiPolygon",
    "GeometryCollection"
  ]
  @types ["xy", "xyz", "xyzm"]

  Enum.map(@geometries, fn geometry ->
    defcombinator(
      to_atom_name(geometry),
      whitespace()
      |> any_case_string(geometry)
      |> replace(atom(geometry))
      |> whitespace()
      |> geometry_tag()
      |> whitespace()
      |> label("geometry name or SRID")
    )
  end)

  defcombinator(
    :geometry_selection,
    choice(Enum.map(@geometries, fn geometry -> parsec(to_atom_name(geometry)) end))
  )

  defparsec(:next, next())

  defparsec(
    :geometry,
    whitespace()
    |> optional(srid())
    |> parsec(:geometry_selection)
    |> post_traverse({Geometry.Decoder.WKT.Parser.CombinatorDefs, :post_geometry, []})
  )

  @types
  |> Enum.with_index(1)
  |> Enum.each(fn {type, type_index} ->
    defparsec(
      :"point_#{type}",
      choice([
        open()
        |> parsec(:"coordinate_#{type}")
        |> close(),
        empty_tag()
      ])
      |> label("Point data")
    )

    defparsec(
      :"multi_point_#{type}",
      choice([
        open()
        |> parsec(:"point_or_coordinate_#{type}")
        |> repeat(char(?,) |> parsec(:"point_or_coordinate_#{type}"))
        |> close(),
        empty_tag()
      ])
      |> label("MultiPoint data")
    )

    defparsec(
      :"line_string_#{type}",
      choice([
        open()
        |> parsec(:"coordinate_#{type}")
        |> times(char(?,) |> parsec(:"coordinate_#{type}"), min: 1)
        |> close(),
        empty_tag()
      ])
      |> label("LineString data")
    )

    defparsec(
      :"multi_line_string_#{type}",
      choice([
        open()
        |> parsec(:"line_string_#{type}")
        |> reduce({List, :wrap, []})
        |> repeat(
          char(?,)
          |> parsec(:"line_string_#{type}")
          |> reduce({List, :wrap, []})
        )
        |> close(),
        empty_tag()
      ])
      |> label("MultiLineString data")
    )

    defparsec(
      :"polygon_#{type}",
      choice([
        open()
        |> parsec(:"ring_#{type}")
        |> repeat(char(?,) |> parsec(:"ring_#{type}"))
        |> close(),
        empty_tag()
      ])
      |> label("Polygon data")
    )

    defparsec(
      :"multi_polygon_#{type}",
      choice([
        open()
        |> parsec(:"polygon_#{type}")
        |> reduce({List, :wrap, []})
        |> repeat(char(?,) |> parsec(:"polygon_#{type}") |> reduce({List, :wrap, []}))
        |> close(),
        empty_tag()
      ])
      |> label("MultiPolygon data")
    )

    defcombinator(
      :"ring_#{type}",
      open()
      |> parsec(:"coordinate_#{type}")
      |> times(char(?,) |> parsec(:"coordinate_#{type}"), min: 3)
      |> close()
      |> reduce({List, :wrap, []})
    )

    defparsec(
      :"circular_string_#{type}",
      choice([
        open()
        |> parsec(:"coordinate_#{type}")
        |> times(
          char(?,)
          |> parsec(:"coordinate_#{type}")
          |> char(?,)
          |> parsec(:"coordinate_#{type}"),
          min: 1
        )
        |> close(),
        empty_tag()
      ])
      |> label("CircularString data")
    )

    defcombinator(
      :"point_or_coordinate_#{type}",
      choice([parsec(:"coordinate_#{type}"), parsec(:"point_#{type}")])
    )

    defcombinator(
      :"coordinate_#{type}",
      whitespace()
      |> number()
      |> times(separator() |> number(), type_index)
      |> wrap()
    )
  end)
end
