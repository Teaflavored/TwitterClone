require 'spec_helper'

describe "MicropostPages" do
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "micropost creation" do
    before { visit root_path }
    
    describe "invalid post" do
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end
    end
    
    describe "valid post" do
      before { fill_in "Content", with: "asdfasdf"}
      
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  
  
  describe "micropost deletion" do
    let(:user2) { FactoryGirl.create(:user, email: "secondtesting@testing.org")}
    let(:post_to_be_deleted) { FactoryGirl.create(:micropost, user: user)}
    
    before do
       sign_in user2, no_capybara: true
       delete micropost_path(post_to_be_deleted)
     end
    
    it "should not be able to delete" do
      expect(response).to redirect_to user2
    end
    
    describe "deletion should work if done by the correct user" do
      
      before do
        sign_in user
        visit root_path
      end
      
      it { should have_content("delete")}
      specify { expect { click_link "delete"}.to change(Micropost, :count).by(-1) }
    end
  end 
end
