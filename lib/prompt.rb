class Prompt
	def initialize(*args)
		result = Result.new(:kjv, args.join(" "))
		puts result.matches
		puts ""
		puts result.show(1..10)
	end
end