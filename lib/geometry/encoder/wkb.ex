defprotocol Geometry.Encoder.WKB do
  @moduledoc false

  @spec to_ewkb(Geometry.geometry(), Geometry.srid(), Geometry.endian()) :: String.t()
  def to_ewkb(geometry, endian, srid)

  @spec to_wkb(Geometry.geometry(), Geometry.endian()) :: String.t()
  def to_wkb(geometry, endian)
end
