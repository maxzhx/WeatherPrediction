#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

s = Rufus::Scheduler.singleton


s.every '10s', :overlap => false do
  #%x(rake weather:getNewData)
  #%x(rake weather:getLocation)
  Rails.logger.info "hello, it's #{Time.now}"
  Location.getLocation()
end
