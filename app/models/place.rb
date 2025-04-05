require "ostruct"
require "securerandom"
class Place < OpenStruct
  def self.rendered_fields
    [
      :name,
      :open_now,
      :icon,
      :icon_background_color,
      :price_level,
      :rating,
      :formatted_address,
      :place_id
    ]
  end

  def open_now
    dig(:opening_hours, 'open_now') || false
  end
end
