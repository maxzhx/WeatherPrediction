class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.text :name
      t.float :lat
      t.float :lon
      t.integer :postcode

      t.timestamps null: false
    end
  end
end
