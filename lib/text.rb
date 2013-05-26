class Text
	attr_reader :text, :symbol
	
	def initialize(name, dir = :texts)
		raise LoadError, "Can't find #{name}.txt" unless File.exists? "./#{dir}/#{name}.txt"
		
		@text = File.new("./#{dir}/#{name}.txt")
		@symbol = name
	end

	def name
		@text.rewind
		@text.each {|l| return l[7,255].strip if l.match '! name '}
	end
	
	def delim
		@text.rewind
		@text.each {|l| return l[8,16].strip if l.match '! delim '}
	end

	def strip
		@text.rewind
		@text.each {|l| return l[8,16].strip if l.match '! strip '}
		".,:;()[]{}?!"
	end
	
	def [](lineno)
		@text.rewind if @text.lineno > lineno
		skip = lineno - @text.lineno
		skip.times { @text.readline }
		@text.readline
		
		#using @text.readlines.fetch(lineno) to get results for "aaron"
		#=> 0.640625
		#skipping lines + continuing at last pointer
		#=> 0.234375
	end
end
