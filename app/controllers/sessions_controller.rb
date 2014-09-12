class SessionsController < ApplicationController
	def new
	end

	def create
		user= User.find_by(email: params[:email].downcase) || User.find_by(username: params[:email].downcase )
  	if user && user.authenticate(params[:password])
  		sign_in user
  		flash[:success] = "Welcome Back!"
  		redirect_back_or user
  	else
      @feed_items = []
  		flash.now[:error] = "Wrong Email/Password Combination"
  		render 'new'
  	end
	end

  
	def destroy
		sign_out
		redirect_to root_url
	end

end
