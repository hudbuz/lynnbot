class Createavailability < ActiveRecord::Migration
  def change

    create_table :availabilities do |t|
      t.string :day
      t.string :time
      t.integer :tutor_id
    end
  end
end
