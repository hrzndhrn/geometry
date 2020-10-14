defmodule Geometry.HexTest do
  use ExUnit.Case

  import Prove

  alias Geometry.Hex

  describe "to_string/4:" do
    prove Hex.to_string(26, :xdr, 8) == "0000001A"
    prove Hex.to_string(26, :ndr, 8) == "1A000000"

    prove Hex.to_string(999_999, :xdr, 8) == "000F423F"
    prove Hex.to_string(999_999, :ndr, 8) == "3F420F00"

    prove Hex.to_string(0xC0000001, :xdr, 8) == "C0000001"
    prove Hex.to_string(0xC0000001, :ndr, 8) == "010000C0"

    prove Hex.to_string(123.321, :xdr, 16) == "405ED48B43958106"
    prove Hex.to_string(123.321, :ndr, 16) == "068195438BD45E40"

    prove Hex.to_string(3.0, :xdr, 16) == "4008000000000000"
    prove Hex.to_string(3.0, :ndr, 16) == "0000000000000840"

    prove Hex.to_string(3, :xdr, 16, :float) == "4008000000000000"
    prove Hex.to_string(3, :ndr, 16, :float) == "0000000000000840"
  end

  describe "to_float/2:" do
    prove Hex.to_float("4008000000000000", :xdr) == {:ok, 3.0}
    prove Hex.to_float("0000000000000840", :ndr) == {:ok, 3.0}

    prove Hex.to_float("ABCDEF0000000000", :xdr) == {:ok, -1.0948390474245091e-97}
    prove Hex.to_float("abcdef0000000000", :xdr) == {:ok, -1.0948390474245091e-97}

    prove Hex.to_float("bcdef0000000000", :ndr) == :error

    prove Hex.to_float("XXXX000000000840", :ndr) == :error
    prove Hex.to_float("XXXX000000000840", :xdr) == :error

    prove Hex.to_float("7FF8000000000000", :xdr) == {:ok, nil}
    prove Hex.to_float("000800000000F87F", :ndr) == {:ok, nil}
  end

  describe "to_integer/2:" do
    prove Hex.to_integer("0000001A", :xdr) == {:ok, 26}
    prove Hex.to_integer("1A000000", :ndr) == {:ok, 26}

    prove Hex.to_integer("000001A", :ndr) == :error

    prove Hex.to_integer("XX000000", :ndr) == :error
    prove Hex.to_integer("XX000000", :xdr) == :error
  end
end
