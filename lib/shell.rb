class Shell
  attr_reader :out

  def initialize(args, puts = true)
    out = []

    parser = Parse.new(args)
    args = parser.args
    options = parser.options

    text = :kjv
    text = options[:text] if options[:text] != nil

    page = 1    
    page = options[:page] if options[:page] != nil

    limit = 10
    limit = options[:limit] if options[:limit] != nil

    # Get results          
    search = Search.new(text)
    result = search.query(args)
    result.limit = limit

    # Display line about matches
    out << result.matches_verbose

    # List results
    if options[:list] != nil
      out << ""
      out << result.list.join(", ")
      return
    end

    # Show results
    if options[:all] != nil
      out << ""
      out << result.show!
    else
      out << "Page #{page} (displaying #{limit} results)" if result.matches > 0
      out << ""
      out << result.show_by_page!(page)
    end

    puts out if puts == true
    
    @out = out.join $/
  end
end

