class Prompt
	def initialize(*args)
		result = Result.new(:kjv, args.flatten)
		puts result.matches
		puts ""
		puts result.show_by_page(1)
	end
end