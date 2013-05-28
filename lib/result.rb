class Result	
	def initialize(version, query)
		@text  = Text.new(version)
		@index = Index.new(version)
		@query = query

		result = self.get
		@count = result.uniq.count
		@matches = result.uniq
	end
	
	def get
		return @index[@query[0]].uniq if @query.count == 1
		
		matches = []
		result = []
		@query.each {|w| matches += @index[w]}
		matches.each {|r|
			result << r if matches.select {|n| n == r}.count >= @query.count
		}
		
		result.uniq
	end
	
	def matches
		return "Nothing to be searched for!" if @query.count == 0
		verse = @count == 1 ? "verse" : "verses"
		"Found #{@count} #{verse} matching: #{@query.join(", ")}"
	end
	
	def show(range = nil)
		result = []
		matches = @matches[range] if range.is_a? Range
		matches ||= @matches
		matches.each { |match| result << @text[match] }
		result.unshift("Showing results #{range}") if range.is_a? Range
		result
	end
end
