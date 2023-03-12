defprotocol Geometry.Protocol do
  @moduledoc false

  @spec empty?(Geometry.t() | Geometry.Feature.t() | Geometry.FeatureCollection.t()) :: boolean()
  def empty?(geometry)
end
