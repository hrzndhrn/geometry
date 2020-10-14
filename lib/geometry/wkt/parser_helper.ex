# credo:disable-for-this-file Credo.Check.Readability.SinglePipe
defmodule Geometry.WKT.ParserHelper do
  @moduledoc false

  import NimbleParsec

  @type rest :: String.t()
  @type args :: list()
  @type context :: map()
  @type line :: {pos_integer(), non_neg_integer()}
  @type offset :: non_neg_integer()

  @geometries [
    "Point",
    "LineString",
    "Polygon",
    "MultiPoint",
    "MultiLineString",
    "MultiPolygon"
  ]
  @types ["xy", "xyz", "xyzm"]

  @spec geometry :: NimbleParsec.t()
  def geometry do
    selection =
      @geometries
      |> Enum.map(&geometry/1)
      |> Enum.concat([eos()])

    whitespace()
    |> optional(srid())
    |> choice(selection)
    |> post_traverse({__MODULE__, :post_geometry, []})
    |> label("'SRID', 'Geometry' or 'SRID;Geometry'")
  end

  @spec post_geometry(rest(), args(), context(), line(), offset()) :: {args(), context()}
  def post_geometry(_rest, args, context, _line, _offset) do
    case args do
      [tag, geometry, srid] ->
        {[%{geometry: geometry, tag: tag, srid: srid}], context}

      [tag, geometry] ->
        {[%{geometry: geometry, tag: tag}], context}
    end
  end

  @spec srid :: NimbleParsec.t()
  def srid do
    whitespace()
    |> srid_label()
    |> char(?=)
    |> srid_value()
    |> char(?;)
  end

  Enum.each(@types, fn type ->
    @spec unquote(:"point_#{type}")() :: NimbleParsec.t()
    def unquote(:"point_#{type}")() do
      # credo:disable-for-previous-line Credo.Check.Readability.Specs
      open()
      |> unquote(:"coordinate_#{type}")()
      |> close()
    end
  end)

  Enum.each(@types, fn type ->
    @spec unquote(:"line_string_#{type}")(NimbleParsec.t()) :: NimbleParsec.t()
    def unquote(:"line_string_#{type}")(combinator \\ empty()) do
      # credo:disable-for-previous-line Credo.Check.Readability.Specs
      concat(
        combinator,
        open()
        |> unquote(:"coordinate_#{type}")()
        |> times(char(?,) |> unquote(:"coordinate_#{type}")(), min: 1)
        |> close()
      )
    end
  end)

  Enum.each(@types, fn type ->
    @spec unquote(:"polygon_#{type}")(NimbleParsec.t()) :: NimbleParsec.t()
    def unquote(:"polygon_#{type}")(combinator \\ empty()) do
      # credo:disable-for-previous-line Credo.Check.Readability.Specs
      concat(
        combinator,
        open()
        |> unquote(:"ring_#{type}")()
        |> repeat(char(?,) |> unquote(:"ring_#{type}")())
        |> close()
      )
    end
  end)

  Enum.each(@types, fn type ->
    defp unquote(:"ring_#{type}")(combinator) do
      concat(
        combinator,
        open()
        |> unquote(:"coordinate_#{type}")()
        |> times(char(?,) |> unquote(:"coordinate_#{type}")(), min: 3)
        |> close()
        |> reduce({List, :wrap, []})
      )
    end
  end)

  Enum.each(@types, fn type ->
    @spec unquote(:"multi_point_#{type}")() :: NimbleParsec.t()
    def unquote(:"multi_point_#{type}")() do
      # credo:disable-for-previous-line Credo.Check.Readability.Specs
      open()
      |> unquote(:"point_or_coordinate_#{type}")()
      |> repeat(char(?,) |> unquote(:"point_or_coordinate_#{type}")())
      |> close()
    end
  end)

  Enum.each(@types, fn type ->
    defp unquote(:"point_or_coordinate_#{type}")(combinator) do
      concat(
        combinator,
        choice([unquote(:"coordinate_#{type}")(), unquote(:"point_#{type}")()])
      )
    end
  end)

  Enum.each(@types, fn type ->
    @spec unquote(:"multi_line_string_#{type}")() :: NimbleParsec.t()
    def unquote(:"multi_line_string_#{type}")() do
      # credo:disable-for-previous-line Credo.Check.Readability.Specs
      open()
      |> unquote(:"line_string_#{type}")()
      |> reduce({List, :wrap, []})
      |> repeat(char(?,) |> unquote(:"line_string_#{type}")() |> reduce({List, :wrap, []}))
      |> close()
    end
  end)

  Enum.each(@types, fn type ->
    @spec unquote(:"multi_polygon_#{type}")() :: NimbleParsec.t()
    def unquote(:"multi_polygon_#{type}")() do
      # credo:disable-for-previous-line Credo.Check.Readability.Specs
      open()
      |> unquote(:"polygon_#{type}")()
      |> reduce({List, :wrap, []})
      |> repeat(char(?,) |> unquote(:"polygon_#{type}")() |> reduce({List, :wrap, []}))
      |> close()
    end
  end)

  @types
  |> Enum.with_index(1)
  |> Enum.each(fn {type, n} ->
    defp unquote(:"coordinate_#{type}")(combinator \\ empty()) do
      concat(
        combinator,
        whitespace()
        |> number()
        |> times(separator() |> number(), unquote(n))
        |> reduce({List, :to_tuple, []})
      )
    end
  end)

  defp whitespace(combinator \\ empty()) do
    concat(
      combinator,
      [?\s, ?\t, ?\n]
      |> ascii_char()
      |> repeat()
      |> ignore()
    )
  end

  defp srid_label(combinator) do
    concat(combinator, any_case_string("SRID") |> label("SRID") |> ignore())
  end

  defp srid_value(combinator) do
    concat(combinator, whitespace() |> integer(min: 1) |> label("SRID value"))
  end

  defp char(combinator \\ empty(), char) do
    str = to_string([char])

    ignore(
      combinator,
      whitespace()
      |> string(str)
      |> label(str)
    )
  end

  defp separator(combinator \\ empty()) do
    concat(
      combinator,
      [?\s, ?\n]
      |> ascii_char()
      |> times(min: 1)
      |> ignore()
      |> label("another number")
    )
  end

  defp any_case_string(combinator \\ empty(), string) do
    downcase = string |> String.downcase() |> to_charlist()
    upcase = string |> String.upcase() |> to_charlist()

    upcase
    |> Enum.zip(downcase)
    |> Enum.reduce(combinator, fn {up_char, down_char}, acc ->
      ascii_char(acc, [up_char, down_char])
    end)
    |> reduce({IO, :iodata_to_binary, []})
  end

  defp geometry_tag(combinator) do
    optional(
      combinator,
      choice([
        any_case_string("ZM") |> replace(:xyzm),
        any_case_string("Z") |> replace(:xyz),
        any_case_string("M") |> replace(:xym)
      ])
    )
    |> post_traverse({__MODULE__, :post_geometry_tag, []})
  end

  @spec post_geometry_tag(rest(), args(), context(), line(), offset()) :: {args(), context()}
  def post_geometry_tag(_rest, args, context, _line, _offset) do
    # add :xy to geometries whitout Z, M, or ZM tag
    case args do
      [geometry] -> {[:xy, geometry], context}
      [_tag, _geometry] -> {args, context}
    end
  end

  defp open(combinator \\ empty()) do
    concat(
      combinator,
      whitespace()
      |> string("(")
      |> whitespace()
      |> ignore()
      |> label("(")
    )
  end

  defp close(combinator) do
    concat(
      combinator,
      whitespace()
      |> string(")")
      |> whitespace()
      |> ignore()
      |> label(")")
    )
  end

  defp number(combinator) do
    concat(
      combinator,
      whitespace()
      |> optional(choice([string("+"), string("-")]))
      |> integer(min: 1)
      |> optional(fraction())
      |> post_traverse({__MODULE__, :post_number, []})
      |> label("number")
    )
  end

  defp fraction(combinator \\ empty()) do
    combinator
    |> string(".")
    |> integer(min: 1)
  end

  @spec post_number(rest(), args(), context(), line(), offset()) :: {args(), context()}
  def post_number(_rest, args, context, _line, _offset) do
    number =
      case args do
        [int] -> int
        [int, "+"] -> int
        [int, "-"] -> -1 * int
        [frac, ".", int] -> to_number(int, frac)
        [frac, ".", int, "+"] -> to_number(int, frac)
        [frac, ".", int, "-"] -> -1 * to_number(int, frac)
      end

    {[number], context}
  end

  defp to_number(int, frac) do
    digits = frac |> Integer.digits() |> length()
    int + frac / :math.pow(10, digits)
  end

  defp geometry(geometry) do
    whitespace()
    |> any_case_string(geometry)
    |> replace(atom(geometry))
    |> whitespace()
    |> geometry_tag()
    |> whitespace()
  end

  defp atom(geometry) do
    geometry |> Macro.underscore() |> String.to_atom()
  end
end
