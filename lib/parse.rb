class Parse
  attr_reader :args, :options

  def initialize(args)
    options = {}
    booleans = ['all', 'list', 'show']
  
    args = args.split if args.is_a? String

    if self.contains_ref(args)
      reference = self.get_ref(args).to_s
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
    match = self.get_ref(str)
    match == nil ? false : match.to_s
  end

  def get_ref(str)
    str = str.join ' ' if str.is_a? Array
    str.match(/([1-9]|(IV|I+))? ?[a-z]+ [0-9]+([.,: ][0-9]+)?/i)
  end
end

