class AddShowEmailColumnToUsersTable < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :show_email, :boolean
  end
end
