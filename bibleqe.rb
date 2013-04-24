class Index
	def initialize(file, bibleversion)
		@file = File.new(file)
		@bibleversion = bibleversion
		@indexversion = 1
		@delim = self.delim
		@index = self.compile(self.index)
	end
	
	def put; print @index; end
	def write; File.open("out.txt", "w") { |f| f << @index }; end
	def delim; @file.each { |l| return l[8,10].strip if l.match '! delim ' }; end
	
	def index
		index = Hash.new { |hash,key| hash[key] = {:occ=>"",:freq=>0} }
		@file.each { |line| self.line(line, @file.lineno, index) unless line[0] == /[!#>]/ }
		return index
	end
	
	def line(line, lineno, index)
		line.slice!(/.*#{@delim} */)
		line.downcase!
		line.delete!(".,:;()[]{}?!")
		words = line.split
		words.each_index { |ind|
			index[words[ind].to_sym][:occ] << " #{lineno},#{ind + 1}";
			index[words[ind].to_sym][:freq] += 1
		}
	end

	def compile(index)
		out = "! BibleQE Index: #{@bibleversion}\n! version #{@indexversion}"
		index = index.sort_by {|k, v| k }
		index.each { |word, props|
			out << "\n#{word} #{props[:freq]}#{props[:occ]}"
		}
		return out
	end
end

class Search
	def initialize(version)
		@index = File.new(version.to_s + ".index")
		@text  = File.new(version.to_s + ".txt")
	end
	
	def search(word)
		@word = word
		self.word
		self.output
	end
	
	def word
		@word.downcase!
		matches = []
		count = 0
		@index.each do |line|
			if line.match(/^#{@word} /) 
				occ = line.split
				count = occ[1].to_i
				occ = occ.drop(2)
				occ.each { |w|
					w.gsub!(/,.*/,'')
					matches << w.to_i - 1
				}
				break
			end
		end
		@matches = matches
		@count = count 
	end
	
	def output
		puts "Found #{@count} occurances of `#{@word}'" if @count > 1
		puts "Found #{@count} occurance of `#{@word}'" if @count == 1
		lines = @text.readlines
		@matches.each { |match|
			puts lines[match]
		}
	end
end

Index.new("faith.txt","KJV test").write

#search = Search.new(:kjv)
#search.search "Nicodemus"