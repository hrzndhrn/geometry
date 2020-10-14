defmodule Geometry.ErrorTest do
  use ExUnit.Case

  import Prove

  alias Geometry.Error

  prove Error.exception({:error, :something}) ==
          %Error{message: "unexpected: :something"}

  prove Error.exception(:something) ==
          %Error{message: "unexpected: :something"}

  prove Error.exception({:error, %{expected: 1, got: 2}}) ==
          %Error{message: "expected: 1, got: 2"}
end
