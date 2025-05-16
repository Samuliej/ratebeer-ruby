require_relative 'config/boot'
require_relative 'config/environment'
require 'clockwork'

module Clockwork
  every(48.hour, 'refresh_cache') do
    RefreshRatingPageCache.perform_async
  end
end
