## URL CONTROLLER

get '/' do
  @url = Url.all
  erb :index
end

get '/:short_url' do
  url = Url.where("short_url = ?", params[:short_url]).first
  url.increment_click
  redirect "#{url.long_url}"
end

post '/urls' do
  @url = Url.all
  @user = User.find(session[:user_id])
  @new_url = Url.new(:long_url => params[:long_url], :user_id => session[:user_id])
  @new_url.save
  
  erb :index
end

### USER CONTROLLER

get '/user/signup' do

  erb :signup
end

post '/user/signup' do
  @url = Url.all
  @user = User.new(params)
  if @user.save
    session[:user_id] = @user.id
    erb :index
  else
    @errors = @user.errors.full_messages
    erb :index
  end
end


get '/user/login' do

  erb :login
end

post '/user/login' do
  @url = Url.all
  @user = User.find_by_email(params[:email])
  @user = User.authenticate(params[:email], params[:password])
  if @user 
    session[:user_id] = @user.id
    erb :index
  else
    @errors = "Invalid email and password" #do ajax later to add errors in
    erb :login
  end
end

post '/user/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/user/:user_id' do
  @users_urls = Url.where("user_id = ?", session[:user_id])
  p @users_urls
  erb :profile
end
