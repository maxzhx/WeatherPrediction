class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.float :temperature
      t.float :rainfall
      t.float :wind_direction
      t.float :wind_speed
      t.date :date

      t.timestamps null: false
    end
  end
end
