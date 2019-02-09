class Shell
  attr_reader :out

  def initialize(args)
    parser = Parse.new(args)
    args = parser.args
    options = parser.options

    text = :kjv
    text = options[:text] if options[:text] != nil

    page = 1    
    page = options[:page] if options[:page] != nil

    limit = 10
    limit = options[:limit] if options[:limit] != nil

    if v = Text.new(text).fetch_by_ref(parser.ref)
      # Fetch by reference
      puts Verse.format(v)
    else
      # Get results          
      search = Search.new(text)
      result = search.query(args)
      result.limit = limit

      # Display line about matches
      puts result.matches_verbose

      # List results
      if options[:list] != nil
        puts ""
        puts result.list.join(", ")
        return 
      end

      # Show results
      if options[:all] != nil
        puts ""
        puts result.show!
      else
        puts "Page #{page} (displaying #{limit} results)" if result.matches > 0
        puts ""
        puts result.show_by_page!(page)
      end
    end
  end
end

