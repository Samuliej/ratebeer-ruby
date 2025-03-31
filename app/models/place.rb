require "ostruct"
class Place < OpenStruct
  def self.rendered_fields
    [
      :name,
      :open_now,
      :icon,
      :icon_background_color,
      :price_level,
      :rating,
      :vicinity
    ]
  end

  def open_now
    dig(:opening_hours, 'open_now') || false
  end
end
