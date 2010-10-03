#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

require 'rubygems'
require 'treetop'
puts 'Loaded Treetop with no problems...'

Treetop.load 'cparse'
puts 'Loaded cparse grammar with no problems...'

class Proj1Parser
  def initialize
    puts 'initializing'
   @cparser =  CparseParser.new
  end
  
  def parse (input)
    input.gsub!(' ','')
    input.gsub!(/[\n\r]/, "")
    puts input
    if @cparser.parse(input)
      puts "I say yes! I understand!"
      true
    else
      puts "I say no, I don't understand."
      unless @cparser.terminal_failures.empty?
        puts @cparser.failure_reason
      else
        puts "I had a problem with line #{parser.failure_line} column #{parser.index+1}"
        puts "To be honest, I was not expecting you to say anything more."
      end
    end    
  end
   
end