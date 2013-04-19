class Index
	def initialize(file)
		index = Hash.new { |hash,key| hash[key] = {:occ=>[],:freq=>0} }
		file.each { |verse| self.index(verse, file.lineno, index) }
		puts self.compile(index)
	end

	def index(line, lineno, hash)
		line.downcase!
		line.tr!(".,;()?!", "")
		words = line.split
		words.each_index { |ind|
			hash[words[ind].to_sym][:occ] << "#{lineno},#{ind + 1}";
			hash[words[ind].to_sym][:freq] += 1
		}
	end

	def compile(index)
		out = []
		index = index.sort_by {|k, v| k }
		index.each { |word, props|
			occs = ""
			props[:occ].each {|o| occs += o + " " }
			out << "#{word} #{props[:freq]} #{occs}"
		}
		return out
	end
end

Index.new(File.new("faith.txt"))