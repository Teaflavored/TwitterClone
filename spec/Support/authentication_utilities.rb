module AuthenticationUtilities

	def validsignin(user)
		fill_in "Email", with: user.email
		fill_in "Password", with: user.password
		click_button "Sign In"
	end

	def invalidsignin
		fill_in "Email", with: "fake@gmail.com"
		fill_in "Password", with: "fakepw"
		click_button "Sign In"
	end
	RSpec::Matchers.define :have_error_message do |message|
		match do |page|
			expect(page).to have_selector('div.alert.alert-error', text: message)
		end
	end


	RSpec::Matchers.define :log_user_out do
		match do |page|
			expect(page).to have_title(full_title(""))
			expect(page).to have_link("Sign In", href: signin_path)
		end
	end
end