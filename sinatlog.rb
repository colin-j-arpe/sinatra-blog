require "sendgrid-ruby"
require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

set :database, "sqlite3:test.sqlite3"

enable :sessions

def current_user
	if session[:user_id]
		@user = User.find(session[:user_id])
	else
		@user = User.new
	end
end	

get '/' do
	redirect "/home"
end

get '/home' do
	flash[:alert] = nil
	current_user
	@posts = Post.all.reverse
	erb :home
end

post '/login' do
	@user = User.where(login_name: params[:username])[0]
	if @user == nil
		flash[:alert] = "Login ID not found"
	elsif @user.password != params[:password]
		flash[:alert] = "Incorrect password"
	else
		session[:user_id] = @user.id
	end
	redirect "/home"
end

get '/users/:id' do
	current_user
	@view_user = User.find(params[:id])
	@this_user = true if @user.id == @view_user.id
	@posts = Post.where(user_id: @view_user.id).reverse
	erb :user
end

post '/user/create' do
	@user_check = User.where(email: params[:email])
	if @user_check.length > 0
		flash[:alert] = "That email has already been registered."
		session[:user_id] = nil
		redirect "/home"
	end
	@user = User.new(display_name: params[:display_name], email: params[:email], show_email: params[:show_email], password: params[:password], admin: false)
	if params[:emailname]
		@user.login_name = params[:email]
	else
		@user.login_name = params[:login_name]
	end
	@user.save
	session[:user_id] = @user.id
	redirect "/users/#{@user.id}"
end

post '/user/edit' do
	@user = User.find(session[:user_id])
	if params[:display_name] != ""
		@user.display_name = params[:display_name]
	end
	if params[:login_name] != ""
		@user.login_name = params[:login_name]		
	end
	if params[:email] != ""
		@user.email = params[:email]
	end
	if params[:photo_url] != ""
		@user.photo_url = params[:photo_url]
	end
	@user.show_email = params[:show_email]
	@user.save
	redirect "users/#{@user.id}"
end

post '/user/password' do
	flash[:alert] = nil
	@user = User.find(session[:user_id])
	if @user.password != params[:old_password]
		flash[:alert] = "Incorrect current password"
		redirect "users/#{@user.id}#change-password-modal"
	elsif params[:new_password] != params[:new_password_confirm]
		flash[:alert] = "New passwords do not match"
		redirect "users/#{@user.id}#change-password-modal"
	else
		@user.password = params[:new_password]
		@user.save
	end
	redirect "users/#{@user.id}"
end

get '/posts/:id' do
	current_user
	@post = Post.find(params[:id])
	@comments = Comment.where(post_id: @post.id).reverse
	erb :post
end

post '/post/create' do
	@post = Post.new(user_id: session[:user_id], title: params[:title], content: params[:content])
	if params[:embed] == ""
		@post.embed = nil
	elsif params[:embed][0] != "<"
		@post.embed = "<img src='"
		@post.embed += params[:embed]
		@post.embed += "'>"
	else
		@post.embed = params[:embed]
	end
	@post.save
	redirect "/posts/#{@post.id}"
end

post 'post/edit' do
	@post = Post.find(params[:post_id])
	if params[:title] != ""
		@post.title = params[:title]
	end
	if params[:embed] != ""
		@post.embed = params[:embed]
	end
	@post.content = params.content
	@post.save
	redirect "/posts/#{@post.id}"
end

get '/posts/:id/delete' do
	@post = Post.find(params[:id])
	@post.destroy
	redirect "/home"
end

post '/comment/create' do
	@comment = Comment.create(params)
	redirect "/posts/#{params[:post_id]}"
end

get '/comments/:id/approve' do
	@comment = Comment.find(params[:id])
	@comment.approved = true
	@comment.save
	redirect "/posts/#{@comment.post_id}"
end

get '/comments/:id/disapprove' do
puts "method called"
	@comment = Comment.find(params[:id])
print "comment to be removed is "
puts @comment.content
	@comment.approved = false
	@comment.save
print "approval is now"
puts @comment.approved
	redirect "/posts/#{@comment.post_id}"
end

get '/comments/:id/delete' do
puts "correct route"
	@comment = Comment.find(params[:id])
print "selected comment: "
puts @comment.content
	@post = @comment.post_id
print "from post number "
puts @post
	@comment.destroy
puts "comment removed"
	redirect "/posts/#{@post}"
end

post '/search' do
	session[:term] = params[:term]
	redirect "/search/results"
end

get '/search/results' do
	current_user
	@term = session[:term]
	@user_results = User.where("display_name LIKE (?)", "%#{@term}%")
	@user_results += User.where("email LIKE (?)", "%#{@term}%")
	@user_results = @user_results.uniq
	@post_results = Post.where("title LIKE (?)", "%#{@term}%")
	@post_results += Post.where("content LIKE (?)", "%#{@term}%")
	@post_results = @post_results.uniq
	comment_results = Comment.where("content LIKE (?)", "%#{@term}%")
	posts_that_own_comments = []
	comment_results.each do |comment|
		posts_that_own_comments.push(Post.find(comment.post_id))
	end
	@posts_plus_comments = (@post_results + posts_that_own_comments).uniq
	erb :results
end

get '/logout' do	
	session[:user_id] = nil
	redirect "/home"
end
