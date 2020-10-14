defmodule Geometry.WKT.Parser do
  @moduledoc false

  import NimbleParsec
  import Geometry.WKT.ParserHelper

  defparsecp(:geometry, geometry())

  defparsecp(:point_xy, point_xy())
  defparsecp(:point_xyz, point_xyz())
  defparsecp(:point_xyzm, point_xyzm())

  defparsecp(:line_string_xy, line_string_xy())
  defparsecp(:line_string_xyz, line_string_xyz())
  defparsecp(:line_string_xyzm, line_string_xyzm())

  defparsecp(:polygon_xy, polygon_xy())
  defparsecp(:polygon_xyz, polygon_xyz())
  defparsecp(:polygon_xyzm, polygon_xyzm())

  defparsecp(:multi_point_xy, multi_point_xy())
  defparsecp(:multi_point_xyz, multi_point_xyz())
  defparsecp(:multi_point_xyzm, multi_point_xyzm())

  defparsecp(:multi_line_string_xy, multi_line_string_xy())
  defparsecp(:multi_line_string_xyz, multi_line_string_xyz())
  defparsecp(:multi_line_string_xyzm, multi_line_string_xyzm())

  defparsecp(:multi_polygon_xy, multi_polygon_xy())
  defparsecp(:multi_polygon_xyz, multi_polygon_xyz())
  defparsecp(:multi_polygon_xyzm, multi_polygon_xyzm())

  @spec parse(Geometry.wkt()) ::
          {:ok, Geometry.t()} | {:ok, Geometry.t(), Geometry.srid()} | Geometry.wkt_error()
  def parse(string) do
    with {:ok, [info], rest, _context, line, byte_offset} <- geometry(string),
         {:ok, geometry} <-
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

  [
    "point",
    "polygon",
    "line_string",
    "multi_point",
    "multi_line_string",
    "multi_polygon"
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
    defp geometry_text({unquote(parser), type}, rest, opts) do
      case type do
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
    with {:ok, coordinates, "", _context, _postion, _byte_offset} <- data do
      {:ok, module.from_coordinates(coordinates)}
    end
  end
end
