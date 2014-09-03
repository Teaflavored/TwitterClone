require 'spec_helper'

describe User do
  before {@user=User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")}

  subject {@user}

  it {should respond_to_user_attributes}
  it {should be_valid}

  describe "micropost association" do
    before {@user.save}


    let!(:older_micrpost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end

    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have micropost in right order" do
      expect(@user.microposts).to eq [newer_micropost, older_micrpost]
    end

    it "should destroy associated microposts" do
      microposts  = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty

      microposts.each do |post|
        expect(Micropost.where(id: post.id)).to be_empty
      end

    end
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
