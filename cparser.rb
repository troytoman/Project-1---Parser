#!/usr/bin/env ruby
# Partial C parser 
# Troy Toman

require 'rubygems'
require 'treetop'
puts 'Loaded Treetop with no problems...'

require './node_extensions.rb'
require 'tree'

class Tree::TreeNode
  def print_tree(level = 0)
    if is_root?
      print "*"
    else
      print "|" unless parent.is_last_sibling?
      print(' ' * (level - 1) * 4)
      print(is_last_sibling? ? "+" : "|")
      print "---"
      print(has_children? ? "+" : ">")
    end

    puts " #{content}"

    children { |child| child.print_tree(level + 1)}
  end
end

Treetop.load 'cparse'
puts 'Loaded cparse grammar with no problems...'

class Proj1Parser
  attr_reader :message, :result
  
  def initialize
    puts 'initializing'
   @cparser =  CparseParser.new
  end
  
  def parse (input)
    
    puts "\n" + "TEST: " + input + "\n"
    
    input.gsub!(/([^a-zA-Z0-9])\s*/,'\1')    #remove whitespace (except near IDs)
    input.gsub!(/\s*([^a-zA-Z0-9{}])/,'\1')    
    input.gsub!(/\/\*(([^\*])|(\*[^\/]))*\*\//,'')  
    
#    puts input
    tree = @cparser.parse(input)

    if tree != nil
      @message = "\nYes! I understand!\n\n"
      puts @message
          self.clean_tree(tree)
      #    tree.printout
          ast = tree.to_ast
          if ast.kind_of?(Array) 
            ast_prime = Tree::TreeNode.new("Program", "Program")
            ast.each  {|node| ast_prime<<node}
            ast_prime.print_tree
            return ast_prime
           else
             ast.print_tree
           return ast
           end
 #     true
    else
      @message = "No, I don't understand.\n"
      unless @cparser.terminal_failures.empty?
        @message += @cparser.failure_reason
      else
        @message += "I had a problem with line #{parser.failure_line} column #{parser.index+1}\n"
        @message += "To be honest, I was not expecting you to say anything more.\n"
      end
      puts message
 #     false
    end   

  

  end
     
  def clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
 #   root_node.elements.each {|node| node.class.name == "Cparse::VarList"}
    root_node.elements.each {|node| self.clean_tree(node) }
  end
  
  def build_ast(root_node)
    ast_subtree = Tree::TreeNode.new(root_node.class.name)
    root_node.elements.each {|node| ast_subtree<<build_ast(node) } 
    ast_subtree
  end
end