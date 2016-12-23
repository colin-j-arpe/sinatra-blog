class CreateUsersTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :users do |t|
  		t.string	:display_name
  		t.string	:email
  		t.string	:login_name
  		t.string	:password
  		t.boolean	:admin
  	end
  end
end
