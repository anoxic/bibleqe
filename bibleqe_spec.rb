require "./bibleqe"

describe Text do
	it "has a text" do
		kjv = Text.new(:kjv)
		kjv.text.is_a?(File).should == true
	end
	
	it "has an index" do
		kjv = Text.new(:kjv)
		kjv.index.is_a?(File).should == true
	end
	
	it "has a delimeter" do
		kjv = Text.new(:kjv)
		kjv.delim.should == "::"
	end	
	
	it "has a name" do
		kjv = Text.new(:kjv)
		kjv.name.should == "King James Version"
	end
	
	it "has a symbol" do
		kjv = Text.new(:kjv)
		kjv.symbol.should == :kjv
	end
end

describe "the search function" do
	it "finds one word" do
		query = Result.new(:kjv, "Jesus")
		query.matches.should == "Found 5 verses matching: Jesus"
	end
	
	it "finds another word" do
		query = Result.new(:kjv, "John")
		query.matches.should == "Found 4 verses matching: John"
	end
	
	it "finds two words" do
		query = Result.new(:kjv, "Jesus came")
		query.matches.should == "Found 2 verses matching: Jesus, came"
	end
	
	it "finds 0 matches for a word" do
		query = Result.new(:kjv, "sentinel")
		query.matches.should == "Found 0 verses matching: sentinel"
	end
	
	it "cannot search for empty string" do
		query = Result.new(:kjv, "")
		query.matches.should == "Nothing to be searched for!"
	end
end

# list: print matching verse references
# show: print matching verses
# matches: print number of matches