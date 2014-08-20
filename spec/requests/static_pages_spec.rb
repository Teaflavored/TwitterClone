require 'spec_helper'

describe "StaticPages" do


  describe "Home Page" do
    it "Should have content My App" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit '/static_pages/home'
      expect(page).to have_content('My App')
      expect(page).to have_title('My App | Home')
    end
  end

  describe "Help Page" do
  	it "should have the content Help" do
  		visit '/static_pages/help'
  		expect(page).to have_content('Help')
  		expect(page).to have_title('My App | Help')
  	end
  end

  describe "About Page" do
  	it "should have the content About" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About')
  		expect(page).to have_title('My App | About')
  	end
  end
end
