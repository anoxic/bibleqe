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
