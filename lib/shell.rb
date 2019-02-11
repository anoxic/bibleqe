class Shell
  attr_reader :out

  def initialize(args)
    parser = Parse.new(args)
    args = parser.args
    options = parser.options

    if v = Text.new(options[:text]).fetch_by_ref(parser.ref)
      # Fetch by reference
      puts Result.format(v)
    else
      # Get results          
      search = Search.new(options[:text])
      result = search.query(args)
      result.limit = options[:limit]

      # Display line about matches
      puts result.matches_verbose

      # List results
      if options[:list]
        puts ""
        puts result.list.join(", ")
        return 
      end

      # Show results
      if options[:all]
        puts ""
        puts result.show!
      else
        puts "Page #{options[:page]} (displaying #{options[:limit]} results)" if result.matches > 0
        puts ""
        puts result.show_by_page!(options[:page])
      end
    end
  end
end

