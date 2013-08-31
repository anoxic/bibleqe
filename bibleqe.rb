require './lib/bibleqe.rb'
require './lib/text.rb'
require './lib/index.rb'
require './lib/index_builder.rb'
require './lib/result.rb'
require './lib/prompt.rb'

if __FILE__ == $0
	Prompt.new(ARGV)
end
