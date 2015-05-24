class AddConditionToWeather < ActiveRecord::Migration
  def change
    add_column :weathers, :condition, :text
  end
end
