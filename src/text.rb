class Text
  attr_reader :content, :symbol

  def initialize(name, dir = :texts)
    unless File.exists? "./#{dir}/#{name}.txt"
      raise LoadError, "Can't find #{name}.txt" 
    end
    @content = File.new("./#{dir}/#{name}.txt")
    @symbol = name
  end

  def name
    @content.rewind
    @content.each {|l| return l[7,255].strip if l.match '! name '}
    raise SyntaxError, "No `name' property found in #{@content.path}"
  end

  def strip
    @content.rewind
    @content.each {|l| return l[8,16].strip if l.match '! strip '}
    ".,:;()[]{}<>?!¶" # Default string for `strip'
  end

  def [](lineno)
    @content.rewind if @content.lineno > lineno
    skip = lineno - @content.lineno
    skip.times { @content.readline }
    @content.readline

    #using @content.readlines.fetch(lineno) to get results for "aaron"
    #=> 0.640625
    #skipping lines + continuing at last pointer
    #=> 0.234375
  end

  def fetch_by_ref(ref)
    @content.rewind

    @content.each do |l|
      return [[l.slice!(Verse.reference_pattern), l]] if l.match /^#{ref} /i
    end

    nil
  end
end
