require 'spec_helper'

describe "Sessions" do

	subject { page }

	describe "Sign In Page" do
		let(:heading) {"Sign In"}

		before {visit signin_path}

		it {should have_title(full_title(heading))}
		it {should have_content(heading)}
		it {should have_link("Sign Up", href: signup_path)}
	end

	describe "Sign In" do
		before { visit signin_path}

		describe "invalid information" do
			before do
				fill_in "Email", with: "ASDF@gmail.com"
				fill_in "Password", with: "DOES NOT EXIST"
				click_button "Sign In"
			end

			it {should have_selector('div.alert.alert-error')}

			describe "visiting another page should not persist error" do
				before {click_link "Home"}

				it {should_not have_selector("div.alert.alert-error")}

			end
		end

		describe "with valid information " do
			let(:user) {FactoryGirl.create(:user)}
			before do
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				click_button "Sign In"
			end

			it {should have_title(full_title(user.name))}
			it {should have_link("Sign Out", href: signout_path)}
			it {should have_link("Profile", href: user_path(user))}
			it {should_not have_link("Sign In", href: signin_path)}

			describe "signing out after signing in should work" do
				before do
					click_link "Sign Out"
				end

				it {should have_title(full_title(""))}
				it {should have_link("Sign In", href: signin_path)}
				it {should_not have_link("Sign Out", href: signout_path)}
			end
		end

	end
end
