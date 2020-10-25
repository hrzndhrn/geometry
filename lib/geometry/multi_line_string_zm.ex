defmodule Geometry.MultiLineStringZM do
  @moduledoc """
  A set of line-strings from type `Geometry.LineStringZM`

  `MultiLineStringMZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiLineStringZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(1, 2, 3, 4),
      ...>       PointZM.new(3, 4, 5, 6)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(1, 2, 3, 4),
      ...>       PointZM.new(11, 12, 13, 14),
      ...>       PointZM.new(13, 14, 15, 16)
      ...>     ])
      ...>   ]),
      ...>   fn line_string -> length line_string end
      ...> )
      [2, 3]

      iex> Enum.into(
      ...>   [LineStringZM.new([PointZM.new(1, 2, 3, 4), PointZM.new(5, 6, 7, 8)])],
      ...>   MultiLineStringZM.new())
      %MultiLineStringZM{
        line_strings:
        MapSet.new([
          [[1, 2, 3, 4], [5, 6, 7, 8]]
        ])
      }
  """

  alias Geometry.{GeoJson, LineStringZM, MultiLineStringZM, PointZM, WKB, WKT}

  defstruct line_strings: MapSet.new()

  @type t :: %MultiLineStringZM{line_strings: MapSet.t(Geometry.coordinates())}

  @doc """
  Creates an empty `MultiLineStringZM`.

  ## Examples

      iex> MultiLineStringZM.new()
      %MultiLineStringZM{line_strings: MapSet.new()}
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
      %Geometry.MultiLineStringZM{
        line_strings:
          MapSet.new([
            [[1, 2, 3, 4], [2, 3, 4, 5], [3, 4, 5, 6]],
            [[10, 20, 30, 40], [30, 40, 50, 60]]
          ])
      }

      iex> MultiLineStringZM.new([])
      %MultiLineStringZM{line_strings: MapSet.new()}
  """
  @spec new([LineStringZM.t()]) :: t()
  def new([]), do: %MultiLineStringZM{}

  def new(line_strings) do
    %MultiLineStringZM{
      line_strings:
        Enum.into(line_strings, MapSet.new(), fn line_string -> line_string.points end)
    }
  end

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
    do: Enum.empty?(multi_line_string.line_strings)

  @doc """
  Creates a `MultiLineStringZM` from the given coordinates.

  ## Examples

      iex> MultiLineStringZM.from_coordinates([
      ...>   [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
      ...>   [[-10, 10, 10, 10], [-20, 20, 20, 20]]
      ...> ])
      %MultiLineStringZM{
        line_strings:
          MapSet.new([
            [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
            [[-10, 10, 10, 10], [-20, 20, 20, 20]]
          ])
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates) do
    %MultiLineStringZM{line_strings: MapSet.new(coordinates)}
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
      {:ok,
       %Geometry.MultiLineStringZM{
         line_strings:
           MapSet.new([
             [[-10, 10, 10, 10], [-20, 20, 20, 20]],
             [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]]
           ])
       }}
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
    [[-1, 1, 1, 1], [2, 2, 2, 2], [-3, 3, 3, 3]],
    [[-10, 10, 10, 10], [-20, 20, 20, 20]]
  ]
  |> MultiLineStringZM.from_coordinates()
  MultiLineStringZM.to_geo_json(
    MultiLineStringZM.new([
      LineStringZM.new([
        PointZM.new(-1, 1, 1, 1),
        PointZM.new(2, 2, 2, 2),
        PointZM.new(-3, 3, 3, 3)
      ]),
      LineStringZM.new([
        PointZM.new(-10, 10, 10, 10),
        PointZM.new(-20, 20, 20, 20)
      ])
    ])
  )
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
  def to_geo_json(%MultiLineStringZM{line_strings: line_strings}) do
    %{
      "type" => "MultiLineString",
      "coordinates" => MapSet.to_list(line_strings)
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
          line_strings:
            MapSet.new([
              [[10, 20, 10, 45], [20, 10, 35, 15], [20, 40, 10, 15]],
              [[40, 30, 10, 20], [30, 30, 25, 30]]
            ])
        },
        1234
      }

      iex> MultiLineStringZM.from_wkt("MultiLineString ZM EMPTY")
      {:ok, %MultiLineStringZM{}}
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
  Returns the WKT representation for a `MultiLineStringZM`. With option `:srid`
  an EWKT representation with the SRID is returned.

  There are no guarantees about the order of line-strings in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiLineStringZM.to_wkt(MultiLineStringZM.new())
  # => "MultiLineString ZM EMPTY"

  MultiLineStringZM.to_wkt(
    MultiLineStringZM.new([
      LineStringZM(
        [PointZM.new(7.1, 8.1, 1.1, 1), PointZM.new(9.2, 5.2, 2.2, 2)]
      ),
      LineStringZM(
        [PointZM.new(5.5, 9.2, 3.1, 1), PointZM.new(1.2, 3.2, 4.2, 2)]
      )
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # MultiLineString ZM (
  #   (5.5 9.2 3.1 1, 1.2 3.2 4.2 2),
  #   (7.1 8.1 1.1 1, 9.2 5.2 2.2 2)
  # )

  MultiLineStringZM.to_wkt(
    MultiLineStringZM.new([
      LineStringZM(
        [PointZM.new(7.1, 8.1, 1.1, 1), PointZM.new(9.2, 5.2, 2.2, 2)]
      ),
      LineStringZM(
        [PointZM.new(5.5, 9.2, 3.1, 1), PointZM.new(1.2, 3.2, 4.2, 2)]
      )
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
  def to_wkt(%MultiLineStringZM{line_strings: line_strings}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiLineString ZM ",
        line_strings |> MapSet.to_list() |> to_wkt_line_strings()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiLineStringZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%MultiLineStringZM{} = multi_line_string, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_line_string, srid, endian)
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

  @doc """
  Returns the number of elements in `MultiLineStringZM`.

  ## Examples

      iex> MultiLineStringZM.size(
      ...>   MultiLineStringZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(11, 12, 13, 14),
      ...>       PointZM.new(21, 22, 23, 24)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(31, 32, 33, 34),
      ...>       PointZM.new(41, 42, 43, 44)
      ...>     ])
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiLineStringZM{line_strings: line_strings}), do: MapSet.size(line_strings)

  @doc """
  Checks if `MultiLineStringZM` contains `line_string`.

  ## Examples

      iex> MultiLineStringZM.member?(
      ...>   MultiLineStringZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(11, 12, 13, 14),
      ...>       PointZM.new(21, 22, 23, 24)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(31, 32, 33, 34),
      ...>       PointZM.new(41, 42, 43, 44)
      ...>     ])
      ...>   ]),
      ...>   LineStringZM.new([
      ...>     PointZM.new(31, 32, 33, 34),
      ...>     PointZM.new(41, 42, 43, 44)
      ...>   ])
      ...> )
      true

      iex> MultiLineStringZM.member?(
      ...>   MultiLineStringZM.new([
      ...>     LineStringZM.new([
      ...>       PointZM.new(11, 12, 13, 14),
      ...>       PointZM.new(21, 22, 23, 24)
      ...>     ]),
      ...>     LineStringZM.new([
      ...>       PointZM.new(31, 32, 33, 34),
      ...>       PointZM.new(41, 42, 43, 44)
      ...>     ])
      ...>   ]),
      ...>   LineStringZM.new([
      ...>     PointZM.new(11, 12, 13, 14),
      ...>     PointZM.new(41, 42, 43, 44)
      ...>   ])
      ...> )
      false
  """
  @spec member?(t(), LineStringZM.t()) :: boolean()
  def member?(%MultiLineStringZM{line_strings: line_strings}, %LineStringZM{points: points}) do
    MapSet.member?(line_strings, points)
  end

  @doc """
  Converts `MultiLineStringZM` to a list.
  """
  @spec to_list(t()) :: [PointZM.t()]
  def to_list(%MultiLineStringZM{line_strings: line_strings}), do: MapSet.to_list(line_strings)

  @compile {:inline, to_wkt_line_strings: 1}
  defp to_wkt_line_strings([]), do: "EMPTY"

  defp to_wkt_line_strings([line_string | line_strings]) do
    <<"(",
      Enum.reduce(line_strings, LineStringZM.to_wkt_points(line_string), fn line_string, acc ->
        <<acc::binary(), ", ", LineStringZM.to_wkt_points(line_string)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 3}
  @spec to_wkb(t(), Geometry.srid() | nil, Geometry.endian()) :: binary()
  def to_wkb(%MultiLineStringZM{line_strings: line_strings}, srid, endian) do
    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_line_strings(line_strings, endian)::binary()
    >>
  end

  @compile {:inline, to_wkb_line_strings: 2}
  defp to_wkb_line_strings(line_strings, endian) do
    Enum.reduce(line_strings, WKB.length(line_strings, endian), fn line_string, acc ->
      <<acc::binary(), LineStringZM.to_wkb(line_string, nil, endian)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000005"
      {:ndr, false} -> "050000C0"
      {:xdr, true} -> "E0000005"
      {:ndr, true} -> "050000E0"
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_line_string) do
      {:ok, MultiLineStringZM.size(multi_line_string)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_line_string, val) do
      {:ok, MultiLineStringZM.member?(multi_line_string, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_line_string) do
      size = MultiLineStringZM.size(multi_line_string)

      {:ok, size,
       &Enumerable.List.slice(MultiLineStringZM.to_list(multi_line_string), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_line_string, acc, fun) do
      Enumerable.List.reduce(MultiLineStringZM.to_list(multi_line_string), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiLineStringZM{line_strings: line_strings}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          map =
            Map.merge(
              line_strings.map,
              Enum.into(list, %{}, fn {line_string, []} -> {line_string.points, []} end)
            )

          %MultiLineStringZM{line_strings: %{line_strings | map: map}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
