class String
    # Wrap string by the given length, and join it with the given character.
    # The method doesn't distinguish between words, it will only work based on
    # the length. The method will also strip and whitespace.
    # (from https://www.ruby-forum.com/topic/57805)
    #
    def wrap(length = 80, character = $/)
        scan(/\S.{0,#{length}}\S(?=\s|$)|\S+/).map { |x| x.strip }.join(character)
    end
end
