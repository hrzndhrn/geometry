defprotocol Geometry.Encoder.GeoJson do
  @moduledoc false

  @spec to_geo_json(Geometry.geometry() | Geometry.Feature.t() | Geometry.FeatureCollection.t()) ::
          Geometry.geo_json_term()
  def to_geo_json(geometry)
end
