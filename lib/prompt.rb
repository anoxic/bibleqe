class Prompt
    def initialize(args)                     
        @args = args
        @flags = self.get_flags()                

        @text = :kjv
        @text = @flags[:text] if @flags[:text] != nil

        @page = 1        
        @page = @flags[:page] if @flags[:page] != nil

        @limit = 10
        @limit = @flags[:limit] if @flags[:limit] != nil

        # Get results                  
        result = Result.new(@text, @args.flatten, @limit)

        puts result.matches

        # List results
        if @flags[:list] != nil
            puts ""
            puts result.list.join ", "
            return
        end

        # Show results
        if @flags[:all] != nil
            puts ""
            puts result.show
        else
            puts "Page #{@page} (displaying #{@limit} results)"
            puts ""
            puts result.show_by_page(@page)
        end
    end
    
    def get_flags()
        flags = {}
        booleans = ['all', 'list', 'show']
        
        @args.each.with_index do |arg, k|
            if arg.start_with? ':'
                name = arg.delete ':'

                if booleans.include? name
                    flags[name.to_sym] = true;
                    @args.delete_at(k)
                else
                    flags[name.to_sym] = @args[k + 1]
                    @args.delete_at(k)
                    @args.delete_at(k)
                end
            end
        end
        
        flags
    end
end
