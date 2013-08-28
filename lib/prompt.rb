class Prompt
	def initialize(args)     
	      
	    # Use arg 1 for page number
	    
	    if args[0] =~ /^[0-9]+$/
	        page = args[0].to_i
            args.delete_at(0)
	    else
	        page = 1;
	    end
	                      
	    # Get results
	                      
		result = Result.new(:kjv, args.flatten)
		puts result.matches
		puts "Page #{page}"
		puts ""
		puts result.show_by_page(page)
	end
end