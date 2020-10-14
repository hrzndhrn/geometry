defmodule Geometry.Guards do
  @moduledoc false

  defguard is_coordinate(x, y)
           when is_number(x) and is_number(y)

  defguard is_coordinate(x, y, z)
           when is_number(x) and is_number(y) and is_number(z)

  defguard is_coordinate(x, y, z, m)
           when is_number(x) and is_number(y) and is_number(z) and is_number(m)
end
