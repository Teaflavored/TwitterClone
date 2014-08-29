Given /^a user visits the signin page$/ do
	visit signin_path
end

When /^they submit invalid signin information$/ do
	fill_in "Email", with: "asdf@asdf@gmail.com"
	fill_in "Password", with: "fakepassword"
end

Then /^they should see an error message$/ do
	click_button "Sign In"
	expect(page).to have_selector("div.alert.alert-error")
end

And /^a valid user exists$/ do
	@user = User.create(name: "Auster Chen", email: "Auster.s.chen@gmail.com", password: "testthis", password_confirmation: "testthis")
end

When /^they submit valid signin information$/ do
	fill_in "Email", with: "Auster.s.chen@gmail.com"
	fill_in "Password", with: "testthis"
end

Then /^they should see their profile page$/ do
	click_button "Sign In"
	expect(page).to have_title(@user.name)
end

And /^they should see a signout link$/ do
	expect(page).to have_link("Sign Out", href: signout_path)
end
