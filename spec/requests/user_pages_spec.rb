require 'spec_helper'

describe "UserPages" do

	subject {page}

  describe "Sign Up Page" do
  	before {visit signup_path}
  	it{should have_content("Sign Up")}
  	it{should have_title(full_title("Sign Up"))}
  end

  describe "Edit Page" do
  	let(:user) {FactoryGirl.create(:user)}
  	
  	before do 
  		sign_in user
  		visit edit_user_path(user)
  	end

  	it {should have_title(full_title("Edit"))}
  	it {should have_content("Update")}
  	it {should have_link("change", href: 'http://gravatar.com/emails')}

  	describe "Invalid Information" do
  		before {click_button "Save Changes"}
  		it {should have_content("error")}
  	end

  	describe "Valid Information" do
  		let(:new_name) { "ASDDFASDF"}
  		let(:new_email) { "example@user.com"}
  		before do
  			fill_in "Name", with: new_name
  			fill_in "Email", with: new_email
  			fill_in "Password", with: user.password
  			fill_in "Confirmation", with: user.password
  			click_button "Save Changes"
  		end

  		it {should have_title(full_title(new_name))}
  		it {should have_selector('div.alert.alert-success')}
  		it {should have_link("Sign Out", href: signout_path)}

  		specify { expect(user.reload.name).to eq new_name}
  		specify { expect(user.reload.email).to eq new_email}




  	end
  end

  describe "Profile Page" do
  	let(:user) {FactoryGirl.create(:user)}
  	before {visit user_path(user)}

  	it {should have_content(user.name)}
  	it {should have_title(user.name)}
  end


  describe "Sign Up" do
  	before {visit signup_path}

	  describe "sign up with no information" do
	  	it "should not increase user count" do
	  		expect{click_button "Create Account"}.not_to change(User, :count)
	  	end
			describe "After Submission" do
				before {click_button "Create Account"}

				it {should have_content("error")}
				it {should have_title(full_title("Sign Up"))}

			end
	  end

	  describe "sign up with valid information should increase user count" do
	  	before {validsignup}

		  it "should increase user count by 1" do
	  		expect { click_button "Create Account" }.to change(User, :count).by(1)
	  	end

	 		describe "after saving the user" do
        before { click_button "Create Account" }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign Out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome to My App!') }
      end

	  end
	end

end
