#!/usr/bin/env ruby
# Partial C parser
# Troy Toman

require 'rubygems'
require 'treetop'
puts 'Loaded Treetop with no problems...'

require 'graphviz'

require './node_extensions.rb'

Treetop.load 'cparse'
puts 'Loaded cparse grammar with no problems...'

class Proj1Parser
  attr_reader :message, :result, :ast, :g

  def initialize
    puts 'initializing'
    @cparser =  CparseParser.new
    $symbol_table = {}            # Creates an empty global symbol table
  end

  def parse (input)
    $symbol_table = {}
    $array_indices = Array.new    # Track the list of variables used as array indices
    @ast = nil                    # Nil out the AST and CFG
    @cfg = nil
    # initialize new Graphviz graph
    @g = GraphViz::new( "structs", "type" => "graph" )
    @g[:rankdir] = "TD"

    # set global node options
    @g.node[:color]    = "#ddaa66"
    @g.node[:style]    = "filled"
    @g.node[:shape]    = "box"
    @g.node[:penwidth] = "1"
    @g.node[:fontname] = "Trebuchet MS"
    @g.node[:fontsize] = "8"
    @g.node[:fillcolor]= "#ffeecc"
    @g.node[:fontcolor]= "#775500"
    @g.node[:margin]   = "0.0"

    # set global edge options
    @g.edge[:color]    = "#999999"
    @g.edge[:weight]   = "1"
    @g.edge[:fontsize] = "6"
    @g.edge[:fontcolor]= "#444444"
    @g.edge[:fontname] = "Verdana"
    @g.edge[:dir]      = "forward"
    @g.edge[:arrowsize]= "0.5"

    # remove whitespace and comments from the input file
    input.gsub!('\n','')
    input.gsub!('\t','')
    input.gsub!(/([^a-zA-Z0-9])\s*/,'\1')    #remove whitespace (except near IDs)
    input.gsub!(/\s*([^a-zA-Z0-9{}])/,'\1')
    input.gsub!(/\/\*(([^\*])|(\*[^\/]))*\*\//,'')  #strip comments

    tree = @cparser.parse(input)

    if tree != nil
      @message = "\nYes! I understand!\n"
      self.get_indices(tree)               # Grab the array_indices in the parse tree before pruning
      self.clean_tree(tree)                # Remove most useless parse tree nodes
      @ast = tree.to_ast                   # Construct the AST
      if @ast.kind_of?(Array)              # If the AST has multiple statements, add a Program parent
        ast_prime = Program_AST_Node.new("Program", "Program", "Program")
        @ast.each  {|node| ast_prime<<node}
        @ast = ast_prime
      end
      begin
        @ast.type_check                    # Perform type checking on the AST
        self.check_array_indices           # Validate that only integers are used as array indices
      rescue => error                      # Handle any Type Checking Errors and exit
        @message = "\nNo, I don't understand.\n"
        @message +=  "!!!!!!! #{error.class}: #{error.message}\n\n"
        @result = nil
        return self
      end
      @result = true                       # Mark the parse as successful
      @cfg = @ast.build_control_flow       # build the control flow graph
      @cfg.to_dot(@g)
      return self
    else
      @message = "\n\nNo, I don't understand.\n"  # Handle parsing errors
      unless @cparser.terminal_failures.empty?
        @message += @cparser.failure_reason
      else
        @message += "I had a problem with line #{parser.failure_line} column #{parser.index+1}\n"
        @message += "To be honest, I was not expecting you to say anything more.\n"
      end
      @result = nil
      return self
    end
  end


# This method removes and non-specific nodes from the parse tree
  def clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each {|node| self.clean_tree(node) }
  end

# This method traverses a cleaned parse tree and builds an AST
  def build_ast(root_node)
    ast_subtree = Tree::TreeNode.new(root_node.class.name)
    root_node.elements.each {|node| ast_subtree<<build_ast(node) }
    ast_subtree
  end

# This method walks a parse tree to create a list of variables that are used to index arrays
  def get_indices(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.each do |node|
      if (node.class.name == "Cparse::ArrayVariableIndex")
        $array_indices << node.text_value.gsub!(/[\[\]]/, '')
      end
      self.get_indices(node)
    end
  end
  
# This method checks array indices and makes sure they are integers
  def check_array_indices
    $array_indices.each do |index|
      if ($symbol_table[index] != "int")
#        puts "Invalid array index: " + index + '\n'
        raise TypeError, "Invalid array index: " + index + "\n"
      end
    end
  end
end