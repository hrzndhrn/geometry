defprotocol Geometry.Encoder.GeoJson do
  @moduledoc false

  @spec to_geo_json(Geometry.t() | Geometry.Feature.t() | Geometry.FeatureCollection.t()) ::
          Geometry.geo_json_term()
  def to_geo_json(geometry)
end
