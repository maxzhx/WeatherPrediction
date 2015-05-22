#
# config/initializers/scheduler.rb

require 'rufus-scheduler'
require 'rake'

# Let's use the rufus-scheduler singleton
#
#ProjectThree::Application.load_tasks
s = Rufus::Scheduler.singleton


# Stupid recurrent task...
#
s.every '10s' do
  #%x(rake weather:getNewData)
  #Rails.logger.info "hello, it's #{Time.now}"
end
