class IndexBuilder
  def initialize(name, dir = :texts)
    t = Text.new(name, dir)

    @indexversion   = 1

    @name           = name
    @dir            = dir
    
    @long_name      = t.name
    @delim          = t.delim
    @strip          = t.strip
    @text           = t.content

    @index          = self.index
    @range          = self.range
    @words          = self.words
  end
  
  def put!
    print self.compile
  end
  
  def write!
    File.open("#{@dir}/#{@name}.ind", "w") { |f| f << self.compile }
    File.open("#{@dir}/#{@name}_toc.ind", "w") { |f| f << self.compile_range }
    File.open("#{@dir}/#{@name}_words.lst", "w") { |f| f << self.compile_words }
  end
  
  def line(line, lineno, index)
    line.slice!(/^[a-zA-Z0-9]{1,4} [0-9]{1,3}:[0-9]{1,3} /)
    line.downcase!
    line.delete!(@strip)

    line.split.each do |k,v|
      index[k.to_sym] << " #{lineno},#{v.to_i + 1}"
    end
  end

  def index
    occurances = Hash.new{|h,k| h[k] = String.new}
    
    @text.each do |line|
      self.line(line, @text.lineno, occurances) unless line.start_with?('!','>','#') 
    end

    occurances
  end
  
  def compile
    out = "! BibleQE Index: #{@long_name}\n! version #{@indexversion}"
    @index = @index.sort
    @index.each { |word, occ|
      out << "\n#{word}#{occ}"
    }
    out
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
  
  def compile_range
    out = "! BibleQE Index TOC: #{@long_name}\n! version #{@indexversion}"
    @range.each { |letter, range|
      out << "\n#{letter} #{range[0]}..#{range[1]}"
    }
    out
  end

  def words
    words = []
    @index.each {|l| words << l[0] }
    words
  end

  def compile_words
    @words.join " "
  end
end
