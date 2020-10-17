defmodule Geometry.WKT.Parser do
  @moduledoc false

  import Geometry.WKT.Parsers

  @spec parse(Geometry.wkt()) ::
          {:ok, Geometry.t()} | {:ok, Geometry.t(), Geometry.srid()} | Geometry.wkt_error()
  def parse(string) do
    with {:ok, [info], rest, _context, line, byte_offset} <- geometry(string),
         {:ok, geometry, _rest, _context, _line, _byte_offset} <-
           geometry_text({info.geometry, info.tag}, rest, line: line, byte_offset: byte_offset) do
      case Map.fetch(info, :srid) do
        {:ok, srid} -> {:ok, geometry, srid}
        :error -> {:ok, geometry}
      end
    else
      {:error, message, rest, _context, line, byte_offset} ->
        {:error, message, rest, line, byte_offset}
    end
  end

  defp geometry_collection_item(string, opts) do
    with {:ok, [info], rest, context, line, byte_offset} <-
           geometry(string, opts) do
      case {info.tag == opts[:tag], Map.get(info, :srid)} do
        {true, nil} ->
          geometry_text({info.geometry, info.tag}, rest, line: line, byte_offset: byte_offset)

        {false, nil} ->
          {:error, "unexpected geometry in collection", rest, context, line, byte_offset}

        {_tag, _srid} ->
          {:error, "unexpected SRID in collection", rest, context, line, byte_offset}
      end
    end
  end

  [
    "point",
    "polygon",
    "line_string",
    "multi_point",
    "multi_line_string",
    "multi_polygon",
    "geometry_collection"
  ]
  |> Enum.map(fn parser ->
    module = Macro.camelize(parser)

    modules = [
      "Elixir.Geometry.#{module}",
      "Elixir.Geometry.#{module}Z",
      "Elixir.Geometry.#{module}M",
      "Elixir.Geometry.#{module}ZM"
    ]

    {String.to_atom(parser), Enum.map(modules, &String.to_atom/1)}
  end)
  |> Enum.each(fn {parser, [module, module_z, module_m, module_zm]} ->
    defp geometry_text({unquote(parser), tag}, rest, opts) do
      opts = Keyword.put(opts, :tag, tag)

      case tag do
        :xy ->
          geometry_text(unquote(module), unquote(:"#{parser}_xy")(rest, opts))

        :xyz ->
          geometry_text(unquote(module_z), unquote(:"#{parser}_xyz")(rest, opts))

        :xym ->
          geometry_text(unquote(module_m), unquote(:"#{parser}_xyz")(rest, opts))

        :xyzm ->
          geometry_text(unquote(module_zm), unquote(:"#{parser}_xyzm")(rest, opts))
      end
    end
  end)

  defp geometry_text(module, data) do
    case data do
      {:ok, [], rest, context, line, byte_offset} ->
        {:ok, struct(module), rest, context, line, byte_offset}

      {:ok, {:geometries, geometries}, rest, context, line, byte_offset} ->
        {:ok, module.new(geometries), rest, context, line, byte_offset}

      {:ok, coordinates, rest, context, line, byte_offset} ->
        {:ok, module.from_coordinates(coordinates), rest, context, line, byte_offset}

      error ->
        error
    end
  end

  Enum.each(
    [:geometry_collection_xy, :geometry_collection_xyz, :geometry_collection_xyzm],
    fn geometry_collection ->
      defp unquote(geometry_collection)(string, opts, acc \\ []) do
        tag = Keyword.get(opts, :tag)

        case next(string, opts) do
          {:ok, [:empty], rest, context, line, byte_offset} ->
            {:ok, {:geometries, acc}, rest, context, line, byte_offset}

          {:ok, [:next], rest, _context, line, byte_offset} ->
            with {:ok, geometry, rest, _context, line, byte_offset} <-
                   geometry_collection_item(rest,
                     line: line,
                     byte_offset: byte_offset,
                     tag: tag
                   ) do
              unquote(geometry_collection)(
                rest,
                [line: line, byte_offset: byte_offset, tag: tag],
                [geometry | acc]
              )
            end

          {:ok, [:halt], rest, context, line, byte_offset} ->
            {:ok, {:geometries, acc}, rest, context, line, byte_offset}

          error ->
            error
        end
      end
    end
  )
end
