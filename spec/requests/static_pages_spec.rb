require 'spec_helper'

describe "StaticPages" do

	let (:basetitle) {'My App'}
  
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
  		visit '/static_pages/help'
  		expect(page).to have_content('Help')
  		expect(page).to have_title("#{basetitle} | Help")
  	end
  end

  describe "About Page" do
  	it "should have the content About" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About')
  		expect(page).to have_title("#{basetitle} | About")
  	end
  end

  describe "Contact Page" do
  	it "should have content" do 
  		visit '/static_pages/contact'
  		expect(page).to have_content("Contact")
  	end

  	it "should have title" do
  		visit '/static_pages/contact'
  		expect(page).to have_title("#{basetitle} | Contact")
  		#expect(page).not_to have_title(' My App | ')
  	end

  end
end