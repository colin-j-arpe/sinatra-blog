class User < ActiveRecord::Base
	has_many	:posts
	has_many	:comments
	after_initialize :default
	def default
		self.login_name	= self.email if self.login_name.nil?
		self.admin = false if self.admin.nil?
	end
end

class Post < ActiveRecord::Base
	belongs_to	:user
	has_many	:comments
end

class Comment < ActiveRecord::Base
	belongs_to	:user
	belongs_to	:post
	after_initialize :default
	def default
		self.approved = true
	end
end