#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

s = Rufus::Scheduler.singleton


# get new forecast data in every 30 minutes
s.every '30m', :overlap => false do
  Rails.logger.info "Acquiring new forecast data.... #{Time.now}"
  Weather.getForecast
  #Location.getLocation()
end
