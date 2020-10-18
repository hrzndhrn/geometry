defmodule Geometry.MultiLineString do
  @moduledoc """
  A set of line-strings from type `Geometry.LineString`

  `MultiLineStringMZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiLineString.new([
      ...>     LineString.new([
      ...>       Point.new(1, 2),
      ...>       Point.new(3, 4)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(1, 2),
      ...>       Point.new(11, 12),
      ...>       Point.new(13, 14)
      ...>     ])
      ...>   ]),
      ...>   fn line_string -> length line_string.points end
      ...> )
      [2, 3]

      iex> Enum.into(
      ...>   [LineString.new([Point.new(1, 2), Point.new(5, 6)])],
      ...>   MultiLineString.new())
      %MultiLineString{
        line_strings:
          MapSet.new([
            %LineString{
              points: [
                %Point{x: 1, y: 2},
                %Point{x: 5, y: 6}
              ]
            }
          ])
      }
  """

  alias Geometry.{GeoJson, LineString, MultiLineString, Point, WKB, WKT}

  defstruct line_strings: MapSet.new()

  @type t :: %MultiLineString{line_strings: MapSet.t(LineString.t())}

  @doc """
  Creates an empty `MultiLineString`.

  ## Examples

      iex> MultiLineString.new()
      %MultiLineString{line_strings: MapSet.new()}
  """
  @spec new :: t()
  def new, do: %MultiLineString{}

  @doc """
  Creates a `MultiLineString` from the given `Geometry.MultiLineString`s.

  ## Examples

      iex> MultiLineString.new([
      ...>   LineString.new([
      ...>     Point.new(1, 2),
      ...>     Point.new(2, 3),
      ...>     Point.new(3, 4)
      ...>   ]),
      ...>   LineString.new([
      ...>     Point.new(10, 20),
      ...>     Point.new(30, 40)
      ...>   ]),
      ...>   LineString.new([
      ...>     Point.new(10, 20),
      ...>     Point.new(30, 40)
      ...>   ])
      ...> ])
      %MultiLineString{line_strings: MapSet.new([
        %LineString{points: [
          %Point{x: 1, y: 2},
          %Point{x: 2, y: 3},
          %Point{x: 3, y: 4}
        ]},
        %LineString{ points: [
          %Point{x: 10, y: 20},
          %Point{x: 30, y: 40}
        ]}
      ])}

      iex> MultiLineString.new([])
      %MultiLineString{line_strings: MapSet.new()}
  """
  @spec new([LineString.t()]) :: t()
  def new([]), do: %MultiLineString{}
  def new(line_strings), do: %MultiLineString{line_strings: MapSet.new(line_strings)}

  @doc """
  Returns `true` if the given `MultiLineString` is empty.

  ## Examples

      iex> MultiLineString.empty?(MultiLineString.new())
      true

      iex> MultiLineString.empty?(
      ...>   MultiLineString.new([
      ...>     LineString.new([Point.new(1, 2), Point.new(3, 4)])
      ...>   ])
      ...> )
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%MultiLineString{} = multi_line_string),
    do: Enum.empty?(multi_line_string.line_strings)

  @doc """
  Creates a `MultiLineString` from the given coordinates.

  ## Examples

      iex> MultiLineString.from_coordinates([
      ...>   [{-1, 1}, {2, 2}, {-3, 3}],
      ...>   [{-10, 10}, {-20, 20}]
      ...> ])
      %MultiLineString{
        line_strings: MapSet.new([
          %LineString{points: [
            %Point{x: -1, y: 1},
            %Point{x: 2, y: 2},
            %Point{x: -3, y: 3}
          ]},
          %LineString{points: [
            %Point{x: -10, y: 10},
            %Point{x: -20, y: 20}
          ]}
        ])
      }
  """
  @spec from_coordinates([[Geometry.coordinate()]]) :: t()
  def from_coordinates(coordinates) do
    %MultiLineString{
      line_strings: coordinates |> Enum.map(&LineString.from_coordinates/1) |> MapSet.new()
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineString` from the given GeoJSON
  term. Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s(
      ...>   {
      ...>     "type": "MultiLineString",
      ...>     "coordinates": [
      ...>       [[-1, 1], [2, 2], [-3, 3]],
      ...>       [[-10, 10], [-20, 20]]
      ...>     ]
      ...>   }
      ...> )
      iex> |> Jason.decode!()
      iex> |> MultiLineString.from_geo_json()
      {
        :ok,
        %MultiLineString{
          line_strings: MapSet.new([
            %LineString{points: [
              %Point{x: -1, y: 1},
              %Point{x: 2, y: 2},
              %Point{x: -3, y: 3}
            ]},
            %LineString{points: [
              %Point{x: -10, y: 10},
              %Point{x: -20, y: 20}
            ]}
          ])
        }
      }
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_multi_line_string(json, MultiLineString)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_multi_line_string(json, MultiLineString) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `MultiLineString`.

  There are no guarantees about the order of line-strings in the returned
  `coordinates`.

  ## Examples

  ```elixir
  [
    [{-1, 1}, {2, 2}, {-3, 3}],
    [{-10, 10}, {-20, 20}]
  ]
  |> MultiLineString.from_coordinates()
  |> MultiLineString.to_geo_json()
  # =>
  # %{
  #   "type" => "MultiLineString",
  #   "coordinates" => [
  #     [[-1, 1], [2, 2], [-3, 3]],
  #     [[-10, 10], [-20, 20]]
  #   ]
  # }
  ```
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%MultiLineString{line_strings: line_strings}) do
    %{
      "type" => "MultiLineString",
      "coordinates" =>
        Enum.map(line_strings, fn line_string ->
          Enum.map(line_string.points, &Point.to_list/1)
        end)
    }
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineString` from the given WKT string.
  Otherwise returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> MultiLineString.from_wkt("
      ...>   SRID=1234;MultiLineString (
      ...>     (10 20, 20 10, 20 40),
      ...>     (40 30, 30 30)
      ...>   )
      ...> ")
      {
        :ok,
        %MultiLineString{
          line_strings:
            MapSet.new([
              %LineString{
                points: [
                  %Point{x: 40, y: 30},
                  %Point{x: 30, y: 30}
                ]
              },
              %LineString{
                points: [
                  %Point{x: 10, y: 20},
                  %Point{x: 20, y: 10},
                  %Point{x: 20, y: 40}
                ]
              }
            ])
        },
        1234
      }

      iex> MultiLineString.from_wkt("MultiLineString EMPTY")
      ...> {:ok, %MultiLineString{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, MultiLineString)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, MultiLineString) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKT representation for a `MultiLineString`. With option `:srid` an
  EWKT representation with the SRID is returned.

  There are no guarantees about the order of line-strings in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiLineString.to_wkt(MultiLineString.new())
  # => "MultiLineString EMPTY"

  MultiLineString.to_wkt(
    MultiLineString.new([
      [Point.new(7.1, 8.1), Point.new(9.2, 5.2)],
      [Point.new(5.5, 9.2), Point.new(1.2, 3.2)]
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # MultiLineString (
  #   (5.5 9.2, 1.2 3.2),
  #   (7.1 8.1, 9.2 5.2)
  # )

  MultiLineString.to_wkt(
    MultiLineString.new([
      [Point.new(7.1, 8.1), Point.new(9.2, 5.2)],
      [Point.new(5.5, 9.2), Point.new(1.2, 3.2)]
    ]),
    srid: 555
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # SRID=555;MultiLineString (
  #   (5.5 9.2, 1.2 3.2),
  #   (7.1 8.1, 9.2 5.2)
  # )
  ```
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(line_strings, opts \\ [])

  def to_wkt(%MultiLineString{line_strings: line_strings}, opts) do
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
  Returns the WKB representation for a `MultiLineString`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiLineString{} = multi_line_string, opts \\ []) do
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
  Returns an `:ok` tuple with the `MultiLineString` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.Point.from_wkb/1` function.
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, MultiLineString)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, MultiLineString) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiLineString`.

  ## Examples

      iex> MultiLineString.size(
      ...>   MultiLineString.new([
      ...>     LineString.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(21, 22)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(31, 32),
      ...>       Point.new(41, 42)
      ...>     ])
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiLineString{line_strings: line_strings}), do: MapSet.size(line_strings)

  @doc """
  Checks if `MultiLineString` contains `line_string`.

  ## Examples

      iex> MultiLineString.member?(
      ...>   MultiLineString.new([
      ...>     LineString.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(21, 22)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(31, 32),
      ...>       Point.new(41, 42)
      ...>     ])
      ...>   ]),
      ...>   LineString.new([
      ...>     Point.new(31, 32),
      ...>     Point.new(41, 42)
      ...>   ])
      ...> )
      true

      iex> MultiLineString.member?(
      ...>   MultiLineString.new([
      ...>     LineString.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(21, 22)
      ...>     ]),
      ...>     LineString.new([
      ...>       Point.new(31, 32),
      ...>       Point.new(41, 42)
      ...>     ])
      ...>   ]),
      ...>   LineString.new([
      ...>     Point.new(11, 12),
      ...>     Point.new(41, 42)
      ...>   ])
      ...> )
      false
  """
  @spec member?(t(), LineString.t()) :: boolean()
  def member?(%MultiLineString{line_strings: line_strings}, %LineString{} = line_string),
    do: MapSet.member?(line_strings, line_string)

  @doc """
  Converts `MultiLineString` to a list.

  ## Examples

      iex> MultiLineString.to_list(
      ...>   MultiLineString.new([
      ...>     LineString.new([
      ...>       Point.new(11, 12),
      ...>       Point.new(41, 42)
      ...>     ])
      ...>   ])
      ...> )
      [%LineString{points: [
        %Point{x: 11, y: 12},
        %Point{x: 41, y: 42}
      ]}]
  """
  @spec to_list(t()) :: [Point.t()]
  def to_list(%MultiLineString{line_strings: line_strings}), do: MapSet.to_list(line_strings)

  @compile {:inline, to_wkt_line_strings: 1}
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
      |> Enum.map(fn point -> Point.to_wkt_coordinate(point) end)
      |> Enum.join(", ")

    "(#{wkt})"
  end

  @compile {:inline, to_wkt_multi_line_string: 1}
  defp to_wkt_multi_line_string(wkt), do: "MultiLineString #{wkt}"

  defp to_wkb_multi_line_string(%MultiLineString{line_strings: line_strings}, endian) do
    data =
      Enum.reduce(line_strings, [], fn line_string, acc ->
        [LineString.to_wkb(line_string, endian: endian) | acc]
      end)

    <<WKB.length(line_strings, endian)::binary, IO.iodata_to_binary(data)::binary>>
  end

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "00000005"
      {:ndr, false} -> "05000000"
      {:xdr, true} -> "20000005"
      {:ndr, true} -> "05000020"
    end
  end

  defimpl Enumerable do
    def count(multi_line_string) do
      {:ok, MultiLineString.size(multi_line_string)}
    end

    def member?(multi_line_string, val) do
      {:ok, MultiLineString.member?(multi_line_string, val)}
    end

    def slice(multi_line_string) do
      size = MultiLineString.size(multi_line_string)

      {:ok, size,
       &Enumerable.List.slice(MultiLineString.to_list(multi_line_string), &1, &2, size)}
    end

    def reduce(multi_line_string, acc, fun) do
      Enumerable.List.reduce(MultiLineString.to_list(multi_line_string), acc, fun)
    end
  end

  defimpl Collectable do
    def into(%MultiLineString{line_strings: line_strings}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          %MultiLineString{
            line_strings: %{line_strings | map: Map.merge(line_strings.map, Map.new(list))}
          }

        _, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
