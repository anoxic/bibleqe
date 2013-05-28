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
		result = []
		@matches.each { |match| result << @text[match] }
		result
	end
end
