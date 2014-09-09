require 'spec_helper'

describe "UserPages" do
  let(:user) { FactoryGirl.create(:user) }
	subject {page}

  describe "Sign Up Page" do
  	before {visit signup_path}
  	it{should have_content("Sign Up")}
  	it{should have_title(full_title("Sign Up"))}

  	describe "Signed In Users should not see this page" do
  		let(:user) {FactoryGirl.create(:user)}

  		before do
  			visit signin_path
  			sign_in user
  			visit signup_path
  		end

  		it {should_not have_title(full_title("Sign Up"))}
  	end
  end
  
  describe "follow/unfollow buttons" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { sign_in user }
    
    describe "following a user" do 
      before { visit user_path(other_user) }
      it "should increment the followed user count" do
        expect do
          click_button "Follow"
        end.to change(user.followed_users, :count).by(1)
      end
      
      it "should increment the other user's followers count" do
        expect do
          click_button "Follow"
        end.to change(other_user.followers, :count).by(1)
      end
      
      describe "button toggle" do
        before { click_button "Follow" }
        it { should have_xpath("//input[@value='Unfollow']") }
      end
    end
    
    describe "unfollowing a user" do
      before do
        user.follow!(other_user)
        visit user_path(other_user)
      end
      
      it "should decrement the followed user count" do
        expect do
          click_button "Unfollow"
        end.to change(user.followed_users, :count).by(-1)
      end
      
      it "should decrement the followers count" do
        expect do
          click_button "Unfollow"
        end.to change(other_user.followers, :count).by(-1)
      end
      
      describe "button toggle" do 
        before { click_button "Unfollow" }
        it { should have_xpath("//input[@value='Follow']") }
      end
    end
  end
  
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    
    before { user.follow!(other_user) }
    
    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end
      
      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end
    
    
    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end
      
      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
    
  end

  describe "index page " do
  	before do
	  	sign_in FactoryGirl.create(:user)
	  	FactoryGirl.create(:user, name: "Bob", email: "bobasdf@example.com")
	  	FactoryGirl.create(:user, name: "Tom", email: "tomasdf@example.com")
	  	visit users_path
  	end

  	it { should have_title(full_title("All users"))}
  	it { should have_content("All users")}

  	it "should list each user" do 
  		User.all.each do |user|
  			expect(page).to have_selector('li', text: user.name)
  		end
  	end

  	describe "pagination" do

			before(:all) {31.times {FactoryGirl.create(:user)}}
			after(:all) {User.delete_all}

			it {should have_selector('div.pagination')}

			it "should list each user" do
				User.paginate(page: 1, per_page: 8).each do |user|
					expect(page).to have_selector('li', text: user.name)

				end
			end
		end

		describe "delete links" do
			it {should_not have_link('delete')}

			describe "as admin user" do
				let(:admin) {FactoryGirl.create(:admin)}

				before do 
					sign_in admin
					visit users_path

				end

				it {should have_link('delete', href: user_path(User.first))}
				it "should be able to delete another user" do
					expect do 
						click_link('delete', match: :first)
					end.to change(User, :count).by(-1)
				end
				it {should_not have_link('delete', href: user_path(admin))}
			end

			describe "admin users should not be able to delete themselves" do
				let(:admin) {FactoryGirl.create(:admin)}
				before do
					sign_in admin, no_capybara: true
				end

				specify {expect{ delete user_path(admin) }.not_to change(User, :count)}
			end
		end
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

  	describe "can't directly update admin attribute" do
  		let(:params) do
  			{ user: {admin: true, password: user.password, password_confirmation: user.password} }
  		end
  		before do
  			sign_in user, no_capybara: true
  			patch user_path(user), params
  		end

  		specify { expect(user.reload).not_to be_admin}

  	end
  end

  describe "Profile Page" do
  	let(:user) {FactoryGirl.create(:user)}
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo")}
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar")}
  	before {visit user_path(user)}

  	it {should have_content(user.name)}
  	it {should have_title(user.name)}
    
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
      
    end
    
    describe "accessing a non-existent user's profile should redirect to home page" do
      let(:user) { FactoryGirl.create(:admin) } 
      let(:user2) { FactoryGirl.create(:user, name: "randomtest", email: "randomtestthistoo@asdf.com") }
      
      before do
        sign_in user, no_capybara: true
        delete user_path(user2)
        get user_path(user2)
      end
        
      it "should redirect to home page" do
        expect(response).to redirect_to root_url
      end
    end
    
    
    describe "following/followers count" do
      let(:user2) { FactoryGirl.create(:user) }
      before do
        sign_in user
        user.follow!(user2)
        visit root_path
      end
      
      it { should have_link("1 following", href: following_user_path(user)) }
      it { should have_link("0 followers", href: followers_user_path(user)) }
    end
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

	  describe "Signed In users should not be able to send create action" do
	  	let(:user) {FactoryGirl.create(:user)}
	  	let(:params) do
  			{ user: {name: user.name, email: user.email, password: user.password, password_confirmation: user.password} }
	  	end
	  	before do
	  		visit signin_path
	  		sign_in user, no_capybara: true
	  		post users_path, params
	  	end

	  	specify { expect(response).to redirect_to(root_url)}
	  end
	end


end
