defmodule Geometry.MultiLineStringZ do
  @moduledoc """
  A set of line-strings from type `Geometry.LineStringZ`
  """

  alias Geometry.{GeoJson, LineStringZ, MultiLineStringZ, PointZ, WKB, WKT}

  defstruct line_strings: MapSet.new()

  @type t :: %MultiLineStringZ{line_strings: MapSet.t(LineStringZ.t())}

  @doc """
  Creates an empty `MultiLineStringZ`.

  ## Examples

      iex> MultiLineStringZ.new()
      %MultiLineStringZ{line_strings: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiLineStringZ{}

  @doc """
  Creates a `MultiLineStringZ` from the given `Geometry.MultiLineStringZ`s.

  ## Examples

      iex> MultiLineStringZ.new([
      ...>   LineStringZ.new([
      ...>     PointZ.new(1, 2, 3),
      ...>     PointZ.new(2, 3, 4),
      ...>     PointZ.new(3, 4, 5)
      ...>   ]),
      ...>   LineStringZ.new([
      ...>     PointZ.new(10, 20, 30),
      ...>     PointZ.new(30, 40, 50)
      ...>   ]),
      ...>   LineStringZ.new([
      ...>     PointZ.new(10, 20, 30),
      ...>     PointZ.new(30, 40, 50)
      ...>   ])
      ...> ])
      %MultiLineStringZ{line_strings: MapSet.new([
        %LineStringZ{points: [
          %PointZ{x: 1, y: 2, z: 3},
          %PointZ{x: 2, y: 3, z: 4},
          %PointZ{x: 3, y: 4, z: 5}
        ]},
        %LineStringZ{ points: [
          %PointZ{x: 10, y: 20, z: 30},
          %PointZ{x: 30, y: 40, z: 50}
        ]}
      ])}

      iex> MultiLineStringZ.new([])
      %MultiLineStringZ{line_strings: MapSet.new()}
  """
  @spec new([LineStringZ.t()]) :: t()
  def new([]), do: %MultiLineStringZ{}
  def new(line_strings), do: %MultiLineStringZ{line_strings: MapSet.new(line_strings)}

  @doc """
  Returns `true` if the given `MultiLineStringZ` is empty.

  ## Examples

      iex> MultiLineStringZ.empty?(MultiLineStringZ.new())
      true

      iex> MultiLineStringZ.empty?(
      ...>   MultiLineStringZ.new([
      ...>     LineStringZ.new([PointZ.new(1, 2, 3), PointZ.new(3, 4, 5)])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiLineStringZ{} = multi_line_string),
    do: Enum.empty?(multi_line_string.line_strings)

  @doc """
  Creates a `MultiLineStringZ` from the given coordinates.

  ## Examples

      iex> MultiLineStringZ.from_coordinates([
      ...>   [{-1, 1, 1}, {2, 2, 2}, {-3, 3, 3}],
      ...>   [{-10, 10, 10}, {-20, 20, 20}]
      ...> ])
      %MultiLineStringZ{
        line_strings: MapSet.new([
          %LineStringZ{points: [
            %PointZ{x: -1, y: 1, z: 1},
            %PointZ{x: 2, y: 2, z: 2},
            %PointZ{x: -3, y: 3, z: 3}
          ]},
          %LineStringZ{points: [
            %PointZ{x: -10, y: 10, z: 10},
            %PointZ{x: -20, y: 20, z: 20}
          ]}
        ])
      }
  """
  @spec from_coordinates([[Geometry.coordinate_z()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiLineStringZ{
      line_strings: coordinates |> Enum.map(&LineStringZ.from_coordinates/1) |> MapSet.new()
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringZ` from the given GeoJSON
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
      iex> |> MultiLineStringZ.from_geo_json()
      {
        :ok,
        %MultiLineStringZ{
          line_strings: MapSet.new([
            %LineStringZ{points: [
              %PointZ{x: -1, y: 1, z: 1},
              %PointZ{x: 2, y: 2, z: 2},
              %PointZ{x: -3, y: 3, z: 3}
            ]},
            %LineStringZ{points: [
              %PointZ{x: -10, y: 10, z: 10},
              %PointZ{x: -20, y: 20, z: 20}
            ]}
          ])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_line_string(json, MultiLineStringZ)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_line_string(json, MultiLineStringZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiLineStringZ`.

  There are no guarantees about the order of line-strings in the returned
  `coordinates`.

  ## Examples

  ```elixir
  [
    [{-1, 1, 1}, {2, 2, 2}, {-3, 3, 3}],
    [{-10, 10, 10}, {-20, 20, 20}]
  ]
  |> MultiLineStringZ.from_coordinates()
  |> MultiLineStringZ.to_geo_json()
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
  def to_geo_json(%MultiLineStringZ{line_strings: line_strings}) do
    %{
      "type" => "MultiLineString",
      "coordinates" =>
        Enum.map(line_strings, fn line_string ->
          Enum.map(line_string.points, &PointZ.to_list/1)
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringZ` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiLineStringZ.from_wkt("
      ...>   SRID=1234;MultiLineString Z (
      ...>     (10 20 10, 20 10 35, 20 40 10),
      ...>     (40 30 10, 30 30 25)
      ...>   )
      ...> ")
      {
        :ok,
        %MultiLineStringZ{
          line_strings:
            MapSet.new([
              %LineStringZ{
                points: [
                  %PointZ{x: 40, y: 30, z: 10},
                  %PointZ{x: 30, y: 30, z: 25}
                ]
              },
              %LineStringZ{
                points: [
                  %PointZ{x: 10, y: 20, z: 10},
                  %PointZ{x: 20, y: 10, z: 35},
                  %PointZ{x: 20, y: 40, z: 10}
                ]
              }
            ])
        },
        1234
      }

      iex> MultiLineStringZ.from_wkt("MultiLineString Z EMPTY")
      ...> {:ok, %MultiLineStringZ{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiLineStringZ)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiLineStringZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiLineStringZ`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of line-strings in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiLineStringZ.to_wkt(MultiLineStringZ.new())
  # => "MultiLineString Z EMPTY"

  MultiLineStringZ.to_wkt(
    MultiLineStringZ.new([
      [PointZ.new(7.1, 8.1, 1.1), PointZ.new(9.2, 5.2, 2.2)],
      [PointZ.new(5.5, 9.2, 3.1), PointZ.new(1.2, 3.2, 4.2)]
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # MultiLineString Z (
  #   (5.5 9.2 3.1, 1.2 3.2 4.2),
  #   (7.1 8.1 1.1, 9.2 5.2 2.2)
  # )

  MultiLineStringZ.to_wkt(
    MultiLineStringZ.new([
      [PointZ.new(7.1, 8.1, 1.1), PointZ.new(9.2, 5.2, 2.2)],
      [PointZ.new(5.5, 9.2, 3.1), PointZ.new(1.2, 3.2, 4.2)]
    ]),
    srid: 555
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # SRID=555;MultiLineString Z (
  #   (5.5 9.2 3.1, 1.2 3.2 4.2),
  #   (7.1 8.1 1.1, 9.2 5.2 2.2)
  # )
  ```
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(line_strings, opts \\ [])

  def to_wkt(%MultiLineStringZ{line_strings: line_strings}, opts) do
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
  Returns the WKB representation for a `MultiLineStringZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiLineStringZ{} = multi_line_string, opts \\ []) do
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
  Returns an `:ok` tuple with the `MultiLineStringZ` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiLineStringZ)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiLineStringZ) do
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
      |> Enum.map(fn point -> PointZ.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  defp to_wkt_multi_line_string(wkt), do: "MultiLineString Z #{wkt}"

  defp to_wkb_multi_line_string(%MultiLineStringZ{line_strings: line_strings}, endian) do
    data =
      Enum.reduce(line_strings, [], fn line_string, acc ->
        [LineStringZ.to_wkb(line_string, endian: endian) | acc]
      end)

    <<WKB.length(line_strings, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "80000005"
      {:ndr, false} -> "05000080"
      {:xdr, true} -> "A0000005"
      {:ndr, true} -> "050000A0"
    end
  end
end
