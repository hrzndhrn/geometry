defmodule Geometry.MultiLineStringM do
  @moduledoc """
  A set of line-strings from type `Geometry.LineStringM`

  `MultiLineStringMZ` implements the protocols `Enumerable` and `Collectable`.

  ## Examples

      iex> Enum.map(
      ...>   MultiLineStringM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(1, 2, 4),
      ...>       PointM.new(3, 4, 6)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(1, 2, 4),
      ...>       PointM.new(11, 12, 14),
      ...>       PointM.new(13, 14, 16)
      ...>     ])
      ...>   ]),
      ...>   fn line_string -> length line_string end
      ...> )
      [2, 3]

      iex> Enum.into(
      ...>   [LineStringM.new([PointM.new(1, 2, 4), PointM.new(5, 6, 8)])],
      ...>   MultiLineStringM.new())
      %MultiLineStringM{
        line_strings:
        MapSet.new([
          [[1, 2, 4], [5, 6, 8]]
        ])
      }
  """

  alias Geometry.{GeoJson, LineStringM, MultiLineStringM, PointM, WKB, WKT}

  defstruct line_strings: MapSet.new()

  @type t :: %MultiLineStringM{line_strings: MapSet.t(Geometry.coordinates())}

  @doc """
  Creates an empty `MultiLineStringM`.

  ## Examples

      iex> MultiLineStringM.new()
      %MultiLineStringM{line_strings: MapSet.new()}
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
      %Geometry.MultiLineStringM{
        line_strings:
          MapSet.new([
            [[1, 2, 4], [2, 3, 5], [3, 4, 6]],
            [[10, 20, 40], [30, 40, 60]]
          ])
      }

      iex> MultiLineStringM.new([])
      %MultiLineStringM{line_strings: MapSet.new()}
  """
  @spec new([LineStringM.t()]) :: t()
  def new([]), do: %MultiLineStringM{}

  def new(line_strings) do
    %MultiLineStringM{
      line_strings:
        Enum.into(line_strings, MapSet.new(), fn line_string -> line_string.points end)
    }
  end

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
    do: Enum.empty?(multi_line_string.line_strings)

  @doc """
  Creates a `MultiLineStringM` from the given coordinates.

  ## Examples

      iex> MultiLineStringM.from_coordinates([
      ...>   [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
      ...>   [[-10, 10, 10], [-20, 20, 20]]
      ...> ])
      %MultiLineStringM{
        line_strings:
          MapSet.new([
            [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
            [[-10, 10, 10], [-20, 20, 20]]
          ])
      }
  """
  @spec from_coordinates([Geometry.coordinate()]) :: t()
  def from_coordinates(coordinates) do
    %MultiLineStringM{line_strings: MapSet.new(coordinates)}
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
      {:ok,
       %Geometry.MultiLineStringM{
         line_strings:
           MapSet.new([
             [[-10, 10, 10], [-20, 20, 20]],
             [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]]
           ])
       }}
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
    [[-1, 1, 1], [2, 2, 2], [-3, 3, 3]],
    [[-10, 10, 10], [-20, 20, 20]]
  ]
  |> MultiLineStringM.from_coordinates()
  MultiLineStringM.to_geo_json(
    MultiLineStringM.new([
      LineStringM.new([
        PointM.new(-1, 1, 1),
        PointM.new(2, 2, 2),
        PointM.new(-3, 3, 3)
      ]),
      LineStringM.new([
        PointM.new(-10, 10, 10),
        PointM.new(-20, 20, 20)
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
  def to_geo_json(%MultiLineStringM{line_strings: line_strings}) do
    %{
      "type" => "MultiLineString",
      "coordinates" => MapSet.to_list(line_strings)
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
          line_strings:
            MapSet.new([
              [[10, 20, 45], [20, 10, 15], [20, 40, 15]],
              [[40, 30, 20], [30, 30, 30]]
            ])
        },
        1234
      }

      iex> MultiLineStringM.from_wkt("MultiLineString M EMPTY")
      {:ok, %MultiLineStringM{}}
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
  Returns the WKT representation for a `MultiLineStringM`. With option `:srid`
  an EWKT representation with the SRID is returned.

  There are no guarantees about the order of line-strings in the returned
  WKT-string.

  ## Examples

  ```elixir
  MultiLineStringM.to_wkt(MultiLineStringM.new())
  # => "MultiLineString M EMPTY"

  MultiLineStringM.to_wkt(
    MultiLineStringM.new([
      LineStringM(
        [PointM.new(7.1, 8.1, 1), PointM.new(9.2, 5.2, 2)]
      ),
      LineStringM(
        [PointM.new(5.5, 9.2, 1), PointM.new(1.2, 3.2, 2)]
      )
    ])
  )
  # Returns a string without any \\n or extra spaces (formatted just for readability):
  # MultiLineString M (
  #   (5.5 9.2 1, 1.2 3.2 2),
  #   (7.1 8.1 1, 9.2 5.2 2)
  # )

  MultiLineStringM.to_wkt(
    MultiLineStringM.new([
      LineStringM(
        [PointM.new(7.1, 8.1, 1), PointM.new(9.2, 5.2, 2)]
      ),
      LineStringM(
        [PointM.new(5.5, 9.2, 1), PointM.new(1.2, 3.2, 2)]
      )
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
  def to_wkt(%MultiLineStringM{line_strings: line_strings}, opts \\ []) do
    WKT.to_ewkt(
      <<
        "MultiLineString M ",
        line_strings |> MapSet.to_list() |> to_wkt_line_strings()::binary()
      >>,
      opts
    )
  end

  @doc """
  Returns the WKB representation for a `MultiLineStringM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.to_wkb/1` function.
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%MultiLineStringM{} = multi_line_string, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    mode = Keyword.get(opts, :mode, Geometry.default_mode())
    srid = Keyword.get(opts, :srid)

    to_wkb(multi_line_string, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `MultiLineStringM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  An example of a simpler geometry can be found in the description for the
  `Geometry.PointM.from_wkb/2` function.
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, MultiLineStringM)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, MultiLineStringM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the number of elements in `MultiLineStringM`.

  ## Examples

      iex> MultiLineStringM.size(
      ...>   MultiLineStringM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(11, 12, 14),
      ...>       PointM.new(21, 22, 24)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(31, 32, 34),
      ...>       PointM.new(41, 42, 44)
      ...>     ])
      ...>   ])
      ...> )
      2
  """
  @spec size(t()) :: non_neg_integer()
  def size(%MultiLineStringM{line_strings: line_strings}), do: MapSet.size(line_strings)

  @doc """
  Checks if `MultiLineStringM` contains `line_string`.

  ## Examples

      iex> MultiLineStringM.member?(
      ...>   MultiLineStringM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(11, 12, 14),
      ...>       PointM.new(21, 22, 24)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(31, 32, 34),
      ...>       PointM.new(41, 42, 44)
      ...>     ])
      ...>   ]),
      ...>   LineStringM.new([
      ...>     PointM.new(31, 32, 34),
      ...>     PointM.new(41, 42, 44)
      ...>   ])
      ...> )
      true

      iex> MultiLineStringM.member?(
      ...>   MultiLineStringM.new([
      ...>     LineStringM.new([
      ...>       PointM.new(11, 12, 14),
      ...>       PointM.new(21, 22, 24)
      ...>     ]),
      ...>     LineStringM.new([
      ...>       PointM.new(31, 32, 34),
      ...>       PointM.new(41, 42, 44)
      ...>     ])
      ...>   ]),
      ...>   LineStringM.new([
      ...>     PointM.new(11, 12, 14),
      ...>     PointM.new(41, 42, 44)
      ...>   ])
      ...> )
      false
  """
  @spec member?(t(), LineStringM.t()) :: boolean()
  def member?(%MultiLineStringM{line_strings: line_strings}, %LineStringM{points: points}) do
    MapSet.member?(line_strings, points)
  end

  @doc """
  Converts `MultiLineStringM` to a list.
  """
  @spec to_list(t()) :: [PointM.t()]
  def to_list(%MultiLineStringM{line_strings: line_strings}), do: MapSet.to_list(line_strings)

  @compile {:inline, to_wkt_line_strings: 1}
  defp to_wkt_line_strings([]), do: "EMPTY"

  defp to_wkt_line_strings([line_string | line_strings]) do
    <<"(",
      Enum.reduce(line_strings, LineStringM.to_wkt_points(line_string), fn line_string, acc ->
        <<acc::binary(), ", ", LineStringM.to_wkt_points(line_string)::binary()>>
      end)::binary(), ")">>
  end

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(t(), srid, endian, mode) :: wkb
        when srid: Geometry.srid() | nil,
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb(%MultiLineStringM{line_strings: line_strings}, srid, endian, mode) do
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
      <<acc::binary(), LineStringM.to_wkb(line_string, nil, endian, mode)::binary()>>
    end)
  end

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "40000005"
      {:ndr, false} -> "05000040"
      {:xdr, true} -> "60000005"
      {:ndr, true} -> "05000060"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x40000005::big-integer-size(32)>>
      {:ndr, false} -> <<0x40000005::little-integer-size(32)>>
      {:xdr, true} -> <<0x60000005::big-integer-size(32)>>
      {:ndr, true} -> <<0x60000005::little-integer-size(32)>>
    end
  end

  defimpl Enumerable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def count(multi_line_string) do
      {:ok, MultiLineStringM.size(multi_line_string)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def member?(multi_line_string, val) do
      {:ok, MultiLineStringM.member?(multi_line_string, val)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def slice(multi_line_string) do
      size = MultiLineStringM.size(multi_line_string)

      {:ok, size,
       &Enumerable.List.slice(MultiLineStringM.to_list(multi_line_string), &1, &2, size)}
    end

    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def reduce(multi_line_string, acc, fun) do
      Enumerable.List.reduce(MultiLineStringM.to_list(multi_line_string), acc, fun)
    end
  end

  defimpl Collectable do
    # credo:disable-for-next-line Credo.Check.Readability.Specs
    def into(%MultiLineStringM{line_strings: line_strings}) do
      fun = fn
        list, {:cont, x} ->
          [{x, []} | list]

        list, :done ->
          map =
            Map.merge(
              line_strings.map,
              Enum.into(list, %{}, fn {line_string, []} -> {line_string.points, []} end)
            )

          %MultiLineStringM{line_strings: %{line_strings | map: map}}

        _list, :halt ->
          :ok
      end

      {[], fun}
    end
  end
end
