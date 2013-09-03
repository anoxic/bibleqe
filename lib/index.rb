class Index
  attr_reader :index, :words, :symbol
  
  def initialize (name, dir = :texts)
  	raise LoadError, "Can't find #{name}.txt" unless File.exists? "./#{dir}/#{name}.txt"
  	IndexBuilder.new(name, dir).write unless File.exists? "./#{dir}/#{name}.ind"
  	IndexBuilder.new(name, dir).write unless File.exists? "./#{dir}/#{name}_toc.ind"
  	IndexBuilder.new(name, dir).write unless File.exists? "./#{dir}/#{name}_words.lst"
  			
  	@index = File.new("./#{dir}/#{name}.ind").readlines
  	@toc = File.new("./#{dir}/#{name}_toc.ind").readlines
  	@words = File.new("./#{dir}/#{name}_words.lst").readlines.join.split
  	@symbol = name
  end

  def range(word)
  	letter = word.to_s[0] 
  	lower,upper = nil

  	@toc.each do |l|
  		if l.start_with? "#{letter} "
  			x = l.split[1].split("..")
  			lower = x[0].to_i
  			upper = x[1].to_i
  			break
  		end
  	end

    return [] if lower.nil?
  	@index[lower..upper]
  	
  	# Without range, search for:
  	# abbadon, 0.187500
  	# zuzims, 0.328125
  	# With range:
  	# abbadon, 0.187500
  	# zuzims, 0.109375
  end
  
  def [](term)
  	matches = []
    terms = term.split '|'
    
    terms.each do |t|
      matches = matches + self.fetch(t)
    end

    matches.uniq
  end

  def fetch(term)
  	word = term.downcase
  	matches = []

  	range(word).each do |line|
  		if line.match(/^#{word} /) 
  			refs = line.split.drop(1)
  			refs.each { |r|
  				r.gsub!(/,.*/,'')
  				matches << r.to_i - 1
  			}
  			break
  		end
  	end

  	matches
  end
end
