class Text
	attr_reader :text, :symbol
	
	def initialize(name, dir = :texts)
		raise LoadError, "Can't find #{name}.txt" unless File.exists? "./#{dir}/#{name}.txt"
		
		@text = File.new("./#{dir}/#{name}.txt").readlines
		@symbol = name
	end
	
	def delim
		@text.each {|l| return l[8,16].strip if l.match '! delim '}
	end

	def strip
		@text.each {|l| return l[8,16].strip if l.match '! strip '}
	end

	def name
		@text.each {|l| return l[7,255].strip if l.match '! name '}
	end
	
	def [](lineno)
		@text.fetch(lineno)
	end
end

class Index
	attr_reader :index, :symbol
	
	def initialize (name, dir = :texts)
		raise LoadError, "Can't find #{name}.txt" unless File.exists? "./#{dir}/#{name}.txt"
		IndexBuilder.new(name, dir).write unless File.exists? "./#{dir}/#{name}.ind"
				
		@index = File.new("./#{dir}/#{name}.ind").readlines
		@symbol = name
	end
	
	def [](term)
		word = term.downcase
		matches = []
		@index.each do |line|
			if line.match(/^#{word} /) 
				refs = line.split.drop(1)
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
	def initialize(name, dir = :texts)
		@name = name
		@dir = dir
		text = Text.new(name, dir)
		@delim = text.delim
		@longversion = text.name
		@strip = text.strip
		@text  = File.new("./#{dir}/#{name}.txt") # @todo swith to Text
		@indexversion = 1
		@index = self.index
		@compiled = self.compile
		@range = self.range
		@compiled_range = self.compile_range
	end
	
	def put
		print @compiled
	end
	
	def write
		File.open("#{@dir}/#{@name}.ind", "w") { |f| f << @compiled }
		File.open("#{@dir}/#{@name}_toc.ind", "w") { |f| f << @compiled_range }
	end
	
	def range(l = nil)
		words = @index.flatten.select {|x| x.is_a? Symbol }
		chars = Hash.new {|k,v| k[v] = Array.new(0) }
		words.each { |w|
			letter = w.to_s[0].to_sym
			chars[letter][0] ||= words.index(w) + 2
			chars[letter][1] = words.index(w) + 2
		}
		return chars[l.to_sym] unless l == nil
		chars
	end
	
	def index
		occurances = Hash.new{|h,k| h[k] = String.new}
		
		@text.each { |line|
			self.line(line, @text.lineno, occurances) unless line.start_with?('!','>','#') 
		}
		occurances
	end
	
	def line(line, lineno, index)
		line.slice!(/.*#{@delim} */)
		line.downcase!
		line.delete!(@strip)
		words = line.split
		words.each_index { |x| index[words[x].to_sym] << " #{lineno},#{x + 1}"; }
	end

	def compile
		out = "! BibleQE Index: #{@longversion}\n! version #{@indexversion}"
		@index = @index.sort
		@index.each { |word, occ|
			out << "\n#{word}#{occ}"
		}
		out
	end
	
	def compile_range
		out = "! BibleQE Index TOC: #{@longversion}\n! version #{@indexversion}"
		@range.each { |letter, range|
			out << "\n#{letter} #{range[0]}..#{range[1]}"
		}
		out
	end
end

class Result	
	def initialize(version, query)
		@text  = Text.new(version)
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
		@matches.each { |match| show += @text[match] }
		show
	end
end

if __FILE__ == $0
	IndexBuilder.new(:kjv).write
	# result = Result.new(:pce2, ARGV.join(" "))
	# puts result.matches
	# puts result.show
end