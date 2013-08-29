class Prompt
	def initialize(args)     	    	    
	    @args = args
	    @flags = self.get_flags()	            

	    @page = 1        
	    @page = @flags[:page] if @flags[:page] != nil

	    @limit = 10
 	    @limit = @flags[:limit] if @flags[:limit] != nil
	                      
	    # Get results                  
		result = Result.new(:kjv, @args.flatten, @limit)
		puts result.matches
		puts "Page #{@page} (displaying #{@limit} results)"
		puts ""
		puts result.show_by_page(@page)
	end
	
	def get_flags()
	    flags = {}
	    
	    @args.each.with_index do |arg, k|
	        if arg.match /^:.?/
	           name = arg.delete ':'
	           flags[name.to_sym] = @args[k + 1]
	           @args.delete_at(k)
	           @args.delete_at(k)
	        end
	    end
	    
	    flags
	end
end