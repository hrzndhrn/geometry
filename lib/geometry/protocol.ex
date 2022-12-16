defprotocol Geometry.Protocol do
  @moduledoc false

  @spec empty?(Geometry.geometry() | Geometry.Feature.t() | Geometry.FeatureCollection.t()) ::
          boolean()
  def empty?(geometry)
end
