namespace :weather do
  desc "TODO"
  task :getNewData => :environment do
    Test.new().save()
  end
end
