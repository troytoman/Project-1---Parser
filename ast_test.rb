#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

load './cparser.rb'

describe CparseParser do
  
  parser = Proj1Parser.new
  
  

  it "should do allow float == intliteral" do
    ast = parser.parse('int x, y; float z;
                        if (0 == z) x = x+y;')
    puts ast.message
    if ast.ast
      ast.ast.print_tree
    end  
    ast.result.should be_true
    cfg = ast.ast.build_control_flow
    puts "\n CONTROL FLOW GRAPH OUTPUT\n"
    puts cfg.to_s
  end


  it "should parse the test input" do
    ast = parser.parse(
      'float a[100][100], b[100][100], c[100][100]; 
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
            }')
    puts ast.message
    if ast.ast
      ast.ast.print_tree
    end
    ast.result.should be_true
    ast.g.output( :pdf => :"./graph.pdf" )
  end
end
