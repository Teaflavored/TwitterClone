module SessionsHelper

	def sign_in(user)

	end


	def current_user
		current_user ||= User.find_by(remember_token: cookies[:remember_token])
	end
end
