#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

s = Rufus::Scheduler.singleton


s.every '30m', :overlap => false do
  Rails.logger.info "Acquiring new forecast data.... #{Time.now}"
  Weather.getForecast
  #Location.getLocation()
end
