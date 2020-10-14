defmodule Geometry.PointM do
  @moduledoc """
  A point struct, representing a 2D point with a measurement.
  """

  alias Geometry.{GeoJson, Hex, PointM, WKB, WKT}

  import Geometry.Guards

  defstruct [:x, :y, :m]

  @blank " "

  @type t ::
          %PointM{x: Geometry.x(), y: Geometry.y(), m: Geometry.m()}
          | %PointM{x: nil, y: nil, m: nil}

  @doc """
  Creates an empty `PointM`.

  ## Examples

      iex> PointM.new()
      %PointM{x: nil, y: nil, m: nil}
  """
  @spec new :: t()
  def new, do: %PointM{}

  @doc """
  Creates a `PointM` from the given `coordinate`.

  ## Examples

      iex> PointM.new([1.5, -2.1, 4])
      %PointM{x: 1.5, y: -2.1, m: 4}

      iex> PointM.new({4, 5, 7})
      %PointM{x: 4, y: 5, m: 7}
  """
  @spec new(Geometry.coordinate_m()) :: t()
  def new([x, y, m] = _coordinate), do: new(x, y, m)
  def new({x, y, m} = _coordinate), do: new(x, y, m)

  @doc """
  Creates a `PointM` from the given `x`, `y`, and `m`.

  ## Examples

      iex> PointM.new(-1.1, 2.2, 4)
      %PointM{x: -1.1, y: 2.2, m: 4}
  """
  @spec new(Geometry.x(), Geometry.y(), Geometry.m()) :: t()
  def new(x, y, m) when is_coordinate(x, y, m), do: %PointM{x: x, y: y, m: m}

  @doc """
  Returns `true` if the given `PointM` is empty.

  ## Examples

      iex> PointM.empty?(PointM.new())
      true

      iex> PointM.empty?(PointM.new(1, 2, 4))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PointM{x: nil, y: nil, m: nil} = _point), do: true
  def empty?(%PointM{x: x, y: y, m: m} = _point) when is_coordinate(x, y, m), do: false

  @doc """
  Creates a `PointM` from the given coordinate.

  ## Examples

      iex> PointM.from_coordinates([{-1, 1, 1}])
      %PointM{x: -1, y: 1, m: 1}
  """
  @spec from_coordinates([Geometry.coordinate_m() | {nil, nil, nil}]) :: t()
  def from_coordinates([{nil, nil, nil}] = _coordinates) do
    %PointM{}
  end

  def from_coordinates([{x, y, m}] = _coordinates) when is_coordinate(x, y, m) do
    %PointM{x: x, y: y, m: m}
  end

  def from_coordinates([x, y, m] = _coordinates) when is_coordinate(x, y, m) do
    %PointM{x: x, y: y, m: m}
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
  def to_wkt(%PointM{} = point, opts \\ []) do
    point
    |> PointM.empty?()
    |> case do
      true -> "EMPTY"
      false -> <<"(", to_wkt_coordinate(point)::binary(), ")">>
    end
    |> to_wkt_point()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns an `:ok` tuple with the `PointM` from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PointM.from_wkt("Point M (-5.1 7.8 12)")
      {:ok, %PointM{x: -5.1, y: 7.8, m: 12}}

      iex> PointM.from_wkt("SRID=7219;Point M (-5.1 7.8 12)")
      {:ok, %PointM{x: -5.1, y: 7.8, m: 12}, 7219}
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
  def to_geo_json(%PointM{x: x, y: y, m: m}) when is_coordinate(x, y, m) do
    %{
      "type" => "Point",
      "coordinates" => [x, y, m]
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PointM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1.1, 2.2, 4.4]})
      iex> |> Jason.decode!()
      iex> |> PointM.from_geo_json()
      {:ok, %PointM{x: 1.1, y: 2.2, m: 4.4}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_point(json, PointM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
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
  endian is returned. The default is `:ndr`.

  ## Examples

      iex> PointM.to_wkb(PointM.new(), endian: :xdr)
      "00400000017FF80000000000007FF80000000000007FF8000000000000"

      iex> PointM.to_wkb(PointM.new(1.1, 2.2, 4.4), endian: :xdr)
      "00400000013FF199999999999A400199999999999A401199999999999A"

      iex> PointM.to_wkb(PointM.new(1.1, 2.2, 4.4))
      "01010000409A9999999999F13F9A999999999901409A99999999991140"

      iex> PointM.to_wkb(PointM.new(1.1, 2.2, 4.4), srid: 4711, endian: :xdr)
      "0060000001000012673FF199999999999A400199999999999A401199999999999A"
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PointM{} = point, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    <<
      WKB.byte_order(endian)::binary(),
      wkb_code(endian, not is_nil(srid))::binary(),
      WKB.srid(srid, endian)::binary(),
      to_wkb_point(point, endian)::binary()
    >>
  end

  @doc """
  Returns an `:ok` tuple with the `PointM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PointM.from_wkb(
      ...>   "00400000017FF80000000000007FF80000000000007FF8000000000000"
      ...> )
      {:ok, %PointM{x: nil, y: nil, m: nil}}

      iex> PointM.from_wkb(
      ...>   "00400000013FF199999999999A400199999999999A401199999999999A"
      ...> )
      {:ok, %PointM{x: 1.1, y: 2.2, m: 4.4}}

      iex> PointM.from_wkb(
      ...>   "01010000409A9999999999F13F9A999999999901409A99999999991140"
      ...> )
      {:ok, %PointM{x: 1.1, y: 2.2, m: 4.4}}

      iex> PointM.from_wkb(
      ...>   "0060000001000012673FF199999999999A400199999999999A401199999999999A"
      ...> )
      {:ok, %PointM{x: 1.1, y: 2.2, m: 4.4}, 4711}
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
  @spec to_list(t()) :: list()
  def to_list(%PointM{x: x, y: y, m: m}) when is_coordinate(x, y, m), do: [x, y, m]

  @doc false
  @spec to_wkt_coordinate(t()) :: String.t()
  def to_wkt_coordinate(%PointM{x: x, y: y, m: m}) when is_coordinate(x, y, m) do
    <<
      to_string(x)::binary(),
      @blank,
      to_string(y)::binary(),
      @blank,
      to_string(m)::binary()
    >>
  end

  @doc false
  @spec to_wkb_coordinate(t(), Geometry.endian()) :: binary()
  def to_wkb_coordinate(%PointM{x: x, y: y, m: m}, endian)
      when is_coordinate(x, y, m) do
    <<
      to_wkb_number(x, endian)::binary(),
      to_wkb_number(y, endian)::binary(),
      to_wkb_number(m, endian)::binary()
    >>
  end

  defp to_wkb_point(point, endian) do
    point
    |> empty?()
    |> case do
      true -> to_wkb_empty(endian)
      false -> to_wkb_coordinate(point, endian)
    end
  end

  defp to_wkb_number(num, endian), do: Hex.to_string(num, endian, 16, :float)

  defp to_wkb_empty(:xdr), do: "7FF80000000000007FF80000000000007FF8000000000000"

  defp to_wkb_empty(:ndr), do: "000000000000F87F000000000000F87F000000000000F87F"

  defp to_wkt_point(wkt), do: <<"Point M ", wkt::binary()>>

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "40000001"
      {:ndr, false} -> "01000040"
      {:xdr, true} -> "60000001"
      {:ndr, true} -> "01000060"
    end
  end
end
