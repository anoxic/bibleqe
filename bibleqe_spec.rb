require "./bibleqe"

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
	
	it "finds 0 results for a word" do
		query = Result.new(:kjv, "sentinel")
		query.matches.should == "Found 0 verses matching: sentinel"
	end
	
	it "cannot search for empty string" do
		query = Result.new(:kjv, "")
		query.matches.should == "Nothing to be searched for!"
	end
end