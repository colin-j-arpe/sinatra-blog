class CreatePostsTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :posts do |t|
  		t.string	:title
  		t.string	:embed
  		t.text		:content
  		t.integer	:user_id
  	end
  end
end
