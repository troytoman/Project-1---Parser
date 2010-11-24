#!/usr/bin/env ruby
# Partial C parser
# Troy Toman

require './cparser.rb'

def ast_print(t)
  puts t.to_s
  t.children.each {|child| ast_print(child)}
end

parser = Proj1Parser.new

puts ("\n" * 10)

print "What file would you like to parse? "; filename = gets
filename.strip! # remove the newline at the end

puts ("\n" * 4)

parseFile = File.new(filename, "r")

parsestring = parseFile.read

parse_result = parser.parse(parsestring)

puts "RESULTS:" + parse_result.message
if parse_result.ast
  puts "Printing AST: \n"
  parse_result.ast.print_tree
  if parse_result.result
    puts "\nCreating json format"
    j = parse_result.ast.to_json
    puts j
    puts "\nCreating new AST from the json"
    another_ast = JSON.parse(j)
    another_ast.type_check
    another_ast.print_tree
  end
end

puts ("\n" * 2)
