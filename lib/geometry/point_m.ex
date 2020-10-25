defmodule Geometry.PointM do
  @moduledoc """
  A point struct, representing a 2D point with a measurement.
  """

  alias Geometry.{GeoJson, Hex, PointM, WKB, WKT}

  import Geometry.Guards

  defstruct [:coordinate]

  @blank " "

  @type t :: %PointM{coordinate: Geometry.coordinate() | nil}

  @doc """
  Creates an empty `PointM`.

  ## Examples

      iex> PointM.new()
      %PointM{coordinate: nil}
  """
  @spec new :: t()
  def new, do: %PointM{}

  @doc """
  Creates a `PointM` from the given `coordinate`.

  ## Examples

      iex> PointM.new([1.5, -2.1, 4])
      %PointM{coordinate: [1.5, -2.1, 4]}
  """
  @spec new(Geometry.coordinate()) :: t()
  def new([x, y, m] = coordinate) when is_coordinate(x, y, m) do
    %PointM{coordinate: coordinate}
  end

  @doc """
  Creates a `PointM` from the given `x`, `y`, and `m`.

  ## Examples

      iex> PointM.new(-1.1, 2.2, 4)
      %PointM{coordinate: [-1.1, 2.2, 4]}
  """
  @spec new(number(), number(), number()) :: t()
  def new(x, y, m) when is_coordinate(x, y, m) do
    %PointM{coordinate: [x, y, m]}
  end

  @doc """
  Returns `true` if the given `PointM` is empty.

  ## Examples

      iex> PointM.empty?(PointM.new())
      true

      iex> PointM.empty?(PointM.new(1, 2, 4))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PointM{coordinate: coordinate}), do: is_nil(coordinate)

  @doc """
  Creates a `PointM` from the given coordinate.

  ## Examples
      iex> PointM.from_coordinates([[-1, 1, 1]])
      %PointM{coordinate: [-1, 1, 1]}
  """
  @spec from_coordinates(Geometry.coordinate() | [nil, ...]) :: t()
  def from_coordinates([[x, y, m] = coordinate]) when is_coordinate(x, y, m) do
    %PointM{coordinate: coordinate}
  end

  def from_coordinates([x, y, m] = coordinate) when is_coordinate(x, y, m) do
    %PointM{coordinate: coordinate}
  end

  def from_coordinates([nil, nil, nil]) do
    %PointM{}
  end

  @doc """
  Returns the WKT representation for a `PointM`. With option `:srid` an EWKT
  representation with the SRID is returned.

  ## Examples

      iex> PointM.to_wkt(PointM.new())
      "Point M EMPTY"

      iex> PointM.to_wkt(PointM.new(1.1, 2.2, 4.4))
      "Point M (1.1 2.2 4.4)"

      iex> PointM.to_wkt(PointM.new(1.1, 2.2, 4.4), srid: 4711)
      "SRID=4711;Point M (1.1 2.2 4.4)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%PointM{coordinate: coordinate}, opts \\ []) do
    WKT.to_ewkt(<<"Point M ", to_wkt_point(coordinate)::binary()>>, opts)
  end

  @doc """
  Returns an `:ok` tuple with the `PointM` from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains an SRID the id is added to the tuple.

  ## Examples

      iex> PointM.from_wkt("Point M (-5.1 7.8 12)")
      {:ok, %PointM{coordinate: [-5.1, 7.8, 12]}}

      iex> PointM.from_wkt("SRID=7219;Point M (-5.1 7.8 12)")
      {:ok, %PointM{coordinate: [-5.1, 7.8, 12]}, 7219}

      iex> PointM.from_wkt("Point M EMPTY")
      {:ok, %PointM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, PointM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, PointM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `PointM`.

  ## Examples

      iex> PointM.to_geo_json(PointM.new(1, 2, 4))
      %{"type" => "Point", "coordinates" => [1, 2, 4]}
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PointM{coordinate: coordinate}) when not is_nil(coordinate) do
    %{
      "type" => "Point",
      "coordinates" => coordinate
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PointM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1.1, 2.2, 4.4]})
      iex> |> Jason.decode!()
      iex> |> PointM.from_geo_json()
      {:ok, %PointM{coordinate: [1.1, 2.2, 4.4]}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_point(json, PointM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it
  fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_point(json, PointM) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKB representation for a `PointM`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:xdr`.

  ## Examples

      iex> PointM.to_wkb(PointM.new())
      "00400000017FF80000000000007FF80000000000007FF8000000000000"

      iex> PointM.to_wkb(PointM.new(), endian: :ndr)
      "0101000040000000000000F87F000000000000F87F000000000000F87F"

      iex> PointM.to_wkb(PointM.new(1.1, 2.2, 4.4), endian: :xdr)
      "00400000013FF199999999999A400199999999999A401199999999999A"

      iex> PointM.to_wkb(PointM.new(1.1, 2.2, 4.4), endian: :ndr)
      "01010000409A9999999999F13F9A999999999901409A99999999991140"

      iex> PointM.to_wkb(PointM.new(1.1, 2.2, 4.4), srid: 4711, endian: :xdr)
      "0060000001000012673FF199999999999A400199999999999A401199999999999A"
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PointM{coordinate: coordinate}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    to_wkb(coordinate, srid, endian)
  end

  @doc """
  Returns an `:ok` tuple with the `PointM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PointM.from_wkb(
      ...>   "00400000017FF80000000000007FF80000000000007FF8000000000000"
      ...> )
      {:ok, %PointM{coordinate: nil}}

      iex> PointM.from_wkb(
      ...>   "00400000013FF199999999999A400199999999999A401199999999999A"
      ...> )
      {:ok, %PointM{coordinate: [1.1, 2.2, 4.4]}}

      iex> PointM.from_wkb(
      ...>   "01010000409A9999999999F13F9A999999999901409A99999999991140"
      ...> )
      {:ok, %PointM{coordinate: [1.1, 2.2, 4.4]}}

      iex> PointM.from_wkb(
      ...>   "0060000001000012673FF199999999999A400199999999999A401199999999999A"
      ...> )
      {:ok, %PointM{coordinate: [1.1, 2.2, 4.4]}, 4711}
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, PointM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, PointM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc false
  @compile {:inline, to_wkt_coordinate: 1}
  @spec to_wkt_coordinate(Geometry.coordinate()) :: String.t()
  def to_wkt_coordinate([x, y, m]) do
    <<
      to_wkt_number(x)::binary(),
      @blank,
      to_wkt_number(y)::binary(),
      @blank,
      to_wkt_number(m)::binary()
    >>
  end

  @compile {:inline, to_wkt_point: 1}
  defp to_wkt_point(nil), do: "EMPTY"

  defp to_wkt_point(coordinate), do: <<"(", to_wkt_coordinate(coordinate)::binary(), ")">>

  @compile {:inline, to_wkt_number: 1}
  defp to_wkt_number(num) when is_integer(num), do: Integer.to_string(num)

  defp to_wkt_number(num) when is_float(num), do: Float.to_string(num)

  @doc false
  @compile {:inline, to_wkb: 3}
  @spec to_wkb(Geometry.coordinate(), Geometry.srid() | nil, Geometry.endian()) :: binary()
  def to_wkb(coordinate, srid, endian) do
    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary,
      WKB.srid(srid, endian)::binary(),
      to_wkb_coordinate(coordinate, endian)::binary
    >>
  end

  @doc false
  @compile {:inline, to_wkb_coordinate: 2}
  @spec to_wkb_coordinate(Geometry.coordinate() | nil, Geometry.endian()) :: binary()
  def to_wkb_coordinate(nil, :ndr),
    do: "000000000000F87F000000000000F87F000000000000F87F"

  def to_wkb_coordinate(nil, :xdr),
    do: "7FF80000000000007FF80000000000007FF8000000000000"

  def to_wkb_coordinate([x, y, m], endian) do
    <<
      to_wkb_number(x, endian)::binary(),
      to_wkb_number(y, endian)::binary(),
      to_wkb_number(m, endian)::binary()
    >>
  end

  @compile {:inline, to_wkb_number: 2}
  defp to_wkb_number(num, endian), do: Hex.to_float_string(num, endian)

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "40000001"
      {:ndr, false} -> "01000040"
      {:xdr, true} -> "60000001"
      {:ndr, true} -> "01000060"
    end
  end
end
