defmodule Geometry.Hex do
  @moduledoc false

  @type t :: binary()
  @type size :: 8 | 16
  @type force :: :none | :float

  @nan nil

  @spec to_string(number(), Geometry.endian(), size(), force()) :: t()
  def to_string(number, endian, size, force_float \\ :none)

  def to_string(number, endian, size, :none) when is_integer(number) do
    hex_string(number, size, endian)
  end

  def to_string(number, endian, size, :none) when is_float(number) do
    number |> from_float() |> hex_string(size, endian)
  end

  def to_string(number, endian, size, :float) do
    to_string(number * 1.0, endian, size)
  end

  @spec to_integer(t(), Geometry.endian()) :: {:ok, integer()} | :error
  def to_integer(hex, endian) when is_binary(hex) do
    binary_to_integer(hex, endian)
  end

  @spec to_float(t(), Geometry.endian()) :: {:ok, float()} | :error
  def to_float("7FF8000000000000", :xdr), do: {:ok, @nan}

  def to_float("000800000000F87F", :ndr), do: {:ok, @nan}

  def to_float(hex, endian) when is_binary(hex) do
    with {:ok, integer} <- binary_to_integer(hex, endian) do
      {:ok, to_float_64(<<integer::integer-64>>)}
    end
  end

  defp to_float_64(<<value::float-64>>), do: value

  defp hex_string(number, size, :xdr) do
    number
    |> Integer.to_string(16)
    |> String.pad_leading(size, "0")
  end

  defp hex_string(number, size, :ndr) do
    {:ok, ndr} = number |> hex_string(size, :xdr) |> to_ndr()
    ndr
  end

  @compile {:inline, from_float: 1}
  defp from_float(float), do: from_bit_string(<<float::float-64>>)

  @compile {:inline, from_bit_string: 1}
  defp from_bit_string(<<value::integer-64>>), do: value

  @compile {:inline, to_ndr: 1}
  defp to_ndr(<<a::binary-size(2), b::binary-size(2), c::binary-size(2), d::binary-size(2)>>) do
    {:ok, "#{d}#{c}#{b}#{a}"}
  end

  defp to_ndr(
         <<a::binary-size(2), b::binary-size(2), c::binary-size(2), d::binary-size(2),
           e::binary-size(2), f::binary-size(2), g::binary-size(2), h::binary-size(2)>>
       ) do
    {:ok, "#{h}#{g}#{f}#{e}#{d}#{c}#{b}#{a}"}
  end

  defp to_ndr(_hex), do: :error

  @compile {:inline, binary_to_integer: 2}
  defp binary_to_integer(binary, :xdr) do
    {:ok, :erlang.binary_to_integer(binary, 16)}
  rescue
    _error -> :error
  end

  defp binary_to_integer(binary, :ndr) do
    with {:ok, ndr} <- to_ndr(binary) do
      {:ok, :erlang.binary_to_integer(ndr, 16)}
    end
  rescue
    _error -> :error
  end

  defp binary_to_integer(_binary, _endian), do: :error
end
