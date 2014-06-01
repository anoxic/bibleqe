class Verse
  def Verse.reference_pattern
    /^\w+ \d+:\d+ /
  end

  def Verse.format(raw)
    formatted = []

    raw.map do |verse|
     formatted << verse.join($/).wrap(75)
     formatted << ''
    end

    formatted
  end
end
