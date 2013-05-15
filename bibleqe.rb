class Text
	attr_reader :text, :symbol
	
	def initialize(name, dir = :texts)
		raise TextNotFoundError, "Can't find #{name}.txt" unless File.exists? "./#{dir}/#{name}.txt"
		
		@text = File.new("./#{dir}/#{name}.txt").readlines
		@symbol = name
	end
	
	def delim
		@text.each {|l| return l[8,16].strip if l.match '! delim '}
	end

	def name
		@text.each {|l| return l[7,255].strip if l.match '! name '}
	end
end

class Index
	attr_reader :index, :symbol
	
	def initialize (name, dir = :texts)
		raise TextNotFoundError, "Can't find #{name}.txt" unless File.exists? "./#{dir}/#{name}.txt"
		IndexBuilder.new(name, dir) unless File.exists? "./#{dir}/#{name}.ind"
				
		@index = File.new("./#{dir}/#{name}.ind").readlines
		@symbol = name
	end
	
	def [](term)
		word = term.downcase
		matches = []
		@index.each do |line|
			if line.match(/^#{word} /) 
				refs = line.split.drop(2)
				refs.each { |r|
					r.gsub!(/,.*/,'')
					matches << r.to_i - 1
				}
				break
			end
		end
		matches.uniq
	end
end

class IndexBuilder
	def initialize(name, dir)
		@name = name
		@dir = dir
		@text  = File.new("./#{dir}/#{name}.txt")
		@longversion = "Kind James Version"
		@indexversion = 1
		@delim = self.delim
		@index = self.compile(self.index)
		self.write
	end
	
	def put; print @index; end
	def write; File.open("#{@dir}/#{@name}.ind", "w") { |f| f << @index }; end
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

class Result	
	def initialize(version, query)
		@text  = Text.new(version).text
		@index = Index.new(version)
		@words = query.split

		result = self.get
		@count = result.uniq.count
		@matches = result.uniq
	end
	
	def get
		return @index[@words[0]].uniq if @words.count == 1
		
		matches = []
		result = []
		@words.each {|w| matches += @index[w]}
		matches.each {|r|
			result << r if matches.select {|n| n == r}.count >= @words.count
		}
		
		result.uniq
	end
	
	def matches
		return "Nothing to be searched for!" if @words.count == 0
		verse = @count == 1 ? "verse" : "verses"
		"Found #{@count} #{verse} matching: #{@words.join(", ")}"
	end
	
	def show
		show = "\n"
		@matches.each { |match| show += @text.fetch(match) }
		show
	end
end

class TextNotFoundError < RuntimeError
end

if __FILE__ == $0
	# Index.new(:kjv)
	result = Result.new(:kjv, ARGV.join(" "))
	puts result.matches
	puts result.show
	#Text.new(:kjv)
end