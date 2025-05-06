class TestJob
  include SuckerPunch::Job
  include TopHelper

  def perform
    Rails.cache.write("beer_top_3", top(Beer, 3))
    Rails.cache.write("brewery_top_3", top(Brewery, 3))
    Rails.cache.write("style_top_3", top(Style, 3))
  end
end
