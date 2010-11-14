#!/usr/bin/env ruby
# Rspec tests for:
# Partial C parser
# Troy Toman

load './cparser.rb'

describe CparseParser do

  parser = Proj1Parser.new

  it "should parse an int declaration" do
    parser.parse("int a;").result.should be_true
  end

  it "should not parse an invalid int declaration" do
    parser.parse("int a").result.should_not be_true
  end

  it "should not parse assignment of invalid ids" do
    parser.parse("int a:34;").result.should_not be_true
  end

  it "should parse a float declaration" do
    parser.parse("float a;").result.should be_true
  end

  it "should not parse an invalid float declaration" do
    parser.parse("float a,;").result.should_not be_true
  end

  it "should parse an int assignment declaration" do
    parser.parse("int a = 5;").result.should be_true
  end

  it "should not parse an invalid int assignment" do
    parser.parse("int a5 = ;").result.should_not be_true
  end

  it "should parse a float assignment declaration" do
    parser.parse("float a = 5.0;").result.should be_true
  end

  it "should parse a float assignment using an exponent -e notation" do
    parser.parse("float a = 2.3e-3;").result.should be_true
  end

  it "should parse a float assignment using an exponent -E notation" do
    parser.parse("float a = 5E2;").result.should be_true
  end

  it "should not parse an invalid float assignment declaration" do
    parser.parse("float a = 5.0.0;").result.should_not be_true
  end

  it "should parse multiple int declarations" do
    parser.parse("int x, y, z;").result.should be_true
  end

  it "should not parse invalid multiple int declarations" do
    parser.parse("int x, y z;").result.should_not be_true
  end

  it "should parse multiple float declarations" do
    parser.parse("float a, b, c;").result.should be_true
  end

  it "should parse array declarations" do
    parser.parse("float arr[100], arr2[100][50];").result.should be_true
  end

  it "should not parse an invalid array declarations" do
    parser.parse("float arr[100]arr2[100][50];").result.should_not be_true
  end

  it "should parse assignment expressions" do
    parser.parse("int a; a = 5;").result.should be_true
  end

  it "should not parse invalid assignment expressions" do
    parser.parse("int a5; a5 =;").result.should_not be_true
  end

  it "should parse if statements" do
    parser.parse("int c,b; if (1) c=b;").result.should be_true
  end

  it "should not parse invalid if statements" do
    parser.parse("int c,b; if (1 c=b;").result.should_not be_true
  end

  it "should parse if-else statements" do
    parser.parse("int a,c,b; if (1) c=b; else c=a;").result.should be_true
  end

  it "should not parse invalid if-else statements" do
    parser.parse("int a, b, c; if (1) c=b; els c=a; ").result.should_not be_true
  end

  it "should parse while statements" do
    parser.parse("int a, b; while (a < b) a = a + 1;").result.should be_true
  end

  it "should parse equivalence expressions" do
    parser.parse("int a; if (a == 5) a = a +1;").result.should be_true
  end

  it "should parse less_than expressions" do
    parser.parse("int a; if (a < 5) a = a + 1;").result.should be_true
  end

  it "should parse greater_than expressions" do
    parser.parse("int a; {if (a > 5) a = a + 1;}").result.should be_true
  end

  it "should parse addition expressions" do
    parser.parse("int a; a = a + 5;").result.should be_true
  end

  it "should parse subtraction expressions" do
    parser.parse("int a; a = a - 5;").result.should be_true
  end

  it "should parse multiply expressions" do
    parser.parse("int a; a = a * 2;").result.should be_true
  end

  it "should parse divide expressions" do
    parser.parse("int a; a = a / 5;").result.should be_true
  end

  it "should parse AND expressions" do
    parser.parse("int a;  if (a && 5) a = a + 1;").result.should be_true
  end

  it "should parse NOT expressions" do
    parser.parse("int a; if (!(a > 5)) a = a + 1;").result.should be_true
  end

  it "should parse OR expressions" do
    parser.parse("int a; if (a || 5) a = a + 1;").result.should be_true
  end

  it "should not parse an invalid OR expression" do
    parser.parse("int a; if (a ||) a = a + 1").result.should_not be_true
  end

  it "should parse block statements" do
    parser.parse("int a,b,c,d; {a = b + c; d = a * 2;}").result.should be_true
  end

  it "should not parse invalid block statements" do
    parser.parse("int a,b,c,d; {a = b + c; d = a * 2;").result.should_not be_true
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
      }").result.should be_true
  end

  it "should do test right3" do
    parser.parse(
      "float foo = 1, Bar = .1, BAZ = 0.8, foo_bar=-.8, _foo42=-0.1, _=4000000, UuUu=5e2;
      int _test;").result.should be_true
  end

  it "should do test right4" do
    parser.parse(
    "float a, v, d, t, test_test56=4.4e-2, _foo=.4e-2, yy=5E10;").result.should be_true
  end

  it "should do test right5" do
    parser.parse("int /**some comments(*^^$%@$+_0=***/x=0;").result.should be_true
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
       ").result.should be_true
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

       ").result.should be_true
  end

  it "should do test right8" do
    parser.parse("int x, y;
       while (!((x<10)&&(y==5)))
       	x=x+1;

       ").result.should be_true
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

       ").result.should be_true
  end

  it "should do test right10" do
    parser.parse("int y, x;
       int z=y+10-4*(2/x*2)/y;
       ").result.should be_true
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
           ").result.should be_true
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
            ").result.should be_true
  end

  it "should do test right22" do
    parser.parse("int test, x;
     x=((((((((((((((((((((test*10))))))))))+((20))))))))))));

     ").result.should be_true
  end

  it "should not do test wrong1" do
    parser.parse("test i;
    ").result.should_not be_true
  end

  it "should not do test wrong2" do
    parser.parse("INT i;
   ").result.should_not be_true
  end

  it "should not do test wrong3" do
    parser.parse("int for;
   ").result.should_not be_true
  end

  it "should not do test wrong4" do
    parser.parse("int while;
   ").result.should_not be_true
  end

  it "should not do test wrong5" do
    parser.parse("int 2
   float x;
   ").result.should_not be_true
  end

  it "should not do test wrong6" do
    parser.parse("int 2
   float x;
   ").result.should_not be_true
  end

  it "should not do test wrong7" do
    parser.parse("int x y;
   ").result.should_not be_true
  end

  it "should not do test wrong8" do
    parser.parse("int $one;
   ").result.should_not be_true
  end

  it "should not do test wrong9" do
    parser.parse("int #one
   ").result.should_not be_true
  end

  it "should not do test wrong10" do
    parser.parse("int #one
   ").result.should_not be_true
  end

  it "should not do test wrong11" do
    parser.parse("int x{};
   ").result.should_not be_true
  end

  it "should not do test wrong12" do
    parser.parse("int v{4};
   ").result.should_not be_true
  end

  it "should not do test wrong13" do
    parser.parse("int x[4][][4];
   ").result.should_not be_true
  end

  it "should not do test wrong14" do
    parser.parse("if (!test {
   x=x+1;
   }){
   y=0;
   }
   ").result.should_not be_true
  end

  it "should not do test wrong15" do
    parser.parse("{
   	int x,t,y;
   	/*commented}*/

   ").result.should_not be_true
  end

  it "should not do test wrong16" do
    parser.parse("x=9+0-8*6/5tst_10*10;
   ").result.should_not be_true
  end

  it "should not do test wrong17" do
    parser.parse("c=9(4);
   ").result.should_not be_true
  end

  it "should not do test wrong18" do
    parser.parse("x=while+10;
   ").result.should_not be_true
  end

  it "should not do test wrong19" do
    parser.parse("while {
   	/*do something*/
   	x=x;
   }
   ").result.should_not be_true
  end

  it "should not do test wrong20" do
    parser.parse("( a = 0; b ) = 0;
   ").result.should_not be_true
  end

  it "should not parse an attempt to assign float values to an integer" do
    parser.parse("int x, y, z = 5.0 + 1.07;").result.should_not be_true
  end

  it "should not parse an integer using a float index" do
    parser.parse("float r;
	int t[10][10][10], s[10][10][10];
	int a[10];
	t[r][r][r] = t[r][r][r] ==s[r][r][r];").result.should_not be_true
  end
  
  it "should not parse an attempt to declare an array with a float index" do
    parser.parse("int a[10][10.1];").result.should_not be_true
  end
  
end
