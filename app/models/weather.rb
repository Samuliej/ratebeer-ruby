class Weather < OpenStruct
  def self.rendered_fields
    [
      :temperature,
      :weather_icons,
      :air_quality,
      :wind_speed,
      :wind_dir,
    ]
  end
end
