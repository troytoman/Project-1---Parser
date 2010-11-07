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

tree = parser.parse(parsestring)
  
  
puts ("\n" * 2)
