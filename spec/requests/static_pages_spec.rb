require 'spec_helper'

describe "StaticPages" do

  let(:basetitle) {"My App"}
  describe "Home Page" do
    it "Should have content My App" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit root_path
      expect(page).to have_content('My App')
      expect(page).to have_title("#{basetitle} | Home")
    end
  end

  describe "Help Page" do
  	it "should have the content Help" do
  		visit help_path
  		expect(page).to have_content('Help')
  		expect(page).to have_title("#{basetitle} | Help")
  	end
  end

  describe "About Page" do
  	it "should have the content About" do
  		visit about_path
  		expect(page).to have_content('About')
  		expect(page).to have_title("#{basetitle} | About")
  	end
  end

  describe "Contact Page" do
    it "should have the content Contact" do
      visit contact_path
      expect(page).to have_content("Contact")
    end

    it "should have the title Contact" do
      visit contact_path
      expect(page).to have_title("#{basetitle} | Contact")
    end
  end
end
