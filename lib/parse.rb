class Parse
  attr_reader :args, :options

  def initialize(args)
    options = {}
    booleans = ['all', 'list', 'show']
  
    args = args.split if args.is_a? String

    if self.contains_ref(args)

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
    str = str.join ' ' if str.is_a? Array

    str.match(/[a-z]+ [0-9]/) != nil ? true : false
  end
end

