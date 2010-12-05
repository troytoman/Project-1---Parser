# This is the class definition for an ASTTree. It is based on rubytree.
# In it's current implementation, node classes are just based on a field.
# I would like to create actual subclasses in a future implementation

# tree.rb was the starting point for much of the ASTTree definition
# I'm including the copyright for this work as acknowledgement
#
# = tree.rb - Generic implementation of an N-ary tree data structure.
#
# Provides a generic tree data structure with ability to
# store keyed node elements in the tree.  This implementation
# mixes in the Enumerable module.
#
# Author:: Anupam Sengupta (anupamsg@gmail.com)
#

# Copyright (c) 2006, 2007, 2008, 2009, 2010 Anupam Sengupta
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# - Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.
#
# - Neither the name of the organization nor the names of its contributors may
#   be used to endorse or promote products derived from this software without
#   specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

require './cfg.rb'

class ASTTree
  include Enumerable

  attr_reader :name
  attr_reader :node_class
  attr_reader :node_type
  attr_accessor :content
  attr_reader   :parent


  def initialize(name, node_class = nil, content = nil)
    raise ArgumentError, "Name is required!" if name == nil
    @name, @content = name, content
    @node_class = node_class.split("::").last

    self.set_as_root!
    @children_hash = Hash.new

    @children = []
  end

  def to_s
      if has_children? 
        s = children[0].to_s + @content.to_s
        for i in 1 .. children.length-1
          s = s + children[i].to_s
        end
      else
        s = @content.to_s
      end
      return s
  end

  def parent=(parent)         # :nodoc:
    @parent = parent
  end

  def <<(child)
    add(child)
  end

  def add(child, at_index = -1)
    raise ArgumentError, "Attempting to add a nil node" unless child
    raise "Child #{child.name} already added!" if @children_hash.has_key?(child.name)

    if insertion_range.include?(at_index)
      @children.insert(at_index, child)
    else
      raise "Attempting to insert a child at a non-existent location (#{at_index}) when only positions from #{insertion_range.min} to #{insertion_range.max} exist."
    end

    @children_hash[child.name]  = child
    child.parent = self
    return child
  end

  # This is the function for validating type
  def type_check(type = nil)
    children {|child| type = child.type_check(nil)}
    return type
  end
  
  # This is the function for building the control flow graph
  def build_control_flow (block = nil)
    children {|child| type = child.build_control_flow(block)}
    return block
  end
  
  # This method enables printing and AST to the screen
  def print_tree(level = 0)
    if is_root?
      print "\n*"
    else
      print "|" unless parent.is_root?
      print(' ' * (level - 1) * 4)
      print(is_root? ? "+" : "|")
      print "---"
      print(has_children? ? "+" : ">")
    end

    if content
      content_hash = content.split("[").first
    else
      content_hash = nil
    end

    puts " #{content}" + " <Type: " + (@node_type || "no_type") + ">"

    children { |child| child.print_tree(level + 1)}
  end

  def has_content?
    @content != nil
  end

  def set_as_root!
    @parent = nil
  end

  def is_root?
    @parent == nil
  end

  def has_children?
    @children.length != 0
  end

  def is_leaf?
    !has_children?
  end

  def each(&block)             # :yields: node
    yield self
    children { |child| child.each(&block) }
  end

  def each_leaf &block
    self.each { |node| yield(node) if node.is_leaf? }
  end

  def [](name_or_index)
    raise ArgumentError, "Name_or_index needs to be provided!" if name_or_index == nil

    if name_or_index.kind_of?(Integer)
      @children[name_or_index]
    else
      @children_hash[name_or_index]
    end
  end
  def size
    @children.inject(1) {|sum, node| sum + node.size}
  end
  def length
    size()
  end
  def root
    root = self
    root = root.parent while !root.is_root?
    root
  end
  def marshal_dump
    self.collect { |node| node.create_dump_rep }
  end

  # This method creates a json representation of an ASTTree
  def to_json(*a)
    begin
      require 'json/pure'

      json_hash = {
        "name"         => name,
        "content"      => content,
        "node_type"    => node_type,
        "node_class"   => node_class,
        JSON.create_id => self.class.name
      }

      if has_children?
        json_hash["children"] = children
      end

      return json_hash.to_json

    rescue LoadError => e
      warn "The JSON gem couldn't be loaded. Due to this we cannot serialize the tree to a JSON representation"
    end
  end

  # This method is used to create a new ASTTree from a json hash.
  # usage is:
  # another_ast = JSON.parse(j)
  def self.json_create(json_hash)
    begin
      require 'json/pure'

      node = new(json_hash["name"], json_hash["node_class"], json_hash["content"])

      json_hash["children"].each do |child|
        node << child
      end if json_hash["children"]

      return node
    rescue LoadError => e
      warn "The JSON gem couldn't be loaded. Due to this we cannot serialize the tree to a JSON representation."
    end
  end

  def insertion_range
    max = @children.size
    min = -(max+1)
    min..max
  end

  def children
    if block_given?
      @children.each {|child| yield child}
    else
      @children
    end
  end
end

class Variable_AST_Node < ASTTree
  def type_check(type = nil)
    content_hash = @content.split("[").first
    if type                                   #Leverages an inherited type definition for unseen variables
      $symbol_table[content_hash] = type      #Store the inherited type in the symbol table
    end
    if !($symbol_table[content_hash])         #Looks up the type in the symbol table for existing variables
      raise TypeError, "Undeclared Variable: " + @content.to_s
    end
    @node_type = $symbol_table[content_hash]
    return $symbol_table[content_hash]
  end
end

class FloatLiteral_AST_Node < ASTTree
  def type_check(type = nil)
    @node_type = "float"
    return "float"
  end
end

class NotExpression_AST_Node < ASTTree
  def type_check(type = nil)
    children.each do |child|
      t = child.type_check(nil)
      if (t == "float")
        raise TypeError, "Can't use float operands with a ! operator."
      end
    end  
    return type
  end
  def to_s
    s = "!"
     for i in 0 .. children.length-1
       s = s + children[i].to_s
     end
     return s
   end
end

class IntegerLiteral_AST_Node < ASTTree
  def type_check(type = nil)
    @node_type = "int"
    return "int"
  end
end

class EquateExpression_AST_Node < ASTTree
  def type_check(type = nil)
    type = nil
    children.each do |child|
      t = child.type_check(nil)
      if type 
        if ((type != t) && (child.node_class != "IntegerLiteral")) 
          raise TypeError, "Using equate expression for: <Type:" + t.to_s + "> and: <Type:" + type.to_s + ">"
        end
      else
        if child.node_class != "IntegerLiteral"
          type = t
        end
      end
      @node_type = type
    end
    return "int"
  end
end

class Operator_AST_Node < ASTTree  # Add, Minus, Div, Mult, Paren
  def type_check(type = nil)
    children.each do |child|
      t = child.type_check(type)
      if ((type == "float") || (t == "float"))  #gathers the type info for operators
        type = "float"                          #if one term is float all is considered float
      else
        type = "int"
      end
      @node_type = type
    end
    return type
  end    
  def to_s
    if (@content == "( )")
      s = "("
       for i in 0 .. children.length-1
         s = s + children[i].to_s
       end
       s = s + ")"
    else 
      super
    end
  end
end

class Assignment_AST_Node < ASTTree
  def type_check(type = nil)
    children.each do |child|
      t = child.type_check(nil)
      if (child == children.first)
        type = t
      end
      if ((type == "int") && (type != t))     #Validates that we are not assigning an int w/float
        raise TypeError, "Assignment Expression is: <Type:" + t.to_s + "> Expected was: <Type:" + type.to_s + ">"
      end
    end
    @node_type = type
    return type
  end
  def build_control_flow(block=nil)
    puts "add statement to block: " + self.to_s  
    block<<self
    children {|child| type = child.build_control_flow(block)}
    return block
  end
  def to_s
    s = children[0].to_s + '='
    for i in 1 .. children.length-1
      s = s + children[i].to_s
    end
    return s
  end
end

class Declaration_AST_Node < ASTTree
  def type_check(type = nil)
    children {|child| type = child.type_check(type)}
    return type
  end
end

class Init_AST_Node < ASTTree
  def type_check(type = nil)
    children.each do |child|
      t = child.type_check(nil)
      if ((type == "int") && (type != t))     #Validates that we are not initializing an int w/float
        raise TypeError, "Initialization Expression is: <Type:" + t.to_s + "> Expected was: <Type:" + type.to_s + ">"
      end
    end
    @node_type = type
    return type
  end
  
  def build_control_flow(block)
    puts "add statement to block: " + self.to_s  
    
    block<<self
    next_block = block
    children.each {|child| next_block = child.build_control_flow(next_block)}
    return next_block
  end
  def to_s
    s = children[0].to_s + '='
    for i in 1 .. children.length-1
      s = s + children[i].to_s
    end
    return s
  end
end

class Type_AST_Node < ASTTree
  def type_check(type = nil)
    return @content
  end
end

class While_AST_Node < ASTTree
  def build_control_flow(block)
    
    next_block = ControlFlowGraph.new        # Create a block for after the while statement
    while_statement = ControlFlowGraph.new   # Create new basic block
    while_statement << self                  # Add the while statement to the block
    while_statement.edge(next_block)         # Connect the while statement to the next block
    block.move_edges(next_block)             # move any existing edges to the next block
    block.edge(while_statement)              # Connect previous block to while block
    
    while_block = ControlFlowGraph.new       # Create a new basic block for while body
    while_statement.edge(while_block)        # Connect while statement block to the while body
    while_block.edge(while_statement)        # Connect the while body back to while statement block
    
    children.each {|child| child.build_control_flow(while_block)}
    
    puts "ENDWHILE"
    
    return next_block
  end
  def to_s
    string = "while (" + children[0].to_s + ")"
  end
end

class IfThen_AST_Node < ASTTree
  def build_control_flow(block)
    new_block = ControlFlowGraph.new         # create new block for post branch
    block.move_edges(new_block)              # move any existing edges to the next block
    block << self                            # add if statement to current block
    then_block = ControlFlowGraph.new        # create block for the branch
    block.edge(then_block)                   # create and edge from current block to then branch
    children[1].build_control_flow(then_block) # build the control flow for then branch
    block.edge(new_block)                    # create an edge from the existing block to post branch block
    then_block.edge(new_block)               # create an edge from the then block to post branch block
    
    return new_block    
  end
  def to_s
    string = "if (" + children[0].to_s + ")"
    return string
  end
end

class IfThenElse_AST_Node < ASTTree
  def build_control_flow(block)
    new_block = ControlFlowGraph.new         # create new block for post branch
    block.move_edges(new_block)              # move any existing edges to the next block
    block << self                            # add if statement to current block
    
    then_block = ControlFlowGraph.new        # create block for the then branch
    block.edge(then_block)                   # create and edge from current block to then branch
    children[1].build_control_flow(then_block) # build the control flow for then branch
    then_block.edge(new_block)               # create an edge from the then block to post branch block          
    
    else_block = ControlFlowGraph.new        # create block for the else branch
    block.edge(else_block)                   # create and edge from current block to then branch
    children[2].build_control_flow(else_block) # build the control flow for then branch
    else_block.edge(new_block)               # create an edge from the then block to post branch block             
    
    return new_block
  end
  def to_s
    string = "if (" + children[0].to_s + ") then-else"
    return string
  end
end

class Block_AST_Node < ASTTree
  def build_control_flow(block)
    puts "New Block: " + @node_class.to_s  
    
    next_block = block
    children.each {|child| next_block = child.build_control_flow(next_block)}
    
    puts "ENDBLOCK"
    return next_block
  end
end

class Program_AST_Node < ASTTree
  def build_control_flow(block = nil)
    puts "New Program: " + @node_class.to_s  
    
    block = ControlFlowGraph.new
    
    children.each {|child| child.build_control_flow(block)}
    
    puts "ENDPROGRAM"
    return block
  end
end