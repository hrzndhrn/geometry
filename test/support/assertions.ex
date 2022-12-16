defmodule Assertions do
  @moduledoc false

  import ExUnit.Assertions

  def assert_fail(fun, input, message) do
    assert_raise Geometry.DecodeError, message, fn ->
      apply(Geometry, fun, List.wrap(input))
    end
  end
end
