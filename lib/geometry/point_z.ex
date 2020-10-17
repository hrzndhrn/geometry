defmodule Geometry.PointZ do
  @moduledoc """
  A point struct, representing a 3D point.
  """

  alias Geometry.{GeoJson, Hex, PointZ, WKB, WKT}

  import Geometry.Guards

  defstruct [:x, :y, :z]

  @blank " "

  @type t ::
          %PointZ{x: Geometry.x(), y: Geometry.y(), z: Geometry.z()}
          | %PointZ{x: nil, y: nil, z: nil}

  @doc """
  Creates an empty `PointZ`.

  ## Examples

      iex> PointZ.new()
      %PointZ{x: nil, y: nil, z: nil}
  """
  @spec new :: t()
  def new, do: %PointZ{}

  @doc """
  Creates a `PointZ` from the given `coordinate`.

  ## Examples

      iex> PointZ.new([1.5, -2.1, 3])
      %PointZ{x: 1.5, y: -2.1, z: 3}

      iex> PointZ.new({4, 5, 6})
      %PointZ{x: 4, y: 5, z: 6}
  """
  @spec new(Geometry.coordinate_z()) :: t()
  def new([x, y, z] = _coordinate), do: new(x, y, z)
  def new({x, y, z} = _coordinate), do: new(x, y, z)

  @doc """
  Creates a `PointZ` from the given `x`, `y`, and `z`.

  ## Examples

      iex> PointZ.new(-1.1, 2.2, 3)
      %PointZ{x: -1.1, y: 2.2, z: 3}
  """
  @spec new(Geometry.x(), Geometry.y(), Geometry.z()) :: t()
  def new(x, y, z) when is_coordinate(x, y, z), do: %PointZ{x: x, y: y, z: z}

  @doc """
  Returns `true` if the given `PointZ` is empty.

  ## Examples

      iex> PointZ.empty?(PointZ.new())
      true

      iex> PointZ.empty?(PointZ.new(1, 2, 3))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PointZ{x: nil, y: nil, z: nil} = _point), do: true
  def empty?(%PointZ{x: x, y: y, z: z} = _point) when is_coordinate(x, y, z), do: false

  @doc """
  Creates a `PointZ` from the given coordinate.

  ## Examples

      iex> PointZ.from_coordinates([{-1, 1, 1}])
      %PointZ{x: -1, y: 1, z: 1}
  """
  @spec from_coordinates([Geometry.coordinate_z() | {nil, nil, nil}]) :: t()
  def from_coordinates([{nil, nil, nil}] = _coordinates) do
    %PointZ{}
  end

  def from_coordinates([{x, y, z}] = _coordinates) when is_coordinate(x, y, z) do
    %PointZ{x: x, y: y, z: z}
  end

  def from_coordinates([x, y, z] = _coordinates) when is_coordinate(x, y, z) do
    %PointZ{x: x, y: y, z: z}
  end

  @doc """
  Returns the WKT representation for a `PointZ`. With option `:srid` an EWKT
  representation with the SRID is returned.

  ## Examples

      iex> PointZ.to_wkt(PointZ.new())
      "Point Z EMPTY"

      iex> PointZ.to_wkt(PointZ.new(1.1, 2.2, 3.3))
      "Point Z (1.1 2.2 3.3)"

      iex> PointZ.to_wkt(PointZ.new(1.1, 2.2, 3.3), srid: 4711)
      "SRID=4711;Point Z (1.1 2.2 3.3)"
  """
  @spec to_wkt(t(), opts) :: Geometry.wkt()
        when opts: [srid: Geometry.srid()]
  def to_wkt(%PointZ{} = point, opts \\ []) do
    point
    |> PointZ.empty?()
    |> case do
      true -> "EMPTY"
      false -> <<"(", to_wkt_coordinate(point)::binary(), ")">>
    end
    |> to_wkt_point()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns an `:ok` tuple with the `PointZ` from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PointZ.from_wkt("Point Z (-5.1 7.8 9.9)")
      {:ok, %PointZ{x: -5.1, y: 7.8, z: 9.9}}

      iex> PointZ.from_wkt("SRID=7219;Point Z (-5.1 7.8 9.9)")
      {:ok, %PointZ{x: -5.1, y: 7.8, z: 9.9}, 7219}

      iex> PointZ.from_wkt("Point Z EMPTY")
      {:ok, %PointZ{}}
  """
  @spec from_wkt(Geometry.wkt()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkt_error()
  def from_wkt(wkt), do: WKT.to_geometry(wkt, PointZ)

  @doc """
  The same as `from_wkt/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkt!(Geometry.wkt()) :: t() | {t(), Geometry.srid()}
  def from_wkt!(wkt) do
    case WKT.to_geometry(wkt, PointZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the GeoJSON term of a `PointZ`.

  ## Examples

      iex> PointZ.to_geo_json(PointZ.new(1, 2, 3))
      %{"type" => "Point", "coordinates" => [1, 2, 3]}
  """
  @spec to_geo_json(t()) :: Geometry.geo_json_term()
  def to_geo_json(%PointZ{x: x, y: y, z: z}) when is_coordinate(x, y, z) do
    %{
      "type" => "Point",
      "coordinates" => [x, y, z]
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PointZ` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1.1, 2.2, 3.3]})
      iex> |> Jason.decode!()
      iex> |> PointZ.from_geo_json()
      {:ok, %PointZ{x: 1.1, y: 2.2, z: 3.3}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_point(json, PointZ)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_geo_json!(Geometry.geo_json_term()) :: t()
  def from_geo_json!(json) do
    case GeoJson.to_point(json, PointZ) do
      {:ok, geometry} -> geometry
      error -> raise Geometry.Error, error
    end
  end

  @doc """
  Returns the WKB representation for a `PointZ`.

  With option `:srid` an EWKB representation with the SRID is returned.

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  ## Examples

      iex> PointZ.to_wkb(PointZ.new(), endian: :xdr)
      "00800000017FF80000000000007FF80000000000007FF8000000000000"

      iex> PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), endian: :xdr)
      "00800000013FF199999999999A400199999999999A400A666666666666"

      iex> PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3))
      "01010000809A9999999999F13F9A999999999901406666666666660A40"

      iex> PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), srid: 4711, endian: :xdr)
      "00A0000001000012673FF199999999999A400199999999999A400A666666666666"
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PointZ{} = point, opts \\ []) do
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
  Returns an `:ok` tuple with the `PointZ` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PointZ.from_wkb(
      ...>   "00800000017FF80000000000007FF80000000000007FF8000000000000"
      ...> )
      {:ok, %PointZ{x: nil, y: nil, z: nil}}

      iex> PointZ.from_wkb(
      ...>   "00800000013FF199999999999A400199999999999A400A666666666666"
      ...> )
      {:ok, %PointZ{x: 1.1, y: 2.2, z: 3.3}}

      iex> PointZ.from_wkb(
      ...>   "01010000809A9999999999F13F9A999999999901406666666666660A40"
      ...> )
      {:ok, %PointZ{x: 1.1, y: 2.2, z: 3.3}}

      iex> PointZ.from_wkb(
      ...>   "00A0000001000012673FF199999999999A400199999999999A400A666666666666"
      ...> )
      {:ok, %PointZ{x: 1.1, y: 2.2, z: 3.3}, 4711}
  """
  @spec from_wkb(Geometry.wkb()) ::
          {:ok, t()} | {:ok, t(), Geometry.srid()} | Geometry.wkb_error()
  def from_wkb(wkb), do: WKB.to_geometry(wkb, PointZ)

  @doc """
  The same as `from_wkb/1`, but raises a `Geometry.Error` exception if it fails.
  """
  @spec from_wkb!(Geometry.wkb()) :: t() | {t(), Geometry.srid()}
  def from_wkb!(wkb) do
    case WKB.to_geometry(wkb, PointZ) do
      {:ok, geometry} -> geometry
      {:ok, geometry, srid} -> {geometry, srid}
      error -> raise Geometry.Error, error
    end
  end

  @doc false
  @spec to_list(t()) :: list()
  def to_list(%PointZ{x: x, y: y, z: z}) when is_coordinate(x, y, z), do: [x, y, z]

  @doc false
  @spec to_wkt_coordinate(t()) :: String.t()
  def to_wkt_coordinate(%PointZ{x: x, y: y, z: z}) when is_coordinate(x, y, z) do
    <<
      to_string(x)::binary(),
      @blank,
      to_string(y)::binary(),
      @blank,
      to_string(z)::binary(),
    >>
  end

  @doc false
  @spec to_wkb_coordinate(t(), Geometry.endian()) :: binary()
  def to_wkb_coordinate(%PointZ{x: x, y: y, z: z}, endian)
      when is_coordinate(x, y, z) do
    <<
      to_wkb_number(x, endian)::binary(),
      to_wkb_number(y, endian)::binary(),
      to_wkb_number(z, endian)::binary(),
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

  defp to_wkt_point(wkt), do: <<"Point Z ", wkt::binary()>>

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "80000001"
      {:ndr, false} -> "01000080"
      {:xdr, true} -> "A0000001"
      {:ndr, true} -> "010000A0"
    end
  end
end
