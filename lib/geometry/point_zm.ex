defmodule Geometry.PointZM do
  @moduledoc """
  A point struct, representing a 3D point with a measurement.
  """

  alias Geometry.{GeoJson, Hex, PointZM, WKB, WKT}

  import Geometry.Guards

  defstruct [:x, :y, :z, :m]

  @blank " "

  @type t ::
          %PointZM{x: Geometry.x(), y: Geometry.y(), z: Geometry.y(), z: Geometry.m()}
          | %PointZM{x: nil, y: nil, z: nil, m: nil}

  @doc """
  Creates an empty `PointZM`.

  ## Examples

      iex> PointZM.new()
      %PointZM{x: nil, y: nil, z: nil, m: nil}
  """
  @spec new :: t()
  def new, do: %PointZM{}

  @doc """
  Creates a `PointZM` from the given `coordinate`.

  ## Examples

      iex> PointZM.new([1.5, -2.1, 3, 4])
      %PointZM{x: 1.5, y: -2.1, z: 3, m: 4}

      iex> PointZM.new({4, 5, 6, 7})
      %PointZM{x: 4, y: 5, z: 6, m: 7}
  """
  @spec new(Geometry.coordinate_zm()) :: t()
  def new([x, y, z, m] = _coordinate), do: new(x, y, z, m)
  def new({x, y, z, m} = _coordinate), do: new(x, y, z, m)

  @doc """
  Creates a `PointZM` from the given `x`, `y`, `z`, and `m`.

  ## Examples

      iex> PointZM.new(-1.1, 2.2, 3, 4)
      %PointZM{x: -1.1, y: 2.2, z: 3, m: 4}
  """
  @spec new(Geometry.x(), Geometry.y(), Geometry.z(), Geometry.m()) :: t()
  def new(x, y, z, m) when is_coordinate(x, y, z, m), do: %PointZM{x: x, y: y, z: z, m: m}

  @doc """
  Returns `true` if the given `PointZM` is empty.

  ## Examples

      iex> PointZM.empty?(PointZM.new())
      true

      iex> PointZM.empty?(PointZM.new(1, 2, 3, 4))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PointZM{x: nil, y: nil, z: nil, m: nil} = _point), do: true
  def empty?(%PointZM{x: x, y: y, z: z, m: m} = _point) when is_coordinate(x, y, z, m), do: false

  @doc """
  Creates a `PointZM` from the given coordinate.

  ## Examples

      iex> PointZM.from_coordinates([{-1, 1, 1, 1}])
      %PointZM{x: -1, y: 1, z: 1, m: 1}
  """
  @spec from_coordinates([Geometry.coordinate_zm() | {nil, nil, nil, nil}]) :: t()
  def from_coordinates([{nil, nil, nil, nil}] = _coordinates) do
    %PointZM{}
  end

  def from_coordinates([{x, y, z, m}] = _coordinates) when is_coordinate(x, y, z, m) do
    %PointZM{x: x, y: y, z: z, m: m}
  end

  def from_coordinates([x, y, z, m] = _coordinates) when is_coordinate(x, y, z, m) do
    %PointZM{x: x, y: y, z: z, m: m}
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
  def to_wkt(%PointZM{} = point, opts \\ []) do
    point
    |> PointZM.empty?()
    |> case do
      true -> "EMPTY"
      false -> <<"(", to_wkt_coordinate(point)::binary(), ")">>
    end
    |> to_wkt_point()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns an `:ok` tuple with the `PointZM` from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PointZM.from_wkt("Point ZM (-5.1 7.8 9.9 12)")
      {:ok, %PointZM{x: -5.1, y: 7.8, z: 9.9, m: 12}}

      iex> PointZM.from_wkt("SRID=7219;Point ZM (-5.1 7.8 9.9 12)")
      {:ok, %PointZM{x: -5.1, y: 7.8, z: 9.9, m: 12}, 7219}

      iex> PointZM.from_wkt("Point ZM EMPTY")
      {:ok, %PointZM{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, PointZM)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, PointZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
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
  def to_geo_json(%PointZM{x: x, y: y, z: z, m: m}) when is_coordinate(x, y, z, m) do
    %{
      "type" => "Point",
      "coordinates" => [x, y, z, m]
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PointZM` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1.1, 2.2, 3.3, 4.4]})
      iex> |> Jason.decode!()
      iex> |> PointZM.from_geo_json()
      {:ok, %PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_point(json, PointZM)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
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

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  ## Examples

      iex> PointZM.to_wkb(PointZM.new(), endian: :xdr)
      "00C00000017FF80000000000007FF80000000000007FF80000000000007FF8000000000000"

      iex> PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), endian: :xdr)
      "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"

      iex> PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4))
      "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"

      iex> PointZM.to_wkb(PointZM.new(1.1, 2.2, 3.3, 4.4), srid: 4711, endian: :xdr)
      "00E0000001000012673FF199999999999A400199999999999A400A666666666666401199999999999A"
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PointZM{} = point, opts \\ []) do
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
  Returns an `:ok` tuple with the `PointZM` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PointZM.from_wkb(
      ...>   "00C00000017FF80000000000007FF80000000000007FF80000000000007FF8000000000000"
      ...> )
      {:ok, %PointZM{x: nil, y: nil, z: nil, m: nil}}

      iex> PointZM.from_wkb(
      ...>   "00C00000013FF199999999999A400199999999999A400A666666666666401199999999999A"
      ...> )
      {:ok, %PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}}

      iex> PointZM.from_wkb(
      ...>   "01010000C09A9999999999F13F9A999999999901406666666666660A409A99999999991140"
      ...> )
      {:ok, %PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}}

      iex> PointZM.from_wkb(
      ...>   "00E0000001000012673FF199999999999A400199999999999A400A666666666666401199999999999A"
      ...> )
      {:ok, %PointZM{x: 1.1, y: 2.2, z: 3.3, m: 4.4}, 4711}
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, PointZM)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, PointZM) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc false
  @spec to_list(t()) :: list()
  def to_list(%PointZM{x: x, y: y, z: z, m: m}) when is_coordinate(x, y, z, m), do: [x, y, z, m]

  @doc false
  @spec to_wkt_coordinate(t()) :: String.t()
  def to_wkt_coordinate(%PointZM{x: x, y: y, z: z, m: m}) when is_coordinate(x, y, z, m) do
    <<
      to_string(x)::binary(),
      @blank,
      to_string(y)::binary(),
      @blank,
      to_string(z)::binary(),
      @blank,
      to_string(m)::binary()
    >>
  end

  @doc false
  @spec to_wkb_coordinate(t(), Geometry.endian()) :: binary()
  def to_wkb_coordinate(%PointZM{x: x, y: y, z: z, m: m}, endian)
      when is_coordinate(x, y, z, m) do
    <<
      to_wkb_number(x, endian)::binary(),
      to_wkb_number(y, endian)::binary(),
      to_wkb_number(z, endian)::binary(),
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

  defp to_wkb_empty(:xdr), do: "7FF80000000000007FF80000000000007FF80000000000007FF8000000000000"

  defp to_wkb_empty(:ndr), do: "000000000000F87F000000000000F87F000000000000F87F000000000000F87F"

  defp to_wkt_point(wkt), do: <<"Point ZM ", wkt::binary()>>

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "C0000001"
      {:ndr, false} -> "010000C0"
      {:xdr, true} -> "E0000001"
      {:ndr, true} -> "010000E0"
    end
  end
end
