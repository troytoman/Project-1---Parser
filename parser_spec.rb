#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

load './cparser.rb'

describe CparseParser do
  
  parser = Proj1Parser.new
  
  it "should parse an int declaration" do 
    parser.parse("int a;").should be_true
  end
  
  it "should not parse an invalid int declaration" do 
    parser.parse("int a").should_not be_true
  end
  
  it "should not parse assignment of invalid ids" do
    parser.parse("int a:34;").should_not be_true
  end

  it "should parse a float declaration" do 
    parser.parse("float a;").should be_true    
  end  
  
  it "should not parse an invalid float declaration" do 
    parser.parse("float a,;").should_not be_true
  end

  it "should parse an int assignment declaration" do 
    parser.parse("int a = 5;").should be_true
  end
  
  it "should not parse an invalid int assignment" do 
    parser.parse("int a5 = ;").should_not be_true
  end

  it "should parse a float assignment declaration" do 
    parser.parse("float a = 5.0;").should be_true
  end
  
  it "should parse a float assignment using an exponent -e notation" do
    parser.parse("float a = 2.3e-3;").should be_true
  end
 
  it "should parse a float assignment using an exponent -E notation" do
    parser.parse("float a = 5E2;").should be_true
  end 
 
  it "should not parse an invalid float assignment declaration" do 
    parser.parse("float a = 5.0.0;").should_not be_true
  end
  
  it "should parse multiple int declarations" do
    parser.parse("int x, y, z;").should be_true
  end
  
  it "should not parse invalid multiple int declarations" do
    parser.parse("int x, y z;").should_not be_true
  end

  it "should parse multiple float declarations" do
    parser.parse("float a, b, c;").should be_true
  end
  
  it "should parse array declarations" do
    parser.parse("float arr[100], arr2[100][50];").should be_true
  end
 
  it "should not parse an invalid array declarations" do
    parser.parse("float arr[100]arr2[100][50];").should_not be_true
  end
 
  it "should parse assignment expressions" do
    parser.parse("a = 5;").should be_true
  end

  it "should not parse invalid assignment expressions" do
    parser.parse("a5 =;").should_not be_true
  end

  it "should parse if statements" do
    parser.parse("if (1) c=b;").should be_true
  end
  
  it "should not parse invalid if statements" do
    parser.parse("if (1 c=b;").should_not be_true
  end
 
  it "should parse if-else statements" do
    parser.parse("if (1) c=b; else c=a;").should be_true
  end
  
  it "should not parse invalid if-else statements" do
    parser.parse("if (1) c=b; els c=a; ").should_not be_true
  end
  
  it "should parse while statements" do
    parser.parse("while (a < b) a = a + 1;").should be_true
  end

  it "should parse equivalence expressions" do
    parser.parse("if (a == 5) a = a +1;").should be_true
  end  
  
  it "should parse less_than expressions" do
    parser.parse("if (a < 5) a = a + 1;").should be_true
  end
  
  it "should parse greater_than expressions" do
    parser.parse("{if (a > 5) a = a + 1;}").should be_true
  end
   
  it "should parse addition expressions" do
    parser.parse("a = a + 5;").should be_true
  end

  it "should parse subtraction expressions" do
    parser.parse("a = a - 5;").should be_true
  end
  
  it "should parse multiply expressions" do
    parser.parse("a = a * 2;").should be_true
  end
  
  it "should parse divide expressions" do
    parser.parse("a = a / 5;").should be_true
  end
  
  it "should parse AND expressions" do
    parser.parse("if (a && 5) a = a + 1;").should be_true
  end
  
  it "should parse NOT expressions" do
    parser.parse("if (!(a > 5)) a = a + 1;").should be_true
  end
  
  it "should parse OR expressions" do
    parser.parse("if (a || 5) a = a + 1;").should be_true
  end
  
  it "should not parse an invalid OR expression" do
    parser.parse("if (a ||) a = a + 1").should_not be_true
  end
  
  it "should parse block statements" do
    parser.parse("{a = b + c; d = a * 2;}").should be_true
  end

  it "should not parse invalid block statements" do
    parser.parse("{a = b + c; d = a * 2;").should_not be_true
  end
  
  it "should parse the test input" do
    parser.parse(
    "float a[100][100], b[100][100], c[100][100]; 
     int i, j, k; 
     i = 0; 
     while (i < 100) {
       j = 0; 
       while (j < 100) {
         if (!(c[i][j] == 0))
            c[i][j] = 0;
            k = 0;
            while (k < 100) {
              c[i][j] = c[i][j] + a[i][k] * b[k][j];
              k = k + 1;
            } 
            j = j + 1;  
        } 
        i = i + 1;
      }").should be_true
    end
  
end
