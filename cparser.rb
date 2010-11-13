#!/usr/bin/env ruby
# Partial C parser
# Troy Toman

require 'rubygems'
require 'treetop'
puts 'Loaded Treetop with no problems...'

require './node_extensions.rb'

Treetop.load 'cparse'
puts 'Loaded cparse grammar with no problems...'

class Proj1Parser
  attr_reader :message, :result

  def initialize
    puts 'initializing'
    @cparser =  CparseParser.new
    $symbol_table = {}
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
        ast_prime = ASTTree.new("Program", "Program")
        ast.each  {|node| ast_prime<<node}
        ast = ast_prime
      end
      begin
        ast.type_check
      rescue
        puts "Type Error\n\n"
        ast.print_tree
        
        return nil
      end
      ast.print_tree
      return ast
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
