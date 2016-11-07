class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.float :rainfall
      t.float :wind_direction
      t.float :wind_speed
      t.float :temperature
      t.datetime :date

      t.timestamps null: false
    end
  end
end
