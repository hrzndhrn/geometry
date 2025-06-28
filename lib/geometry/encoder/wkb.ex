defprotocol Geometry.Encoder.WKB do
  @moduledoc false

  @spec to_wkb(Geometry.t(), Geometry.endian()) :: String.t()
  def to_wkb(geometry, endian)

  @spec to_ewkb(Geometry.t(), Geometry.endian()) :: String.t()
  def to_ewkb(geometry, endian)
end
