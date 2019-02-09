class Parse
  attr_reader :args, :options, :ref

  BoolOptions = ['all', 'list', 'show']

  def initialize(args = [])
    @args = if args.is_a? String then args.split else args end
    @options = {}

    if contains_ref(@args)
      @ref = get_ref(@args).to_s
    end

    @args.each.with_index do |arg, k|
      if arg.start_with? ':'
        name = arg.delete ':'

        if BoolOptions.include? name
          @options[name.to_sym] = true;
          @args.delete_at(k)
        else
          @options[name.to_sym] = @args[k + 1]
          @args.delete_at(k)
          @args.delete_at(k)
        end
      end
    end

    @args = args
    @options = options
  end

  def contains_ref(str)
    return true if get_ref(str)
    false
  end

  def get_ref(str)
    ref  = /([1-9]|(IV|I+))? ?(st|nd|rd|th)? ?\w+ \d+([.,: ]\d+)?/i
    book = /([1-9]|(IV|I+))? ?(st|nd|rd|th)? ?\w+/i

    str = str.join ' ' if str.is_a? Array

    if str.match ref
      str = str[ref].downcase

      if str.match book and short_name = get_short_name(str[book])
          str[book] = short_name
      end

      return str
    end
  end

  def get_short_name(name)
    @abbrs ||= File.new "./texts/book_abbreviations.txt", "r:UTF-8"
    @abbrs.rewind

    name = name.downcase

    @abbrs.map do |line|
      next unless line.match /\w+ {2,}/

      abbr = line.slice! /\w+/
      exps = line.chop.split(/ {2,}/).drop(2)

      exps.map do |e|
        e = Regexp.new e
        return abbr if name.match e
      end
    end

    nil
  end

  def get_long_name(abbr)
    @abbrs ||= File.new "./texts/book_abbreviations.txt", "r:UTF-8"
    @abbrs.rewind

    @abbrs.map do |line|
      next unless line.match /\w+ {2,}/

      if abbr == line.slice!(/\w+ {2,}/).rstrip
        return line.slice!(/( ?\w)+(?= {2,})/)
      end
    end

    nil
  end
end

