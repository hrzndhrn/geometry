defmodule Geometry.Decoder.WKB do
  @moduledoc false

  alias Geometry.DecodeError

  alias Geometry.CircularString
  alias Geometry.CircularStringM
  alias Geometry.CircularStringZ
  alias Geometry.CircularStringZM
  alias Geometry.GeometryCollection
  alias Geometry.GeometryCollectionM
  alias Geometry.GeometryCollectionZ
  alias Geometry.GeometryCollectionZM
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

  @spec decode(Geometry.wkb()) :: {:ok, Geometry.t()} | {:error, DecodeError.t()}
  geos =
    [
      :point,
      :line_string,
      :polygon,
      :multi_point,
      :multi_line_string,
      :multi_polygon,
      :geometry_collection,
      :circular_string
    ]
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {type, index} ->
      [
        %{code: 0x00000000 + index, type: type, dim: :xy, srid?: false},
        %{code: 0x20000000 + index, type: type, dim: :xy, srid?: true},
        %{code: 0x40000000 + index, type: type, dim: :xym, srid?: false},
        %{code: 0x60000000 + index, type: type, dim: :xym, srid?: true},
        %{code: 0x80000000 + index, type: type, dim: :xyz, srid?: false},
        %{code: 0xA0000000 + index, type: type, dim: :xyz, srid?: true},
        %{code: 0xC0000000 + index, type: type, dim: :xyzm, srid?: false},
        %{code: 0xE0000000 + index, type: type, dim: :xyzm, srid?: true}
      ]
    end)
    |> Enum.flat_map(fn data ->
      [
        Map.merge(data, %{
          flag: 0,
          mod: quote(do: big),
          endian: :xdr,
          empty: <<127, 248, 0, 0, 0, 0, 0, 0>>
        }),
        Map.merge(data, %{
          flag: 1,
          mod: quote(do: little),
          endian: :ndr,
          empty: <<0, 0, 0, 0, 0, 0, 248, 127>>
        })
      ]
    end)

  for geo <- geos do
    if geo.srid? do
      cond do
        geo.type == :point && geo.dim == :xy ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, x::unquote(geo.mod)-float-size(64),
                  y::unquote(geo.mod)-float-size(64)>>
              ) do
            {:ok, Point.new(x, y, srid)}
          end

          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, unquote(geo.empty),
                  unquote(geo.empty)>>
              ) do
            {:ok, Map.put(Point.new(), :srid, srid)}
          end

        geo.type == :point && geo.dim == :xym ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, x::unquote(geo.mod)-float-size(64),
                  y::unquote(geo.mod)-float-size(64), m::unquote(geo.mod)-float-size(64)>>
              ) do
            {:ok, PointM.new(x, y, m, srid)}
          end

          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, unquote(geo.empty),
                  unquote(geo.empty), unquote(geo.empty)>>
              ) do
            {:ok, Map.put(PointM.new(), :srid, srid)}
          end

        geo.type == :point && geo.dim == :xyz ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, x::unquote(geo.mod)-float-size(64),
                  y::unquote(geo.mod)-float-size(64), z::unquote(geo.mod)-float-size(64)>>
              ) do
            {:ok, PointZ.new(x, y, z, srid)}
          end

          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, unquote(geo.empty),
                  unquote(geo.empty), unquote(geo.empty)>>
              ) do
            {:ok, Map.put(PointZ.new(), :srid, srid)}
          end

        geo.type == :point && geo.dim == :xyzm ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, x::unquote(geo.mod)-float-size(64),
                  y::unquote(geo.mod)-float-size(64), z::unquote(geo.mod)-float-size(64),
                  m::unquote(geo.mod)-float-size(64)>>
              ) do
            {:ok, PointZM.new(x, y, z, m, srid)}
          end

          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, unquote(geo.empty),
                  unquote(geo.empty), unquote(geo.empty), unquote(geo.empty)>>
              ) do
            {:ok, Map.put(PointZM.new(), :srid, srid)}
          end

        true ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  <<srid::unquote(geo.mod)-integer-size(32)>>, rest::bits>> = bin
              ) do
            with {:ok, geometry, rest} <-
                   unquote(geo.type)(unquote(geo.dim), unquote(geo.endian), srid, rest),
                 <<>> <- rest do
              {:ok, geometry}
            else
              error -> handle_error(error, bin)
            end
          end
      end
    else
      cond do
        geo.type == :point && geo.dim == :xy ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64)>>
              ) do
            {:ok, Point.new(x, y)}
          end

          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  unquote(geo.empty), unquote(geo.empty)>>
              ) do
            {:ok, Point.new()}
          end

        geo.type == :point && geo.dim == :xym ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64),
                  m::unquote(geo.mod)-float-size(64)>>
              ) do
            {:ok, PointM.new(x, y, m)}
          end

          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  unquote(geo.empty), unquote(geo.empty), unquote(geo.empty)>>
              ) do
            {:ok, PointM.new()}
          end

        geo.type == :point && geo.dim == :xyz ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64),
                  z::unquote(geo.mod)-float-size(64)>>
              ) do
            {:ok, PointZ.new(x, y, z)}
          end

          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  unquote(geo.empty), unquote(geo.empty), unquote(geo.empty)>>
              ) do
            {:ok, PointZ.new()}
          end

        geo.type == :point && geo.dim == :xyzm ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64),
                  z::unquote(geo.mod)-float-size(64), m::unquote(geo.mod)-float-size(64)>>
              ) do
            {:ok, PointZM.new(x, y, z, m)}
          end

          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  unquote(geo.empty), unquote(geo.empty), unquote(geo.empty), unquote(geo.empty)>>
              ) do
            {:ok, PointZM.new()}
          end

        true ->
          def decode(
                <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
                  rest::bits>> = bin
              ) do
            with {:ok, geometry, rest} <-
                   unquote(geo.type)(unquote(geo.dim), unquote(geo.endian), 0, rest),
                 <<>> <- rest do
              {:ok, geometry}
            else
              error -> handle_error(error, bin)
            end
          end
      end
    end
  end

  def decode(<<>>) do
    {:error, %DecodeError{from: :wkb, reason: :empty}}
  end

  for geo <- geos do
    if geo.srid? do
      def decode(
            <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
              _srid::unquote(geo.mod)-integer-size(32), rest::bits>> = bin
          ) do
        handle_error(:invalid_data, rest, bin)
      end

      def decode(
            <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
              rest::bits>> = bin
          ) do
        handle_error(:invalid_srid, rest, bin)
      end
    else
      def decode(
            <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32),
              rest::bits>> = bin
          ) do
        handle_error(:invalid_data, rest, bin)
      end
    end
  end

  def decode(<<endian::8, _rest::bits>> = bin) when endian not in [0, 1] do
    handle_error([expected_endian: :flag], bin, bin)
  end

  def decode(<<_endian::8, rest::bits>> = bin) do
    handle_error(:expected_geometry_code, rest, bin)
  end

  def decode(input) when not is_binary(input) do
    {:error, %DecodeError{from: :wkb, reason: :no_binary, rest: input}}
  end

  for geo <- geos, !geo.srid? do
    defp collection(
           unquote(geo.dim),
           unquote(geo.endian),
           <<unquote(geo.flag), unquote(geo.code)::unquote(geo.mod)-integer-size(32), rest::bits>>
         ) do
      {:ok, unquote(geo.type), rest}
    end
  end

  defp collection(_dim, endian, <<flag::8, rest::bits>> = bin) do
    if (endian == :xdr && flag == 0) || (endian == :ndr && flag == 1) do
      {:error, :expected_geometry_code, rest}
    else
      {:error, [expected_endian: endian], bin}
    end
  end

  endian_code_bin = %{
    {:ndr, :point, :xy} => <<1, 1, 0, 0, 0>>,
    {:ndr, :point, :xym} => <<1, 1, 0, 0, 64>>,
    {:ndr, :point, :xyz} => <<1, 1, 0, 0, 128>>,
    {:ndr, :point, :xyzm} => <<1, 1, 0, 0, 192>>,
    {:xdr, :point, :xy} => <<0, 0, 0, 0, 1>>,
    {:xdr, :point, :xym} => <<0, 64, 0, 0, 1>>,
    {:xdr, :point, :xyz} => <<0, 128, 0, 0, 1>>,
    {:xdr, :point, :xyzm} => <<0, 192, 0, 0, 1>>,
    {:ndr, :line_string, :xy} => <<1, 2, 0, 0, 0>>,
    {:ndr, :line_string, :xym} => <<1, 2, 0, 0, 64>>,
    {:ndr, :line_string, :xyz} => <<1, 2, 0, 0, 128>>,
    {:ndr, :line_string, :xyzm} => <<1, 2, 0, 0, 192>>,
    {:xdr, :line_string, :xy} => <<0, 0, 0, 0, 2>>,
    {:xdr, :line_string, :xym} => <<0, 64, 0, 0, 2>>,
    {:xdr, :line_string, :xyz} => <<0, 128, 0, 0, 2>>,
    {:xdr, :line_string, :xyzm} => <<0, 192, 0, 0, 2>>,
    {:ndr, :polygon, :xy} => <<1, 3, 0, 0, 0>>,
    {:ndr, :polygon, :xym} => <<1, 3, 0, 0, 64>>,
    {:ndr, :polygon, :xyz} => <<1, 3, 0, 0, 128>>,
    {:ndr, :polygon, :xyzm} => <<1, 3, 0, 0, 192>>,
    {:xdr, :polygon, :xy} => <<0, 0, 0, 0, 3>>,
    {:xdr, :polygon, :xym} => <<0, 64, 0, 0, 3>>,
    {:xdr, :polygon, :xyz} => <<0, 128, 0, 0, 3>>,
    {:xdr, :polygon, :xyzm} => <<0, 192, 0, 0, 3>>
  }

  for geo <- geos, geo.type == :point, geo.srid? do
    defp coordinates(
           unquote(geo.dim),
           unquote(geo.endian),
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn _ignore, bin ->
            case coordinate(unquote(geo.dim), unquote(geo.endian), bin) do
              {:ok, data, bin} ->
                {data, bin}

              error ->
                throw(error)
            end
          end)

        {:ok, data, rest}
      catch
        error -> error
      end
    end

    defp coordinates(unquote(geo.dim), unquote(geo.endian), bin) do
      {:error, :invalid_length, bin}
    end

    defp multi_coordinates(
           unquote(geo.dim),
           unquote(geo.endian),
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn _ignore, bin ->
            case coordinates(unquote(geo.dim), unquote(geo.endian), bin) do
              {:ok, data, bin} ->
                {data, bin}

              error ->
                throw(error)
            end
          end)

        {:ok, data, rest}
      catch
        error -> error
      end
    end

    defp multi_coordinates(unquote(geo.dim), unquote(geo.endian), bin) do
      {:error, :invalid_length, bin}
    end

    defp line_string(
           unquote(geo.dim),
           unquote(geo.endian),
           srid,
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn _ignore, bin ->
            case coordinate(unquote(geo.dim), unquote(geo.endian), bin) do
              {:ok, data, bin} ->
                {data, bin}

              error ->
                throw(error)
            end
          end)

        line_string = %unquote(
            case geo.dim do
              :xy -> LineString
              :xym -> LineStringM
              :xyz -> LineStringZ
              :xyzm -> LineStringZM
            end
          ){
          path: data,
          srid: srid
        }

        {:ok, line_string, rest}
      catch
        error -> error
      end
    end

    defp line_string(unquote(geo.dim), unquote(geo.endian), _srid, bin) do
      {:error, :invalid_length, bin}
    end

    defp circular_string(
           unquote(geo.dim),
           unquote(geo.endian),
           srid,
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn _ignore, bin ->
            case coordinate(unquote(geo.dim), unquote(geo.endian), bin) do
              {:ok, data, bin} ->
                {data, bin}

              error ->
                throw(error)
            end
          end)

        circular_string = %unquote(
            case geo.dim do
              :xy -> CircularString
              :xym -> CircularStringM
              :xyz -> CircularStringZ
              :xyzm -> CircularStringZM
            end
          ){
          arcs: data,
          srid: srid
        }

        {:ok, circular_string, rest}
      catch
        error -> error
      end
    end

    defp circular_string(unquote(geo.dim), unquote(geo.endian), _srid, bin) do
      {:error, :invalid_length, bin}
    end

    defp polygon(
           unquote(geo.dim),
           unquote(geo.endian),
           srid,
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn _ignore, bin ->
            case coordinates(unquote(geo.dim), unquote(geo.endian), bin) do
              {:ok, data, bin} ->
                {data, bin}

              error ->
                throw(error)
            end
          end)

        polygon = %unquote(
            case geo.dim do
              :xy -> Polygon
              :xym -> PolygonM
              :xyz -> PolygonZ
              :xyzm -> PolygonZM
            end
          ){
          rings: data,
          srid: srid
        }

        {:ok, polygon, rest}
      catch
        error -> error
      end
    end

    defp polygon(unquote(geo.dim), unquote(geo.endian), _srid, bin) do
      {:error, :invalid_length, bin}
    end

    defp multi_point(
           unquote(geo.dim),
           unquote(geo.endian),
           srid,
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn
            _ignore, <<unquote(endian_code_bin[{geo.endian, :point, geo.dim}]), bin::bits>> ->
              case coordinate(unquote(geo.dim), unquote(geo.endian), bin) do
                {:ok, data, bin} ->
                  {data, bin}

                error ->
                  throw(error)
              end

            _ignore, bin ->
              case bin do
                <<flag::8, bin::bits>> when flag == unquote(geo.flag) ->
                  throw({:error, :expected_geometry_code, bin})

                bin ->
                  throw({:error, [expected_endian: unquote(geo.endian)], bin})
              end
          end)

        multi_point = %unquote(
            case geo.dim do
              :xy -> MultiPoint
              :xym -> MultiPointM
              :xyz -> MultiPointZ
              :xyzm -> MultiPointZM
            end
          ){
          points: data,
          srid: srid
        }

        {:ok, multi_point, rest}
      catch
        error -> error
      end
    end

    defp multi_point(unquote(geo.dim), unquote(geo.endian), _srid, bin) do
      {:error, :invalid_length, bin}
    end

    defp multi_line_string(
           unquote(geo.dim),
           unquote(geo.endian),
           srid,
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn
            _ignore,
            <<unquote(endian_code_bin[{geo.endian, :line_string, geo.dim}]), bin::bits>> ->
              case coordinates(unquote(geo.dim), unquote(geo.endian), bin) do
                {:ok, data, bin} ->
                  {data, bin}

                error ->
                  throw(error)
              end

            _ignore, bin ->
              case bin do
                <<flag::8, bin::bits>> when flag == unquote(geo.flag) ->
                  throw({:error, :expected_geometry_code, bin})

                bin ->
                  throw({:error, [expected_endian: unquote(geo.endian)], bin})
              end
          end)

        multi_line_string = %unquote(
            case geo.dim do
              :xy -> MultiLineString
              :xym -> MultiLineStringM
              :xyz -> MultiLineStringZ
              :xyzm -> MultiLineStringZM
            end
          ){
          line_strings: data,
          srid: srid
        }

        {:ok, multi_line_string, rest}
      catch
        error -> error
      end
    end

    defp multi_line_string(unquote(geo.dim), unquote(geo.endian), _srid, bin) do
      {:error, :invalid_length, bin}
    end

    defp multi_polygon(
           unquote(geo.dim),
           unquote(geo.endian),
           srid,
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn
            _ignore, <<unquote(endian_code_bin[{geo.endian, :polygon, geo.dim}]), bin::bits>> ->
              case multi_coordinates(unquote(geo.dim), unquote(geo.endian), bin) do
                {:ok, data, bin} ->
                  {data, bin}

                error ->
                  throw(error)
              end

            _ignore, bin ->
              case bin do
                <<flag::8, bin::bits>> when flag == unquote(geo.flag) ->
                  throw({:error, :expected_geometry_code, bin})

                bin ->
                  throw({:error, [expected_endian: unquote(geo.endian)], bin})
              end
          end)

        multi_polygon = %unquote(
            case geo.dim do
              :xy -> MultiPolygon
              :xym -> MultiPolygonM
              :xyz -> MultiPolygonZ
              :xyzm -> MultiPolygonZM
            end
          ){
          polygons: data,
          srid: srid
        }

        {:ok, multi_polygon, rest}
      catch
        error -> error
      end
    end

    defp multi_polygon(unquote(geo.dim), unquote(geo.endian), _srid, bin) do
      {:error, :invalid_length, bin}
    end

    defp geometry_collection(
           unquote(geo.dim),
           unquote(geo.endian),
           srid,
           <<length::unquote(geo.mod)-integer-size(32), bin::bits>>
         ) do
      try do
        {data, rest} =
          Enum.map_reduce(List.duplicate(0, length), bin, fn _ignore, bin ->
            case collection(unquote(geo.dim), unquote(geo.endian), bin) do
              {:ok, :geometry_collection, bin} ->
                case geometry_collection(unquote(geo.dim), unquote(geo.endian), srid, bin) do
                  {:ok, geometry_collection, bin} -> {geometry_collection, bin}
                  error -> throw(error)
                end

              {:ok, :line_string, bin} ->
                case line_string(unquote(geo.dim), unquote(geo.endian), srid, bin) do
                  {:ok, line_string, bin} -> {line_string, bin}
                  error -> throw(error)
                end

              {:ok, :multi_line_string, bin} ->
                case multi_line_string(unquote(geo.dim), unquote(geo.endian), srid, bin) do
                  {:ok, multi_line_string, bin} -> {multi_line_string, bin}
                  error -> throw(error)
                end

              {:ok, :multi_point, bin} ->
                case multi_point(unquote(geo.dim), unquote(geo.endian), srid, bin) do
                  {:ok, multi_point, bin} -> {multi_point, bin}
                  error -> throw(error)
                end

              {:ok, :multi_polygon, bin} ->
                case multi_polygon(unquote(geo.dim), unquote(geo.endian), srid, bin) do
                  {:ok, multi_polygon, bin} -> {multi_polygon, bin}
                  error -> throw(error)
                end

              {:ok, :point, bin} ->
                case point(unquote(geo.dim), unquote(geo.endian), srid, bin) do
                  {:ok, point, bin} -> {point, bin}
                  error -> throw(error)
                end

              {:ok, :polygon, bin} ->
                case polygon(unquote(geo.dim), unquote(geo.endian), srid, bin) do
                  {:ok, polygon, bin} -> {polygon, bin}
                  error -> throw(error)
                end

              error ->
                throw(error)
            end
          end)

        geometry_collection = %unquote(
            case geo.dim do
              :xy -> GeometryCollection
              :xym -> GeometryCollectionM
              :xyz -> GeometryCollectionZ
              :xyzm -> GeometryCollectionZM
            end
          ){
          geometries: data,
          srid: srid
        }

        {:ok, geometry_collection, rest}
      catch
        error -> error
      end
    end

    defp geometry_collection(unquote(geo.dim), unquote(geo.endian), _srid, bin) do
      {:error, :invalid_length, bin}
    end
  end

  for geo <- geos, geo.type == :point, geo.srid?, geo.dim == :xy do
    defp coordinate(:xy, unquote(geo.endian), bin) do
      case bin do
        <<x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64), bin::bits>> ->
          {:ok, [x, y], bin}

        _error ->
          {:error, :invalid_coordinate, bin}
      end
    end

    defp coordinate(dim, unquote(geo.endian), bin) when dim in [:xym, :xyz] do
      case bin do
        <<x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64),
          z::unquote(geo.mod)-float-size(64), bin::bits>> ->
          {:ok, [x, y, z], bin}

        _error ->
          {:error, :invalid_coordinate, bin}
      end
    end

    defp coordinate(:xyzm, unquote(geo.endian), bin) do
      case bin do
        <<x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64),
          z::unquote(geo.mod)-float-size(64), m::unquote(geo.mod)-float-size(64), bin::bits>> ->
          {:ok, [x, y, z, m], bin}

        _error ->
          {:error, :invalid_coordinate, bin}
      end
    end

    # The point functions are just used for geometry collections. A geometry
    # point is detected in the decode function.
    defp point(:xy, unquote(geo.endian), srid, bin) do
      case bin do
        <<x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64), bin::bits>> ->
          {:ok, Point.new(x, y, srid), bin}

        <<unquote(geo.empty), unquote(geo.empty), bin::bits>> ->
          {:ok, Point.new([], srid), bin}

        _error ->
          {:error, :invalid_coordinate, bin}
      end
    end

    defp point(:xym, unquote(geo.endian), srid, bin) do
      case bin do
        <<x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64),
          m::unquote(geo.mod)-float-size(64), bin::bits>> ->
          {:ok, PointM.new(x, y, m, srid), bin}

        <<unquote(geo.empty), unquote(geo.empty), unquote(geo.empty), bin::bits>> ->
          {:ok, PointM.new([], srid), bin}

        _error ->
          {:error, :invalid_coordinate, bin}
      end
    end

    defp point(:xyz, unquote(geo.endian), srid, bin) do
      case bin do
        <<x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64),
          z::unquote(geo.mod)-float-size(64), bin::bits>> ->
          {:ok, PointZ.new(x, y, z, srid), bin}

        <<unquote(geo.empty), unquote(geo.empty), unquote(geo.empty), bin::bits>> ->
          {:ok, PointZ.new([], srid), bin}

        _error ->
          {:error, :invalid_coordinate, bin}
      end
    end

    defp point(:xyzm, unquote(geo.endian), srid, bin) do
      case bin do
        <<x::unquote(geo.mod)-float-size(64), y::unquote(geo.mod)-float-size(64),
          z::unquote(geo.mod)-float-size(64), m::unquote(geo.mod)-float-size(64), bin::bits>> ->
          {:ok, PointZM.new(x, y, z, m, srid), bin}

        <<unquote(geo.empty), unquote(geo.empty), unquote(geo.empty), unquote(geo.empty),
          bin::bits>> ->
          {:ok, PointZM.new([], srid), bin}

        _error ->
          {:error, :invalid_coordinate, bin}
      end
    end
  end

  defp handle_error({:error, reason, rest}, data) do
    {:error,
     %DecodeError{
       from: :wkb,
       reason: reason,
       rest: rest,
       offset: byte_size(data) - byte_size(rest)
     }}
  end

  defp handle_error(rest, data) when is_binary(rest) and is_binary(data) do
    {:error,
     %DecodeError{
       from: :wkb,
       reason: :eos,
       rest: rest,
       offset: byte_size(data) - byte_size(rest)
     }}
  end

  defp handle_error(reason, rest, data) do
    {:error,
     %DecodeError{
       from: :wkb,
       reason: reason,
       rest: rest,
       offset: byte_size(data) - byte_size(rest)
     }}
  end
end
