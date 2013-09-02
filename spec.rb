require_relative "bibleqe"

describe IndexBuilder do
	before do
		@kjv = IndexBuilder.new(:test)
	end
	
	it "has a range for 'a'" do
		@kjv.range(:a).should == [2,19]
	end
	
	it "has a range for 'y'" do
		@kjv.range(:y).should == [240,243]
	end
end

describe Text do
	before do
		@kjv = Text.new :test
	end
	
	it "has a text" do
		@kjv.content.is_a?(File).should == true
	end
	
	it "has a delimeter" do
		@kjv.delim.should == "::"
	end	
	
	it "has a name" do
		@kjv.name.should == "King James Version"
	end
	
	it "has a symbol" do
		@kjv.symbol.should == :test
	end	
	
	it "has a characters to strip" do
		@kjv.strip.should == ".,:;()[]{}?!"
	end
	
	it "gets lines" do
		@kjv[2].should == "! delim ::\n"
	end
end

describe Index do
	before do
		@kjv = Index.new :test
	end
	
	it "has an index" do
		@kjv.index.is_a?(Array).should == true
	end
	
	it "gets matched lines for a word" do
		@kjv["jesus"].should == [6,8,11,16,28]
	end
end

describe "Search and Result" do
	it "finds one word" do
		query = Search.new(:test).query("Jesus")
		query.matches_verbose.should == "Found 5 verses matching: Jesus"
	end
	
	it "finds another word" do
		query = Search.new(:test).query("John")
		query.matches_verbose.should == "Found 4 verses matching: John"
	end
	
	it "finds two words" do
		query = Search.new(:test).query("Jesus came")
		query.matches_verbose.should == "Found 2 verses matching: Jesus, came"
	end
	
	it "finds two words, reversed terms" do
		query = Search.new(:test).query("came Jesus")
		query.matches_verbose.should == "Found 2 verses matching: came, Jesus"
	end
	
	it "finds three words" do
		query = Search.new(:test).query("and art thou")
		query.matches_verbose.should == "Found 2 verses matching: and, art, thou"
	end
	
	it "finds 0 matches for a word" do
		query = Search.new(:test).query("sentinel")
		query.matches_verbose.should == "Found 0 verses matching: sentinel"
	end
	
	it "cannot search for empty string" do
		query = Search.new(:test).query("")
		query.matches_verbose.should == "Nothing to be searched for!"
	end

    it "gets number of matches" do
		query = Search.new(:test).query("John")
		query.matches.should == 4
    end
	
	it "shows just 10 results of a larger query" do
		query = Search.new(:test).query("and")
		query.show(1..10).count.should == 10
	end
	
#	it "displays by page" do
#		query = Search.new(:test).query("john")
#		query.show_by_page(1).count.should == 10
#	end
end

