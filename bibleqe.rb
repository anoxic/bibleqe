class Index
	def initialize(version, longversion)
		@version = version
		@text  = File.new(version.to_s + ".txt")
		@longversion = longversion
		@indexversion = 1
		@delim = self.delim
		@index = self.compile(self.index)
		puts @text.path
	end
	
	def put; print @index; end
	def write; File.open(@version.to_s + ".index", "w") { |f| f << @index }; end
	def delim; @text.each { |l| return l[8,10].strip if l.match '! delim ' }; end
	
	def index
		index = Hash.new { |hash,key| hash[key] = {:occ=>"",:freq=>0} }
		@text.each { |line| 
			self.line(line, @text.lineno, index) unless line[0].match(/!|>|\#/) 
		}
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
		out = "! BibleQE Index: #{@longversion}\n! version #{@indexversion}"
		index = index.sort_by {|k, v| k }
		index.each { |word, props|
			out << "\n#{word} #{props[:freq]}#{props[:occ]}"
		}
		return out
	end
end

class Search
	attr_accessor :matches, :count
	
	def initialize(version)
		@index = File.new(version.to_s + ".index")
		@text  = File.new(version.to_s + ".txt")
	end
	
	def search(word)
		@word = word
		self.word
	end
	
	def word
		@word.downcase!
		matches = []
		count = 0
		@index.each do |line|
			if line.match(/^#{@word} /) 
				x = line.split
				count = x[1].to_i
				refs = x.drop(2)
				refs.each { |r|
					r.gsub!(/,.*/,'')
					matches << r.to_i - 1
				}
				break
			end
		end
		@matches = matches
		@count = count 
	end
	
	def output
		verse = @text.readlines
		puts "Found #{@count} occurances of `#{@word}'" if @count > 1
		puts "Found #{@count} occurance of `#{@word}'" if @count == 1
		@matches.each { |match|
			puts verse.fetch(match)
		}
	end
end

#Index.new(:kjv,"KJV test").write

search = Search.new(:kjv)
search.search "Nicodemus"
search.output