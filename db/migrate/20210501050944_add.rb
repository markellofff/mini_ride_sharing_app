# intitial schema
class Add < ActiveRecord::Migration[6.0]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :phone_number
      t.timestamps
    end
    add_index :drivers, :name, unique: true
    create_table :rides do |t|
      t.integer :status, limit: 4
      t.string :pickup_location
      t.string :drop_location
      t.integer :driver_id
      t.integer :user_id
      t.float :cost
      t.datetime :ride_start_time
      t.datetime :ride_end_time
      t.timestamps
    end
    add_index :rides, :driver_id
    add_index :rides, :user_id
    add_index :rides, :status
  end
end
