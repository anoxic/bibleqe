class Prompt
	def initialize(*args)
		result = Result.new(:kjv, args.flatten)
		puts result.matches
		puts ""
		puts result.show(1..10)
	end
end