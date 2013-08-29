require "../bibleqe"

describe "the index builder" do
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

describe "the search function" do
	it "finds one word" do
		query = Result.new(:test, "Jesus")
		query.matches.should == "Found 5 verses matching: Jesus"
	end
	
	it "finds another word" do
		query = Result.new(:test, "John")
		query.matches.should == "Found 4 verses matching: John"
	end
	
	it "finds two words" do
		query = Result.new(:test, "Jesus came")
		query.matches.should == "Found 2 verses matching: Jesus, came"
	end
	
	it "finds two words, reversed terms" do
		query = Result.new(:test, "came Jesus")
		query.matches.should == "Found 2 verses matching: came, Jesus"
	end
	
	it "finds three words" do
		query = Result.new(:test, "and art thou")
		query.matches.should == "Found 2 verses matching: and, art, thou"
	end
	
	it "finds 0 matches for a word" do
		query = Result.new(:test, "sentinel")
		query.matches.should == "Found 0 verses matching: sentinel"
	end
	
	it "cannot search for empty string" do
		query = Result.new(:test, "")
		query.matches.should == "Nothing to be searched for!"
	end
	
	it "gets matching verses" do
		query = Result.new(:test, "jesus")
		query.show.count.should == 5
	end
	
	it "shows just 10 results of a larger query" do
		query = Result.new(:test, "and")
		query.show(1..10).count.should == 10
	end
	
	it "displays by page" do
		query = Result.new(:test, "and")
		query.show_by_page(1).count.should == 10
	end
end

# list: print matching verse references
# show: print matching verses
# matches: print number of matches
