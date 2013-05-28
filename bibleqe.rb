require './lib/text.rb'
require './lib/index.rb'
require './lib/index_builder.rb'
require './lib/result.rb'

if __FILE__ == $0
	result = Result.new(:pce2, ARGV.join(" "))
	puts result.show
	puts ""
	puts result.matches
end
