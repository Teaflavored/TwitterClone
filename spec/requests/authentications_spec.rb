require 'spec_helper'

describe "Sessions" do

	subject { page }

	describe "Sign in page" do
		let(:heading) {"Sign In"}
		before {visit signin_path}

		it {should have_title(full_title(heading))}
		it {should have_content(heading)}
		it {should have_link("Sign Up", href: signup_path)}
	end

	describe "Signing in" do
		before { visit signin_path}

		describe "with invalid information" do
			before {invalidsignin}
			it {should have_error_message("Wrong")}
			it {should_not have_links_when_signed_in()}

			describe "and visiting another page should not persist error" do
				before {click_link "Home"}
				it {should_not have_error_message("Wrong")}
			end
		end

		describe "with valid information " do
			let(:user) {FactoryGirl.create(:user)}
			before { sign_in user }
			it {should have_title(full_title(user.name))}
			it {should have_links_when_signed_in(user)}
			#links when signed in

			describe "and signing out after should successfully log user out" do
				before {click_link "Sign Out"}
				it { should log_user_out}
			end

		end
	end

	describe "authorization tools" do 
		let(:user) {FactoryGirl.create(:user)}

		describe "non-signed in users should be redirected if they attempt to edit/update" do
			
			describe "edit page redirect do" do
				before { visit edit_user_path(user)}
				it {should have_title(full_title("Sign In"))}
			end

			describe "update request redirect do" do
				before {patch user_path(user)}
				specify { expect(response).to redirect_to(signin_url)}
			end

			describe "not signed_in users attempting to view users index" do
				before { visit users_path}
				it {should have_title(full_title("Sign In"))}
			end
		end

		describe "non-admin users should not be able to delete users" do
			let(:user) { FactoryGirl.create(:user)}
			let(:non_admin) {FactoryGirl.create(:user, name: "Auster Chen", email: "Auster.s.chen@gmail.com")}

			before do
				visit signin_path
				sign_in non_admin, no_capybara: true
			end

			
			describe "delete request should redirect" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_url)}
			end

		end

		describe "wrong user trying to access the page" do
			let(:user) {FactoryGirl.create(:user)}
			let(:wrong_user) {FactoryGirl.create(:user, email: "different@gmail.com")}


			before { sign_in user, no_capybara: true}


			describe "get request to users edit" do
				before { get edit_user_path(wrong_user)}

				specify { expect(response.body).not_to match(full_title("Edit"))}
				specify { expect(response).to redirect_to(root_url)}

			end

			describe "submitting a patch request to update action" do
				before { patch user_path(wrong_user)}

				specify { expect(response).to redirect_to(root_url)}

			end
		end

		describe "friendly forwarding" do
			let(:user) {FactoryGirl.create(:user)}

			before do 
				visit edit_user_path(user)
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				click_button "Sign In"
			end

			it { should have_title(full_title("Edit"))}

			describe "Signing In Again" do
				before do 
					click_link "Sign Out"
					visit signin_path
					fill_in "Email", with: user.email
					fill_in "Password", with: user.password
					click_button "Sign In"
				end

				it {should have_title(full_title(user.name))}

			end


		end
	end
end
