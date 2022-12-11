defmodule Geometry.WKB.Parser do
  @moduledoc false

  alias Geometry.GeometryCollection
  alias Geometry.GeometryCollectionM
  alias Geometry.GeometryCollectionZ
  alias Geometry.GeometryCollectionZM
  alias Geometry.Hex
  alias Geometry.LineString
  alias Geometry.LineStringM
  alias Geometry.LineStringZ
  alias Geometry.LineStringZM
  alias Geometry.MultiLineString
  alias Geometry.MultiLineStringM
  alias Geometry.MultiLineStringZ
  alias Geometry.MultiLineStringZM
  alias Geometry.MultiPoint
  alias Geometry.MultiPointM
  alias Geometry.MultiPointZ
  alias Geometry.MultiPointZM
  alias Geometry.MultiPolygon
  alias Geometry.MultiPolygonM
  alias Geometry.MultiPolygonZ
  alias Geometry.MultiPolygonZM
  alias Geometry.Point
  alias Geometry.PointM
  alias Geometry.PointZ
  alias Geometry.PointZM
  alias Geometry.Polygon
  alias Geometry.PolygonM
  alias Geometry.PolygonZ
  alias Geometry.PolygonZM

  @codes %{
    0x00000001 => {Point, false},
    0x20000001 => {Point, true},
    0x40000001 => {PointM, false},
    0x60000001 => {PointM, true},
    0x80000001 => {PointZ, false},
    0xA0000001 => {PointZ, true},
    0xC0000001 => {PointZM, false},
    0xE0000001 => {PointZM, true},
    0x00000002 => {LineString, false},
    0x20000002 => {LineString, true},
    0x40000002 => {LineStringM, false},
    0x60000002 => {LineStringM, true},
    0x80000002 => {LineStringZ, false},
    0xA0000002 => {LineStringZ, true},
    0xC0000002 => {LineStringZM, false},
    0xE0000002 => {LineStringZM, true},
    0x00000003 => {Polygon, false},
    0x20000003 => {Polygon, true},
    0x40000003 => {PolygonM, false},
    0x60000003 => {PolygonM, true},
    0x80000003 => {PolygonZ, false},
    0xA0000003 => {PolygonZ, true},
    0xC0000003 => {PolygonZM, false},
    0xE0000003 => {PolygonZM, true},
    0x00000004 => {MultiPoint, false},
    0x20000004 => {MultiPoint, true},
    0x40000004 => {MultiPointM, false},
    0x60000004 => {MultiPointM, true},
    0x80000004 => {MultiPointZ, false},
    0xA0000004 => {MultiPointZ, true},
    0xC0000004 => {MultiPointZM, false},
    0xE0000004 => {MultiPointZM, true},
    0x00000005 => {MultiLineString, false},
    0x20000005 => {MultiLineString, true},
    0x40000005 => {MultiLineStringM, false},
    0x60000005 => {MultiLineStringM, true},
    0x80000005 => {MultiLineStringZ, false},
    0xA0000005 => {MultiLineStringZ, true},
    0xC0000005 => {MultiLineStringZM, false},
    0xE0000005 => {MultiLineStringZM, true},
    0x00000006 => {MultiPolygon, false},
    0x20000006 => {MultiPolygon, true},
    0x40000006 => {MultiPolygonM, false},
    0x60000006 => {MultiPolygonM, true},
    0x80000006 => {MultiPolygonZ, false},
    0xA0000006 => {MultiPolygonZ, true},
    0xC0000006 => {MultiPolygonZM, false},
    0xE0000006 => {MultiPolygonZM, true},
    0x00000007 => {GeometryCollection, false},
    0x20000007 => {GeometryCollection, true},
    0x40000007 => {GeometryCollectionM, false},
    0x60000007 => {GeometryCollectionM, true},
    0x80000007 => {GeometryCollectionZ, false},
    0xA0000007 => {GeometryCollectionZ, true},
    0xC0000007 => {GeometryCollectionZM, false},
    0xE0000007 => {GeometryCollectionZM, true}
  }

  @spec parse(wkb, mode) :: {:ok, geometry | {geometry, srid}} | {:error, message, rest, offset}
        when wkb: Geometry.wkb(),
             mode: Geometry.mode(),
             geometry: Geometry.t(),
             srid: Geometry.srid(),
             message: String.t(),
             rest: binary(),
             offset: non_neg_integer()
  def parse(wkb, mode) do
    with {:ok, {module, endian, srid?}, rest, offset} <-
           geometry(wkb, 0, mode),
         {:ok, srid, rest, offset} <- srid(rest, offset, srid?, endian, mode),
         {:ok, geometry, rest, offset} <- geometry_body(module, rest, offset, endian, mode),
         :ok <- eos(rest, offset) do
      case srid? do
        true -> {:ok, {geometry, srid}}
        false -> {:ok, geometry}
      end
    end
  end

  # compile-time helpers

  to_atoms = fn lists ->
    Enum.map(lists, fn list -> Enum.map(list, &String.to_atom/1) end)
  end

  extend = fn xs, ys ->
    Enum.map(ys, fn y ->
      Enum.map(xs, fn x -> x <> y end)
    end)
  end

  args = fn list ->
    list |> extend.(["", "_z", "_m", "_zm"]) |> to_atoms.()
  end

  # combinators/parsers

  defp geometry(str, offset, mode) do
    with {:ok, endian, rest, offset} <- endian(str, offset, mode),
         {:ok, {module, srid?}, rest, offset} <- code(rest, offset, endian, mode) do
      {:ok, {module, endian, srid?}, rest, offset}
    end
  end

  defp endian(<<"00", rest::binary>>, offset, :hex) do
    {:ok, :xdr, rest, offset + 2}
  end

  defp endian(<<"01", rest::binary>>, offset, :hex) do
    {:ok, :ndr, rest, offset + 2}
  end

  defp endian(<<got::binary-size(2), rest::binary>>, offset, :hex) do
    {:error, ~s(expected endian flag "00" or "01", got #{inspect(got)}), rest, offset}
  end

  defp endian(str, offset, :hex) do
    {:error, ~s(expected endian flag "00" or "01"), str, offset}
  end

  defp endian(<<0::8, rest::binary>>, offset, :binary) do
    {:ok, :xdr, rest, offset + 1}
  end

  defp endian(<<1::8, rest::binary>>, offset, :binary) do
    {:ok, :ndr, rest, offset + 1}
  end

  defp endian(str, offset, :binary) do
    {:error, "expected endian flag", str, offset}
  end

  defp check_endian(<<endian::binary-size(2), rest::binary>>, offset, expected, :hex) do
    case {endian, expected} do
      {"00", :xdr} ->
        {:ok, rest, offset + 2}

      {"01", :ndr} ->
        {:ok, rest, offset + 2}

      {got, :ndr} ->
        {:error, ~s(expected endian flag "01", got #{inspect(got)}), rest, offset}

      {got, :xdr} ->
        {:error, ~s(expected endian flag "00", got #{inspect(got)}), rest, offset}
    end
  end

  defp check_endian(<<0::8, rest::binary>>, offset, :xdr, :binary) do
    {:ok, rest, offset + 1}
  end

  defp check_endian(<<1::8, rest::binary>>, offset, :ndr, :binary) do
    {:ok, rest, offset + 1}
  end

  defp check_endian(rest, offset, endian, _mode) do
    {:error, "expected endian #{inspect(endian)}", rest, offset}
  end

  defp code(<<code::binary-size(8), rest::binary>>, offset, endian, :hex) do
    case fetch_info(code, endian) do
      {:ok, info} ->
        {:ok, info, rest, offset + 8}

      {:error, :invalid} ->
        {:error, "invalid geomtry code: #{inspect(code)}", rest, offset}

      :error ->
        {:error, "unknown geomtry code: #{inspect(code)}", rest, offset}
    end
  end

  defp code(<<code::big-integer-size(32), rest::binary>>, offset, :xdr, :binary) do
    code(code, rest, offset)
  end

  defp code(<<code::little-integer-size(32), rest::binary>>, offset, :ndr, :binary) do
    code(code, rest, offset)
  end

  defp code(str, offset, _endian, _mode) do
    {:error, "expected geometry code", str, offset}
  end

  defp code(code, rest, offset) do
    case Map.fetch(@codes, code) do
      {:ok, info} ->
        {:ok, info, rest, offset + 4}

      :error ->
        {:error, "unknown geomtry code: #{inspect(code)}", rest, offset}
    end
  end

  defp check_code(<<code::binary-size(8), rest::binary>>, offset, endian, :hex, type) do
    case fetch_info(code, endian) do
      {:ok, {module, _srid?}} ->
        case Macro.underscore(module) == "geometry/#{type}" do
          true -> {:ok, rest, offset + 8}
          false -> {:error, "unexpected code #{inspect(code)} for sub-geometry", rest, offset}
        end

      {:error, :invalid} ->
        {:error, "invalid sub-geomtry code: #{inspect(code)}", rest, offset}

      :error ->
        {:error, "unknown sub-geomtry code: #{inspect(code)}", rest, offset}
    end
  end

  defp check_code(<<code::big-integer-size(32), rest::binary>>, offset, :xdr, :binary, type) do
    check_code(code, rest, offset, type)
  end

  defp check_code(<<code::little-integer-size(32), rest::binary>>, offset, :ndr, :binary, type) do
    check_code(code, rest, offset, type)
  end

  defp check_code(str, offset, _endian, _mode, _type) do
    {:error, "expected geometry code", str, offset}
  end

  defp check_code(code, rest, offset, type) do
    case Map.fetch(@codes, code) do
      {:ok, {module, _srid?}} ->
        case Macro.underscore(module) == "geometry/#{type}" do
          true -> {:ok, rest, offset + 4}
          false -> {:error, "unexpected code #{inspect(code)} for sub-geometry", rest, offset}
        end

      :error ->
        {:error, "unknown sub-geomtry code: #{inspect(code)}", rest, offset}
    end
  end

  [
    "point",
    "line_string",
    "polygon",
    "multi_point",
    "multi_line_string",
    "multi_polygon"
  ]
  |> Enum.flat_map(fn geometry ->
    module = Macro.camelize(geometry)

    [
      ["Elixir.Geometry.#{module}", geometry],
      ["Elixir.Geometry.#{module}M", "#{geometry}_m"],
      ["Elixir.Geometry.#{module}Z", "#{geometry}_z"],
      ["Elixir.Geometry.#{module}ZM", "#{geometry}_zm"]
    ]
  end)
  |> to_atoms.()
  |> Enum.each(fn [module, parser] ->
    defp geometry_body(unquote(module), str, offset, endian, mode) do
      with {:ok, coordinates, rest, offset} <- unquote(parser)(str, offset, endian, mode) do
        {:ok, unquote(module).from_coordinates(coordinates), rest, offset}
      end
    end
  end)

  ["geometry_collection"]
  |> Enum.flat_map(fn geometry ->
    module = Macro.camelize(geometry)

    [
      ["Elixir.Geometry.#{module}", geometry],
      ["Elixir.Geometry.#{module}M", "#{geometry}_m"],
      ["Elixir.Geometry.#{module}Z", "#{geometry}_z"],
      ["Elixir.Geometry.#{module}ZM", "#{geometry}_zm"]
    ]
  end)
  |> to_atoms.()
  |> Enum.each(fn [module, parser] ->
    defp geometry_body(unquote(module), str, offset, endian, mode) do
      with {:ok, geometries, rest, offset} <- unquote(parser)(str, offset, endian, mode) do
        {:ok, unquote(module).new(geometries), rest, offset}
      end
    end
  end)

  ["point", "coordinate"]
  |> args.()
  |> Enum.each(fn [point, coordinate] ->
    defp unquote(point)(str, offset, endian, mode) do
      unquote(coordinate)(str, offset, endian, mode)
    end
  end)

  ["line_string", "coordinates"]
  |> args.()
  |> Enum.each(fn [line_string, coordinates] ->
    defp unquote(line_string)(str, offset, endian, mode) do
      with {:ok, length, rest, offset} <- length(str, offset, endian, mode) do
        unquote(coordinates)(length, rest, offset, endian, mode)
      end
    end
  end)

  ["polygon", "rings"]
  |> args.()
  |> Enum.each(fn [polygon, rings] ->
    defp unquote(polygon)(str, offset, endian, mode) do
      with {:ok, length, rest, offset} <- length(str, offset, endian, mode) do
        unquote(rings)(length, rest, offset, endian, mode)
      end
    end
  end)

  ["multi_point", "points"]
  |> args.()
  |> Enum.each(fn [multi_point, points] ->
    defp unquote(multi_point)(str, offset, endian, mode) do
      with {:ok, length, rest, offset} <- length(str, offset, endian, mode) do
        unquote(points)(length, rest, offset, endian, mode)
      end
    end
  end)

  ["multi_line_string", "line_strings"]
  |> args.()
  |> Enum.each(fn [multi_line_string, line_strings] ->
    defp unquote(multi_line_string)(str, offset, endian, mode) do
      with {:ok, length, rest, offset} <- length(str, offset, endian, mode) do
        unquote(line_strings)(length, rest, offset, endian, mode)
      end
    end
  end)

  ["multi_polygon", "polygons"]
  |> args.()
  |> Enum.each(fn [multi_polygon, polygons] ->
    defp unquote(multi_polygon)(str, offset, endian, mode) do
      with {:ok, length, rest, offset} <- length(str, offset, endian, mode) do
        unquote(polygons)(length, rest, offset, endian, mode)
      end
    end
  end)

  ["geometry_collection", "geometry_collection_items"]
  |> args.()
  |> Enum.each(fn [geometry_collection, geometry_collection_items] ->
    defp unquote(geometry_collection)(str, offset, endian, mode) do
      with {:ok, length, rest, offset} <- length(str, offset, endian, mode) do
        unquote(geometry_collection_items)(length, rest, offset, endian, mode)
      end
    end
  end)

  ["geometry_collection_items"]
  |> args.()
  |> Enum.each(fn [geometry_collection_items] ->
    defp unquote(geometry_collection_items)(n, str, offset, endian, mode, acc \\ [])

    defp unquote(geometry_collection_items)(0, str, offset, _endian, _mode, acc) do
      {:ok, acc, str, offset}
    end

    defp unquote(geometry_collection_items)(n, str, offset, endian, mode, acc) do
      with {:ok, {module, _endian, srid?}, rest, offset} <- geometry(str, offset, mode),
           {:ok, srid, rest, offset} <- srid(rest, offset, srid?, endian, mode),
           {:ok, geometry, rest, offset} <- geometry_body(module, rest, offset, endian, mode) do
        case srid == nil do
          true ->
            unquote(geometry_collection_items)(n - 1, rest, offset, endian, mode, [geometry | acc])

          false ->
            {:error, "unexpected SRID in sub-geometry", str, offset}
        end
      end
    end
  end)

  ["rings", "coordinates"]
  |> args.()
  |> Enum.each(fn [rings, coordinates] ->
    defp unquote(rings)(n, str, offset, endian, mode, acc \\ [])

    defp unquote(rings)(0, str, offset, _endian, _mode, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(rings)(n, str, offset, endian, mode, acc) do
      with {:ok, length, rest, offset} <- length(str, offset, endian, mode),
           {:ok, coordinates, rest, offset} <-
             unquote(coordinates)(length, rest, offset, endian, mode) do
        unquote(rings)(n - 1, rest, offset, endian, mode, [coordinates | acc])
      end
    end
  end)

  ["points", "point", "coordinate"]
  |> args.()
  |> Enum.each(fn [points, point, coordinate] ->
    defp unquote(points)(n, str, offset, endian, mode, acc \\ [])

    defp unquote(points)(0, str, offset, _endian, _mode, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(points)(n, str, offset, endian, mode, acc) do
      with {:ok, rest, offset} <- check_endian(str, offset, endian, mode),
           {:ok, rest, offset} <- check_code(rest, offset, endian, mode, unquote(point)),
           {:ok, coordinates, rest, offset} <- unquote(coordinate)(rest, offset, endian, mode) do
        unquote(points)(n - 1, rest, offset, endian, mode, [coordinates | acc])
      end
    end
  end)

  ["polygons", "polygon"]
  |> args.()
  |> Enum.each(fn [polygons, polygon] ->
    defp unquote(polygons)(n, str, offset, endian, mode, acc \\ [])

    defp unquote(polygons)(0, str, offset, _endian, _mode, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(polygons)(n, str, offset, endian, mode, acc) do
      with {:ok, rest, offset} <- check_endian(str, offset, endian, mode),
           {:ok, rest, offset} <- check_code(rest, offset, endian, mode, unquote(polygon)),
           {:ok, coordinates, rest, offset} <- unquote(polygon)(rest, offset, endian, mode) do
        unquote(polygons)(n - 1, rest, offset, endian, mode, [coordinates | acc])
      end
    end
  end)

  ["line_strings", "line_string"]
  |> args.()
  |> Enum.each(fn [line_strings, line_string] ->
    defp unquote(line_strings)(n, str, offset, endian, mode, acc \\ [])

    defp unquote(line_strings)(0, str, offset, _endian, _mode, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(line_strings)(n, str, offset, endian, mode, acc) do
      with {:ok, rest, offset} <- check_endian(str, offset, endian, mode),
           {:ok, rest, offset} <- check_code(rest, offset, endian, mode, unquote(line_string)),
           {:ok, coordinates, rest, offset} <- unquote(line_string)(rest, offset, endian, mode) do
        unquote(line_strings)(n - 1, rest, offset, endian, mode, [coordinates | acc])
      end
    end
  end)

  ["coordinates", "coordinate"]
  |> args.()
  |> Enum.each(fn [coordinates, coordinate] ->
    defp unquote(coordinates)(n, str, offset, endian, mode, acc \\ [])

    defp unquote(coordinates)(0, str, offset, _endian, _mode, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(coordinates)(n, str, offset, endian, mode, acc) do
      with {:ok, coordinate, rest, offset} <- unquote(coordinate)(str, offset, endian, mode) do
        unquote(coordinates)(n - 1, rest, offset, endian, mode, [coordinate | acc])
      end
    end
  end)

  defp length(<<hex::binary-size(8), rest::binary>>, offset, endian, :hex) do
    case Hex.to_integer(hex, endian) do
      {:ok, length} -> {:ok, length, rest, offset + 8}
      :error -> {:error, "invalid length #{inspect(hex)}", rest, offset}
    end
  end

  defp length(<<length::big-integer-size(32), rest::binary>>, offset, :xdr, :binary) do
    {:ok, length, rest, offset + 4}
  end

  defp length(<<length::little-integer-size(32), rest::binary>>, offset, :ndr, :binary) do
    {:ok, length, rest, offset + 4}
  end

  defp length(str, offset, _endian, _mode) do
    {:error, "expected length, got #{inspect(str)}", str, offset}
  end

  defp coordinate_zm(
         <<x::binary-size(16), y::binary-size(16), z::binary-size(16), m::binary-size(16),
           rest::binary>>,
         offset,
         endian,
         :hex
       ) do
    with {:x, {:ok, x}} <- {:x, Hex.to_float(x, endian)},
         {:y, {:ok, y}} <- {:y, Hex.to_float(y, endian)},
         {:z, {:ok, z}} <- {:z, Hex.to_float(z, endian)},
         {:m, {:ok, m}} <- {:m, Hex.to_float(m, endian)} do
      {:ok, [x, y, z, m], rest, offset + 64}
    else
      {:x, :error} -> {:error, "expected float, got #{inspect(x)}", rest, offset}
      {:y, :error} -> {:error, "expected float, got #{inspect(y)}", rest, offset + 16}
      {:z, :error} -> {:error, "expected float, got #{inspect(z)}", rest, offset + 32}
      {:m, :error} -> {:error, "expected float, got #{inspect(m)}", rest, offset + 48}
    end
  end

  defp coordinate_zm(
         <<x::big-float-size(64), y::big-float-size(64), z::big-float-size(64),
           m::big-float-size(64), rest::binary>>,
         offset,
         :xdr,
         :binary
       ) do
    {:ok, [x, y, z, m], rest, offset + 32}
  end

  defp coordinate_zm(
         <<x::little-float-size(64), y::little-float-size(64), z::little-float-size(64),
           m::little-float-size(64), rest::binary>>,
         offset,
         :ndr,
         :binary
       ) do
    {:ok, [x, y, z, m], rest, offset + 32}
  end

  defp coordinate_z(
         <<x::binary-size(16), y::binary-size(16), z::binary-size(16), rest::binary>>,
         offset,
         endian,
         :hex
       ) do
    with {:x, {:ok, x}} <- {:x, Hex.to_float(x, endian)},
         {:y, {:ok, y}} <- {:y, Hex.to_float(y, endian)},
         {:z, {:ok, z}} <- {:z, Hex.to_float(z, endian)} do
      {:ok, [x, y, z], rest, offset + 48}
    else
      {:x, :error} -> {:error, "expected float, got #{inspect(x)}", rest, offset}
      {:y, :error} -> {:error, "expected float, got #{inspect(y)}", rest, offset + 16}
      {:z, :error} -> {:error, "expected float, got #{inspect(z)}", rest, offset + 32}
    end
  end

  defp coordinate_z(
         <<x::big-float-size(64), y::big-float-size(64), z::big-float-size(64), rest::binary>>,
         offset,
         :xdr,
         :binary
       ) do
    {:ok, [x, y, z], rest, offset + 24}
  end

  defp coordinate_z(
         <<x::little-float-size(64), y::little-float-size(64), z::little-float-size(64),
           rest::binary>>,
         offset,
         :ndr,
         :binary
       ) do
    {:ok, [x, y, z], rest, offset + 24}
  end

  defp coordinate_m(
         <<x::binary-size(16), y::binary-size(16), m::binary-size(16), rest::binary>>,
         offset,
         endian,
         :hex
       ) do
    with {:x, {:ok, x}} <- {:x, Hex.to_float(x, endian)},
         {:y, {:ok, y}} <- {:y, Hex.to_float(y, endian)},
         {:m, {:ok, m}} <- {:m, Hex.to_float(m, endian)} do
      {:ok, [x, y, m], rest, offset + 48}
    else
      {:x, :error} -> {:error, "expected float, got #{inspect(x)}", rest, offset}
      {:y, :error} -> {:error, "expected float, got #{inspect(y)}", rest, offset + 16}
      {:m, :error} -> {:error, "expected float, got #{inspect(m)}", rest, offset + 32}
    end
  end

  defp coordinate_m(
         <<x::big-float-size(64), y::big-float-size(64), m::big-float-size(64), rest::binary>>,
         offset,
         :xdr,
         :binary
       ) do
    {:ok, [x, y, m], rest, offset + 24}
  end

  defp coordinate_m(
         <<x::little-float-size(64), y::little-float-size(64), m::little-float-size(64),
           rest::binary>>,
         offset,
         :ndr,
         :binary
       ) do
    {:ok, [x, y, m], rest, offset + 24}
  end

  defp coordinate(
         <<x::binary-size(16), y::binary-size(16), rest::binary>>,
         offset,
         endian,
         :hex
       ) do
    with {:x, {:ok, x}} <- {:x, Hex.to_float(x, endian)},
         {:y, {:ok, y}} <- {:y, Hex.to_float(y, endian)} do
      {:ok, [x, y], rest, offset + 32}
    else
      {:x, :error} -> {:error, "expected float, got #{inspect(x)}", rest, offset}
      {:y, :error} -> {:error, "expected float, got #{inspect(y)}", rest, offset + 16}
    end
  end

  defp coordinate(
         <<x::big-float-size(64), y::big-float-size(64), rest::binary>>,
         offset,
         :xdr,
         :binary
       ) do
    {:ok, [x, y], rest, offset + 16}
  end

  defp coordinate(
         <<x::little-float-size(64), y::little-float-size(64), rest::binary>>,
         offset,
         :ndr,
         :binary
       ) do
    {:ok, [x, y], rest, offset + 16}
  end

  ["coordinate"]
  |> args.()
  |> Enum.each(fn [coordinate] ->
    defp unquote(coordinate)(rest, offset, _endian, _mode) do
      {:error, "invalid coordinate", rest, offset}
    end
  end)

  defp srid(str, offset, false = _srid?, _endian, _mode), do: {:ok, nil, str, offset}

  defp srid(<<srid::binary-size(8), rest::binary>>, offset, _srid?, endian, :hex) do
    case Hex.to_integer(srid, endian) do
      {:ok, srid} -> {:ok, srid, rest, offset + 8}
      :error -> {:error, "invalid SRID #{inspect(srid)}", rest, offset}
    end
  end

  defp srid(<<srid::big-integer-size(32), rest::binary>>, offset, _srid?, :xdr, :binary) do
    {:ok, srid, rest, offset + 4}
  end

  defp srid(<<srid::little-integer-size(32), rest::binary>>, offset, _srid?, :ndr, :binary) do
    {:ok, srid, rest, offset + 4}
  end

  defp srid(rest, offset, _srid?, _endian, _mode) do
    {:error, "expected SRID, got #{inspect(rest)}", rest, offset}
  end

  defp eos("", _offset), do: :ok

  defp eos(eos, offset) do
    case Regex.match?(~r/^[\s\n]*$/, eos) do
      true ->
        :ok

      false ->
        {:error, "expected EOS", eos, offset}
    end
  end

  defp fetch_info(code, endian) do
    case Hex.to_integer(code, endian) do
      {:ok, int} -> Map.fetch(@codes, int)
      :error -> {:error, :invalid}
    end
  end
end
