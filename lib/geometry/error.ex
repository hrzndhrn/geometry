defmodule Geometry.Error do
  @moduledoc """
  Raised when the creation of a geometry fails.
  """

  alias Geometry.Error

  defexception [:message]

  @max_rest 9

  @impl Exception
  def exception({:error, message, rest, {line, offset}, byte_offset}) do
    col = byte_offset - offset

    data =
      case String.length(rest) > @max_rest + 3 do
        true -> String.slice(rest, 0, @max_rest) <> "..."
        false -> rest
      end

    %Error{message: "#{message} at #{line}:#{col}, got: #{inspect(data)}"}
  end

  def exception({:error, message, _rest, offset}) do
    %Error{message: "#{message}, at position #{offset}"}
  end

  def exception({:error, %{expected: expected, got: got}}) do
    %Error{message: "expected: #{inspect(expected)}, got: #{inspect(got)}"}
  end

  def exception({:error, reason}) do
    message =
      case reason do
        :coordinates_not_found -> "coordinates not found"
        :invalid_data -> "invalid data"
        :type_not_found -> "type not found"
        :unknown_type -> "unknown type"
        _unexpected -> "unexpected: #{inspect(reason)}"
      end

    %Error{message: message}
  end

  def exception(error) do
    %Error{message: "unexpected: #{inspect(error)}"}
  end
end
