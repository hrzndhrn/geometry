defmodule Geometry.Point do
  @moduledoc """
  A point struct, representing a 2D point.
  """

  alias Geometry.{GeoJson, Hex, Point, WKB, WKT}

  import Geometry.Guards

  defstruct [:x, :y]

  @blank " "

  @type t ::
          %Point{x: Geometry.x(), y: Geometry.y()}
          | %Point{x: nil, y: nil}

  @doc """
  Creates an empty `Point`.

  ## Examples

      iex> Point.new()
      %Point{x: nil, y: nil}
  """
  @spec new :: t()
  def new, do: %Point{}

  @doc """
  Creates a `Point` from the given `coordinate`.

  ## Examples

      iex> Point.new([1.5, -2.1])
      %Point{x: 1.5, y: -2.1}

      iex> Point.new({4, 5})
      %Point{x: 4, y: 5}
  """
  @spec new(Geometry.coordinate()) :: t()
  def new([x, y] = _coordinate), do: new(x, y)
  def new({x, y} = _coordinate), do: new(x, y)

  @doc """
  Creates a `Point` from the given `x` and `y`.

  ## Examples

      iex> Point.new(-1.1, 2.2)
      %Point{x: -1.1, y: 2.2}
  """
  @spec new(Geometry.x(), Geometry.y()) :: t()
  def new(x, y) when is_coordinate(x, y), do: %Point{x: x, y: y}

  @doc """
  Returns `true` if the given `Point` is empty.

  ## Examples

      iex> Point.empty?(Point.new())
      true

      iex> Point.empty?(Point.new(1, 2))
      false
  """
  @spec empty?(t()) :: boolean
  def empty?(%Point{x: nil, y: nil} = _point), do: true
  def empty?(%Point{x: x, y: y} = _point) when is_coordinate(x, y), do: false

  @doc """
  Creates a `Point` from the given coordinate.

  ## Examples

      iex> Point.from_coordinates([{-1, 1}])
      %Point{x: -1, y: 1}
  """
  @spec from_coordinates([Geometry.coordinate() | {nil, nil}]) :: t()
  def from_coordinates([{nil, nil}] = _coordinates) do
    %Point{}
  end

  def from_coordinates([{x, y}] = _coordinates) when is_coordinate(x, y) do
    %Point{x: x, y: y}
  end

  def from_coordinates([x, y] = _coordinates) when is_coordinate(x, y) do
    %Point{x: x, y: y}
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
  def to_wkt(%Point{} = point, opts \\ []) do
    point
    |> Point.empty?()
    |> case do
      true -> "EMPTY"
      false -> <<"(", to_wkt_coordinate(point)::binary(), ")">>
    end
    |> to_wkt_point()
    |> WKT.to_ewkt(opts)
  end

  @doc """
  Returns an `:ok` tuple with the `Point` from the given WKT string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> Point.from_wkt("Point (-5.1 7.8)")
      {:ok, %Point{x: -5.1, y: 7.8}}

      iex> Point.from_wkt("SRID=7219;Point (-5.1 7.8)")
      {:ok, %Point{x: -5.1, y: 7.8}, 7219}

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
  def to_geo_json(%Point{x: x, y: y}) when is_coordinate(x, y) do
    %{
      "type" => "Point",
      "coordinates" => [x, y]
    }
  end

  @doc """
  Returns an `:ok` tuple with the `Point` from the given GeoJSON term.
  Otherwise returns an `:error` tuple.

  ## Examples

      iex> ~s({"type": "Point", "coordinates": [1.1, 2.2]})
      iex> |> Jason.decode!()
      iex> |> Point.from_geo_json()
      {:ok, %Point{x: 1.1, y: 2.2}}
  """
  @spec from_geo_json(Geometry.geo_json_term()) :: {:ok, t()} | Geometry.geo_json_error()
  def from_geo_json(json), do: GeoJson.to_point(json, Point)

  @doc """
  The same as `from_geo_json/1`, but raises a `Geometry.Error` exception if it fails.
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

  The option `endian` indicates whether `:xdr` big endian or `:ndr` little
  endian is returned. The default is `:ndr`.

  ## Examples

      iex> Point.to_wkb(Point.new(), endian: :xdr)
      "00000000017FF80000000000007FF8000000000000"

      iex> Point.to_wkb(Point.new(1.1, 2.2), endian: :xdr)
      "00000000013FF199999999999A400199999999999A"

      iex> Point.to_wkb(Point.new(1.1, 2.2))
      "01010000009A9999999999F13F9A99999999990140"

      iex> Point.to_wkb(Point.new(1.1, 2.2), srid: 4711, endian: :xdr)
      "0020000001000012673FF199999999999A400199999999999A"
  """
  @spec to_wkb(t(), opts) :: Geometry.wkb()
        when opts: [endian: Geometry.endian(), srid: Geometry.srid()]
  def to_wkb(%Point{} = point, opts \\ []) do
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
  Returns an `:ok` tuple with the `Point` from the given WKB string. Otherwise
  returns an `:error` tuple.

  If the geometry contains a SRID the id is added to the tuple.

  ## Examples

      iex> Point.from_wkb(
      ...>   "00000000017FF80000000000007FF8000000000000"
      ...> )
      {:ok, %Point{x: nil, y: nil}}

      iex> Point.from_wkb(
      ...>   "00000000013FF199999999999A400199999999999A"
      ...> )
      {:ok, %Point{x: 1.1, y: 2.2}}

      iex> Point.from_wkb(
      ...>   "01010000009A9999999999F13F9A99999999990140"
      ...> )
      {:ok, %Point{x: 1.1, y: 2.2}}

      iex> Point.from_wkb(
      ...>   "0020000001000012673FF199999999999A400199999999999A"
      ...> )
      {:ok, %Point{x: 1.1, y: 2.2}, 4711}
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
  @spec to_list(t()) :: list()
  def to_list(%Point{x: x, y: y}) when is_coordinate(x, y), do: [x, y]

  @doc false
  @spec to_wkt_coordinate(t()) :: String.t()
  def to_wkt_coordinate(%Point{x: x, y: y}) when is_coordinate(x, y) do
    <<
      to_string(x)::binary(),
      @blank,
      to_string(y)::binary(),
    >>
  end

  @doc false
  @spec to_wkb_coordinate(t(), Geometry.endian()) :: binary()
  def to_wkb_coordinate(%Point{x: x, y: y}, endian)
      when is_coordinate(x, y) do
    <<
      to_wkb_number(x, endian)::binary(),
      to_wkb_number(y, endian)::binary(),
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

  defp to_wkb_empty(:xdr), do: "7FF80000000000007FF8000000000000"

  defp to_wkb_empty(:ndr), do: "000000000000F87F000000000000F87F"

  defp to_wkt_point(wkt), do: <<"Point ", wkt::binary()>>

  defp wkb_code(endian, srid?) do
    case {endian, srid?} do
      {:xdr, false} -> "00000001"
      {:ndr, false} -> "01000000"
      {:xdr, true} -> "20000001"
      {:ndr, true} -> "01000020"
    end
  end
end
