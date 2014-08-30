module StaticPagesUtilities

	RSpec::Matchers.define :have_right_page do |heading, title|
		match do |page|
			expect(page).to have_selector('h1', heading)
			expect(page).to have_title(full_title(title))
		end
	end

end