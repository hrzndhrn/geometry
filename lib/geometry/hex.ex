defmodule Geometry.Hex do
  @moduledoc false

  @type t :: binary()
  @type size :: 8 | 16
  @type force :: :none | :float

  @nan nil

  @spec from_binary(binary) :: String.t
  def from_binary(binary), do: from_binary(binary, "")

  defp from_binary(<<>>, acc), do: acc

  defp from_binary(<<x::8, rest::binary()>>, acc) do
    hex = Integer.to_string(x, 16)

    case x < 16 do
      true -> from_binary(rest, <<acc::binary, "0", hex::binary>>)
      false -> from_binary(rest, <<acc::binary, hex::binary>>)
    end
  end

  @spec to_binary(String.t) :: binary
  def to_binary(str), do: to_binary(str, <<>>)

  defp to_binary(<<>>, acc), do: acc

  defp to_binary(<<x::binary-size(2), rest::binary()>>, acc) do
    int = String.to_integer(x, 16)
    to_binary(rest, <<acc::binary, int::integer-size(8)>>)
  end

  @spec to_integer_string(integer, Geometry.endian) :: t
  def to_integer_string(number, :xdr) do
    to_integer_string(number)
  end

  def to_integer_string(number, :ndr) do
    number |> to_integer_string() |> endian8()
  end

  @spec to_float_string(number(), Geometry.endian()) :: t()
  def to_float_string(number, :xdr) do
    to_float_string(number)
  end

  def to_float_string(number, :ndr) do
    number |> to_float_string() |> endian16()
  end

  @spec to_integer(t(), Geometry.endian()) :: {:ok, integer()} | :error
  def to_integer(hex, endian) when is_binary(hex) do
    binary_to_integer(hex, endian, 8)
  end

  @spec to_float(t(), Geometry.endian()) :: {:ok, float()} | :error
  def to_float("7FF8000000000000", :xdr), do: {:ok, @nan}

  def to_float("000800000000F87F", :ndr), do: {:ok, @nan}

  def to_float(hex, endian) when is_binary(hex) do
    with {:ok, integer} <- binary_to_integer(hex, endian, 16) do
      {:ok, to_float_64(<<integer::integer-64>>)}
    end
  end

  @compile {:inline, to_integer_string: 1}
  defp to_integer_string(number) do
    number |> Integer.to_string(16) |> pad_leading(8)
  end

  @compile {:inline, to_float_string: 1}
  defp to_float_string(number) do
    number |> from_float() |> Integer.to_string(16) |> pad_leading(16)
  end

  @compile {:inline, pad_leading: 2}
  defp pad_leading(str, size) do
    n = size - byte_size(str)

    case n <= 0 do
      true -> str
      false -> String.duplicate("0", n) <> str
    end
  end

  @compile {:inline, to_float_64: 1}
  defp to_float_64(<<value::float-64>>), do: value

  @compile {:inline, from_float: 1}
  defp from_float(float), do: from_bit_string(<<float::float-64>>)

  @compile {:inline, from_bit_string: 1}
  defp from_bit_string(<<value::integer-64>>), do: value

  @compile {:inline, endian8: 1}
  defp endian8(<<a::binary-size(2), b::binary-size(2), c::binary-size(2), d::binary-size(2)>>) do
    <<d::binary(), c::binary(), b::binary(), a::binary>>
  end

  @compile {:inline, endian16: 1}
  defp endian16(
         <<a::binary-size(2), b::binary-size(2), c::binary-size(2), d::binary-size(2),
           e::binary-size(2), f::binary-size(2), g::binary-size(2), h::binary-size(2)>>
       ) do
    <<
      h::binary(),
      g::binary(),
      f::binary(),
      e::binary(),
      d::binary(),
      c::binary(),
      b::binary(),
      a::binary
    >>
  end

  @compile {:inline, binary_to_integer: 3}
  defp binary_to_integer(binary, :xdr, _size) do
    {:ok, :erlang.binary_to_integer(binary, 16)}
  rescue
    _error -> :error
  end

  defp binary_to_integer(binary, :ndr, 8) do
    {:ok, binary |> endian8() |> :erlang.binary_to_integer(16)}
  rescue
    _error -> :error
  end

  defp binary_to_integer(binary, :ndr, 16) do
    {:ok, binary |> endian16() |> :erlang.binary_to_integer(16)}
  rescue
    _error -> :error
  end

  defp binary_to_integer(_binary, _endian, _size), do: :error
end
