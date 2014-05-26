class IndexBuilder
  def initialize(name, dir = :texts)
    t = Text.new(name, dir)

    @bqe_version    = 2
    @name           = name
    @dir            = dir
    @long_name      = t.name
    @strip          = t.strip
    @text           = t.content
  end
  
  def put!
    print self.compile
  end
  
  def write!
    File.open("#{@dir}/#{@name}.ind", "w") { |f| f << self.compile }
    File.open("#{@dir}/#{@name}_toc.ind", "w") { |f| f << self.compile_range }
    File.open("#{@dir}/#{@name}_words.lst", "w") { |f| f << self.compile_words }
    true
  end
  
  def index
    return @index if @index

    occurances = Hash.new{|h,k| h[k] = String.new}
    
    @text.each do |line|
      next unless line.match(/^[a-zA-Z0-9]{1,4} [0-9]{1,3}:[0-9]{1,3} /)

      line.slice!(/^[a-zA-Z0-9]{1,4} [0-9]{1,3}:[0-9]{1,3} /)
      line.downcase!
      line.delete!(@strip)

      line.split.map.with_index do |k,v|
        occurances[k.to_sym] << " #{@text.lineno},#{v.to_i + 1}"
      end
    end

    @index = occurances.sort
  end
  
  def compile
    out = "! BibleQE Index: #{@long_name}\n! version #{@bqe_version}"

    self.index.each do |word, occ|
      out << "\n#{word}#{occ}"
    end

    out
  end
  
  def range(l = nil)
    words = self.words
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
    out = "! BibleQE Index TOC: #{@long_name}\n! version #{@bqe_version}"
    self.range.each { |letter, range|
      out << "\n#{letter} #{range[0]}..#{range[1]}"
    }
    out
  end

  def words
    words = []
    self.index.each {|l| words << l[0] }
    words
  end

  def compile_words
    self.words.join " "
  end
end
