defmodule Geometry.MultiLineStringZM do
  @moduledoc """
  A collection set of geometries restricted to `Geometry.MultiLineStringZM`.
  """

  alias Geometry.{GeoJson, LineStringZM, MultiLineStringZM, PointZM, WKB, WKT}

  defstruct geometries: MapSet.new()

  @type t :: %MultiLineStringZM{geometries: MapSet.t(LineStringZM.t())}

  @doc """
  Creates an empty `MultiLineStringZM`.

  ## Examples

      iex> MultiLineStringZM.new()
      %MultiLineStringZM{geometries: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiLineStringZM{}

  @doc """
  Creates a `MultiLineStringZM` from the given `Geometry.MultiLineStringZM`s.

  ## Examples

      iex> MultiLineStringZM.new([
      ...>   LineStringZM.new([
      ...>     PointZM.new(1, 2, 3, 4),
      ...>     PointZM.new(2, 3, 4, 5),
      ...>     PointZM.new(3, 4, 5, 6)
      ...>   ]),
      ...>   LineStringZM.new([
      ...>     PointZM.new(10, 20, 30, 40),
      ...>     PointZM.new(30, 40, 50, 60)
      ...>   ]),
      ...>   LineStringZM.new([
      ...>     PointZM.new(10, 20, 30, 40),
      ...>     PointZM.new(30, 40, 50, 60)
      ...>   ])
      ...> ])
      %MultiLineStringZM{geometries: MapSet.new([
        %LineStringZM{points: [
          %PointZM{x: 1, y: 2, z: 3, m: 4},
          %PointZM{x: 2, y: 3, z: 4, m: 5},
          %PointZM{x: 3, y: 4, z: 5, m: 6}
        ]},
        %LineStringZM{ points: [
          %PointZM{x: 10, y: 20, z: 30, m: 40},
          %PointZM{x: 30, y: 40, z: 50, m: 60}
        ]}
      ])}

      iex> MultiLineStringZM.new([])
      %MultiLineStringZM{geometries: MapSet.new()}
  """
  @spec new([LineStringZM.t()]) :: t()
  def new([]), do: %MultiLineStringZM{}
  def new(line_strings), do: %MultiLineStringZM{geometries: MapSet.new(line_strings)}

  @doc """
  Returns `true` if the given `MultiLineStringZM` is empty.

  ## Examples

      iex> MultiLineStringZM.empty?(MultiLineStringZM.new())
      true

      iex> MultiLineStringZM.empty?(
      ...>   MultiLineStringZM.new([
      ...>     LineStringZM.new([PointZM.new(1, 2, 3, 4), PointZM.new(3, 4, 5, 6)])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiLineStringZM{} = multi_line_string),
    do: Enum.empty?(multi_line_string.geometries)

  @doc """
  Creates a `MultiLineStringZM` from the given coordinates.

  ## Examples

      iex> MultiLineStringZM.from_coordinates([
      ...>   [{-1, 1, 1, 1}, {2, 2, 2, 2}, {-3, 3, 3, 3}],
      ...>   [{-10, 10, 10, 10}, {-20, 20, 20, 20}]
      ...> ])
      %MultiLineStringZM{
        geometries: MapSet.new([
          %LineStringZM{points: [
            %PointZM{x: -1, y: 1, z: 1, m: 1},
            %PointZM{x: 2, y: 2, z: 2, m: 2},
            %PointZM{x: -3, y: 3, z: 3, m: 3}
          ]},
          %LineStringZM{points: [
            %PointZM{x: -10, y: 10, z: 10, m: 10},
            %PointZM{x: -20, y: 20, z: 20, m: 20}
          ]}
        ])
      }
  """
  @spec from_coordinates([[Geometry.coordinate_zm()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiLineStringZM{
      geometries: coordinates |> Enum.map(&LineStringZM.from_coordinates/1) |> MapSet.new()
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringZM` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiLineString",
      ...>     "coordinates": [
      ...>       [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
      ...>       [[-10, 10, 10, 10], [-20, 20, 20, 20]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> MultiLineStringZM.from_geo_json()
      {
        :ok,
        %MultiLineStringZM{
          geometries: MapSet.new([
            %LineStringZM{points: [
              %PointZM{x: -1, y: 1, z: 1, m: 1},
              %PointZM{x: 2, y: 2, z: 2, m: 2},
              %PointZM{x: -3, y: 3, z: 3, m: 3}
            ]},
            %LineStringZM{points: [
              %PointZM{x: -10, y: 10, z: 10, m: 10},
              %PointZM{x: -20, y: 20, z: 20, m: 20}
            ]}
          ])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_line_string(json, MultiLineStringZM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_line_string(json, MultiLineStringZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiLineStringZM`.

  There are no guarantees about the order of line-strings in the returned
  `coordinates`.

  ## Examples

  ```elixir
  [
    [{-1, 1, 1, 1}, {2, 2, 2, 2}, {-3, 3, 3, 3}],
    [{-10, 10, 10, 10}, {-20, 20, 20, 20}]
  ]
  |> MultiLineStringZM.from_coordinates()
  |> MultiLineStringZM.to_geo_json()
  # =>
  # %{
  #   "type" => "MultiLineString",
  #   "coordinates" => [
  #     [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
  #     [[-10, 10, 10, 10], [-20, 20, 20, 20]]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiLineStringZM{geometries: line_strings}) do
    %{
      "type" => "MultiLineString",
      "coordinates" =>
        Enum.map(line_strings, fn line_string ->
          Enum.map(line_string.points, &PointZM.to_list/1)
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringZM` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiLineStringZM.from_wkt("
      ...>   SRID=1234;MultiLineString ZM (
      ...>     (10 20 10 45, 20 10 35 15, 20 40 10 15),
      ...>     (40 30 10 20, 30 30 25 30)
      ...>   )
      ...> ")
      {
        :ok,
        %MultiLineStringZM{
          geometries:
            MapSet.new([
              %LineStringZM{
                points: [
                  %PointZM{x: 40, y: 30, z: 10, m: 20},
                  %PointZM{x: 30, y: 30, z: 25, m: 30}
                ]
              },
              %LineStringZM{
                points: [
                  %PointZM{x: 10, y: 20, z: 10, m: 45},
                  %PointZM{x: 20, y: 10, z: 35, m: 15},
                  %PointZM{x: 20, y: 40, z: 10, m: 15}
                ]
              }
            ])
        },
        1234
      }
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiLineStringZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiLineStringZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiLineStringZM`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of line-strings in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiLineStringZM.to_wkt(MultiLineStringZM.new())
  # => "MultiLineString ZM EMPTY"

  MultiLineStringZM.to_wkt(
    MultiLineStringZM.new([
      [PointZM.new(7.1, 8.1, 1.1, 1), PointZM.new(9.2, 5.2, 2.2, 2)],
      [PointZM.new(5.5, 9.2, 3.1, 1), PointZM.new(1.2, 3.2, 4.2, 2)]
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # MultiLineString ZM (
  #   (5.5 9.2 3.1 1, 1.2 3.2 4.2 2),
  #   (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)
  # )

  MultiLineStringZM.to_wkt(
    MultiLineStringZM.new([
      [PointZM.new(7.1, 8.1, 1.1, 1), PointZM.new(9.2, 5.2, 2.2, 2)],
      [PointZM.new(5.5, 9.2, 3.1, 1), PointZM.new(1.2, 3.2, 4.2, 2)]
    ]),
    srid: 555
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # SRID=555;MultiLineString ZM (
  #   (5.5 9.2 3.1 1, 1.2 3.2 4.2 2),
  #   (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)
  # )
  ```
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(line_strings, opts \\ [])

  def to_wkt(%MultiLineStringZM{geometries: line_strings}, opts) do
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
  Returns the WKB representation for a `MultiLineStringZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiLineStringZM{} = multi_line_string, opts \\ []) do
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
  Returns an `:ok` tuple with the `MultiLineStringZM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiLineStringZM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiLineStringZM) do
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
      |> Enum.map(fn point -> PointZM.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_multi_line_string(wkt), do: "MultiLineString ZM #{wkt}"

  defp to_wkb_multi_line_string(%MultiLineStringZM{geometries: geometries}, endian) do
    data =
      Enum.reduce(geometries, [], fn line_string, acc ->
        [LineStringZM.to_wkb(line_string, endian: endian) | acc]
      end)

    <<WKB.length(geometries, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000005"
      {:ndr, false} -> "050000C0"
      {:xdr, true} -> "E0000005"
      {:ndr, true} -> "050000E0"
    end
  end
end
