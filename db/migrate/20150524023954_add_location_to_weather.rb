class AddLocationToWeather < ActiveRecord::Migration
  def change
    add_reference :weathers, :location, index: true, foreign_key: true
  end
end
