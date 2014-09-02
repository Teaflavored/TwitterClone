module AuthenticationUtilities

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

	RSpec::Matchers.define :have_links_when_signed_in do |user|
		match do |page|

			expect(page).to have_link("Sign Out", href: signout_path)
			expect(page).to have_link("Profile", href: user_path(user))
			expect(page).not_to have_link("Sign In", href: signin_path)
			expect(page).to have_link("Settings", href: edit_user_path(user))
			expect(page).to have_link("Users", href: users_path)
		end
	end

end