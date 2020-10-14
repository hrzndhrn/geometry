defmodule Geometry.WKB do
  @moduledoc false

  alias Geometry.Hex

  alias Geometry.WKB.Parser

  @spec byte_order(Geometry.endian()) :: binary()
  def byte_order(:xdr), do: "00"
  def byte_order(:ndr), do: "01"

  @spec srid(non_neg_integer() | nil, Geometry.endian()) :: binary()
  def srid(nil, _endian), do: ""
  def srid(int, endian), do: Hex.to_string(int, endian, 8)

  @spec to_geometry(wkb, module()) ::
          {:ok, geometry} | {:ok, geometry, srid} | {:error, message, rest, offset}
        when wkb: Geometry.wkb(),
             geometry: Geometry.t(),
             srid: Geometry.srid(),
             message: String.t(),
             rest: binary(),
             offset: non_neg_integer()
  def to_geometry(wkb, module) do
    case to_geometry(wkb) do
      {:ok, geometry} = result ->
        with :ok <- check_geometry(geometry, module), do: result

      {:ok, geometry, _srid} = result ->
        with :ok <- check_geometry(geometry, module), do: result

      error ->
        error
    end
  end

  defdelegate to_geometry(wkb), to: Parser, as: :parse

  @spec length(list | MapSet.t(), Geometry.endian()) :: binary()
  def length(list, endian) when is_list(list), do: list |> length() |> Hex.to_string(endian, 8)

  def length(set, endian), do: set |> MapSet.size() |> Hex.to_string(endian, 8)

  defp check_geometry(%geometry{}, geometry), do: :ok

  defp check_geometry(%{__struct__: got}, expected),
    do: {:error, %{expected: expected, got: got}}
end
