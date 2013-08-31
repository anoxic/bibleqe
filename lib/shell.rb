class Shell
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

        # Get results                  
        result = Result.new(text, args.flatten, limit)

        puts result.matches

        # List results
        if options[:list] != nil
            puts ""
            puts result.list.join ", "
            return
        end

        # Show results
        if options[:all] != nil
            puts ""
            puts result.show
        else
            puts "Page #{page} (displaying #{limit} results)"
            puts ""
            puts result.show_by_page(page)
        end
    end
    
end