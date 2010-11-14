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
    $symbol_table = {}
    $array_indicies = Array.new

    puts "\n" + "TEST: " + input + "\n"

    input.gsub!(/([^a-zA-Z0-9])\s*/,'\1')    #remove whitespace (except near IDs)
    input.gsub!(/\s*([^a-zA-Z0-9{}])/,'\1')
    input.gsub!(/\/\*(([^\*])|(\*[^\/]))*\*\//,'')

    tree = @cparser.parse(input)

    if tree != nil
      @message = "\nYes! I understand!\n\n"
#      puts @message
      self.get_indicies(tree)
      self.clean_tree(tree)
      ast = tree.to_ast
      if ast.kind_of?(Array)
        ast_prime = ASTTree.new("Program", "Program", "Program")
        ast.each  {|node| ast_prime<<node}
        ast = ast_prime
      end
      begin
        ast.type_check
        self.check_array_indicies
      rescue => error
        @message = "\n\nNo, I don't understand."
        puts @message
        puts "!!!!!!! #{error.class}: #{error.message}\n\n"
        ast.print_tree
        return nil
      end
      puts @message
      ast.print_tree
      return ast
    else
      @message = "\n\nNo, I don't understand.\n"
      unless @cparser.terminal_failures.empty?
        @message += @cparser.failure_reason
      else
        @message += "I had a problem with line #{parser.failure_line} column #{parser.index+1}\n"
        @message += "To be honest, I was not expecting you to say anything more.\n"
      end
      puts message
    end
  end

  def clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each {|node| self.clean_tree(node) }
  end

  def build_ast(root_node)
    ast_subtree = Tree::TreeNode.new(root_node.class.name)
    root_node.elements.each {|node| ast_subtree<<build_ast(node) }
    ast_subtree
  end

  def get_indicies(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.each do |node|
      if (node.class.name == "Cparse::ArrayVariableIndex")
        $array_indicies << node.text_value.gsub!(/[\[\]]/, '')
      end
      self.get_indicies(node)
    end
  end
  
  def check_array_indicies
    $array_indicies.each do |index|
      if ($symbol_table[index] != "int")
#        puts "Invalid array index: " + index + '\n'
        raise TypeError, "Invalid array index: " + index + '\n'
      end
    end
  end
end
