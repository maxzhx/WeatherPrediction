# task for testing 
namespace :weather do
  desc "TODO"
  task :getLocation => :environment do
    Location.getLocation
  end

  desc "TODO"
  task :getForecast => :environment do
    Weather.getForecast
  end
end
