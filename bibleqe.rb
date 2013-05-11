class Index
	def initialize(version, longversion)
		@version = version
		@text  = File.new(version.to_s + ".txt")
		@longversion = longversion
		@indexversion = 1
		@delim = self.delim
		@index = self.compile(self.index)
	end
	
	def put; print @index; end
	def write; File.open(@version.to_s + ".index", "w") { |f| f << @index }; end
	def delim; @text.each { |l| return l[8,10].strip if l.match '! delim ' }; end
	
	def index
		index = Hash.new { |hash,key| hash[key] = {:occ=>"",:freq=>0} }
		@text.each { |line| 
			self.line(line, @text.lineno, index) unless line.start_with?('!','>','#') 
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
	attr_accessor :matches
	def initialize(version, word)
		index = File.new(version.to_s + ".index")
		word.downcase!
		matches = []
		index.each do |line|
			if line.match(/^#{word} /) 
				refs = line.split.drop(2)
				refs.each { |r|
					r.gsub!(/,.*/,'')
					matches << r.to_i - 1
				}
				break
			end
		end
		@matches = matches
	end
end

class Result	
	def initialize(version, query)
		result = self.get(version, query)
		@text  = File.new(version.to_s + ".txt")
		@words = query.split
		@count = result.uniq.count
		@matches = result.uniq
	end
	
	def get(version, query)
		words = query.split
		return Search.new(version,words.fetch(0)).matches.uniq if words.count == 1
		matches = []
		result = []
		words.each {|w|
			matches += Search.new(version,w).matches.uniq
		}
		matches.each {|r|
			result << r if matches.select {|n| n == r}.count >= words.count
		}
		
		result.uniq
	end
	
	def matches
		return "Nothing to be searched for!" if @words.count == 0
		verse = @count == 1 ? "verse" : "verses"
		"Found #{@count} #{verse} matching: #{@words.join(", ")}"
	end
	
	def show
		verse = @text.readlines
		show = "\n"
		@matches.each { |match| show += verse.fetch(match) }
		show
	end
end

if __FILE__ == $0
	# Index.new(:kjv,"KJV test").write
	result = Result.new(:kjv, ARGV.join(" "))
	puts result.matches
	puts result.show
end