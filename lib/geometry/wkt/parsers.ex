defmodule Geometry.WKT.Parsers do
  @moduledoc false

  import Geometry.WKT.ParsersHelper
  import NimbleParsec

  defparsec(:geometry, geometry())

  defparsec(:point_xy, point_xy())
  defparsec(:point_xyz, point_xyz())
  defparsec(:point_xyzm, point_xyzm())

  defparsec(:line_string_xy, line_string_xy())
  defparsec(:line_string_xyz, line_string_xyz())
  defparsec(:line_string_xyzm, line_string_xyzm())

  defparsec(:polygon_xy, polygon_xy())
  defparsec(:polygon_xyz, polygon_xyz())
  defparsec(:polygon_xyzm, polygon_xyzm())

  defparsec(:multi_point_xy, multi_point_xy())
  defparsec(:multi_point_xyz, multi_point_xyz())
  defparsec(:multi_point_xyzm, multi_point_xyzm())

  defparsec(:multi_line_string_xy, multi_line_string_xy())
  defparsec(:multi_line_string_xyz, multi_line_string_xyz())
  defparsec(:multi_line_string_xyzm, multi_line_string_xyzm())

  defparsec(:multi_polygon_xy, multi_polygon_xy())
  defparsec(:multi_polygon_xyz, multi_polygon_xyz())
  defparsec(:multi_polygon_xyzm, multi_polygon_xyzm())

  defparsec(:next, next())
end
