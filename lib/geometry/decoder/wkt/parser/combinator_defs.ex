defmodule Geometry.Decoder.WKT.Parser.CombinatorDefs do
  @moduledoc false
  import NimbleParsec

  @type rest :: String.t()
  @type args :: list()
  @type context :: map()
  @type line :: {pos_integer(), non_neg_integer()}
  @type offset :: non_neg_integer()

  ####
  # Combinators
  ####
  @spec whitespace(NimpleParsec.t()) :: NimbleParsec.t()
  def whitespace(combinator \\ empty()) do
    concat(
      combinator,
      [?\s, ?\t, ?\n]
      |> ascii_char()
      |> repeat()
      |> ignore()
    )
  end

  @spec any_case_string(NimpleParsec.t()) :: NimbleParsec.t()
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

  @spec srid_label(NimpleParsec.t()) :: NimbleParsec.t()
  def srid_label(combinator) do
    concat(
      combinator,
      any_case_string("SRID") |> ignore()
    )
  end

  @spec srid_value(NimpleParsec.t()) :: NimbleParsec.t()
  def srid_value(combinator) do
    concat(
      combinator,
      whitespace() |> integer(min: 1)
    )
  end

  @spec char(NimpleParsec.t()) :: NimbleParsec.t()
  def char(combinator \\ empty(), char) do
    str = to_string([char])

    ignore(
      combinator,
      whitespace()
      |> string(str)
      |> label(str)
    )
  end

  @spec srid() :: NimbleParsec.t()
  def srid do
    whitespace()
    |> srid_label()
    |> char(?=)
    |> srid_value()
    |> char(?;)
  end

  @spec geometry_tag_match() :: NimbleParsec.t()
  def geometry_tag_match do
    choice([
      any_case_string("ZM") |> replace(:xyzm),
      any_case_string("Z") |> replace(:xyz),
      any_case_string("M") |> replace(:xym)
    ])
  end

  @spec geometry_tag(NimbleParsec.t()) :: NimbleParsec.t()
  def geometry_tag(combinator \\ empty()) do
    optional(
      combinator,
      geometry_tag_match()
    )
    |> post_traverse({__MODULE__, :post_geometry_tag, []})
  end

  @spec empty_tag() :: NimbleParsec.t()
  def empty_tag, do: ignore(any_case_string("EMPTY"))

  @spec post_next(rest(), args(), context(), line(), offset()) :: {rest(), args(), context()}
  def post_next(rest, args, context, _line, _offset) do
    cond do
      args in [~c"(", ~c","] -> {rest, [:next], context}
      args == [] -> {rest, [:empty], context}
      true -> {rest, [:halt], context}
    end
  end

  @spec next() :: NimbleParsec.t()
  def next do
    whitespace()
    |> choice([empty_tag(), ascii_char([?(, ?,, ?)])])
    |> post_traverse({__MODULE__, :post_next, []})
    |> label("coordinates or EMPTY")
  end

  @spec separator() :: NimbleParsec.t()
  def separator do
    [?\s, ?\n]
    |> ascii_char()
    |> times(min: 1)
    |> ignore()
  end

  @spec fraction() :: NimbleParsec.t()
  def fraction do
    string(".")
    |> ascii_string([?0..?9], min: 1)
  end

  @spec number(NimbleParsec.t()) :: NimbleParsec.t()
  def number(combinator \\ empty()) do
    concat(
      combinator,
      whitespace()
      |> optional(choice([string("+"), string("-")]))
      |> integer(min: 1)
      |> optional(fraction())
      |> post_traverse({__MODULE__, :post_number, []})
    )
  end

  @spec open() :: NimbleParsec.t()
  def open do
    whitespace()
    |> string("(")
    |> whitespace()
    |> ignore()
  end

  @spec close(NimbleParsec.t()) :: NimbleParsec.t()
  def close(combinator \\ empty()) do
    concat(
      combinator,
      whitespace()
      |> string(")")
      |> whitespace()
      |> ignore()
    )
  end

  ####
  # Post-match processing functions
  ####
  @spec post_geometry_tag(rest(), args(), context(), line(), offset()) ::
          {rest(), args(), context()}
  def post_geometry_tag(rest, args, context, _line, _offset) do
    # add :xy to geometries whitout Z, M, or ZM tag
    case args do
      [geometry] -> {rest, [:xy, geometry], context}
      [_tag, _geometry] -> {rest, args, context}
    end
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

  ####
  # Utilities
  ####
  @spec to_number(integer(), String.t()) :: number()
  defp to_number(int, frac_string) do
    digits = String.length(frac_string)
    frac = String.to_integer(frac_string)
    int + frac / :math.pow(10, digits)
  end

  @spec to_atom_name(String.t()) :: atom()
  def to_atom_name(name) do
    name
    |> String.downcase()
    |> String.to_atom()
  end

  @spec atom(String.t()) :: atom()
  def atom(geometry) do
    geometry |> Macro.underscore() |> String.to_atom()
  end
end
