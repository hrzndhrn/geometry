defmodule Geometry.WKT do
  @moduledoc false

  alias Geometry.WKT.Parser

  @spec to_ewkt(String.t(), keyword()) :: String.t()
  def to_ewkt(wkt, []), do: wkt

  def to_ewkt(wkt, opts) when is_list(opts) do
    opts
    |> Keyword.get(:srid)
    |> ewkt(wkt)
  end

  @spec to_geometry(Geometry.wkt(), module()) ::
          {:ok, Geometry.t()} | {:ok, Geometry.t(), Geometry.srid()} | Geometry.wkt_error()
  def to_geometry(wkt, module) do
    case to_geometry(wkt) do
      {:ok, geometry} = result ->
        with :ok <- check_geometry(geometry, module), do: result

      {:ok, geometry, _srid} = result ->
        with :ok <- check_geometry(geometry, module), do: result

      error ->
        error
    end
  end

  defdelegate to_geometry(wkt), to: Parser, as: :parse

  defp ewkt(nil, wkt), do: wkt

  defp ewkt(srid, wkt) when is_integer(srid),
    do: <<"SRID=", to_string(srid)::binary(), ";", wkt::binary>>

  defp check_geometry(%geometry{}, geometry), do: :ok

  defp check_geometry(%{__struct__: got}, expected),
    do: {:error, %{expected: expected, got: got}}
end
