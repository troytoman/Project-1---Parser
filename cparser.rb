#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

require 'rubygems'
require 'treetop'
puts 'Loaded Treetop with no problems...'

Treetop.load 'cparse'
puts 'Loaded cparse grammar with no problems...'

class Proj1Parser
  attr_reader :message, :result
  
  def initialize
    puts 'initializing'
   @cparser =  CparseParser.new
  end
  
  def parse (input)
    
    input.gsub!(/([^a-zA-Z0-9])\s*/,'\1')    #remove whitespace (except near IDs)
    input.gsub!(/\s*([^a-zA-Z0-9{}])/,'\1')    
    input.gsub!(/\/\*(([^\*])|(\*[^\/]))*\*\//,'')  
    
    puts input

    if @cparser.parse(input)
      @message = "Yes! I understand!"
      true
    else
      @message = "No, I don't understand.\n"
      unless @cparser.terminal_failures.empty?
        @message += @cparser.failure_reason
      else
        @message += "I had a problem with line #{parser.failure_line} column #{parser.index+1}\n"
        @message += "To be honest, I was not expecting you to say anything more.\n"
      end
      puts message
      false
    end    
  end
   
end