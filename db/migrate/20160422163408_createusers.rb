class Createusers < ActiveRecord::Migration
  def change

    create_table :tutors do |t|
      t.string :name
      t.string :username
      t.string :password
    end
  end
end
