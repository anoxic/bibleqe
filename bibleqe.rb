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
	attr_accessor :count, :matches, :verses
	
	def initialize(version, query)
		result = self.get(version, query)
		@text  = File.new(version.to_s + ".txt")
		@words = query.split
		@count = result.count
		@matches = result.uniq
		@verses = result.uniq.count
	end
	
	def get(version, query)
		words = query.split
		results = []
		result = []
		words.each { |w|
			search = Search.new(version,w)
			results += search.matches
		}
		if words.count > 1
			results.each { |r|
				count = results.select {|num| num == r }.count
				result += [r] if count > 1
			}
		else
			result = results
		end
		result
	end
	
	def put
		verse = @text.readlines
		words = @words.map {|w| "`#{w}'"}.join(", ")
		m = "matches"
		m = "match" if @count == 1
		v = "verses"
		v = "verse" if @verses == 1
		puts "Found #{@count} #{m} for #{words} in #{@verses} #{v}."
		@matches.each { |match| puts verse.fetch(match) }
	end
end

#Index.new(:kjv,"KJV test").write

result = Result.new(:kjv, "nicodemus")
result.put