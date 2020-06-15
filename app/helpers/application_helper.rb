module ApplicationHelper
	# Returns the full title on a per-page basis.
	def full_title(page_title = '')
		base_title = "Hup Soon Cheong Services"
		if page_title.empty?
		  base_title
		else
		  "#{page_title} | #{base_title}"
		end
	end

	def date_modifier date_obj = '', mod = "%d %b %Y"

    date_obj = date_obj.blank? ? '' : date_obj.strftime(mod)

		return date_obj
	end

end
