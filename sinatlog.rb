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
		@user = nil
	end
end	

get '/' do
	redirect "/home"
end

get '/home' do
	flash[:alert] = nil
	current_user
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
	redirect "/users/#{@user.id}"
end

get '/users/:id' do
	current_user
	@posts = Post.where(user_id: @user.id)
	erb :user
end

post '/users/create' do
	@user_check = User.where(email: params[:email])
	if @user_check.length > 0
		flash[:alert] = "That email has already been registered."
		session[:user_id] = nil
		redirect "/home"
	end
	@user = User.new(display_name: params[:display_name], email: params[:email], password: params[:password], admin: false)
	if params[:emailname]
		@user.login_name = params[:email]
	else
		@user.login_name = params[:login_name]
	end
	@user.save
	session[:user_id] = @user.id
	redirect "/users/#{@user.id}"
end

post '/post/create' do
	@post = Post.new (user_id: session[:user_id], title: params[:title], content: params[:content])
	if params[:embed] == ""
		@post.embed = nil
	else
		@post.embed = params[:embed]
	end
	redirect "/users/#{session[:user_id]}"
end

get '/logout' do	
	session[:user_id] = nil
	redirect "/home"
end