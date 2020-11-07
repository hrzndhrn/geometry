defmodule Geometry.MultiLineStringZ do
  @moduledoc """
  A set of line-strings from type `Geometry.LineStringZ`

  `MultiLineStringMZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiLineStringZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(1, 2, 3),
      ...>       PointZ.new(3, 4, 5)
      ...>     ]),
      ...>     LineStringZ.new([
      ...>       PointZ.new(1, 2, 3),
      ...>       PointZ.new(11, 12, 13),
      ...>       PointZ.new(13, 14, 15)
      ...>     ])
      ...>   ]),
      ...>   fn line_string -> length line_string end
      ...> )
      [2, 3]

      iex> Enum.into(
      ...>   [LineStringZ.new([PointZ.new(1, 2, 3), PointZ.new(5, 6, 7)])],
      ...>   MultiLineStringZ.new())
      %MultiLineStringZ{
        line_strings:
        MapSet.new([
          [[1, 2, 3], [5, 6, 7]]
        ])
      }
  """

  alias Geometry.{GeoJson, LineStringZ, MultiLineStringZ, PointZ, WKB, WKT}

  defstruct line_strings: MapSet.new()

  @type t :: %MultiLineStringZ{line_strings: MapSet.t(Geometry.coordinates())}

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
      %Geometry.MultiLineStringZ{
        line_strings:
          MapSet.new([
            [[1, 2, 3], [2, 3, 4], [3, 4, 5]],
            [[10, 20, 30], [30, 40, 50]]
          ])
      }

      iex> MultiLineStringZ.new([])
      %MultiLineStringZ{line_strings: MapSet.new()}
  """
  @spec new([LineStringZ.t()]) :: t()
  def new([]), do: %MultiLineStringZ{}

  def new(line_strings) do
    %MultiLineStringZ{
      line_strings:
        Enum.into(line_strings, MapSet.new(), fn line_string -> line_string.points end)
    }
  end

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
      ...>   [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
      ...>   [[-10, 10, 10], [-20, 20, 20]]
      ...> ])
      %MultiLineStringZ{
        line_strings:
          MapSet.new([
            [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
            [[-10, 10, 10], [-20, 20, 20]]
          ])
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates) do
    %MultiLineStringZ{line_strings: MapSet.new(coordinates)}
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
      {:ok,
       %Geometry.MultiLineStringZ{
         line_strings:
           MapSet.new([
             [[-10, 10, 10], [-20, 20, 20]],
             [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]]
           ])
       }}
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
    [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
    [[-10, 10, 10], [-20, 20, 20]]
  ]
  |> MultiLineStringZ.from_coordinates()
  MultiLineStringZ.to_geo_json(
    MultiLineStringZ.new([
      LineStringZ.new([
        PointZ.new(-1, 1, 1),
        PointZ.new(2, 2, 2),
        PointZ.new(-3, 3, 3)
      ]),
      LineStringZ.new([
        PointZ.new(-10, 10, 10),
        PointZ.new(-20, 20, 20)
      ])
    ])
  )
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
      "coordinates" => MapSet.to_list(line_strings)
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
              [[10, 20, 10], [20, 10, 35], [20, 40, 10]],
              [[40, 30, 10], [30, 30, 25]]
            ])
        },
        1234
      }

      iex> MultiLineStringZ.from_wkt("MultiLineString Z EMPTY")
      {:ok, %MultiLineStringZ{}}
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
  Returns the WKT representation for a `MultiLineStringZ`. With option `:srid`
  an EWKT representation with the SRID is returned.

  There are no guarantees about the order of line-strings in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiLineStringZ.to_wkt(MultiLineStringZ.new())
  # => "MultiLineString Z EMPTY"

  MultiLineStringZ.to_wkt(
    MultiLineStringZ.new([
      LineStringZ(
        [PointZ.new(7.1, 8.1, 1.1), PointZ.new(9.2, 5.2, 2.2)]
      ),
      LineStringZ(
        [PointZ.new(5.5, 9.2, 3.1), PointZ.new(1.2, 3.2, 4.2)]
      )
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # MultiLineString Z (
  #   (5.5 9.2 3.1, 1.2 3.2 4.2),
  #   (7.1 8.1 1.1, 9.2 5.2 2.2)
  # )

  MultiLineStringZ.to_wkt(
    MultiLineStringZ.new([
      LineStringZ(
        [PointZ.new(7.1, 8.1, 1.1), PointZ.new(9.2, 5.2, 2.2)]
      ),
      LineStringZ(
        [PointZ.new(5.5, 9.2, 3.1), PointZ.new(1.2, 3.2, 4.2)]
      )
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
  def to_wkt(%MultiLineStringZ{line_strings: line_strings}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiLineString Z ",
        line_strings |> MapSet.to_list() |> to_wkt_line_strings()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiLineStringZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%MultiLineStringZ{} = multi_line_string, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_line_string, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringZ` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointZ.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, MultiLineStringZ)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, MultiLineStringZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiLineStringZ`.

  ## Examples

      iex> MultiLineStringZ.size(
      ...>   MultiLineStringZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(11, 12, 13),
      ...>       PointZ.new(21, 22, 23)
      ...>     ]),
      ...>     LineStringZ.new([
      ...>       PointZ.new(31, 32, 33),
      ...>       PointZ.new(41, 42, 43)
      ...>     ])
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiLineStringZ{line_strings: line_strings}), do: MapSet.size(line_strings)

  @doc """
  Checks if `MultiLineStringZ` contains `line_string`.

  ## Examples

      iex> MultiLineStringZ.member?(
      ...>   MultiLineStringZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(11, 12, 13),
      ...>       PointZ.new(21, 22, 23)
      ...>     ]),
      ...>     LineStringZ.new([
      ...>       PointZ.new(31, 32, 33),
      ...>       PointZ.new(41, 42, 43)
      ...>     ])
      ...>   ]),
      ...>   LineStringZ.new([
      ...>     PointZ.new(31, 32, 33),
      ...>     PointZ.new(41, 42, 43)
      ...>   ])
      ...> )
      true

      iex> MultiLineStringZ.member?(
      ...>   MultiLineStringZ.new([
      ...>     LineStringZ.new([
      ...>       PointZ.new(11, 12, 13),
      ...>       PointZ.new(21, 22, 23)
      ...>     ]),
      ...>     LineStringZ.new([
      ...>       PointZ.new(31, 32, 33),
      ...>       PointZ.new(41, 42, 43)
      ...>     ])
      ...>   ]),
      ...>   LineStringZ.new([
      ...>     PointZ.new(11, 12, 13),
      ...>     PointZ.new(41, 42, 43)
      ...>   ])
      ...> )
      false
  """
  @spec member?(t(), LineStringZ.t()) :: boolean()
  def member?(%MultiLineStringZ{line_strings: line_strings}, %LineStringZ{points: points}) do
    MapSet.member?(line_strings, points)
  end

  @doc """
  Converts `MultiLineStringZ` to a list.
  """
  @spec to_list(t()) :: [PointZ.t()]
  def to_list(%MultiLineStringZ{line_strings: line_strings}), do: MapSet.to_list(line_strings)

  @compile {:inline, to_wkt_line_strings: 1}
  defp to_wkt_line_strings([]), do: "EMPTY"

  defp to_wkt_line_strings([line_string | line_strings]) do
    <<"(",
      Enum.reduce(line_strings, LineStringZ.to_wkt_points(line_string), fn line_string, acc ->
        <<acc::binary(), ", ", LineStringZ.to_wkt_points(line_string)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(t(), srid, endian, mode) :: wkb
        when srid: Geometry.srid() | nil,
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb(%MultiLineStringZ{line_strings: line_strings}, srid, endian, mode) do
    <<
      WKB.byte_order(endian, mode)::binary(),
      wkb_code(endian, not is_nil(srid), mode)::binary(),
      WKB.srid(srid, endian, mode)::binary(),
      to_wkb_line_strings(line_strings, endian, mode)::binary()
    >>
  end

  @compile {:inline, to_wkb_line_strings: 3}
  defp to_wkb_line_strings(line_strings, endian, mode) do
    Enum.reduce(line_strings, WKB.length(line_strings, endian, mode), fn line_string, acc ->
      <<acc::binary(), LineStringZ.to_wkb(line_string, nil, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "80000005"
      {:ndr, false} -> "05000080"
      {:xdr, true} -> "A0000005"
      {:ndr, true} -> "050000A0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x80000005::big-integer-size(32)>>
      {:ndr, false} -> <<0x80000005::little-integer-size(32)>>
      {:xdr, true} -> <<0xA0000005::big-integer-size(32)>>
      {:ndr, true} -> <<0xA0000005::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_line_string) do
      {:ok, MultiLineStringZ.size(multi_line_string)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_line_string, val) do
      {:ok, MultiLineStringZ.member?(multi_line_string, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_line_string) do
      size = MultiLineStringZ.size(multi_line_string)

      {:ok, size,
       &Enumerable.List.slice(MultiLineStringZ.to_list(multi_line_string), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_line_string, acc, fun) do
      Enumerable.List.reduce(MultiLineStringZ.to_list(multi_line_string), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiLineStringZ{line_strings: line_strings}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          map =
            Map.merge(
              line_strings.map,
              Enum.into(list, %{}, fn {line_string, []} -> {line_string.points, []} end)
            )

          %MultiLineStringZ{line_strings: %{line_strings | map: map}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
