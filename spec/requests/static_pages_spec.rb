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
    
    
    describe "micropost pluralrization" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "testing") }
      before do
        sign_in user
        visit root_path
      end
      
      
      it { should have_title(full_title(""))}
      it { should have_selector("span", text: "1 micropost") }
      
    end
    
    describe "micropost pluralrization" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "testing") }
      let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "stesting") }
      
      before do
        sign_in user
        visit root_path
      end
      
      
      it { should have_title(full_title(""))}
      it { should have_selector("span", text: "2 microposts") }
      
    end
    
    
    
    describe "micropost pagination" do
      let(:user) { FactoryGirl.create(:user) }
			after(:all) {user.microposts.delete_all}
      
      before do
        31.times { FactoryGirl.create(:micropost, user: user, content: "random") }
        sign_in user
        visit root_url
      end
      
      it { should have_selector('div.pagination')}
      
      it "should have all the microposts" do
        user.microposts.paginate(page: 1).each do |post|
          expect(page).to have_selector('li', text: user.name)
        end
      end
      
    end
    
    describe "follower/following counts" do
      let(:user) {FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      
      before do
        sign_in user
        other_user.follow!(user)
        visit root_path
      end
      
      it { should have_link("0 following", href: following_user_path(user)) }
      it { should have_link("1 followers", href: followers_user_path(user)) }
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
