require_relative './lib/bibleqe.rb'
require_relative './lib/text.rb'
require_relative './lib/index.rb'
require_relative './lib/indexer.rb'
require_relative './lib/search.rb'
require_relative './lib/result.rb'
require_relative './lib/shell.rb'
require_relative './lib/parse.rb'

if __FILE__ == $0
  Shell.new(ARGV)
end
