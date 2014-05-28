require_relative "bibleqe"

describe Parse do 
  before :all do
    @p = Parse.new
  end
  
  # Note: the part that parses arguments into options
  #       is completely untested at this point
  
  describe "reference matching" do
    it "doesn't match single arguments" do
      @p.contains_ref('john').should == false
      @p.contains_ref('12').should == false
    end

    it "matches basic references" do
      @p.contains_ref('john 12').should == true
      @p.contains_ref('genesis 2').should == true
      @p.contains_ref('psalm 119').should == true
    end

    it "matches verse references" do
      @p.contains_ref('genesis 2:15').should == true
      @p.contains_ref('rev 3:8').should == true
      @p.contains_ref('psalm 119.1').should == true
      @p.contains_ref('psalm 119,1').should == true
      @p.contains_ref('psalm 119:1').should == true
      @p.contains_ref('psalm 119 1').should == true
    end

    it "matches books beginning with a number" do
      @p.contains_ref('1sa 2:1').should == true
      @p.contains_ref('1 sa 2:1').should == true
      @p.contains_ref('i sa 2:1').should == true
      @p.contains_ref('I Samuel 2:1').should == true
      @p.contains_ref('ii maccabees 1').should == true
      @p.contains_ref('iii maccabees 1').should == true
      @p.contains_ref('iiii maccabees 1').should == true
      @p.contains_ref('iv maccabees 1').should == true
      @p.contains_ref('1st John 1').should == true
    end
  end

  describe "reference expansion" do
    it "converts book names to abbreviations" do
      @p.get_short_name("jn").should == "Joh"
      @p.get_short_name("1jn").should == "1Jo"
      @p.get_short_name("genesis").should == "Ge"
      @p.get_short_name("revel").should == "Re"
    end

    it "formats chapters and verses consistently" do
      @p.get_ref("GENESIS 1:1").should == "Ge 1:1"
      @p.get_ref('1st John 1').should == "1Jo 1"
    end
  end
end

describe IndexBuilder do
  before :all do
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
  before :all do
  	@kjv = Text.new :test
  end
  
  it "has a text" do
  	@kjv.content.is_a?(File).should == true
  end
  
  it "has a name" do
  	@kjv.name.should == "King James Version"
  end
  
  it "has a symbol" do
  	@kjv.symbol.should == :test
  end	
  
  it "has a characters to strip" do
  	@kjv.strip.should == "¶.,:;()[]{}?!"
  end
  
  it "gets lines" do
  	@kjv[32].should == "Jhn 3:27 John answered and said, A man can receive nothing, except it be given him from heaven.\n"
  end
end

describe Index do
  before :all do
  	@kjv = Index.new :test
  end
  
  it "has an index" do
  	@kjv.index.is_a?(Array).should == true
  end
  
  it "gets matched lines for a word" do
  	@kjv["jesus"].should == [5, 7, 10, 15, 27]
  end
end

describe "Search and Result" do
  before :all do
    @s = Search.new :test
  end

  it "finds one word" do
  	query = @s.query("Jesus")
  	query.matches_verbose.should == "Found 5 verses matching: Jesus"
  end
  
  it "finds another word" do
  	query = @s.query("John")
  	query.matches_verbose.should == "Found 4 verses matching: John"
  end
  
  it "finds two words" do
  	query = @s.query("Jesus came")
  	query.matches_verbose.should == "Found 2 verses matching: Jesus, came"
  end
  
  it "finds two words, reversed terms" do
  	query = @s.query("came Jesus")
  	query.matches_verbose.should == "Found 2 verses matching: came, Jesus"
  end
  
  it "finds three words" do
  	query = @s.query("and art thou")
  	query.matches_verbose.should == "Found 2 verses matching: and, art, thou"
  end
  
  it "finds 0 matches for a word" do
  	query = @s.query("sentinel")
  	query.matches_verbose.should == "Found 0 verses matching: sentinel"
  end
  
  it "cannot search for empty string" do
  	query = @s.query("")
  	query.matches_verbose.should == "Nothing to be searched for!"
  end

  it "gets number of matches" do
  	query = @s.query("John")
  	query.matches.should == 4
  end
  
  it "shows just 10 results of a larger query" do
  	query = @s.query("and")
  	query.show(1..10).count.should == 10
  end
  
#  it "displays by page" do
#  	query = Search.new(:test).query("john")
#  	query.show_by_page(1).count.should == 10
#  end
end

