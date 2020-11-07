defmodule Geometry.WKB do
  @moduledoc false

  alias Geometry.Hex

  alias Geometry.WKB.Parser

  @compile {:inline, byte_order: 2}
  @spec byte_order(Geometry.endian(), Geometry.mode()) :: binary()
  def byte_order(:xdr, :hex), do: "00"
  def byte_order(:ndr, :hex), do: "01"
  def byte_order(:xdr, :binary), do: <<0::8>>
  def byte_order(:ndr, :binary), do: <<1::8>>

  @compile {:inline, srid: 3}
  @spec srid(non_neg_integer() | nil, Geometry.endian(), Geometry.mode()) :: binary()
  def srid(nil, _endian, _mode), do: <<>>
  def srid(int, endian, :hex), do: Hex.to_integer_string(int, endian)
  def srid(int, :xdr, :binary), do: <<int::big-integer-size(32)>>
  def srid(int, :ndr, :binary), do: <<int::little-integer-size(32)>>

  @spec to_geometry(wkb, mode, module()) ::
          {:ok, geometry} | {:ok, geometry, srid} | {:error, message, rest, offset}
        when wkb: Geometry.wkb(),
             mode: Geometry.mode(),
             geometry: Geometry.t(),
             srid: Geometry.srid(),
             message: String.t(),
             rest: binary(),
             offset: non_neg_integer()
  def to_geometry(wkb, mode, module) do
    case to_geometry(wkb, mode) do
      {:ok, geometry} = result ->
        with :ok <- check_geometry(geometry, module), do: result

      {:ok, geometry, _srid} = result ->
        with :ok <- check_geometry(geometry, module), do: result

      error ->
        error
    end
  end

  defdelegate to_geometry(wkb, mode), to: Parser, as: :parse

  @compile {:inline, length: 3}
  @spec length(list | MapSet.t(), Geometry.endian(), Geometry.mode()) :: binary()
  def length(list, endian, :hex) when is_list(list) do
    list |> length() |> Hex.to_integer_string(endian)
  end

  def length(set, endian, :hex) do
    set |> MapSet.size() |> Hex.to_integer_string(endian)
  end

  def length(list, endian, :binary) when is_list(list) do
    length = length(list)

    case endian do
      :ndr -> <<length::little-integer-size(32)>>
      :xdr -> <<length::big-integer-size(32)>>
    end
  end

  def length(set, endian, :binary) do
    size = MapSet.size(set)

    case endian do
      :ndr -> <<size::little-integer-size(32)>>
      :xdr -> <<size::big-integer-size(32)>>
    end
  end

  defp check_geometry(%geometry{}, geometry), do: :ok

  defp check_geometry(%{__struct__: got}, expected),
    do: {:error, %{expected: expected, got: got}}
end
