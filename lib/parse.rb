class Parse
  attr_reader :args, :options, :ref

  def initialize(args = [])
    options = {}
    booleans = ['all', 'list', 'show']
  
    args = args.split if args.is_a? String

    if contains_ref(args)
      @ref = get_ref(args).to_s
    end
    
    args.each.with_index do |arg, k|
      if arg.start_with? ':'
        name = arg.delete ':'
  
        if booleans.include? name
          options[name.to_sym] = true;
          args.delete_at(k)
        else
          options[name.to_sym] = args[k + 1]
          args.delete_at(k)
          args.delete_at(k)
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
    ref  = /([1-9]|(IV|I+))? ?\w+ \d+([.,: ]\d+)?/i
    book = /([1-9]|(IV|I+))? ?\w+/i

    str = str.join ' ' if str.is_a? Array

    if str.match ref
      str = str[ref].downcase
    
      if str.match book and short = get_short_name(str[book])
          str[book] = get_short_name(str[book])
      end

      return str
    end
  end

  def get_short_name(name)
    @abbrs ||= File.new "./texts/book_abbreviations.txt"
    @abbrs.rewind

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
end

