#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

load './cparser.rb'

describe CparseParser do
  
  parser = Proj1Parser.new
  
  
  it "should parse a float assignment declaration" do 
    parser.parse('float a = 5.0;').result.should be_true
  end
  
  it "should not parse float assigned to an integer" do
    parser.parse('int x, y, z = 5.0 + 1.07;').result.should_not be_true
  end

  it "should parse multiple float declarations" do
    parser.parse('float a, b, c;').result.should be_true
  end
  
  it "should do test right10" do
    parser.parse('int y, x;
    int z=y+10-4*(2/x*2)/y;
    ').result.should be_true
  end
  
  it "should do a complicated assignment" do
    parser.parse('int x, z, y; z=y+1-4*(2/x*2)/y;').result.should be_true
  end
 
  it "should do a complicated assignment" do
    parser.parse('int y; int x = y + 5 / 10 * 3 - 20;').result.should be_true
  end
  it "should not do allow int == float" do
    ast = parser.parse('int x, y; float z;
                        if (x == z) x = x+y;')
    puts ast.message
    if ast.ast
      ast.ast.print_tree
    end
    ast.result.should_not be_true
  end
  it "should do allow float == intliteral" do
    ast = parser.parse('int x, y; float z;
                        if (0 == z) x = x+y;')
    puts ast.message
    if ast.ast
      ast.ast.print_tree
    end  
    ast.result.should be_true
  end
  it "should not do float variable with ! operator" do
    ast = parser.parse('float z;
                        if (!z) x = x+y;')
    puts ast.message                      
    if ast.ast
      ast.ast.print_tree
    end  
    ast.result.should_not be_true
  end
  it "should do input with escaped characters (newline)" do
    ast = parser.parse('int x,y;\nif (test == 0) \n\tx=x+1; \nelse \n\tx=x+2;')
    puts ast.message                      
    if ast.ast
      ast.ast.print_tree
    end  
    ast.result.should_not be_true
  end
end
