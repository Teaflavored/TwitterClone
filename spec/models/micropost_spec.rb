require 'spec_helper'

describe Micropost do
	let(:user) {FactoryGirl.create(:user)}
 	before {@micropost =user.microposts.build(content: "test", user_id: user.id)}

 	subject {@micropost}

 	it { should respond_to(:content)}
 	it { should respond_to(:user_id)}
 	its(:user) { should eq user}
 	it { should be_valid}


 	describe "user id has to be present" do
 		before {@micropost.user_id=nil}
 		it {should_not be_valid}
 	end

 	describe "content has to be present" do 
 		before { @micropost.content = "" }
 		it { should_not be_valid}
 	end

 	describe "content cannot be over 140 char" do
 		before { @micropost.content = "a"*141 }
 		it { should_not be_valid }
 	end
end
