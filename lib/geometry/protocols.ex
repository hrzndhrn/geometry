defmodule Geometry.Protocols do
  @moduledoc false

  @codes point: 1,
         line_string: 2,
         polygon: 3,
         multi_point: 4,
         multi_line_string: 5,
         multi_polygon: 6,
         geometry_collection: 7
  @dims xy: 2, xym: 3, xyz: 3, xyzm: 4
  @empty_xdr [127, 248, 0, 0, 0, 0, 0, 0]
  @empty_ndr [0, 0, 0, 0, 0, 0, 248, 127]
  @wkt_types xy: " ", xym: " M ", xyz: " Z ", xyzm: " ZM "
  @wkb_types %{
    {:xy, false} => 0,
    {:xy, true} => 32,
    {:xym, false} => 64,
    {:xym, true} => 96,
    {:xyz, false} => 128,
    {:xyz, true} => 160,
    {:xyzm, false} => 192,
    {:xyzm, true} => 224
  }
  @geometry_keys point: :coordinate,
                 line_string: :points,
                 polygon: :rings,
                 multi_point: :points,
                 multi_line_string: :line_strings,
                 multi_polygon: :polygons,
                 geometry_collection: :geometries

  @multi_sub_keys multi_line_string: :points,
                  multi_polygon: :rings,
                  multi_point: :coordinate

  @multi [:multi_point, :multi_line_string, :multi_polygon, :geometry_collection]

  defmacro __using__([]) do
    %{context_modules: [module]} = __CALLER__
    module_name = module |> Module.split() |> List.last() |> to_string()

    {geometry_name, dim} =
      case Regex.run(~r/(.*?)((?:ZM|M|Z))$/, module_name) do
        nil ->
          {module_name, :xy}

        [_module, module_name, type] ->
          case type do
            "M" -> {module_name, :xym}
            "Z" -> {module_name, :xyz}
            "ZM" -> {module_name, :xyzm}
          end
      end

    geometry = geometry_name |> Macro.underscore() |> String.to_existing_atom()

    quote do
      alias Geometry.Protocols
      require Protocols

      Protocols.protocol(unquote(geometry))
      Protocols.geo_json(unquote(geometry))
      Protocols.wkb(unquote(geometry), unquote(dim))
      Protocols.wkt(unquote(geometry), unquote(dim))
      Protocols.enumerable(unquote(geometry))
      Protocols.collectable(unquote(geometry))
    end
  end

  defmacro protocol(geometry) do
    quote do
      defimpl Geometry.Protocol do
        def empty?(%{unquote(@geometry_keys[geometry]) => data}) do
          Enum.empty?(data)
        end
      end
    end
  end

  defmacro geo_json(:geometry_collection) do
    quote do
      defimpl Geometry.Encoder.GeoJson do
        def to_geo_json(%{geometries: geometries}) do
          %{
            "type" => "GeometryCollection",
            "geometries" =>
              Enum.map(geometries, fn geometry -> Geometry.to_geo_json(geometry) end)
          }
        end
      end
    end
  end

  defmacro geo_json(type) when type in @multi do
    quote do
      defimpl Geometry.Encoder.GeoJson do
        def to_geo_json(unquote(match(@geometry_keys[type], quote(do: coordinates)))) do
          %{
            "type" => unquote(type |> to_string() |> Macro.camelize()),
            "coordinates" => coordinates
          }
        end
      end
    end
  end

  defmacro geo_json(type) do
    quote do
      defimpl Geometry.Encoder.GeoJson do
        def to_geo_json(unquote(match(@geometry_keys[type], quote(do: coordinates)))) do
          %{
            "type" => unquote(type |> to_string() |> Macro.camelize()),
            "coordinates" => coordinates
          }
        end
      end
    end
  end

  defmacro wkb(:point, dim) do
    quote do
      defimpl Geometry.Encoder.WKB do
        def to_wkb(%{coordinate: []}, :xdr) do
          unquote(
            binary([
              code(:point, dim, false, :xdr),
              duplicate(@empty_xdr, dim)
            ])
          )
        end

        def to_wkb(%{coordinate: []}, :ndr) do
          unquote(
            binary([
              code(:point, dim, false, :ndr),
              duplicate(@empty_ndr, dim)
            ])
          )
        end

        def to_wkb(unquote(match(:coordinate, dim)), :xdr) do
          unquote(
            binary([
              code(:point, dim, false, :xdr),
              coordinate_to_binary(dim, :xdr)
            ])
          )
        end

        def to_wkb(unquote(match(:coordinate, dim)), :ndr) do
          unquote(
            binary([
              code(:point, dim, false, :ndr),
              coordinate_to_binary(dim, :ndr)
            ])
          )
        end

        def to_ewkb(%{coordinate: [], srid: srid}, :xdr) do
          unquote(
            binary([
              code(:point, dim, true, :xdr),
              srid_to_binary(:xdr),
              duplicate(@empty_xdr, dim)
            ])
          )
        end

        def to_ewkb(%{coordinate: [], srid: srid}, :ndr) do
          unquote(
            binary([
              code(:point, dim, true, :ndr),
              srid_to_binary(:ndr),
              duplicate(@empty_ndr, dim)
            ])
          )
        end

        def to_ewkb(unquote(match_with_srid(:coordinate, dim)), :xdr) do
          unquote(
            binary([
              code(:point, dim, true, :xdr),
              srid_to_binary(:xdr),
              coordinate_to_binary(dim, :xdr)
            ])
          )
        end

        def to_ewkb(unquote(match_with_srid(:coordinate, dim)), :ndr) do
          unquote(
            binary([
              code(:point, dim, true, :ndr),
              srid_to_binary(:ndr),
              coordinate_to_binary(dim, :ndr)
            ])
          )
        end
      end
    end
  end

  defmacro wkb(:line_string, dim) do
    quote do
      defimpl Geometry.Encoder.WKB do
        def to_wkb(%{points: points}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:line_string, dim, false, :xdr),
                count(quote(do: points), :xdr)
              ])
            ),
            unquote(points_to_binary(dim, :xdr))
          ])
        end

        def to_wkb(%{points: points}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:line_string, dim, false, :ndr),
                count(quote(do: points), :ndr)
              ])
            ),
            unquote(points_to_binary(dim, :ndr))
          ])
        end

        def to_ewkb(%{points: points, srid: srid}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:line_string, dim, true, :xdr),
                srid_to_binary(:xdr),
                count(quote(do: points), :xdr)
              ])
            ),
            unquote(points_to_binary(dim, :xdr))
          ])
        end

        def to_ewkb(%{points: points, srid: srid}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:line_string, dim, true, :ndr),
                srid_to_binary(:ndr),
                count(quote(do: points), :ndr)
              ])
            ),
            unquote(points_to_binary(dim, :ndr))
          ])
        end
      end
    end
  end

  defmacro wkb(:polygon, dim) do
    quote do
      defimpl Geometry.Encoder.WKB do
        def to_wkb(%{rings: rings}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:polygon, dim, false, :xdr),
                count(quote(do: rings), :xdr)
              ])
            ),
            unquote(rings_to_binary(dim, :xdr))
          ])
        end

        def to_wkb(%{rings: rings}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:polygon, dim, false, :ndr),
                count(quote(do: rings), :ndr)
              ])
            ),
            unquote(rings_to_binary(dim, :ndr))
          ])
        end

        def to_ewkb(%{rings: rings, srid: srid}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:polygon, dim, true, :xdr),
                srid_to_binary(:xdr),
                count(quote(do: rings), :xdr)
              ])
            ),
            unquote(rings_to_binary(dim, :xdr))
          ])
        end

        def to_ewkb(%{rings: rings, srid: srid}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:polygon, dim, true, :ndr),
                srid_to_binary(:ndr),
                count(quote(do: rings), :ndr)
              ])
            ),
            unquote(rings_to_binary(dim, :ndr))
          ])
        end
      end
    end
  end

  defmacro wkb(:multi_point, dim) do
    quote do
      defimpl Geometry.Encoder.WKB do
        def to_wkb(%{points: points}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_point, dim, false, :xdr),
                count(quote(do: points), :xdr)
              ])
            ),
            unquote(points_to_binary(dim, :xdr, code(:point, dim, false, :xdr)))
          ])
        end

        def to_wkb(%{points: points}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_point, dim, false, :ndr),
                count(quote(do: points), :ndr)
              ])
            ),
            unquote(points_to_binary(dim, :ndr, code(:point, dim, false, :ndr)))
          ])
        end

        def to_ewkb(%{points: points, srid: srid}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_point, dim, true, :xdr),
                srid_to_binary(:xdr),
                count(quote(do: points), :xdr)
              ])
            ),
            unquote(points_to_binary(dim, :xdr, code(:point, dim, false, :xdr)))
          ])
        end

        def to_ewkb(%{points: points, srid: srid}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_point, dim, true, :ndr),
                srid_to_binary(:ndr),
                count(quote(do: points), :ndr)
              ])
            ),
            unquote(points_to_binary(dim, :ndr, code(:point, dim, false, :ndr)))
          ])
        end
      end
    end
  end

  defmacro wkb(:multi_line_string, dim) do
    quote do
      defimpl Geometry.Encoder.WKB do
        def to_wkb(%{line_strings: line_strings}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_line_string, dim, false, :xdr),
                count(quote(do: line_strings), :xdr)
              ])
            ),
            unquote(line_strings_to_binary(dim, :xdr, code(:line_string, dim, false, :xdr)))
          ])
        end

        def to_wkb(%{line_strings: line_strings}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_line_string, dim, false, :ndr),
                count(quote(do: line_strings), :ndr)
              ])
            ),
            unquote(line_strings_to_binary(dim, :ndr, code(:line_string, dim, false, :ndr)))
          ])
        end

        def to_ewkb(%{line_strings: line_strings, srid: srid}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_line_string, dim, true, :xdr),
                srid_to_binary(:xdr),
                count(quote(do: line_strings), :xdr)
              ])
            ),
            unquote(line_strings_to_binary(dim, :xdr, code(:line_string, dim, false, :xdr)))
          ])
        end

        def to_ewkb(%{line_strings: line_strings, srid: srid}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_line_string, dim, true, :ndr),
                srid_to_binary(:ndr),
                count(quote(do: line_strings), :ndr)
              ])
            ),
            unquote(line_strings_to_binary(dim, :ndr, code(:line_string, dim, false, :ndr)))
          ])
        end
      end
    end
  end

  defmacro wkb(:multi_polygon, dim) do
    quote do
      defimpl Geometry.Encoder.WKB do
        def to_wkb(%{polygons: polygons}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_polygon, dim, false, :xdr),
                count(quote(do: polygons), :xdr)
              ])
            ),
            unquote(polygons_to_binary(dim, :xdr, code(:polygon, dim, false, :xdr)))
          ])
        end

        def to_wkb(%{polygons: polygons}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_polygon, dim, false, :ndr),
                count(quote(do: polygons), :ndr)
              ])
            ),
            unquote(polygons_to_binary(dim, :ndr, code(:polygon, dim, false, :ndr)))
          ])
        end

        def to_ewkb(%{polygons: polygons, srid: srid}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_polygon, dim, true, :xdr),
                srid_to_binary(:xdr),
                count(quote(do: polygons), :xdr)
              ])
            ),
            unquote(polygons_to_binary(dim, :xdr, code(:polygon, dim, false, :xdr)))
          ])
        end

        def to_ewkb(%{polygons: polygons, srid: srid}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:multi_polygon, dim, true, :ndr),
                srid_to_binary(:ndr),
                count(quote(do: polygons), :ndr)
              ])
            ),
            unquote(polygons_to_binary(dim, :ndr, code(:polygon, dim, false, :ndr)))
          ])
        end
      end
    end
  end

  defmacro wkb(:geometry_collection, dim) do
    quote do
      defimpl Geometry.Encoder.WKB do
        def to_wkb(%{geometries: geometries}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:geometry_collection, dim, false, :xdr),
                count(quote(do: geometries), :xdr)
              ])
            ),
            unquote(geometries_to_binary(:xdr))
          ])
        end

        def to_wkb(%{geometries: geometries}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:geometry_collection, dim, false, :ndr),
                count(quote(do: geometries), :ndr)
              ])
            ),
            unquote(geometries_to_binary(:ndr))
          ])
        end

        def to_ewkb(%{geometries: geometries, srid: srid}, :xdr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:geometry_collection, dim, true, :xdr),
                srid_to_binary(:xdr),
                count(quote(do: geometries), :xdr)
              ])
            ),
            unquote(geometries_to_binary(:xdr))
          ])
        end

        def to_ewkb(%{geometries: geometries, srid: srid}, :ndr) do
          IO.iodata_to_binary([
            unquote(
              binary([
                code(:geometry_collection, dim, true, :ndr),
                srid_to_binary(:ndr),
                count(quote(do: geometries), :ndr)
              ])
            ),
            unquote(geometries_to_binary(:ndr))
          ])
        end
      end
    end
  end

  defmacro wkt(:point, dim) do
    quote do
      defimpl Geometry.Encoder.WKT do
        def to_wkt(%{coordinate: []}) do
          unquote(
            binary([
              "Point",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_wkt(unquote(match(:coordinate, dim))) do
          unquote(
            binary([
              "Point",
              @wkt_types[dim],
              "(",
              coordinate_to_string(dim),
              ")"
            ])
          )
        end

        def to_ewkt(%{coordinate: [], srid: srid}) do
          unquote(
            binary([
              srid_to_string(),
              "Point",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_ewkt(unquote(match_with_srid(:coordinate, dim))) do
          unquote(
            binary([
              srid_to_string(),
              "Point",
              @wkt_types[dim],
              "(",
              coordinate_to_string(dim),
              ")"
            ])
          )
        end
      end
    end
  end

  defmacro wkt(:line_string, dim) do
    quote do
      defimpl Geometry.Encoder.WKT do
        def to_wkt(%{points: []}) do
          unquote(
            binary([
              "LineString",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_wkt(%{points: points}) do
          data = unquote(points_to_string(dim))

          unquote(
            binary([
              "LineString",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end

        def to_ewkt(%{points: [], srid: srid}) do
          unquote(
            binary([
              srid_to_string(),
              "LineString",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_ewkt(%{points: points, srid: srid}) do
          data = unquote(points_to_string(dim))

          unquote(
            binary([
              srid_to_string(),
              "LineString",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end
      end
    end
  end

  defmacro wkt(:polygon, dim) do
    quote do
      defimpl Geometry.Encoder.WKT do
        def to_wkt(%{rings: []}) do
          unquote(
            binary([
              "Polygon",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_wkt(%{rings: rings}) do
          data = unquote(rings_to_string(dim))

          unquote(
            binary([
              "Polygon",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end

        def to_ewkt(%{rings: [], srid: srid}) do
          unquote(
            binary([
              srid_to_string(),
              "Polygon",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_ewkt(%{rings: rings, srid: srid}) do
          data = unquote(rings_to_string(dim))

          unquote(
            binary([
              srid_to_string(),
              "Polygon",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end
      end
    end
  end

  defmacro wkt(:multi_point, dim) do
    quote do
      defimpl Geometry.Encoder.WKT do
        def to_wkt(%{points: []}) do
          unquote(
            binary([
              "MultiPoint",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_wkt(%{points: points}) do
          data = unquote(points_to_string(dim))

          unquote(
            binary([
              "MultiPoint",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end

        def to_ewkt(%{points: [], srid: srid}) do
          unquote(
            binary([
              srid_to_string(),
              "MultiPoint",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_ewkt(%{points: points, srid: srid}) do
          data = unquote(points_to_string(dim))

          unquote(
            binary([
              srid_to_string(),
              "MultiPoint",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end
      end
    end
  end

  defmacro wkt(:multi_line_string, dim) do
    quote do
      defimpl Geometry.Encoder.WKT do
        def to_wkt(%{line_strings: []}) do
          unquote(
            binary([
              "MultiLineString",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_wkt(%{line_strings: line_strings}) do
          data = unquote(line_strings_to_string(dim))

          unquote(
            binary([
              "MultiLineString",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end

        def to_ewkt(%{line_strings: [], srid: srid}) do
          unquote(
            binary([
              srid_to_string(),
              "MultiLineString",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_ewkt(%{line_strings: line_strings, srid: srid}) do
          data = unquote(line_strings_to_string(dim))

          unquote(
            binary([
              srid_to_string(),
              "MultiLineString",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end
      end
    end
  end

  defmacro wkt(:multi_polygon, dim) do
    quote do
      defimpl Geometry.Encoder.WKT do
        def to_wkt(%{polygons: []}) do
          unquote(
            binary([
              "MultiPolygon",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_wkt(%{polygons: polygons}) do
          data = unquote(polygons_to_string(dim))

          unquote(
            binary([
              "MultiPolygon",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end

        def to_ewkt(%{polygons: [], srid: srid}) do
          unquote(
            binary([
              srid_to_string(),
              "MultiPolygon",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_ewkt(%{polygons: polygons, srid: srid}) do
          data = unquote(polygons_to_string(dim))

          unquote(
            binary([
              srid_to_string(),
              "MultiPolygon",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end
      end
    end
  end

  defmacro wkt(:geometry_collection, dim) do
    quote do
      defimpl Geometry.Encoder.WKT do
        def to_wkt(%{geometries: []}) do
          unquote(
            binary([
              "GeometryCollection",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_wkt(%{geometries: geometries}) do
          data = Enum.map_join(geometries, ", ", fn geometry -> Geometry.to_wkt(geometry) end)

          unquote(
            binary([
              "GeometryCollection",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end

        def to_ewkt(%{geometries: [], srid: srid}) do
          unquote(
            binary([
              srid_to_string(),
              "GeometryCollection",
              @wkt_types[dim],
              "EMPTY"
            ])
          )
        end

        def to_ewkt(%{geometries: geometries, srid: srid}) do
          data = Enum.map_join(geometries, ", ", fn geometry -> Geometry.to_wkt(geometry) end)

          unquote(
            binary([
              srid_to_string(),
              "GeometryCollection",
              @wkt_types[dim],
              "(",
              quote(do: data :: binary),
              ")"
            ])
          )
        end
      end
    end
  end

  defmacro enumerable(geometry) when geometry in @multi do
    quote do
      defimpl Enumerable do
        def count(unquote(match(@geometry_keys[geometry], quote(do: data)))) do
          {:ok, length(data)}
        end

        def member?(
              unquote(match(@geometry_keys[geometry], quote(do: data))),
              unquote(
                if @multi_sub_keys[geometry] do
                  match(@multi_sub_keys[geometry], quote(do: sub))
                else
                  quote(do: sub)
                end
              )
            ) do
          {:ok, Enum.member?(data, sub)}
        end

        def reduce(unquote(match(@geometry_keys[geometry], quote(do: data))), acc, fun) do
          Enumerable.List.reduce(data, acc, fun)
        end

        def slice(unquote(match(@geometry_keys[geometry], quote(do: data)))) do
          size = length(data)

          {:ok, size,
           fn unquote(match(@geometry_keys[geometry], quote(do: data))) ->
             data
           end}
        end
      end
    end
  end

  defmacro enumerable(_geometry) do
    :noop
  end

  defmacro collectable(:multi_point) do
    quote do
      defimpl Collectable do
        def into(%{points: data} = geometry) do
          fun = fn
            list, {:cont, x} ->
              [x | list]

            list, :done ->
              %{
                geometry
                | points: Enum.reduce(list, data, fn point, acc -> [point.coordinate | acc] end)
              }

            _list, :halt ->
              :ok
          end

          {[], fun}
        end
      end
    end
  end

  defmacro collectable(:multi_line_string) do
    quote do
      defimpl Collectable do
        def into(%{line_strings: data} = geometry) do
          fun = fn
            list, {:cont, x} ->
              [x | list]

            list, :done ->
              %{
                geometry
                | line_strings:
                    Enum.reduce(list, data, fn line_string, acc -> [line_string.points | acc] end)
              }

            _list, :halt ->
              :ok
          end

          {[], fun}
        end
      end
    end
  end

  defmacro collectable(:multi_polygon) do
    quote do
      defimpl Collectable do
        def into(%{polygons: data} = geometry) do
          fun = fn
            list, {:cont, x} ->
              [x | list]

            list, :done ->
              %{
                geometry
                | polygons: Enum.reduce(list, data, fn polygon, acc -> [polygon.rings | acc] end)
              }

            _list, :halt ->
              :ok
          end

          {[], fun}
        end
      end
    end
  end

  defmacro collectable(:geometry_collection) do
    quote do
      defimpl Collectable do
        def into(%{geometries: data} = geometry_collection) do
          fun = fn
            list, {:cont, item} ->
              [item | list]

            list, :done ->
              %{
                geometry_collection
                | geometries: Enum.reduce(list, data, fn geometry, acc -> [geometry | acc] end)
              }

            _list, :halt ->
              :ok
          end

          {[], fun}
        end
      end
    end
  end

  defmacro collectable(_geometry) do
    :noop
  end

  defp code(geometry, dim, srid?, endian) do
    <<_a, b, c, d>> = <<@codes[geometry]::big-integer-size(32)>>
    a = Map.fetch!(@wkb_types, {dim, srid?})

    case endian do
      :xdr -> [0, a, b, c, d]
      :ndr -> [1, d, c, b, a]
    end
  end

  defp match(key, :xy) do
    quote do
      %{unquote(key) => [x, y]}
    end
  end

  defp match(key, dim) when dim in [:xyz, :xym] do
    quote do
      %{unquote(key) => [x, y, z]}
    end
  end

  defp match(key, :xyzm) do
    quote do
      %{unquote(key) => [x, y, z, m]}
    end
  end

  defp match(key, var) do
    quote do
      %{unquote(key) => unquote(var)}
    end
  end

  defp match_with_srid(key, :xy) do
    quote do
      %{unquote(key) => [x, y], :srid => srid}
    end
  end

  defp match_with_srid(key, :xyzm) do
    quote do
      %{unquote(key) => [x, y, z, m], :srid => srid}
    end
  end

  defp match_with_srid(key, dim) when dim in [:xyz, :xym] do
    quote do
      %{unquote(key) => [x, y, z], :srid => srid}
    end
  end

  defp match_with_srid(key, var) do
    quote do
      %{unquote(key) => unquote(var), :srid => srid}
    end
  end

  defp srid_to_binary(endian) do
    srid =
      quote do
        <<srid::unquote(modifier(endian))-integer-size(32)>>
      end

    elem(srid, 2)
  end

  defp srid_to_string do
    quote do
      "SRID=#{srid};"
    end
  end

  defp count(list, endian) do
    quote do
      length(unquote(list)) :: unquote(modifier(endian)) - integer - size(32)
    end
  end

  defp points_to_binary(:xy, endian) do
    quote do
      Enum.map(points, fn [x, y] ->
        <<
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64)
        >>
      end)
    end
  end

  defp points_to_binary(dim, endian) when dim in [:xyz, :xym] do
    quote do
      Enum.map(points, fn [x, y, z] ->
        <<
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64),
          z::unquote(modifier(endian))-float-size(64)
        >>
      end)
    end
  end

  defp points_to_binary(:xyzm, endian) do
    quote do
      Enum.map(points, fn [x, y, z, m] ->
        <<
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64),
          z::unquote(modifier(endian))-float-size(64),
          m::unquote(modifier(endian))-float-size(64)
        >>
      end)
    end
  end

  defp points_to_binary(:xy, endian, code) do
    quote do
      Enum.map(points, fn [x, y] ->
        <<
          unquote(IO.iodata_to_binary(code))::binary,
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64)
        >>
      end)
    end
  end

  defp points_to_binary(dim, endian, code) when dim in [:xyz, :xym] do
    quote do
      Enum.map(points, fn [x, y, z] ->
        <<
          unquote(IO.iodata_to_binary(code))::binary,
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64),
          z::unquote(modifier(endian))-float-size(64)
        >>
      end)
    end
  end

  defp points_to_binary(:xyzm, endian, code) do
    quote do
      Enum.map(points, fn [x, y, z, m] ->
        <<
          unquote(IO.iodata_to_binary(code))::binary,
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64),
          z::unquote(modifier(endian))-float-size(64),
          m::unquote(modifier(endian))-float-size(64)
        >>
      end)
    end
  end

  defp line_strings_to_binary(dim, endian, code) do
    quote do
      Enum.map(line_strings, fn points ->
        [
          <<
            unquote(IO.iodata_to_binary(code))::binary,
            unquote(count(quote(do: points), endian))
          >>,
          unquote(points_to_binary(dim, endian))
        ]
      end)
    end
  end

  defp polygons_to_binary(dim, endian, code) do
    quote do
      Enum.map(polygons, fn rings ->
        [
          <<
            unquote(IO.iodata_to_binary(code))::binary,
            unquote(count(quote(do: rings), endian))
          >>,
          unquote(rings_to_binary(dim, endian))
        ]
      end)
    end
  end

  defp geometries_to_binary(endian) do
    quote do
      Enum.map(geometries, fn geometry -> Geometry.to_wkb(geometry, unquote(endian)) end)
    end
  end

  defp points_to_string(:xy) do
    quote do
      Enum.reduce(points, <<>>, fn
        [x, y], <<>> ->
          <<
            to_string(x)::binary,
            ?\s,
            to_string(y)::binary
          >>

        [x, y], acc ->
          <<
            acc::binary,
            ", ",
            to_string(x)::binary,
            ?\s,
            to_string(y)::binary
          >>
      end)
    end
  end

  defp points_to_string(dim) when dim in [:xyz, :xym] do
    quote do
      Enum.reduce(points, <<>>, fn
        [x, y, z], <<>> ->
          <<
            to_string(x)::binary,
            ?\s,
            to_string(y)::binary,
            ?\s,
            to_string(z)::binary
          >>

        [x, y, z], acc ->
          <<
            acc::binary,
            ", ",
            to_string(x)::binary,
            ?\s,
            to_string(y)::binary,
            ?\s,
            to_string(z)::binary
          >>
      end)
    end
  end

  defp points_to_string(:xyzm) do
    quote do
      Enum.reduce(points, <<>>, fn
        [x, y, z, m], <<>> ->
          <<
            to_string(x)::binary,
            ?\s,
            to_string(y)::binary,
            ?\s,
            to_string(z)::binary,
            ?\s,
            to_string(m)::binary
          >>

        [x, y, z, m], acc ->
          <<
            acc::binary,
            ", ",
            to_string(x)::binary,
            ?\s,
            to_string(y)::binary,
            ?\s,
            to_string(z)::binary,
            ?\s,
            to_string(m)::binary
          >>
      end)
    end
  end

  defp rings_to_string(dim) do
    quote do
      [points | rings] = rings
      hd = <<"(", unquote(points_to_string(dim))::binary, ")">>

      Enum.reduce(rings, hd, fn points, acc ->
        <<acc::binary, ", (", unquote(points_to_string(dim))::binary, ")">>
      end)
    end
  end

  defp line_strings_to_string(dim) do
    quote do
      [points | line_strings] = line_strings
      hd = <<"(", unquote(points_to_string(dim))::binary, ")">>

      Enum.reduce(line_strings, hd, fn points, acc ->
        <<acc::binary, ", (", unquote(points_to_string(dim))::binary, ")">>
      end)
    end
  end

  defp polygons_to_string(dim) do
    quote do
      [rings | polygons] = polygons
      hd = <<"(", unquote(rings_to_string(dim))::binary, ")">>

      Enum.reduce(polygons, hd, fn rings, acc ->
        <<acc::binary, ", (", unquote(rings_to_string(dim))::binary, ")">>
      end)
    end
  end

  defp coordinate_to_binary(:xy, endian) do
    coordinate =
      quote do
        <<
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64)
        >>
      end

    elem(coordinate, 2)
  end

  defp coordinate_to_binary(dim, endian) when dim in [:xyz, :xym] do
    coordinate =
      quote do
        <<
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64),
          z::unquote(modifier(endian))-float-size(64)
        >>
      end

    elem(coordinate, 2)
  end

  defp coordinate_to_binary(:xyzm, endian) do
    coordinate =
      quote do
        <<
          x::unquote(modifier(endian))-float-size(64),
          y::unquote(modifier(endian))-float-size(64),
          z::unquote(modifier(endian))-float-size(64),
          m::unquote(modifier(endian))-float-size(64)
        >>
      end

    elem(coordinate, 2)
  end

  defp coordinate_to_string(:xy) do
    coordinate =
      quote do
        <<
          to_string(x)::binary,
          ?\s,
          to_string(y)::binary
        >>
      end

    elem(coordinate, 2)
  end

  defp coordinate_to_string(dim) when dim in [:xyz, :xym] do
    coordinate =
      quote do
        <<
          to_string(x)::binary,
          ?\s,
          to_string(y)::binary,
          ?\s,
          to_string(z)::binary
        >>
      end

    elem(coordinate, 2)
  end

  defp coordinate_to_string(:xyzm) do
    coordinate =
      quote do
        <<
          to_string(x)::binary,
          ?\s,
          to_string(y)::binary,
          ?\s,
          to_string(z)::binary,
          ?\s,
          to_string(m)::binary
        >>
      end

    elem(coordinate, 2)
  end

  defp rings_to_binary(dim, endian) do
    quote do
      Enum.map(rings, fn points ->
        [
          <<length(points)::unquote(modifier(endian))-integer-size(32)>>,
          unquote(points_to_binary(dim, endian))
        ]
      end)
    end
  end

  defp duplicate(list, dim) do
    List.duplicate(list, @dims[dim])
  end

  defp binary(list), do: {:<<>>, [], List.flatten(list)}

  defp modifier(:xdr), do: quote(do: big)
  defp modifier(:ndr), do: quote(do: little)
end
