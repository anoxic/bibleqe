require_relative '../bibleqe.rb'

regex = File.new("texts/book_abbreviations.txt.orig")
books = IndexBuilder.new(:kjv).book_names
out   = []

regex.map do |line|
  next unless line.match /^\d+\s/

  bookno = line.slice!(/\d+\s+/)
  url = books.keys.fetch bookno.to_i - 1
  out << url.to_s.ljust(6) + line
end

File.open("texts/book_abbreviations.txt", "w") { |f| f << out.join }
