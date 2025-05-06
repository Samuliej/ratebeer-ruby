require_relative './config/boot'
require_relative './config/environment'
require 'clockwork'

# Suorittaa minuutin välein cachen refreshauksen ratings sivua varten
# toimii Fly.io:ssa erillisessä worker machinessa.
module Clockwork
  every(1.minute, 'refresh_cache') do
    TestJob.perform_async
  end
end
