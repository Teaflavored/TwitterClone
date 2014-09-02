module ApplicationHelper
	def full_title(title)
		base = "My App"
		if title.empty?
			base
		else
			"#{base} | #{title}"
		end
	end
end
