defmodule Geometry.Decoder.WKT.ParserHelpers do
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
    "MultiPolygon",
    "GeometryCollection"
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
    |> label("geometry name or SRID")
  end

  @spec post_geometry(rest(), args(), context(), line(), offset()) :: {rest(), args(), context()}
  def post_geometry(rest, args, context, _line, _offset) do
    case args do
      [tag, geometry, srid] ->
        {rest, [%{geometry: geometry, tag: tag, srid: srid}], context}

      [tag, geometry] ->
        {rest, [%{geometry: geometry, tag: tag}], context}

      _missing_data ->
        {:error, :no_data_found}
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

  @spec next :: NimbleParsec.t()
  def next do
    whitespace()
    |> choice([empty_tag(), ascii_char([?(, ?,, ?)])])
    |> post_traverse({__MODULE__, :post_next, []})
    |> label("coordinates or EMPTY")
  end

  @spec post_next(rest(), args(), context(), line(), offset()) :: {rest(), args(), context()}
  def post_next(rest, args, context, _line, _offset) do
    cond do
      args in [~c"(", ~c","] -> {rest, [:next], context}
      args == [] -> {rest, [:empty], context}
      true -> {rest, [:halt], context}
    end
  end

  Enum.each(@types, fn type ->
    @spec unquote(:"point_#{type}")() :: NimbleParsec.t()
    def unquote(:"point_#{type}")() do
      choice([
        open()
        |> unquote(:"coordinate_#{type}")()
        |> close(),
        empty_tag()
      ])
      |> label("Point data")
    end
  end)

  Enum.each(@types, fn type ->
    @spec unquote(:"line_string_#{type}")(NimbleParsec.t()) :: NimbleParsec.t()
    def unquote(:"line_string_#{type}")(combinator \\ empty()) do
      concat(
        combinator,
        choice([
          open()
          |> unquote(:"coordinate_#{type}")()
          |> times(char(?,) |> unquote(:"coordinate_#{type}")(), min: 1)
          |> close(),
          empty_tag()
        ])
        |> label("LineString data")
      )
    end
  end)

  Enum.each(@types, fn type ->
    @spec unquote(:"polygon_#{type}")(NimbleParsec.t()) :: NimbleParsec.t()
    def unquote(:"polygon_#{type}")(combinator \\ empty()) do
      concat(
        combinator,
        choice([
          open()
          |> unquote(:"ring_#{type}")()
          |> repeat(char(?,) |> unquote(:"ring_#{type}")())
          |> close(),
          empty_tag()
        ])
        |> label("Polygon data")
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
      choice([
        open()
        |> unquote(:"point_or_coordinate_#{type}")()
        |> repeat(char(?,) |> unquote(:"point_or_coordinate_#{type}")())
        |> close(),
        empty_tag()
      ])
      |> label("MultiPoint data")
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
      choice([
        open()
        |> unquote(:"line_string_#{type}")()
        |> reduce({List, :wrap, []})
        |> repeat(char(?,) |> unquote(:"line_string_#{type}")() |> reduce({List, :wrap, []}))
        |> close(),
        empty_tag()
      ])
      |> label("MultiLineString data")
    end
  end)

  Enum.each(@types, fn type ->
    @spec unquote(:"multi_polygon_#{type}")() :: NimbleParsec.t()
    def unquote(:"multi_polygon_#{type}")() do
      choice([
        open()
        |> unquote(:"polygon_#{type}")()
        |> reduce({List, :wrap, []})
        |> repeat(char(?,) |> unquote(:"polygon_#{type}")() |> reduce({List, :wrap, []}))
        |> close(),
        empty_tag()
      ])
      |> label("MultiPolygon data")
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
        |> wrap()
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
    concat(combinator, any_case_string("SRID") |> ignore())
  end

  defp srid_value(combinator) do
    concat(combinator, whitespace() |> integer(min: 1))
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

  defp empty_tag, do: ignore(any_case_string("EMPTY"))

  @spec post_geometry_tag(rest(), args(), context(), line(), offset()) ::
          {rest(), args(), context()}
  def post_geometry_tag(rest, args, context, _line, _offset) do
    # add :xy to geometries whitout Z, M, or ZM tag
    case args do
      [geometry] -> {rest, [:xy, geometry], context}
      [_tag, _geometry] -> {rest, args, context}
    end
  end

  defp open(combinator \\ empty()) do
    concat(
      combinator,
      whitespace()
      |> string("(")
      |> whitespace()
      |> ignore()
    )
  end

  defp close(combinator) do
    concat(
      combinator,
      whitespace()
      |> string(")")
      |> whitespace()
      |> ignore()
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
    )
  end

  defp fraction(combinator \\ empty()) do
    combinator
    |> string(".")
    |> integer(min: 1)
  end

  @spec post_number(rest(), args(), context(), line(), offset()) :: {rest(), args(), context()}
  def post_number(rest, args, context, _line, _offset) do
    number =
      case args do
        [int] -> int
        [int, "+"] -> int
        [int, "-"] -> -1 * int
        [frac, ".", int] -> to_number(int, frac)
        [frac, ".", int, "+"] -> to_number(int, frac)
        [frac, ".", int, "-"] -> -1 * to_number(int, frac)
      end

    {rest, [number], context}
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
