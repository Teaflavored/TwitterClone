module UserPagesUtilities

	def validsignup
		fill_in "Name", with: "Auster Chen"
		fill_in "Email", with: "user@example.com"
		fill_in "Password", with: "asdfasdf"
		fill_in "Confirmation", with: "asdfasdf"
	end

	def invalidsignup
		fill_in "Name", with: ""
		fill_in "Email", with: ""
		fill_in "Password", with: "123"
		fill_in "Confirmation", with: "123"
	end

end