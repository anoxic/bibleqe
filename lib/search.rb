class Search
    attr_accessor :result

    def initialize(version)
        @version = version
    end

    def query(query)
        @result = Result.new(@version, query, @limit)
    end
end
