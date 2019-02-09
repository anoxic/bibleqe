class Verse
  ReferencePattern = /^\w+ \d+:\d+ /

  def Verse.format(raw)
    formatted = []

    raw.map do |verse|
      verse[0][/\w+/] = Parse.new.get_long_name(verse[0][/\w+/])

      formatted << wrap(verse.join($/), 75)
      formatted << ''
    end

    formatted
  end

  # Wrap string by the given length, and join it with the given character.
  # The method doesn't distinguish between words, it will only work based on
  # the length. The method will also strip and whitespace.
  # (from https://www.ruby-forum.com/topic/57805)
  #
  def Verse.wrap(str, length = 80, character = $/)
    str.scan(/\S.{0,#{length}}\S(?=\s|$)|\S+/).map { |x| x.strip }.join(character)
  end
end
