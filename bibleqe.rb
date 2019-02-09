require_relative './src/bibleqe.rb'
require_relative './src/text.rb'
require_relative './src/index.rb'
require_relative './src/index_builder.rb'
require_relative './src/search.rb'
require_relative './src/result.rb'
require_relative './src/shell.rb'
require_relative './src/parse.rb'
require_relative './src/verse.rb'

if __FILE__ == $0
  Shell.new(ARGV)
end
