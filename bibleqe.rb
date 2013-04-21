class Index
	def initialize(file, bibleversion)
		@index = self.compile(self.index(file), bibleversion)
	end
	
	def put
		print @index
	end
	
	def write
		File.open("out.txt", "w") do |file|
			file << @index
		end
	end

	def index(f)
		index = Hash.new { |hash,key| hash[key] = {:occ=>"",:freq=>0} }
		f.each { |line|
			self.line(line, f.lineno, index) unless line[0] == "!"
		}
		return index
	end
	
	def line(line, lineno, index)
		line.downcase!
		line.tr!(".,;()?!", "")
		words = line.split
		words.each_index { |ind|
			index[words[ind].to_sym][:occ] << " #{lineno},#{ind + 1}";
			index[words[ind].to_sym][:freq] += 1
		}
	end

	def compile(index, bibleversion)
		out = "! BibleQE Index: #{bibleversion}\n! version 1"
		index = index.sort_by {|k, v| k }
		index.each { |word, props|
			out << "\n#{word} #{props[:freq]}#{props[:occ]}"
		}
		return out
	end
end

ind = Index.new(File.new("faith.txt"),"NIV test")
ind.put
ind.write