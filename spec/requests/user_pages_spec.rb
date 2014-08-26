require 'spec_helper'

describe "UserPages" do

	subject {page}

  describe "Sign Up Page" do
  	before {visit signup_path}
  	it{should have_content("Sign Up")}
  	it{should have_title(full_title("Sign Up"))}
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
	  end

	  describe "sign up with valid information should increase user count" do
	  	before do 
		  	fill_in "Name", with: "Auster"
		  	fill_in "Email", with: "Auster.s.chen@gmail.com"
		  	fill_in "Password", with: "asdfasdf"
		  	fill_in "Confirmation", with: "asdfasdf"
		  end
		  it "should increase user count by 1" do
	  		expect { click_button "Create Account" }.to change(User, :count).by(1)
	  	end
	  end
	end
end
