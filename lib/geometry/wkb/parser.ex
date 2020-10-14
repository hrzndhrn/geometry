defmodule Geometry.WKB.Parser do
  @moduledoc false

  alias Geometry.{
    Hex,
    LineString,
    LineStringM,
    LineStringZ,
    LineStringZM,
    MultiLineString,
    MultiLineStringM,
    MultiLineStringZ,
    MultiLineStringZM,
    MultiPoint,
    MultiPointM,
    MultiPointZ,
    MultiPointZM,
    MultiPolygon,
    MultiPolygonM,
    MultiPolygonZ,
    MultiPolygonZM,
    Point,
    PointM,
    PointZ,
    PointZM,
    Polygon,
    PolygonM,
    PolygonZ,
    PolygonZM
  }

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
    0xE0000006 => {MultiPolygonZM, true}
  }

  @spec parse(wkb) :: {:ok, geometry} | {:ok, geometry, srid} | {:error, message, rest, offset}
        when wkb: Geometry.wkb(),
             geometry: Geometry.t(),
             srid: Geometry.srid(),
             message: String.t(),
             rest: binary(),
             offset: non_neg_integer()
  def parse(wkb) do
    with {:ok, {module, endian, srid?}, rest, offset} <- geometry(wkb, 0),
         {:ok, srid, rest, offset} <- srid(rest, offset, srid?, endian),
         {:ok, geometry} <- geometry_body(module, rest, endian, offset) do
      case srid? do
        true -> {:ok, geometry, srid}
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

  defp geometry(str, offset) do
    with {:ok, endian, rest, offset} <- endian(str, offset),
         {:ok, {module, srid?}, rest, offset} <- code(rest, offset, endian) do
      {:ok, {module, endian, srid?}, rest, offset}
    end
  end

  defp endian(<<"00", rest::binary()>>, offset) do
    {:ok, :xdr, rest, offset + 2}
  end

  defp endian(<<"01", rest::binary()>>, offset) do
    {:ok, :ndr, rest, offset + 2}
  end

  defp endian(<<got::binary-size(2), rest::binary()>>, offset) do
    {:error, "expected endian flag '00' or '01', got '#{got}'", rest, offset}
  end

  defp endian(str, offset) do
    {:error, "expected endian flag '00' or '01'", str, offset}
  end

  defp check_endian(<<endian::binary-size(2), rest::binary()>>, offset, expected) do
    case {endian, expected} do
      {"00", :xdr} ->
        {:ok, rest, offset + 2}

      {"01", :ndr} ->
        {:ok, rest, offset + 2}

      {got, :ndr} ->
        {:error, "expected endian flag '01', got '#{got}'", rest, offset}

      {got, :xdr} ->
        {:error, "expected endian flag '00', got '#{got}'", rest, offset}
    end
  end

  defp code(<<code::binary-size(8), rest::binary()>>, offset, endian) do
    case fetch_info(code, endian) do
      {:ok, info} ->
        {:ok, info, rest, offset + 8}

      {:error, :invalid} ->
        {:error, "invalid geomtry code: #{code}", rest, offset}

      :error ->
        {:error, "unknown geomtry code: #{code}", rest, offset}
    end
  end

  defp code(str, offset, _endian) do
    {:error, "expected geometry code", str, offset}
  end

  defp check_code(<<code::binary-size(8), rest::binary()>>, offset, endian, type) do
    case fetch_info(code, endian) do
      {:ok, {module, _srid?}} ->
        case Macro.underscore(module) == "geometry/#{type}" do
          true -> {:ok, rest, offset + 8}
          false -> {:error, "unexpected code '#{code}' for sub-geometry", rest, offset}
        end

      {:error, :invalid} ->
        {:error, "invalid sub-geomtry code: #{code}", rest, offset}

      :error ->
        {:error, "unknown sub-geomtry code: #{code}", rest, offset}
    end
  end

  defp check_code(str, offset, _endian, _type) do
    {:error, "expected geometry code", str, offset}
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
    defp geometry_body(unquote(module), str, endian, offset) do
      with {:ok, coordinates, rest, offset} <- unquote(parser)(str, endian, offset),
           :ok <- eos(rest, offset) do
        {:ok, unquote(module).from_coordinates(coordinates)}
      end
    end
  end)

  ["point", "coordinate"]
  |> args.()
  |> Enum.each(fn [point, coordinate] ->
    defp unquote(point)(str, endian, offset), do: unquote(coordinate)(str, endian, offset)
  end)

  ["line_string", "coordinates"]
  |> args.()
  |> Enum.each(fn [line_string, coordinates] ->
    defp unquote(line_string)(str, endian, offset) do
      with {:ok, length, rest, offset} <- length(str, endian, offset),
           {:ok, acc, rest, offset} <- unquote(coordinates)(length, rest, endian, offset) do
        {:ok, acc, rest, offset}
      end
    end
  end)

  ["polygon", "rings"]
  |> args.()
  |> Enum.each(fn [polygon, rings] ->
    defp unquote(polygon)(str, endian, offset) do
      with {:ok, length, rest, offset} <- length(str, endian, offset),
           {:ok, acc, rest, offset} <- unquote(rings)(length, rest, endian, offset) do
        {:ok, acc, rest, offset}
      end
    end
  end)

  ["multi_point", "points"]
  |> args.()
  |> Enum.each(fn [multi_point, points] ->
    defp unquote(multi_point)(str, endian, offset) do
      with {:ok, length, rest, offset} <- length(str, endian, offset),
           {:ok, acc, rest, offset} <- unquote(points)(length, rest, endian, offset) do
        {:ok, acc, rest, offset}
      end
    end
  end)

  ["multi_line_string", "line_strings"]
  |> args.()
  |> Enum.each(fn [multi_line_string, line_strings] ->
    defp unquote(multi_line_string)(str, endian, offset) do
      with {:ok, length, rest, offset} <- length(str, endian, offset),
           {:ok, acc, rest, offset} <- unquote(line_strings)(length, rest, endian, offset) do
        {:ok, acc, rest, offset}
      end
    end
  end)

  ["multi_polygon", "polygons"]
  |> args.()
  |> Enum.each(fn [multi_polygon, polygons] ->
    defp unquote(multi_polygon)(str, endian, offset) do
      with {:ok, length, rest, offset} <- length(str, endian, offset),
           {:ok, acc, rest, offset} <- unquote(polygons)(length, rest, endian, offset) do
        {:ok, acc, rest, offset}
      end
    end
  end)

  ["rings", "coordinates"]
  |> args.()
  |> Enum.each(fn [rings, coordinates] ->
    defp unquote(rings)(n, str, endian, offset, acc \\ [])

    defp unquote(rings)(0, str, _endian, offset, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(rings)(n, str, endian, offset, acc) do
      with {:ok, length, rest, offset} <- length(str, endian, offset),
           {:ok, coordinates, rest, offset} <- unquote(coordinates)(length, rest, endian, offset) do
        unquote(rings)(n - 1, rest, endian, offset, [coordinates | acc])
      end
    end
  end)

  ["points", "point", "coordinate"]
  |> args.()
  |> Enum.each(fn [points, point, coordinate] ->
    defp unquote(points)(n, str, endian, offset, acc \\ [])

    defp unquote(points)(0, str, _endian, offset, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(points)(n, str, endian, offset, acc) do
      with {:ok, rest, offset} <- check_endian(str, offset, endian),
           {:ok, rest, offset} <- check_code(rest, offset, endian, unquote(point)),
           {:ok, [coordinates], rest, offset} <- unquote(coordinate)(rest, endian, offset) do
        unquote(points)(n - 1, rest, endian, offset, [coordinates | acc])
      end
    end
  end)

  ["polygons", "polygon"]
  |> args.()
  |> Enum.each(fn [polygons, polygon] ->
    defp unquote(polygons)(n, str, endian, offset, acc \\ [])

    defp unquote(polygons)(0, str, _endian, offset, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(polygons)(n, str, endian, offset, acc) do
      with {:ok, rest, offset} <- check_endian(str, offset, endian),
           {:ok, rest, offset} <- check_code(rest, offset, endian, unquote(polygon)),
           {:ok, coordinates, rest, offset} <- unquote(polygon)(rest, endian, offset) do
        unquote(polygons)(n - 1, rest, endian, offset, [coordinates | acc])
      end
    end
  end)

  ["line_strings", "line_string"]
  |> args.()
  |> Enum.each(fn [line_strings, line_string] ->
    defp unquote(line_strings)(n, str, endian, offset, acc \\ [])

    defp unquote(line_strings)(0, str, _endian, offset, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(line_strings)(n, str, endian, offset, acc) do
      with {:ok, rest, offset} <- check_endian(str, offset, endian),
           {:ok, rest, offset} <- check_code(rest, offset, endian, unquote(line_string)),
           {:ok, coordinates, rest, offset} <- unquote(line_string)(rest, endian, offset) do
        unquote(line_strings)(n - 1, rest, endian, offset, [coordinates | acc])
      end
    end
  end)

  ["coordinates", "coordinate"]
  |> args.()
  |> Enum.each(fn [coordinates, coordinate] ->
    defp unquote(coordinates)(n, str, endian, offset, acc \\ [])

    defp unquote(coordinates)(0, str, _endian, offset, acc) do
      {:ok, Enum.reverse(acc), str, offset}
    end

    defp unquote(coordinates)(n, str, endian, offset, acc) do
      with {:ok, [coordinate], rest, offset} <- unquote(coordinate)(str, endian, offset) do
        unquote(coordinates)(n - 1, rest, endian, offset, [coordinate | acc])
      end
    end
  end)

  defp length(<<hex::binary-size(8), rest::binary()>>, endian, offset) do
    case Hex.to_integer(hex, endian) do
      {:ok, length} -> {:ok, length, rest, offset + 8}
      :error -> {:error, "invalid length '#{hex}'", rest, offset}
    end
  end

  defp length(str, _endian, offset) do
    {:error, "expected length, got '#{str}'", str, offset}
  end

  defp coordinate_zm(
         <<x::binary-size(16), y::binary-size(16), z::binary-size(16), m::binary-size(16),
           rest::binary()>>,
         endian,
         offset
       ) do
    with {:x, {:ok, x}} <- {:x, Hex.to_float(x, endian)},
         {:y, {:ok, y}} <- {:y, Hex.to_float(y, endian)},
         {:z, {:ok, z}} <- {:z, Hex.to_float(z, endian)},
         {:m, {:ok, m}} <- {:m, Hex.to_float(m, endian)} do
      {:ok, [{x, y, z, m}], rest, offset + 64}
    else
      {:x, :error} -> {:error, "expected float, got '#{x}'", rest, offset}
      {:y, :error} -> {:error, "expected float, got '#{y}'", rest, offset + 16}
      {:z, :error} -> {:error, "expected float, got '#{z}'", rest, offset + 32}
      {:m, :error} -> {:error, "expected float, got '#{m}'", rest, offset + 48}
    end
  end

  defp coordinate_z(
         <<x::binary-size(16), y::binary-size(16), z::binary-size(16), rest::binary()>>,
         endian,
         offset
       ) do
    with {:x, {:ok, x}} <- {:x, Hex.to_float(x, endian)},
         {:y, {:ok, y}} <- {:y, Hex.to_float(y, endian)},
         {:z, {:ok, z}} <- {:z, Hex.to_float(z, endian)} do
      {:ok, [{x, y, z}], rest, offset + 48}
    else
      {:x, :error} -> {:error, "expected float, got '#{x}'", rest, offset}
      {:y, :error} -> {:error, "expected float, got '#{y}'", rest, offset + 16}
      {:z, :error} -> {:error, "expected float, got '#{z}'", rest, offset + 32}
    end
  end

  defp coordinate_m(
         <<x::binary-size(16), y::binary-size(16), m::binary-size(16), rest::binary()>>,
         endian,
         offset
       ) do
    with {:x, {:ok, x}} <- {:x, Hex.to_float(x, endian)},
         {:y, {:ok, y}} <- {:y, Hex.to_float(y, endian)},
         {:m, {:ok, m}} <- {:m, Hex.to_float(m, endian)} do
      {:ok, [{x, y, m}], rest, offset + 48}
    else
      {:x, :error} -> {:error, "expected float, got '#{x}'", rest, offset}
      {:y, :error} -> {:error, "expected float, got '#{y}'", rest, offset + 16}
      {:m, :error} -> {:error, "expected float, got '#{m}'", rest, offset + 32}
    end
  end

  defp coordinate(
         <<x::binary-size(16), y::binary-size(16), rest::binary()>>,
         endian,
         offset
       ) do
    with {:x, {:ok, x}} <- {:x, Hex.to_float(x, endian)},
         {:y, {:ok, y}} <- {:y, Hex.to_float(y, endian)} do
      {:ok, [{x, y}], rest, offset + 32}
    else
      {:x, :error} -> {:error, "expected float, got '#{x}'", rest, offset}
      {:y, :error} -> {:error, "expected float, got '#{y}'", rest, offset + 16}
    end
  end

  ["coordinate"]
  |> args.()
  |> Enum.each(fn [coordinate] ->
    defp unquote(coordinate)(rest, _endian, offset) do
      {:error, "invalid coordiante", rest, offset}
    end
  end)

  defp srid(str, offset, false = _srid?, _endian), do: {:ok, nil, str, offset}

  defp srid(<<srid::binary-size(8), rest::binary()>>, offset, _srid?, endian) do
    case Hex.to_integer(srid, endian) do
      {:ok, srid} -> {:ok, srid, rest, offset + 8}
      :error -> {:error, "invalid SRID '#{srid}'", rest, offset}
    end
  end

  defp srid(rest, offset, _srid?, _endian) do
    {:error, "expected SRID, got '#{rest}'", rest, offset}
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
