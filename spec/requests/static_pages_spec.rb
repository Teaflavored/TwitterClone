require 'spec_helper'

describe "StaticPages" do

  subject{page}

  shared_examples_for "All Static Pages" do
    it {should have_selector("h1", heading)}
    it {should have_title(full_title(pagetitle))}
  end

  describe "Home Page" do
    before {visit root_path}
    let(:heading) {"My App"}
    let(:pagetitle) {""}
    it_should_behave_like "All Static Pages"
    it {should_not have_title("| Home")}
  end

  describe "Help Page" do
  	before {visit help_path}
    let(:heading) {"Help"}
    let(:pagetitle) {"Help"}
    it_should_behave_like "All Static Pages"
  end

  describe "About Page" do
  	before {visit about_path}
    let(:heading) {"About"}
    let(:pagetitle) {"About"}
    it_should_behave_like "All Static Pages"
  end

  describe "Contact Page" do
    before {visit contact_path}
    let(:heading) {"Contact"}
    let(:pagetitle) {"Contact"}
    it_should_behave_like "All Static Pages"
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
    end
  end

end
