class Verse
  def Verse.reference_pattern
    /^\w+ \d+:\d+ /
  end

  def Verse.format(raw)
    formatted = []

    raw.map do |verse|
      verse[0][/\w+/] = Parse.new.get_long_name(verse[0][/\w+/])

      formatted << verse.join($/).wrap(75)
      formatted << ''
    end

    formatted
  end
end
