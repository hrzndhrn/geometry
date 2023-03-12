defmodule Support do
  def file(module) do
    Path.join("bench/reports", Macro.underscore(module) <> ".md")
  end

  @sm 100
  @lg 1_000
  @xl 1_000

  wkt = fn geometry ->
    case geometry do
      :point ->
        "POINT (1 2)"

      :line_string ->
        "LINESTRING (30 10,10 30,40 40)"

      :line_string_long ->
        data = Enum.map_join(1..100, ", ", fn i -> "#{i} #{i}" end)
        "LINESTRING (#{data})"

      :polygon ->
        "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10), (20 30, 35 35, 30 20, 20 30))"

      :multi_point ->
        data = Enum.map_join(1..100, ", ", fn i -> "#{i} #{i}" end)
        "MULTIPOINT (#{data})"

      :multi_line_string ->
        data =
          Enum.map_join(1..100, ", ", fn l ->
            line_string = Enum.map_join(1..10, ", ", fn i -> "#{l + i} #{l + i}" end)
            "(#{line_string})"
          end)

        "MULTILINESTRING (#{data})"

      :multi_polygon ->
        data =
          Enum.map_join(1..100, ", ", fn i ->
            """
            ((#{35 + 1} #{10 + 1}, #{45 + 1} #{45 + i}, #{15 + 1} #{40 + i}, #{10 + i} \
            #{20 + i}, #{35 + i} #{10 + i}), (#{20 + i} #{30 + i}, #{35 + i} \
            #{35 + i}, #{30 + i} #{20 + i}, #{20 + i} #{30 + i}))\
            """
          end)

        "MULTIPOLYGON (#{data})"

      :geometry_collection ->
        """
        GEOMETRYCOLLECTION(\
        POINT(40 10),\
        LINESTRING(10 10, 20 20, 10 40))\
        """
    end
  end

  Mix.Shell.IO.info("Generate input WKT")

  @wkt %{
    "(1) Point" => List.duplicate(wkt.(:point), @xl),
    "(2) LineString" => List.duplicate(wkt.(:line_string), @lg),
    "(3) LineString (long)" => List.duplicate(wkt.(:line_string_long), @lg),
    "(4) Polygon" => List.duplicate(wkt.(:polygon), @lg),
    "(5) MultiPoint" => List.duplicate(wkt.(:multi_point), @sm),
    "(6) MultiLineString" => List.duplicate(wkt.(:multi_line_string), @sm),
    "(7) MultiPolygon" => List.duplicate(wkt.(:multi_polygon), @sm),
    "(8) GeometryCollection" => List.duplicate(wkt.(:geometry_collection), @sm)
  }

  Mix.Shell.IO.info("Generate input structs")

  @elixir Enum.into(@wkt, %{}, fn {key, wkts} ->
            elixir =
              Enum.reduce(wkts, {[], []}, fn wkt, {geometry, geo} ->
                {[Geometry.from_wkt!(wkt) | geometry], [Geo.WKT.decode!(wkt) | geo]}
              end)

            {key, elixir}
          end)

  Mix.Shell.IO.info("Generate input GeoJSON")

  @geo_json Enum.into(@wkt, %{}, fn {key, wkts} ->
              geo_jsons =
                Enum.map(wkts, fn wkt ->
                  wkt |> Geometry.from_wkt!() |> Geometry.to_geo_json()
                end)

              {key, geo_jsons}
            end)

  Mix.Shell.IO.info("Generate input WKB (ndr/bin)")

  @wkb_ndr_bin Enum.into(@wkt, %{}, fn {key, wkts} ->
                 wkbs =
                   Enum.map(wkts, fn wkt ->
                     wkt |> Geometry.from_wkt!() |> Geometry.to_wkb(:ndr)
                   end)

                 {key, wkbs}
               end)

  Mix.Shell.IO.info("Generate input WKB (xdr/bin)")

  @wkb_xdr_bin Enum.into(@wkt, %{}, fn {key, wkts} ->
                 wkbs =
                   Enum.map(wkts, fn wkt ->
                     wkt |> Geometry.from_wkt!() |> Geometry.to_wkb(:xdr)
                   end)

                 {key, wkbs}
               end)

  Mix.Shell.IO.info("Generate input WKB (ndr/hex)")

  @wkb_ndr_hex Enum.into(@wkt, %{}, fn {key, wkts} ->
                 wkbs =
                   Enum.map(wkts, fn wkt ->
                     wkt |> Geometry.from_wkt!() |> Geometry.to_wkb(:ndr) |> Base.encode16()
                   end)

                 {key, wkbs}
               end)

  Mix.Shell.IO.info("Generate input WKB (xdr/hex)")

  @wkb_xdr_hex Enum.into(@wkt, %{}, fn {key, wkts} ->
                 wkbs =
                   Enum.map(wkts, fn wkt ->
                     wkt |> Geometry.from_wkt!() |> Geometry.to_wkb(:xdr) |> Base.encode16()
                   end)

                 {key, wkbs}
               end)

  def data(:wkt), do: @wkt
  def data(:elixir), do: @elixir
  def data(:geo_json), do: @geo_json
  def data(:wkb, :ndr, :bin), do: @wkb_ndr_bin
  def data(:wkb, :xdr, :bin), do: @wkb_xdr_bin
  def data(:wkb, :ndr, :hex), do: @wkb_ndr_hex
  def data(:wkb, :xdr, :hex), do: @wkb_xdr_hex
end
