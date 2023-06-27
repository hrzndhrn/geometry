defmodule Geometry.DecodeError do
  @moduledoc """
  Raised when the decoding of a geometry fails.
  """

  defexception [
    :from,
    :line,
    :message,
    :offset,
    :reason,
    :rest
  ]

  @type byte_offset :: pos_integer()

  @type line :: pos_integer()

  @type t :: %__MODULE__{
          from: :wkb | :wkt | :geo_json,
          line: {line(), byte_offset()},
          message: String.t() | nil,
          offset: byte_offset(),
          reason: atom(),
          rest: binary()
        }

  @max_rest 9

  @impl true
  def message(%{from: :wkt} = error) do
    {line, offset} = error.line
    col = error.offset - offset

    data =
      if String.length(error.rest) > @max_rest + 3 do
        String.slice(error.rest, 0, @max_rest) <> "..."
      else
        error.rest
      end

    "#{error.message} at #{line}:#{col}, got: #{inspect(data)}"
  end

  def message(%{from: :wkb, reason: :empty}) do
    "empty binary"
  end

  def message(%{from: :wkb, reason: :no_binary, rest: rest}) do
    "expected binary, got: #{inspect(rest)}"
  end

  def message(%{from: :wkb, reason: [expected_endian: :flag]} = error) do
    "expected endian flag at position #{error.offset}, got: #{inspect_hex(error.rest, 1)}"
  end

  def message(%{from: :wkb, reason: [expected_endian: :ndr]} = error) do
    "expected endian NDR at position #{error.offset}, got: #{inspect_hex(error.rest, 1)}"
  end

  def message(%{from: :wkb, reason: [expected_endian: :xdr]} = error) do
    "expected endian XDR at position #{error.offset}, got: #{inspect_hex(error.rest, 1)}"
  end

  def message(%{from: :wkb, reason: :expected_geometry_code} = error) do
    "expected geometry code at position #{error.offset}, got: #{inspect_hex(error.rest, 4)}"
  end

  def message(%{from: :wkb, reason: :invalid_data} = error) do
    "unexpected data at position #{error.offset}, got: #{inspect_hex(error.rest, 9)}"
  end

  def message(%{from: :wkb, reason: :invalid_coordinate} = error) do
    "invalid coordiante at position #{error.offset}, got: #{inspect_hex(error.rest, 9)}"
  end

  def message(%{from: :wkb, reason: :invalid_length} = error) do
    "invalid length at position #{error.offset}, got: #{inspect_hex(error.rest, 9)}"
  end

  def message(%{from: :wkb, reason: :invalid_srid} = error) do
    "expected SRID at position #{error.offset}, got: #{inspect_hex(error.rest, 4)}"
  end

  def message(%{from: :wkb, reason: :eos} = error) do
    "expected end of binary at position #{error.offset}, got: #{inspect_hex(error.rest, 9)}"
  end

  def message(%{from: :geo_json, reason: [unknown_type: type]}) do
    "unknown type '#{type}'"
  end

  def message(%{from: :geo_json, reason: :invalid_data}) do
    "invalid data"
  end

  def message(%{from: :geo_json, reason: :type_not_found}) do
    "type not found"
  end

  def message(%{from: :geo_json, reason: :coordinates_not_found}) do
    "coordinates not found"
  end

  defp inspect_hex(bin, limit), do: inspect(bin, base: :hex, binaries: :as_binaries, limit: limit)
end
