require 'spec_helper'

describe User do
  before { @user=User.new(name: "Example User", email: "user@example.com", 
    username: "teaflavored", password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it {should respond_to_user_attributes}
  it {should be_valid}
  describe "following" do
    
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(user2)
      user3.follow!(@user)
    end
    
    it { should be_following(user2) }
    its(:followed_users) { should include(user2) }
    
    describe "other user's followers" do
      subject { user2 }
      its(:followers) { should include(@user) }
    end
    
    describe "unfollowing" do
      before do
        @user.unfollow!(user2)
      end
      
      it { should_not be_following(user2) }
      its(:followed_users) { should_not include(user2) }
      
      describe "other user's followers" do
        subject { user2 }
        its(:followers) { should_not include(@user) }
      end
    end
    
    
    describe "destroy user should remove it as follower" do
      before do
        @user.destroy
      end
      
      it { should_not be_following(user2) }
      
      describe "destroying user should remove it from followed" do
        it { should_not be_followed(user3) }
      end

    end
    
  end
  
  describe "micropost association" do
    before {@user.save}


    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end

    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have micropost in right order" do
      expect(@user.microposts).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts  = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty

      microposts.each do |post|
        expect(Micropost.where(id: post.id)).to be_empty
      end

    end
    
 
    describe "status" do
      
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }
      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "hi") }
      end
      
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |post|
          should include(post)
        end
      end
    end
  end

  describe "when username is not valid" do
    describe "presence of username" do
      before do
        @user.username = ""
        @user.save
      end
      it { should_not be_valid}
    end
    
    describe "username has space in it" do
      before do
        @user.username = "teaflavored hi"
        @user.save
      end
      it { should_not be_valid }
    end
    
    describe "username is either too long or too short" do
      before do
        @user.username = "adf"
        @user.save
      end
      
      it { should_not be_valid }
      
      describe "username too long" do
        before do
          @user.username = "a"*17
          @user.save
        end
        it { should_not be_valid }
      end
    end
  end
  
  describe "no duplicate usernames" do
    before do
      user2 = @user.dup
      user2.username = user2.username.upcase
      user2.save
    end
    
    it { should_not be_valid }
  end
  
  describe "username is case insensitive" do
    let(:randomname) { "fFdSgSdDxX" }
    before do
      @user.username = randomname
      @user.save
    end
    
    specify { expect(@user.reload.username).to eq(randomname.downcase) }
  end
  
  describe "with admin attribute set to true" do
    before do
      @user.save
      @user.toggle(:admin)
    end
    it {should be_admin}
  end

  describe "remember_token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end

  describe "return value of authenticate" do
  	before {@user.save}
  	let(:found_user) {User.find_by(email: @user.email)}

  	describe "valid pw" do
  		it {should eq found_user.authenticate(@user.password)}
  	end

  	describe "invalid pw" do
  		let(:user_with_invalid_pw) {found_user.authenticate("invalid")}

  		it {should_not eq user_with_invalid_pw}
  		specify {expect(user_with_invalid_pw).to be_false}
  	end
  end

  describe "password shorter than 6" do
  	before {@user.password = "asdfg"}
  	it {should be_invalid}
  end

  describe "When name is not given" do
  	before {@user.name = ""}
  	it {should_not be_valid}
  end

  describe "When passwords don't match" do
  	before do
  		@user.password_confirmation= "mismatch"
  	end

  	it {should_not be_valid}

  end

  describe "When Password is not Present" do
  	before do
  		@user=User.new(name: "Example", email: "Example@example.com", password: " ", password_confirmation: " ")
  	end
  	it {should_not be_valid}
  end

  describe "When email is not given" do
  	before {@user.email = ""}
  	it {should_not be_valid}
  end

  describe "When name is too short" do
  	before {@user.name = "a"*51}
  	it {should_not be_valid}
  end

  describe "when email is invalid" do
  	it "should be invalid" do
  		addresses= %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |a|
      	@user.email = a
      	expect(@user).not_to be_valid
      end
  	end
  end

  describe "when email is valid" do
  	it "should be valid" do
  		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  		addresses.each do |a|
  			@user.email = a
  			expect(@user).to be_valid
  		end
  	end
  end

  describe "no duplicate entries in database" do

  	before do
  		user=@user.dup
  		user.email  = @user.email.upcase
  		user.save
  	end

  	it {should_not be_valid}
  end

  describe "email address case should not affect uniquness" do
  	let(:randomcase) { "ASDF@ASDF.com" }

  	it "should be saved into database as all lowercase" do
  		@user.email = randomcase
  		@user.save
  		expect(@user.reload.email).to eq(randomcase.downcase)
  	end
  end



end
