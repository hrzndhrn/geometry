defmodule Binary do
  @moduledoc false

  def replace(bin, value, offset) when is_integer(offset) do
    tail_size = byte_size(bin) - offset - byte_size(value)

    unless tail_size >= 0, do: raise("value fits not in binary")

    head = :binary.part(bin, {0, offset})
    tail = :binary.part(bin, {byte_size(bin), -1 * tail_size})
    <<head::binary, value::binary, tail::binary>>
  end

  def replace(bin, pattern, replacement) when is_binary(pattern) and is_binary(replacement) do
    :binary.replace(bin, Base.decode16!(pattern), Base.decode16!(replacement))
  end

  def take(bin, offset), do: :binary.part(bin, {0, offset})
end
