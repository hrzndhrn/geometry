defmodule Geometry.Decoder.WKT.Parser do
  @moduledoc false

  import Geometry.Decoder.WKT.Parser.Combinators

  alias Geometry.DecodeError

  @spec parse(Geometry.wkt()) ::
          {type :: atom(), dim :: atom(), data :: term(), srid :: Geometry.srid() | nil}
          | {:error, DecodeError.t()}
  def parse(string) do
    with {:ok, [info], rest, _context, line, byte_offset} <- geometry(string),
         {:ok, data, _rest, _context, _line, _byte_offset} <-
           geometry_text({info.geometry, info.tag}, rest, line: line, byte_offset: byte_offset) do
      {:ok, info.geometry, info.tag, data, Map.get(info, :srid)}
    else
      {:error, message, rest, _context, line, offset} ->
        {
          :error,
          %DecodeError{
            from: :wkt,
            message: message,
            rest: rest,
            line: line,
            offset: offset
          }
        }
    end
  end

  defp geometry_collection_item(string, opts) do
    with {:ok, [info], rest, context, line, byte_offset} <- geometry(string, opts) do
      case {info.tag == opts[:tag], Map.get(info, :srid)} do
        {true, nil} ->
          geometry_collection_item_text({info.geometry, info.tag}, rest,
            line: line,
            byte_offset: byte_offset
          )

        {false, nil} ->
          {:error, "unexpected geometry in collection", rest, context, line, byte_offset}

        {_tag, _srid} ->
          {:error, "unexpected SRID in collection", rest, context, line, byte_offset}
      end
    end
  end

  defp geometry_collection_item_text({geometry, _tag} = info, str, opts) do
    with {:ok, data, rest, context, line, byte_offset} <- geometry_text(info, str, opts) do
      {:ok, {geometry, data}, rest, context, line, byte_offset}
    end
  end

  for parser <- [
        :point,
        :polygon,
        :line_string,
        :circular_string,
        :compound_curve,
        :multi_point,
        :multi_line_string,
        :multi_polygon,
        :geometry_collection
      ] do
    defp geometry_text({unquote(parser), :xy}, rest, opts) do
      unquote(:"#{parser}_xy")(rest, Keyword.put(opts, :tag, :xy))
    end

    defp geometry_text({unquote(parser), :xyzm}, rest, opts) do
      unquote(:"#{parser}_xyzm")(rest, Keyword.put(opts, :tag, :xyzm))
    end

    defp geometry_text({unquote(parser), dim}, rest, opts) do
      unquote(:"#{parser}_xyz")(rest, Keyword.put(opts, :tag, dim))
    end
  end

  for geometry_collection <- [
        :geometry_collection_xy,
        :geometry_collection_xyz,
        :geometry_collection_xyzm
      ] do
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
          {:ok, {:geometries, Enum.reverse(acc)}, rest, context, line, byte_offset}
      end
    end
  end

  for compound_curve <- [
        :compound_curve_xy,
        :compound_curve_xyz,
        :compound_curve_xyzm
      ] do
    defp unquote(compound_curve)(string, opts, acc \\ []) do
      tag = Keyword.get(opts, :tag)

      case next(string, opts) do
        {:ok, [:empty], rest, context, line, byte_offset} ->
          {:ok, {:segments, acc}, rest, context, line, byte_offset}

        {:ok, [:next], rest, _context, line, byte_offset} ->
          with {:ok, geometry, rest, _context, line, byte_offset} <-
                 geometry_collection_item(rest,
                   line: line,
                   byte_offset: byte_offset,
                   tag: tag
                 ) do
            unquote(compound_curve)(
              rest,
              [line: line, byte_offset: byte_offset, tag: tag],
              [geometry | acc]
            )
          end

        {:ok, [:halt], rest, context, line, byte_offset} ->
          {:ok, {:segments, Enum.reverse(acc)}, rest, context, line, byte_offset}
      end
    end
  end
end
