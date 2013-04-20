class Index
	def initialize(file,bibleversion)
		index = Hash.new { |hash,key| hash[key] = {:occ=>"",:freq=>0} }
		file.each { |verse| self.index(verse, file.lineno, index) }
		
		File.open("out.txt", "w") do |f|
			f.puts self.compile(index,bibleversion)
		end
	end

	def index(line, lineno, hash)
		line.downcase!
		line.tr!(".,;()?!", "")
		words = line.split
		words.each_index { |ind|
			hash[words[ind].to_sym][:occ] << "#{lineno},#{ind + 1} ";
			hash[words[ind].to_sym][:freq] += 1
		}
	end

	def compile(index,bibleversion)
		out = "! BibleQE Index: #{bibleversion}\n! version 1\n"
		index = index.sort_by {|k, v| k }
		index.each { |word, props|
			out << "#{word} #{props[:freq]} #{props[:occ]}\n"
		}
		return out
	end
end

Index.new(File.new("faith.txt"),"NIV test")