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
    
    it "should do test right3" do
      parser.parse(
      "float foo = 1, Bar = .1, BAZ = 0.8, foo_bar=-.8, _foo42=-0.1, _=4000000, UuUu=5e2;
      int _test;").should be_true
    end
    
    it "should do test right4" do
       parser.parse(
       "float a, v, d, t, test_test56=4.4e-2, _foo=.4e-2, yy=5E10;").should be_true
     end
     
     it "should do test right5" do
       parser.parse("int /**some comments(*^^$%@$+_0=***/x=0;").should be_true
     end
     
     it "should do test right6" do
       parser.parse("int test, blah, x, y;
       if (test == blah) {
       	/*do something*/
       	x = x;
       } else {
       	/*do something*/
       	y=y;
       }
       ").should be_true
     end
     
     it "should do test right7" do
       parser.parse("int t, r, x, y, n, d, u;
       if ((t>20)||(r==10)) { 
       	x = y*n;
       } else {
       	x=y+n;
       }
       if ((r==0)&&(d<1)) {
       	x=y-n;
       } else { /*spans
       multiple
       lines*/
       	x=(7*x) / (t-u);
       }

       ").should be_true
     end
     
     it "should do test right8" do
       parser.parse("int x, y;
       while (!((x<10)&&(y==5)))
       	x=x+1;

       ").should be_true
     end
     
     it "should do test right9" do
       parser.parse("int a, q, u, i;
       {
       	/* some new code structure */
       	int x[5], y[9];
       	int a, q, u, i;
       	float testing = 0.01e20;
       	q=((a+4)*(10/u)/i);
       }

       ").should be_true
     end
     
     it "should do test right10" do
       parser.parse("int y, x;
       int z=y+10-4*(2/x*2)/y;
       ").should be_true
     end
     
     it "should do test right11" do
       parser.parse("
       /*{
       	{*/
       		int y;
       		int x = y + 5 / 10 * 3 - 20;
       		{
       			int x, r, d;
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
   
          it "should do test right21" do
            parser.parse("int test, x, t;
            if (test > 10) {
            	x=x+1;
            	if (t == 0) {
            		x=0;
            	} else {
            		x=10;
            	}
            } else {
            	x=1;
            }
            ").should be_true
          end
  
   it "should do test right22" do
     parser.parse("int test, x;
     x=((((((((((((((((((((test*10))))))))))+((20))))))))))));

     ").should be_true
   end
 
  it "should not do test wrong1" do
    parser.parse("test i;
    ").should_not be_true
  end

 it "should not do test wrong2" do
   parser.parse("INT i;
   ").should_not be_true
 end

 it "should not do test wrong3" do
   parser.parse("int for;
   ").should_not be_true
 end

 it "should not do test wrong4" do
   parser.parse("int while;
   ").should_not be_true
 end

 it "should not do test wrong5" do
   parser.parse("int 2
   float x;
   ").should_not be_true
 end

 it "should not do test wrong6" do
   parser.parse("int 2
   float x;
   ").should_not be_true
 end

 it "should not do test wrong7" do
   parser.parse("int x y;
   ").should_not be_true
 end

 it "should not do test wrong8" do
   parser.parse("int $one;
   ").should_not be_true
 end

 it "should not do test wrong9" do
   parser.parse("int #one
   ").should_not be_true
 end

 it "should not do test wrong10" do
   parser.parse("int #one
   ").should_not be_true
 end

 it "should not do test wrong11" do
   parser.parse("int x{};
   ").should_not be_true
 end

 it "should not do test wrong12" do
   parser.parse("int v{4};
   ").should_not be_true
 end

 it "should not do test wrong13" do
   parser.parse("int x[4][][4];
   ").should_not be_true
 end

 it "should not do test wrong14" do
   parser.parse("if (!test {
   x=x+1;
   }){
   y=0;
   }
   ").should_not be_true
 end

 it "should not do test wrong15" do
   parser.parse("{
   	int x,t,y;
   	/*commented}*/

   ").should_not be_true
 end

 it "should not do test wrong16" do
   parser.parse("x=9+0-8*6/5tst_10*10;
   ").should_not be_true
 end

 it "should not do test wrong17" do
   parser.parse("c=9(4);
   ").should_not be_true
 end

 it "should not do test wrong18" do
   parser.parse("x=while+10;
   ").should_not be_true
 end

 it "should not do test wrong19" do
   parser.parse("while {
   	/*do something*/
   	x=x;
   }
   ").should_not be_true
 end

 it "should not do test wrong20" do
   parser.parse("( a = 0; b ) = 0;
   ").should_not be_true
 end

end
