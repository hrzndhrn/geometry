defmodule GeoJsonValidator do
  @moduledoc false

  @external_resource "test/fixtures/schema/GeoJSON.json"

  @schema @external_resource
          |> File.read!()
          |> :json.decode()
          |> Xema.from_json_schema()

  @spec valid?(term()) :: boolean
  def valid?(geo_json), do: Xema.valid?(@schema, geo_json)
end
