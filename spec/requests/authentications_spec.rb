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
			
			before {invalidsignin}
			it {should have_error_message("Wrong")}

			describe "visiting another page should not persist error" do
				before {click_link "Home"}
				it {should_not have_error_message("Wrong")}
			end

		end

		describe "with valid information " do
			let(:user) {FactoryGirl.create(:user)}
			before { validsignin(user) }

			it {should have_title(full_title(user.name))}
			it {should have_link("Sign Out", href: signout_path)}
			it {should have_link("Profile", href: user_path(user))}
			it {should_not have_link("Sign In", href: signin_path)}

			describe "signing out after signing in should work" do

				before {click_link "Sign Out"}
				it { should log_user_out}
			
			end
		end

	end
end