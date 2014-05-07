class AddBirthToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :birth, :date
  end
end
