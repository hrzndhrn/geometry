defmodule Geometry.PointZM do
  @moduledoc """
  A point struct, representing a 3D point with a measurement.
  """

  import Geometry.Guards

  alias Geometry.GeoJson
  alias Geometry.Hex
  alias Geometry.PointZM
  alias Geometry.WKB
  alias Geometry.WKT

  defstruct [:coordinate]

  @blank " "

  @empty %{
    {:ndr, :hex} => "000000000000F87F000000000000F87F000000000000F87F000000000000F87F",
    {:xdr, :hex} => "7FF80000000000007FF80000000000007FF80000000000007FF8000000000000",
    {:ndr, :binary} =>
      Hex.to_binary("000000000000F87F000000000000F87F000000000000F87F000000000000F87F"),
    {:xdr, :binary} =>
      Hex.to_binary("7FF80000000000007FF80000000000007FF80000000000007FF8000000000000")
  }

  @type t :: %PointZM{coordinate: Geometry.coordinate() | nil}

  @doc """
  Creates an empty `PointZM`.

  ## Examples

      iex> PointZM.new()
      %PointZM{coordinate: nil}
  """
  @spec new :: t()
  def new, do: %PointZM{}

  @doc """
  Creates a `PointZM` from the given `coordinate`.

  ## Examples

      iex> PointZM.new([1.5, -2.1, 3, 4])
      %PointZM{coordinate: [1.5, -2.1, 3, 4]}
  """
  @spec new(Geometry.coordinate()) :: t()
  def new([x, y, z, m] = coordinate) when is_coordinate(x, y, z, m) do
    %PointZM{coordinate: coordinate}
  end

  @doc """
  Creates a `PointZM` from the given `x`, `y`, `z`, and `m`.

  ## Examples

      iex> PointZM.new(-1.1, 2.2, 3, 4)
      %PointZM{coordinate: [-1.1, 2.2, 3, 4]}
  """
  @spec new(number(), number(), number(), number()) :: t()
  def new(x, y, z, m) when is_coordinate(x, y, z, m) do
    %PointZM{coordinate: [x, y, z, m]}
  end

  @doc """
  Returns `true` if the given `PointZM` is empty.

  ## Examples

      iex> PointZM.empty?(PointZM.new())
      true

      iex> PointZM.empty?(PointZM.new(1, 2, 3, 4))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PointZM{coordinate: coordinate}), do: is_nil(coordinate)

  @doc """
  Creates a `PointZM` from the given coordinate.

  ## Examples
      iex> PointZM.from_coordinates([[-1, 1, 1, 1]])
      %PointZM{coordinate: [-1, 1, 1, 1]}
  """
  @spec from_coordinates(Geometry.coordinate() | [nil, ...]) :: t()
  def from_coordinates([[x, y, z, m] = coordinate]) when is_coordinate(x, y, z, m) do
    %PointZM{coordinate: coordinate}
  end

  def from_coordinates([x, y, z, m] = coordinate) when is_coordinate(x, y, z, m) do
    %PointZM{coordinate: coordinate}
  end

  def from_coordinates([nil, nil, nil, nil]) do
    %PointZM{}
  end

  @doc """
  Returns the WKT representation for a `PointZM`. With option `:srid` an EWKT
  representation with the SRID is returned.

  ## Examples

      iex> PointZM.to_wkt(PointZM.new())
      "Point ZM EMPTY"

      iex> PointZM.to_wkt(PointZM.new(1.1, 2.2, 3.3, 4.4))
      "Point ZM (1.1 2.2 3.3 4.4)"

      iex> PointZM.to_wkt(PointZM.new(1.1, 2.2, 3.3, 4.4), srid: 4711)
      "SRID=4711;Point ZM (1.1 2.2 3.3 4.4)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%PointZM{coordinate: coordinate}, opts \\ []) do
    WKT.to_ewkt(<<"Point ZM ", to_wkt_point(coordinate)::binary>>, opts)
  end

  @doc """
  Returns an `:ok` tuple with the `PointZM` from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains an SRID the id is added to the tuple.

  ## Examples

      iex> PointZM.from_wkt("Point ZM (-5.1 7.8 9.9 12)")
      {:ok, %PointZM{coordinate: [-5.1, 7.8, 9.9, 12]}}

      iex> PointZM.from_wkt("SRID=7219;Point ZM (-5.1 7.8 9.9 12)")
      {:ok, {%PointZM{coordinate: [-5.1, 7.8, 9.9, 12]}, 7219}}

      iex> PointZM.from_wkt("Point ZM EMPTY")
      {:ok, %PointZM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, PointZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, PointZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `PointZM`.

  ## Examples

      iex> PointZM.to_geo_json(PointZM.new(1, 2, 3, 4))
      %{"type" => "Point", "coordinates" => [1, 2, 3, 4]}
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PointZM{coordinate: coordinate}) when not is_nil(coordinate) do
    %{
      "type" => "Point",
      "coordinates" => coordinate
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PointZM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1.1, 2.2, 3.3, 4.4]})
      iex> |> Jason.decode!()
      iex> |> PointZM.from_geo_json()
      {:ok, %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_point(json, PointZM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it
  fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_point(json, PointZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKB representation for a `PointZM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `:endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  The `:mode` determines whether a hex-string or binary is returned. The default
  is `:binary`.

  ## Examples

      iex> PointZM.to_wkb(PointZM.new(), mode: :hex)
      "00C00000017FF80000000000007FF80000000000007FF80000000000007FF8000000000000"

      iex> PointZM.to_wkb(PointZM.new(), endian: :ndr, mode: :hex)
      "01010000C0000000000000F87F000000000000F87F000000000000F87F000000000000F87F"

      iex> PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), endian: :xdr, mode: :hex)
      "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"

      iex> PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), endian: :ndr, mode: :hex)
      "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"

      iex> PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), srid: 4711, endian: :xdr, mode: :hex)
      "00E0000001000012673FF199999999999A400199999999999A400A666666666666401199999999999A"
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid(), mode: Geometry.mode()]
  def to_wkb(%PointZM{coordinate: coordinate}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)
    mode = Keyword.get(opts, :mode, Geometry.default_mode())

    to_wkb(coordinate, srid, endian, mode)
  end

  @doc """
  Returns an `:ok` tuple with the `PointZM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  The optional second argument determines if a `:hex`-string or a `:binary`
  input is expected. The default is `:binary`.

  ## Examples

      iex> PointZM.from_wkb(
      ...>   "00C00000017FF80000000000007FF80000000000007FF80000000000007FF8000000000000",
      ...>   :hex
      ...> )
      {:ok, %PointZM{coordinate: nil}}

      iex> PointZM.from_wkb(
      ...>   "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A",
      ...>   :hex
      ...> )
      {:ok, %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}}

      iex> PointZM.from_wkb(
      ...>   "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140",
      ...>   :hex
      ...> )
      {:ok, %PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}}

      iex> PointZM.from_wkb(
      ...>   "00E0000001000012673FF199999999999A400199999999999A400A666666666666401199999999999A",
      ...>   :hex
      ...> )
      {:ok, {%PointZM{coordinate: [1.1, 2.2, 3.3, 4.4]}, 4711}}
  """
  @spec from_wkb(Geometry.wkb(), Geometry.mode()) ::
          {:ok, t() | {t(), Geometry.srid()}}
          | Geometry.wkb_error()
  def from_wkb(wkb, mode \\ :binary), do: WKB.to_geometry(wkb, mode, PointZM)

  @doc """
  The same as `from_wkb/2`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb(), Geometry.mode()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb, mode \\ :binary) do
    case WKB.to_geometry(wkb, mode, PointZM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc false
  @compile {:inline, to_wkt_coordinate: 1}
  @spec to_wkt_coordinate(Geometry.coordinate()) :: String.t()
  def to_wkt_coordinate([x, y, z, m]) do
    <<
      to_wkt_number(x)::binary,
      @blank,
      to_wkt_number(y)::binary,
      @blank,
      to_wkt_number(z)::binary,
      @blank,
      to_wkt_number(m)::binary
    >>
  end

  @compile {:inline, to_wkt_point: 1}
  defp to_wkt_point(nil), do: "EMPTY"

  defp to_wkt_point(coordinate), do: <<"(", to_wkt_coordinate(coordinate)::binary, ")">>

  @compile {:inline, to_wkt_number: 1}
  defp to_wkt_number(num) when is_integer(num), do: Integer.to_string(num)

  defp to_wkt_number(num) when is_float(num), do: Float.to_string(num)

  @doc false
  @compile {:inline, to_wkb: 4}
  @spec to_wkb(
          Geometry.coordinate() | nil,
          Geometry.srid() | nil,
          Geometry.endian(),
          Geometry.mode()
        ) ::
          binary()
  def to_wkb(coordinate, srid, endian, mode) do
    <<
      WKB.byte_order(endian, mode)::binary,
      wkb_code(endian, not is_nil(srid), mode)::binary,
      WKB.srid(srid, endian, mode)::binary,
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

  def to_wkb_coordinate([x, y, z, m], endian, mode) do
    <<
      to_wkb_number(x, endian, mode)::binary,
      to_wkb_number(y, endian, mode)::binary,
      to_wkb_number(z, endian, mode)::binary,
      to_wkb_number(m, endian, mode)::binary
    >>
  end

  @compile {:inline, to_wkb_number: 3}
  defp to_wkb_number(num, endian, :hex), do: Hex.to_float_string(num, endian)
  defp to_wkb_number(num, :xdr, :binary), do: <<num::big-float-size(64)>>
  defp to_wkb_number(num, :ndr, :binary), do: <<num::little-float-size(64)>>

  @compile {:inline, wkb_code: 3}
  defp wkb_code(endian, srid?, :hex) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000001"
      {:ndr, false} -> "010000C0"
      {:xdr, true} -> "E0000001"
      {:ndr, true} -> "010000E0"
    end
  end

  defp wkb_code(endian, srid?, :binary) do
    case {endian, srid?} do
      {:xdr, false} -> <<0xC0000001::big-integer-size(32)>>
      {:ndr, false} -> <<0xC0000001::little-integer-size(32)>>
      {:xdr, true} -> <<0xE0000001::big-integer-size(32)>>
      {:ndr, true} -> <<0xE0000001::little-integer-size(32)>>
    end
  end
end
