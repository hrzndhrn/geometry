defmodule Geometry.Decoder.WKT.Parser.CombinatorDefs do
  import NimbleParsec

  @type rest :: String.t()
  @type args :: list()
  @type context :: map()
  @type line :: {pos_integer(), non_neg_integer()}
  @type offset :: non_neg_integer()

  def atom(geometry) do
    geometry |> Macro.underscore() |> String.to_atom()
  end

  @spec post_geometry_tag(rest(), args(), context(), line(), offset()) ::
          {rest(), args(), context()}
  def post_geometry_tag(rest, args, context, _line, _offset) do
    # add :xy to geometries whitout Z, M, or ZM tag
    case args do
      [geometry] -> {rest, [:xy, geometry], context}
      [_tag, _geometry] -> {rest, args, context}
    end
  end

  @spec whitespace() :: NimbleParsec.t()
  def whitespace do
    [?\s, ?\t, ?\n]
    |> ascii_char()
    |> repeat()
    |> ignore()
  end

  @spec whitespace(NimpleParsec.t()) :: NimbleParsec.t()
  def whitespace(combinator) do
    concat(
      combinator,
      whitespace()
    )
  end

  def any_case_string(combinator \\ empty(), string) do
    downcase = string |> String.downcase() |> to_charlist()
    upcase = string |> String.upcase() |> to_charlist()

    upcase
    |> Enum.zip(downcase)
    |> Enum.reduce(combinator, fn {up_char, down_char}, acc ->
      ascii_char(acc, [up_char, down_char])
    end)
    |> reduce({IO, :iodata_to_binary, []})
  end

  def srid_label(combinator) do
    concat(
      combinator,
      any_case_string("SRID") |> ignore()
    )
  end

  def srid_value(combinator) do
    concat(
      combinator,
      whitespace() |> integer(min: 1)
    )
  end

  def char(combinator \\ empty(), char) do
    str = to_string([char])

    ignore(
      combinator,
      whitespace()
      |> string(str)
      |> label(str)
    )
  end

  def to_atom_name(name) do
    name
    |> String.downcase()
    |> String.to_atom()
  end

  @spec srid :: NimbleParsec.t()
  def srid do
    whitespace()
    |> srid_label()
    |> char(?=)
    |> srid_value()
    |> char(?;)
  end

  def geometry_tag_match do
    choice([
      any_case_string("ZM") |> replace(:xyzm),
      any_case_string("Z") |> replace(:xyz),
      any_case_string("M") |> replace(:xym)
    ])
  end

  def geometry_tag(combinator \\ empty()) do
    optional(
      combinator,
      geometry_tag_match()
    )
    |> post_traverse({__MODULE__, :post_geometry_tag, []})
  end

  def empty_tag, do: ignore(any_case_string("EMPTY"))

  @spec post_next(rest(), args(), context(), line(), offset()) :: {rest(), args(), context()}
  def post_next(rest, args, context, _line, _offset) do
    cond do
      args in [~c"(", ~c","] -> {rest, [:next], context}
      args == [] -> {rest, [:empty], context}
      true -> {rest, [:halt], context}
    end
  end

  @spec next :: NimbleParsec.t()
  def next do
    whitespace()
    |> choice([empty_tag(), ascii_char([?(, ?,, ?)])])
    |> post_traverse({__MODULE__, :post_next, []})
    |> label("coordinates or EMPTY")
  end

  def separator do
    [?\s, ?\n]
    |> ascii_char()
    |> times(min: 1)
    |> ignore()
  end

  def fraction do
    string(".")
    |> ascii_string([?0..?9], min: 1)
  end

  def number do
    whitespace()
    |> optional(choice([string("+"), string("-")]))
    |> integer(min: 1)
    |> optional(fraction())
    |> post_traverse({__MODULE__, :post_number, []})
  end

  def number(combinator) do
    concat(combinator, number())
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

  defp to_number(int, frac_string) do
    digits = String.length(frac_string)
    frac = String.to_integer(frac_string)
    int + frac / :math.pow(10, digits)
  end

  def open do
    whitespace()
    |> string("(")
    |> whitespace()
    |> ignore()
  end

  def close do
    whitespace()
    |> string(")")
    |> whitespace()
    |> ignore()
  end

  def close(combinator) do
    concat(
      combinator,
      whitespace()
      |> string(")")
      |> whitespace()
      |> ignore()
    )
  end
end
