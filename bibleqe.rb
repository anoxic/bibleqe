def get_frequencies(str,array)
    str.downcase!
    str.tr!(".,;()?!", "")
    words = str.split
    words.each { |word| array[word] += 1 }
end

str = "By faith we understand that the universe was formed at God's command, so that what is seen was not made out of what was visible."
frequencies = Hash.new(0)
get_frequencies(str, frequencies)
frequencies = frequencies.sort_by { |k, v| v }
frequencies.reverse!
frequencies.each { |word, freq| puts "#{word}: #{freq}" }

## For the index:
# <word> <frequency> <lineno>,<wordno> ...
# i.e.:
# was 3 1,8 1,18 1,24