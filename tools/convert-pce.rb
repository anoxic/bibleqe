# open the file

pce = File.new("texts/kjv-pce.txt")
lines = pce.readlines
lines.each do |line|
  line.sub!(/[a-zA-Z0-9]* [0-9]*:[0-9]*/, '\0 ' + "\1")
end
File.open("texts/pce2.txt", "w") do |f|
  lines.each {|l| f.puts l}
end
