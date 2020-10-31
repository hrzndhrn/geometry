defmodule Geometry.Point do
  @moduledoc """
  A point struct, representing a 2D point.
  """

  import Geometry.Guards

  alias Geometry.{GeoJson, Hex, Point, WKB, WKT}

  defstruct [:coordinate]

  @blank " "

  @empty %{
    {:ndr, :hex} => "000000000000F87F000000000000F87F",
    {:xdr, :hex} => "7FF80000000000007FF8000000000000",
    {:ndr, :binary} => Hex.to_binary("000000000000F87F000000000000F87F"),
    {:xdr, :binary} => Hex.to_binary("7FF80000000000007FF8000000000000")
  }

  @type t :: %Point{coordinate: Geometry.coordinate() | nil}

  @doc """
  Creates an empty `Point`.

  ## Examples

      iex> Point.new()
      %Point{coordinate: nil}
  """
  @spec new :: t()
  def new, do: %Point{}

  @doc """
  Creates a `Point` from the given `coordinate`.

  ## Examples

      iex> Point.new([1.5, -2.1])
      %Point{coordinate: [1.5, -2.1]}
  """
  @spec new(Geometry.coordinate()) :: t()
  def new([x, y] = coordinate) when is_coordinate(x, y) do
    %Point{coordinate: coordinate}
  end

  @doc """
  Creates a `Point` from the given `x` and `y`.

  ## Examples

      iex> Point.new(-1.1, 2.2)
      %Point{coordinate: [-1.1, 2.2]}
  """
  @spec new(number(), number()) :: t()
  def new(x, y) when is_coordinate(x, y) do
    %Point{coordinate: [x, y]}
  end

  @doc """
  Returns `true` if the given `Point` is empty.

  ## Examples

      iex> Point.empty?(Point.new())
      true

      iex> Point.empty?(Point.new(1, 2))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%Point{coordinate: coordinate}), do: is_nil(coordinate)

  @doc """
  Creates a `Point` from the given coordinate.

  ## Examples
      iex> Point.from_coordinates([[-1, 1]])
      %Point{coordinate: [-1, 1]}
  """
  @spec from_coordinates(Geometry.coordinate() | [nil, ...]) :: t()
  def from_coordinates([[x, y] = coordinate]) when is_coordinate(x, y) do
    %Point{coordinate: coordinate}
  end

  def from_coordinates([x, y] = coordinate) when is_coordinate(x, y) do
    %Point{coordinate: coordinate}
  end

  def from_coordinates([nil, nil]) do
    %Point{}
  end

  @doc """
  Returns the WKT representation for a `Point`. With option `:srid` an EWKT
  representation with the SRID is returned.

  ## Examples

      iex> Point.to_wkt(Point.new())
      "Point EMPTY"

      iex> Point.to_wkt(Point.new(1.1, 2.2))
      "Point (1.1 2.2)"

      iex> Point.to_wkt(Point.new(1.1, 2.2), srid: 4711)
      "SRID=4711;Point (1.1 2.2)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%Point{coordinate: coordinate}, opts \\ []) do
    WKT.to_ewkt(<<"Point ", to_wkt_point(coordinate)::binary()>>, opts)
  end

  @doc """
  Returns an `:ok` tuple with the `Point` from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains an SRID the id is added to the tuple.

  ## Examples

      iex> Point.from_wkt("Point (-5.1 7.8)")
      {:ok, %Point{coordinate: [-5.1, 7.8]}}

      iex> Point.from_wkt("SRID=7219;Point (-5.1 7.8)")
      {:ok, %Point{coordinate: [-5.1, 7.8]}, 7219}

      iex> Point.from_wkt("Point EMPTY")
      {:ok, %Point{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, Point)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, Point) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `Point`.

  ## Examples

      iex> Point.to_geo_json(Point.new(1, 2))
      %{"type" => "Point", "coordinates" => [1, 2]}
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%Point{coordinate: coordinate}) when not is_nil(coordinate) do
    %{
      "type" => "Point",
      "coordinates" => coordinate
    }
  end

  @doc """
  Returns an `:ok` tuple with the `Point` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1.1, 2.2]})
      iex> |> Jason.decode!()
      iex> |> Point.from_geo_json()
      {:ok, %Point{coordinate: [1.1, 2.2]}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_point(json, Point)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it
  fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_point(json, Point) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKB representation for a `Point`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `:endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  ## Examples

      iex> Point.to_wkb(Point.new(), mode: :hex)
      "00000000017FF80000000000007FF8000000000000"

      iex> Point.to_wkb(Point.new(), endian: :ndr, mode: :hex)
      "0101000000000000000000F87F000000000000F87F"

      iex> Point.to_wkb(Point.new(1.1, 2.2), endian: :xdr, mode: :hex)
      "00000000013FF199999999999A400199999999999A"

      iex> Point.to_wkb(Point.new(1.1, 2.2), endian: :ndr, mode: :hex)
      "01010000009A9999999999F13F9A99999999990140"

      iex> Point.to_wkb(Point.new(1.1, 2.2), srid: 4711, endian: :xdr, mode: :hex)
      "0020000001000012673FF199999999999A400199999999999A"
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%Point{coordinate: coordinate}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)
    mode = Keyword.get(opts, :mode, Geometry.default_mode())

    to_wkb(coordinate, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `Point` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> Point.from_wkb(
      ...>   "00000000017FF80000000000007FF8000000000000"
      ...> )
      {:ok, %Point{coordinate: nil}}

      iex> Point.from_wkb(
      ...>   "00000000013FF199999999999A400199999999999A"
      ...> )
      {:ok, %Point{coordinate: [1.1, 2.2]}}

      iex> Point.from_wkb(
      ...>   "01010000009A9999999999F13F9A99999999990140"
      ...> )
      {:ok, %Point{coordinate: [1.1, 2.2]}}

      iex> Point.from_wkb(
      ...>   "0020000001000012673FF199999999999A400199999999999A"
      ...> )
      {:ok, %Point{coordinate: [1.1, 2.2]}, 4711}
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, Point)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, Point) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc false
  @compile {:inline, to_wkt_coordinate: 1}
  @spec to_wkt_coordinate(Geometry.coordinate()) :: String.t()
  def to_wkt_coordinate([x, y]) do
    <<
      to_wkt_number(x)::binary(),
      @blank,
      to_wkt_number(y)::binary()
    >>
  end

  @compile {:inline, to_wkt_point: 1}
  defp to_wkt_point(nil), do: "EMPTY"

  defp to_wkt_point(coordinate), do: <<"(", to_wkt_coordinate(coordinate)::binary(), ")">>

  @compile {:inline, to_wkt_number: 1}
  defp to_wkt_number(num) when is_integer(num), do: Integer.to_string(num)

  defp to_wkt_number(num) when is_float(num), do: Float.to_string(num)

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(Geometry.coordinate(), Geometry.srid() | nil, Geometry.endian(), Geometry.mode()) ::
          binary()
  def to_wkb(coordinate, srid, endian, mode) do
    <<
      WKB.byte_order(endian, mode)::binary(),
      wkb_code(endian, not is_nil(srid), mode)::binary,
      WKB.srid(srid, endian, mode)::binary(),
      to_wkb_coordinate(coordinate, endian, mode)::binary
    >>
  end

  @doc false
  @compile {:inline, to_wkb_coordinate: 3}
  @spec to_wkb_coordinate(coordinate, endian, mode) :: wkb
        when coordinate: Geometry.coordinate() | nil,
             endian: Geometry.endian(),
             mode: Geometry.mode(),
             wkb: Geometry.wkb()
  def to_wkb_coordinate(nil, endian, mode), do: Map.fetch!(@empty, {endian, mode})
  # do: "000000000000F87F000000000000F87F"

  # def to_wkb_coordinate(nil, :xdr, :hex),
  # do: "7FF80000000000007FF8000000000000"

  def to_wkb_coordinate([x, y], endian, mode) do
    <<
      to_wkb_number(x, endian, mode)::binary(),
      to_wkb_number(y, endian, mode)::binary()
    >>
  end

  @compile {:inline, to_wkb_number: 3}
  defp to_wkb_number(num, endian, :hex), do: Hex.to_float_string(num, endian)
  defp to_wkb_number(num, :xdr, :binary), do: <<num::big-float-size(64)>>
  defp to_wkb_number(num, :ndr, :binary), do: <<num::little-float-size(64)>>

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "00000001"
      {:ndr, false} -> "01000000"
      {:xdr, true} -> "20000001"
      {:ndr, true} -> "01000020"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0x00000001::big-integer-size(32)>>
      {:ndr, false} -> <<0x00000001::little-integer-size(32)>>
      {:xdr, true} -> <<0x20000001::big-integer-size(32)>>
      {:ndr, true} -> <<0x20000001::little-integer-size(32)>>
    end
  end
end
