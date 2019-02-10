class Result
  attr_accessor :limit

  def initialize(version, query, limit = 10)
    @text  = Text.new(version)
    @index = Index.new(version)
    @query = query
    @query = query.split if query.is_a? String
    @limit = limit.to_i

    @query = self.expand(@query)
    result = self.get
    @count = result.uniq.count
    @matches = result.uniq
  end

  def matches
    self.show.count
  end

  def query
    @query.join("|").split("|").sort.reverse
  end

  def matches_verbose
    return "Nothing to be searched for!" if @query.count == 0
    verse = @count == 1 ? "verse" : "verses"
    "Found #{@count} #{verse} matching: #{@query.join(", ")}"
  end

  def list
    list = []
    self.show.each { |verse| list << verse[0] }
    list
  end

  def show(range = nil)
    result = []

    matches = @matches[range] if range.is_a? Range
    matches ||= @matches

    matches.sort.each do |match|
      match = @text[match]
      result << [match.slice!(Text::ReferencePattern), match]
    end

    result
  end

  def show!(range = nil)
    Verse.format(show(range))
  end

  def show_by_page(pagenum, format = nil)
    pagenum = pagenum.to_i
    raise_by = pagenum * @limit
    range = 1..@limit
    range = range.min + raise_by..range.max + raise_by if pagenum > 1

    return self.show!(range) if format
    self.show(range)
  end

  def show_by_page!(pagenum)
    self.show_by_page(pagenum, true)
  end

  protected

  def expand(query)
    expanded = []
    query.map! do |q|
      next q unless q.match /[*?]/
      if x = self.regex("/" + q.gsub(/[*?]/, "*"=>".*", "?"=>".?") + "/")
        expanded << x
        next false
      end
      q
    end
    query.select! {|q| q }
    query + expanded
  end

  def regex(regexp)
    matches = []
    regex = Regexp.new(regexp.tr('/',''))

    @index.words.each do |word|
      raise Error, "#{regexp}: matched too many words" if matches.count > 20
      matches << word if word[regex] == word
    end

    return matches.join "|" if matches.count > 0
    nil
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
end
