class Fixpassword < ActiveRecord::Migration
  def change

    remove_column :tutors, :password
    add_column :tutors, :password_digest, :string

    remove_column :students, :password
    add_column :students, :password_digest, :string
  end
end
