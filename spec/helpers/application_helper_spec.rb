require 'spec_helper.rb'


describe ApplicationHelper do
	subject {full_title(heading)}

	describe "full_title" do 
		let(:heading) {"foo"}
		it {should match(/foo/)}
		it {should match(/^My App/)}
		describe "No title given" do
			let(:heading) {""}
			it {should_not match(/\|/)}
		end
	end
end