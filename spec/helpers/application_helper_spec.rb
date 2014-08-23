require 'spec_helper.rb'


describe ApplicationHelper do
	describe "full_title" do 

		it "should include the page title" do 
			expect(full_title("foo")).to match(/foo/)
		end

		it "should include the base title" do
			expect(full_title("foo")).to match(/^My App/)
		end

		it "should not include bar" do
			expect(full_title("")).not_to match(/\|/)
		end
	end
end