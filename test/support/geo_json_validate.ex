defmodule GeoJsonValidator do
  @moduledoc false

  @schema "test/fixtures/schema/GeoJSON.json"
          |> File.read!()
          |> Jason.decode!()
          |> Xema.from_json_schema()

  @spec valid?(term()) :: boolean
  def valid?(geo_json), do: Xema.valid?(@schema, geo_json)
end
