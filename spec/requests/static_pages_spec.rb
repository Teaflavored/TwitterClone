require 'spec_helper'

describe "StaticPages" do
  subject { page }


  describe "Home Page" do
    before {visit root_path}
    let(:heading) {"Welcome"}
    let(:pagetitle) {""}
    it {should have_right_page(heading,pagetitle)}
    
    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "asdfasdf")
        FactoryGirl.create(:micropost, user: user, content: "testing2")
        sign_in user
        visit root_path
      end
      
      it "should render user's feed" do
        user.feed.each do |i|
          expect(page).to have_selector("li##{i.id}", text: i.content)
        end
      end
    end
  end

  describe "Help Page" do
  	before {visit help_path}
    let(:heading) {"Help"}
    let(:pagetitle) {"Help"}
    it {should have_right_page(heading,pagetitle)}
  end

  describe "About Page" do
  	before {visit about_path}
    let(:heading) {"About"}
    let(:pagetitle) {"About"}
    it {should have_right_page(heading,pagetitle)}
  end

  describe "Contact Page" do
    before {visit contact_path}
    let(:heading) {"Contact"}
    let(:pagetitle) {"Contact"}
    it {should have_right_page(heading,pagetitle)}
  end

  describe "Links" do
    it "should link to right places" do
      visit root_path
      click_link "About"
      expect(page).to have_title(full_title("About"))
      click_link "Contact"
      expect(page).to have_title(full_title("Contact"))
      click_link "Help"
      expect(page).to have_title(full_title("Help"))
      click_link "Home"
      expect(page).to have_title(full_title(""))
      click_link "Sign Up"
      expect(page).to have_title(full_title("Sign Up"))
      click_link "My App"
      expect(page).to have_title(full_title(""))
      click_link "Sign In"
      expect(page).to have_title(full_title("Sign In"))
    end
  end

end
