defmodule Geometry.PointZ do
  @moduledoc """
  A point struct, representing a 3D point.
  """

  alias Geometry.{GeoJson, Hex, PointZ, WKB, WKT}

  import Geometry.Guards

  defstruct [:coordinate]

  @blank " "

  @type t :: %PointZ{coordinate: Geometry.coordinate() | nil}

  @doc """
  Creates an empty `PointZ`.

  ## Examples

      iex> PointZ.new()
      %PointZ{coordinate: nil}
  """
  @spec new :: t()
  def new, do: %PointZ{}

  @doc """
  Creates a `PointZ` from the given `coordinate`.

  ## Examples

      iex> PointZ.new([1.5, -2.1, 3])
      %PointZ{coordinate: [1.5, -2.1, 3]}
  """
  @spec new(Geometry.coordinate()) :: t()
  def new([x, y, z] = coordinate) when is_coordinate(x, y, z) do
    %PointZ{coordinate: coordinate}
  end

  @doc """
  Creates a `PointZ` from the given `x`, `y`, and `z`.

  ## Examples

      iex> PointZ.new(-1.1, 2.2, 3)
      %PointZ{coordinate: [-1.1, 2.2, 3]}
  """
  @spec new(number(), number(), number()) :: t()
  def new(x, y, z) when is_coordinate(x, y, z) do
    %PointZ{coordinate: [x, y, z]}
  end

  @doc """
  Returns `true` if the given `PointZ` is empty.

  ## Examples

      iex> PointZ.empty?(PointZ.new())
      true

      iex> PointZ.empty?(PointZ.new(1, 2, 3))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%PointZ{coordinate: coordinate}), do: is_nil(coordinate)

  @doc """
  Creates a `PointZ` from the given coordinate.

  ## Examples
      iex> PointZ.from_coordinates([[-1, 1, 1]])
      %PointZ{coordinate: [-1, 1, 1]}
  """
  @spec from_coordinates(Geometry.coordinate() | [nil, ...]) :: t()
  def from_coordinates([[x, y, z] = coordinate]) when is_coordinate(x, y, z) do
    %PointZ{coordinate: coordinate}
  end

  def from_coordinates([x, y, z] = coordinate) when is_coordinate(x, y, z) do
    %PointZ{coordinate: coordinate}
  end

  def from_coordinates([nil, nil, nil]) do
    %PointZ{}
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
  def to_wkt(%PointZ{coordinate: coordinate}, opts \\ []) do
    WKT.to_ewkt(<<"Point Z ", to_wkt_point(coordinate)::binary()>>, opts)
  end

  @doc """
  Returns an `:ok` tuple with the `PointZ` from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains an SRID the id is added to the tuple.

  ## Examples

      iex> PointZ.from_wkt("Point Z (-5.1 7.8 9.9)")
      {:ok, %PointZ{coordinate: [-5.1, 7.8, 9.9]}}

      iex> PointZ.from_wkt("SRID=7219;Point Z (-5.1 7.8 9.9)")
      {:ok, %PointZ{coordinate: [-5.1, 7.8, 9.9]}, 7219}

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
  def to_geo_json(%PointZ{coordinate: coordinate}) when not is_nil(coordinate) do
    %{
      "type" => "Point",
      "coordinates" => coordinate
    }
  end

  @doc """
  Returns an `:ok` tuple with the `PointZ` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1.1, 2.2, 3.3]})
      iex> |> Jason.decode!()
      iex> |> PointZ.from_geo_json()
      {:ok, %PointZ{coordinate: [1.1, 2.2, 3.3]}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_point(json, PointZ)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it
  fails.
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
  endian is returned. The default is `:xdr`.

  ## Examples

      iex> PointZ.to_wkb(PointZ.new())
      "00800000017FF80000000000007FF80000000000007FF8000000000000"

      iex> PointZ.to_wkb(PointZ.new(), endian: :ndr)
      "0101000080000000000000F87F000000000000F87F000000000000F87F"

      iex> PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), endian: :xdr)
      "00800000013FF199999999999A400199999999999A400A666666666666"

      iex> PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), endian: :ndr)
      "01010000809A9999999999F13F9A999999999901406666666666660A40"

      iex> PointZ.to_wkb(PointZ.new(1.1, 2.2, 3.3), srid: 4711, endian: :xdr)
      "00A0000001000012673FF199999999999A400199999999999A400A666666666666"
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%PointZ{coordinate: coordinate}, opts \\ []) do
    endian = Keyword.get(opts, :endian, Geometry.default_endian())
    srid = Keyword.get(opts, :srid)

    to_wkb(coordinate, srid, endian)
  end

  @doc """
  Returns an `:ok` tuple with the `PointZ` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> PointZ.from_wkb(
      ...>   "00800000017FF80000000000007FF80000000000007FF8000000000000"
      ...> )
      {:ok, %PointZ{coordinate: nil}}

      iex> PointZ.from_wkb(
      ...>   "00800000013FF199999999999A400199999999999A400A666666666666"
      ...> )
      {:ok, %PointZ{coordinate: [1.1, 2.2, 3.3]}}

      iex> PointZ.from_wkb(
      ...>   "01010000809A9999999999F13F9A999999999901406666666666660A40"
      ...> )
      {:ok, %PointZ{coordinate: [1.1, 2.2, 3.3]}}

      iex> PointZ.from_wkb(
      ...>   "00A0000001000012673FF199999999999A400199999999999A400A666666666666"
      ...> )
      {:ok, %PointZ{coordinate: [1.1, 2.2, 3.3]}, 4711}
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
  @compile {:inline, to_wkt_coordinate: 1}
  @spec to_wkt_coordinate(Geometry.coordinate()) :: String.t()
  def to_wkt_coordinate([x, y, z]) do
    <<
      to_wkt_number(x)::binary(),
      @blank,
      to_wkt_number(y)::binary(),
      @blank,
      to_wkt_number(z)::binary()
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

  def to_wkb_coordinate([x, y, z], endian) do
    <<
      to_wkb_number(x, endian)::binary(),
      to_wkb_number(y, endian)::binary(),
      to_wkb_number(z, endian)::binary()
    >>
  end

  @compile {:inline, to_wkb_number: 2}
  defp to_wkb_number(num, endian), do: Hex.to_float_string(num, endian)

  @compile {:inline, wkb_code: 2}
  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "80000001"
      {:ndr, false} -> "01000080"
      {:xdr, true} -> "A0000001"
      {:ndr, true} -> "010000A0"
    end
  end
end
