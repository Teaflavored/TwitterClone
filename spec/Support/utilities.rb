include ApplicationHelper
require 'rspec/expectations'

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

def validsignup
	fill_in "Name", with: "Auster Chen"
	fill_in "Email", with: "user@example.com"
	fill_in "Password", with: "asdfasdf"
	fill_in "Confirmation", with: "asdfasdf"
end

def invalidsignup
	fill_in "Name", with: ""
	fill_in "Email", with: ""
	fill_in "Password", with: "123"
	fill_in "Confirmation", with: "123"
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


RSpec::Matchers.define :have_right_page do |heading, title|
	match do |page|
		expect(page).to have_selector('h1', heading)
		expect(page).to have_title(full_title(title))
	end
end