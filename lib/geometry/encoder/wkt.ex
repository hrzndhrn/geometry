defprotocol Geometry.Encoder.WKT do
  @moduledoc false

  @spec to_wkt(Geometry.t()) :: String.t()
  def to_wkt(geometry)

  @spec to_ewkt(Geometry.t(), Geometry.srid()) :: String.t()
  def to_ewkt(geometry, srid)
end
