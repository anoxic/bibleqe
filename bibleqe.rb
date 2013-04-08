def get_frequencies(line,array)
    line.downcase!
    line.tr!(".,;()?!", "")
    words = line.split
    words.each { |word| array[word] += 1 }
end

verse = "By faith we understand that the universe was formed at God's command, so that what is seen was not made out of what was visible."
frequencies = Hash.new(0)
get_frequencies(verse, frequencies)
frequencies = frequencies.sort_by { |k, v| v }
frequencies.reverse!
frequencies.each { |word, freq| puts "#{word}: #{freq}" }

## For the index:
# <word> <frequency> <lineno>,<wordno> ...
# i.e.:
# was 3 1,8 1,18 1,24