class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :salt
      t.string :email
      t.boolean :dm
      t.string :roles
      t.integer :reviews_count

      t.timestamps
    end
  end
end
