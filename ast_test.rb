#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

load './cparser.rb'

describe CparseParser do
  
  parser = Proj1Parser.new
  
  
  it "should parse a float assignment declaration" do 
    parser.parse("float a = 5.0;").should be_true
  end
  
  it "should not parse multiple int declarations" do
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
  
end
