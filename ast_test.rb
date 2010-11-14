#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

load './cparser.rb'

describe CparseParser do
  
  parser = Proj1Parser.new
  
  
  it "should parse a float assignment declaration" do 
    parser.parse("float a = 5.0;").should be_true
  end
  
  it "should not parse float assigned to an integer" do
    parser.parse("int x, y, z = 5.0 + 1.07;").should_not be_true
  end

  it "should parse multiple float declarations" do
    parser.parse("float a, b, c;").should be_true
  end
  
  it "should do test right10" do
    parser.parse("int y, x;
    int z=y+10-4*(2/x*2)/y;
    ").should be_true
  end
  
  it "should do a complicated assignment" do
    parser.parse("int x, z, y; z=y+10-4*(2/x*2)/y;").should be_true
  end
 
  it "should do a complicated assignment" do
    parser.parse("int y; int x = y + 5 / 10 * 3 - 20;").should be_true
  end
  it "should do test right11" do
    parser.parse("
    /*{
    	{*/
    		int y;
    		int x = y + 5 / 10 * 3 - 20;
    		{
    			int x, d;
    			int r;
    			int t[10][10][10], s[10][10][10];
    			int a[10];
    			t[r][r][r] = t[r][r][r] ==s[r][r][r];
    			a[3] = a[2] * a[d];
    			if (!a[x])
    				r=0;
    		}
    		while ((x < 1000)) {
    			r= r;
    		}

    	/*}
    }*/
        ").should be_true
  end
end
