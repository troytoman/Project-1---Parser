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



end