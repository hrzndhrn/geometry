defmodule Geometry.MultiLineStringM do
  @moduledoc """
  A collection set of geometries restricted to `Geometry.MultiLineStringM`.
  """

  alias Geometry.{GeoJson, LineStringM, MultiLineStringM, PointM, WKB, WKT}

  defstruct geometries: MapSet.new()

  @type t :: %MultiLineStringM{geometries: MapSet.t(LineStringM.t())}

  @doc """
  Creates an empty `MultiLineStringM`.

  ## Examples

      iex> MultiLineStringM.new()
      %MultiLineStringM{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiLineStringM{}

  @doc """
  Creates a `MultiLineStringM` from the given `Geometry.MultiLineStringM`s.

  ## Examples

      iex> MultiLineStringM.new([
      ...>   LineStringM.new([
      ...>     PointM.new(1, 2, 4),
      ...>     PointM.new(2, 3, 5),
      ...>     PointM.new(3, 4, 6)
      ...>   ]),
      ...>   LineStringM.new([
      ...>     PointM.new(10, 20, 40),
      ...>     PointM.new(30, 40, 60)
      ...>   ]),
      ...>   LineStringM.new([
      ...>     PointM.new(10, 20, 40),
      ...>     PointM.new(30, 40, 60)
      ...>   ])
      ...> ])
      %MultiLineStringM{geometries: MapSet.new([
        %LineStringM{points: [
          %PointM{x: 1, y: 2, m: 4},
          %PointM{x: 2, y: 3, m: 5},
          %PointM{x: 3, y: 4, m: 6}
        ]},
        %LineStringM{ points: [
          %PointM{x: 10, y: 20, m: 40},
          %PointM{x: 30, y: 40, m: 60}
        ]}
      ])}

      iex> MultiLineStringM.new([])
      %MultiLineStringM{geometries: MapSet.new()}
  """
  @spec new([LineStringM.t()]) :: t()
  def new([]), do: %MultiLineStringM{}
  def new(line_strings), do: %MultiLineStringM{geometries: MapSet.new(line_strings)}

  @doc """
  Returns `true` if the given `MultiLineStringM` is empty.

  ## Examples

      iex> MultiLineStringM.empty?(MultiLineStringM.new())
      true

      iex> MultiLineStringM.empty?(
      ...>   MultiLineStringM.new([
      ...>     LineStringM.new([PointM.new(1, 2, 4), PointM.new(3, 4, 6)])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiLineStringM{} = multi_line_string),
    do: Enum.empty?(multi_line_string.geometries)

  @doc """
  Creates a `MultiLineStringM` from the given coordinates.

  ## Examples

      iex> MultiLineStringM.from_coordinates([
      ...>   [{-1, 1, 1}, {2, 2, 2}, {-3, 3, 3}],
      ...>   [{-10, 10, 10}, {-20, 20, 20}]
      ...> ])
      %MultiLineStringM{
        geometries: MapSet.new([
          %LineStringM{points: [
            %PointM{x: -1, y: 1, m: 1},
            %PointM{x: 2, y: 2, m: 2},
            %PointM{x: -3, y: 3, m: 3}
          ]},
          %LineStringM{points: [
            %PointM{x: -10, y: 10, m: 10},
            %PointM{x: -20, y: 20, m: 20}
          ]}
        ])
      }
  """
  @spec from_coordinates([[Geometry.coordinate_m()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiLineStringM{
      geometries: coordinates |> Enum.map(&LineStringM.from_coordinates/1) |> MapSet.new()
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringM` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiLineString",
      ...>     "coordinates": [
      ...>       [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
      ...>       [[-10, 10, 10], [-20, 20, 20]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> MultiLineStringM.from_geo_json()
      {
        :ok,
        %MultiLineStringM{
          geometries: MapSet.new([
            %LineStringM{points: [
              %PointM{x: -1, y: 1, m: 1},
              %PointM{x: 2, y: 2, m: 2},
              %PointM{x: -3, y: 3, m: 3}
            ]},
            %LineStringM{points: [
              %PointM{x: -10, y: 10, m: 10},
              %PointM{x: -20, y: 20, m: 20}
            ]}
          ])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_line_string(json, MultiLineStringM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_line_string(json, MultiLineStringM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiLineStringM`.

  There are no guarantees about the order of line-strings in the returned
  `coordinates`.

  ## Examples

  ```elixir
  [
    [{-1, 1, 1}, {2, 2, 2}, {-3, 3, 3}],
    [{-10, 10, 10}, {-20, 20, 20}]
  ]
  |> MultiLineStringM.from_coordinates()
  |> MultiLineStringM.to_geo_json()
  # =>
  # %{
  #   "type" => "MultiLineString",
  #   "coordinates" => [
  #     [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
  #     [[-10, 10, 10], [-20, 20, 20]]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiLineStringM{geometries: line_strings}) do
    %{
      "type" => "MultiLineString",
      "coordinates" =>
        Enum.map(line_strings, fn line_string ->
          Enum.map(line_string.points, &PointM.to_list/1)
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiLineStringM.from_wkt("
      ...>   SRID=1234;MultiLineString M (
      ...>     (10 20 45, 20 10 15, 20 40 15),
      ...>     (40 30 20, 30 30 30)
      ...>   )
      ...> ")
      {
        :ok,
        %MultiLineStringM{
          geometries:
            MapSet.new([
              %LineStringM{
                points: [
                  %PointM{x: 40, y: 30, m: 20},
                  %PointM{x: 30, y: 30, m: 30}
                ]
              },
              %LineStringM{
                points: [
                  %PointM{x: 10, y: 20, m: 45},
                  %PointM{x: 20, y: 10, m: 15},
                  %PointM{x: 20, y: 40, m: 15}
                ]
              }
            ])
        },
        1234
      }
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiLineStringM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiLineStringM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiLineStringM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of line-strings in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiLineStringM.to_wkt(MultiLineStringM.new())
  # => "MultiLineString M EMPTY"

  MultiLineStringM.to_wkt(
    MultiLineStringM.new([
      [PointM.new(7.1, 8.1, 1), PointM.new(9.2, 5.2, 2)],
      [PointM.new(5.5, 9.2, 1), PointM.new(1.2, 3.2, 2)]
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # MultiLineString M (
  #   (5.5 9.2 1, 1.2 3.2 2),
  #   (7.1 8.1 1, 9.2 5.2 2)
  # )

  MultiLineStringM.to_wkt(
    MultiLineStringM.new([
      [PointM.new(7.1, 8.1, 1), PointM.new(9.2, 5.2, 2)],
      [PointM.new(5.5, 9.2, 1), PointM.new(1.2, 3.2, 2)]
    ]),
    srid: 555
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # SRID=555;MultiLineString M (
  #   (5.5 9.2 1, 1.2 3.2 2),
  #   (7.1 8.1 1, 9.2 5.2 2)
  # )
  ```
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(line_strings, opts \\ [])

  def to_wkt(%MultiLineStringM{geometries: line_strings}, opts) do
    line_strings
    |> Enum.empty?()
    |> case do
      true -> "EMPTY"
      false -> to_wkt_line_strings(line_strings)
    end
    |> to_wkt_multi_line_string()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns the WKB representation for a `MultiLineStringM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiLineStringM{} = multi_line_string, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_multi_line_string(multi_line_string, endian)::binary()
    >>
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiLineStringM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiLineStringM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  defp to_wkt_line_strings(line_strings) do
    wkt =
      line_strings
      |> Enum.map(&to_wkt_line_string/1)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_line_string(line_string) do
    wkt =
      line_string
      |> Enum.map(fn point -> PointM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_multi_line_string(wkt), do: "MultiLineString M #{wkt}"

  defp to_wkb_multi_line_string(%MultiLineStringM{geometries: geometries}, endian) do
    data =
      Enum.reduce(geometries, [], fn line_string, acc ->
        [LineStringM.to_wkb(line_string, endian: endian) | acc]
      end)

    <<WKB.length(geometries, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "40000005"
      {:ndr, false} -> "05000040"
      {:xdr, true} -> "60000005"
      {:ndr, true} -> "05000060"
    end
  end
end
