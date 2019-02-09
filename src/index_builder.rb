class IndexBuilder
  def initialize(name, dir = :texts)
    t = Text.new(name, dir)

    @name           = name
    @dir            = dir
    @long_name      = t.name
    @strip          = t.strip
    @text           = t.content
  end

  def put!
    print self.compile_index
  end

  def write!
    File.open("#{@dir}/#{@name}.ind", "w:UTF-8") { |f| f << self.compile_index }
    File.open("#{@dir}/#{@name}_toc.ind", "w:UTF-8") { |f| f << self.compile_range }
    File.open("#{@dir}/#{@name}_words.lst", "w:UTF-8") { |f| f << self.compile_words }
    File.open("#{@dir}/#{@name}_toc.txt", "w:UTF-8") { |f| f << self.compile_book_names }
    true
  end

  def index
    return @index if @index

    occurances = Hash.new{|h,k| h[k] = String.new}

    @text.each do |line|
      next unless line.match(Verse::ReferencePattern)

      line.slice!(Verse::ReferencePattern)
      line.downcase!
      line.delete!(@strip)

      line.split.map.with_index do |k,v|
        occurances[k.to_sym] << " #{@text.lineno},#{v.to_i + 1}"
      end
    end

    @index = occurances.sort
  end

  def compile_index
    out = "! BibleQE Index: #{@long_name}\n! version #{BibleQE::version}"

    self.index.each do |word, occ|
      out << "\n#{word}#{occ}"
    end

    out
  end

  def book_names
    names = Hash.new
    @text.rewind if @text.lineno > 0

    @text.map.with_index do |line,lineno|
      next unless line.match(Verse::ReferencePattern)

      unless names[line.slice(/\w+/).to_sym]
        names[line.slice(/\w+/).to_sym] = lineno
      end
    end

    names
  end

  def compile_book_names
    out = ["! BibleQE Text TOC: #{@long_name}","! version #{BibleQE::version}"]
    book_names.map { |i| out << "#{i[0]} #{i[1]}" }
    out.join "\n"
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
    out = "! BibleQE Index TOC: #{@long_name}\n! version #{BibleQE::version}"
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
