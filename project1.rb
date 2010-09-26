#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

require 'rubygems'
require 'treetop'
puts 'Loaded Treetop with no problems...'

Treetop.load 'cparse'
puts 'Loaded cparse grammar with no problems...'

parser = CparseParser.new

print "You say: "; what_you_said = gets
what_you_said.strip! # remove the newline at the end

if parser.parse(what_you_said)
  puts "I say yes! I understand!"
else
  puts "I say no, I don't understand."
  unless parser.terminal_failures.empty?
    puts parser.failure_reason
  else
    puts "I had a problem with line #{parser.failure_line} column #{parser.index+1}"
    puts "To be honest, I was not expecting you to say anything more."
  end
end