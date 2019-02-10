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
    Result.format(show(range))
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

  def Result.format(raw)
    formatted = []

    raw.map do |verse|
      verse[0][/\w+/] = Parse.new.get_long_name(verse[0][/\w+/])

      formatted << wrap(verse.join($/), 75)
      formatted << ''
    end

    formatted
  end

  # Wrap string by the given length, and join it with the given character.
  # The method doesn't distinguish between words, it will only work based on
  # the length. The method will also strip and whitespace.
  # (from https://www.ruby-forum.com/topic/57805)
  #
  def Result.wrap(str, length = 80, character = $/)
    str.scan(/\S.{0,#{length}}\S(?=\s|$)|\S+/).map { |x| x.strip }.join(character)
  end
end
