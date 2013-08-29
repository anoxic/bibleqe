class Result	
	def initialize(version, query, results_per_page = 10)
		@text  = Text.new(version)
		@index = Index.new(version)
		@query = query
		@query = query.split if query.is_a? String
		@results_per_page = results_per_page.to_i

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
		result
	end
	
	def show_by_page(pagenum)
		pagenum = pagenum.to_i
		raise_by = pagenum * @results_per_page
		range = 1..@results_per_page
		range = range.min + raise_by..range.max + raise_by if pagenum > 1
		self.show(range)
	end
end
