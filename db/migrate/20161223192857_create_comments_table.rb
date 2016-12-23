class CreateCommentsTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :comments do |t|
  		t.string	:content
  		t.integer	:user_id
  		t.integer	:post_id
  		t.boolean	:approved
  	end
  end
end
