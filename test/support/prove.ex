defmodule Prove do
  @moduledoc """
  Prove provides the macro `prove` to write short tests.
  """

  @operators [:==, :!=, :===, :!==, :<=, :>=, :<, :>, :=~]

  @doc """
  Prove
  """
  @spec prove(String.t(), Macro.expr()) :: true | no_return
  defmacro prove(description \\ "", expr)

  defmacro prove(description, {operator, _, [code, _]} = expr)
           when is_binary(description) and operator in @operators do
    description = if description != "", do: description <> " "
    code = Macro.to_string(code)

    quote do
      test "#{unquote(description)}#{unquote(code)}" do
        assert unquote(expr)
      end
    end
  end

  defmacro prove(_description, expr) do
    raise ArgumentError, message: "Unsupported do: #{Macro.to_string(expr)}"
  end
end
