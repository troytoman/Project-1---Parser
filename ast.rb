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
    "Node Name: #{@name}" +
      " Node Type: " + (@node_class || "<Empty>") +
      " Content: " + (@content || "<Empty>") +
      " Parent: " + (is_root?()  ? "<None>" : @parent.name) +
      " Children: #{@children.length}" +
      " Total Nodes: #{size()}"
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
    case @node_class
    when "TypeInt", "TypeFloat"   #Recognizes a "type" definition and passes back to VariableDeclaration
      return @content
    when "IntegerLiteral"         #Sets type for a integer literal
      @node_type = "int"
      return "int"
    when "FloatLiteral"           #Sets type for a float literal
      @node_type = "float"
      return "float"
    when "Variable"
      content_hash = @content.split("[").first
      if type                                   #Leverages an inherited type definition for unseen variables
        $symbol_table[content_hash] = type      #Store the inherited type in the symbol table
      end
      if !($symbol_table[content_hash])         #Looks up the type in the symbol table for existing variables
        raise TypeError, "Undeclared Variable: " + @content.to_s
      end
      @node_type = $symbol_table[content_hash]
      return $symbol_table[content_hash]
    when "VariableDeclaration"                  #Gets and then passes on the type for the declaration
      children {|child| type = child.type_check(type)}
      return type
    when "Init"
      children.each do |child|
        t = child.type_check(nil)
        if ((type == "int") && (type != t))     #Validates that we are not initializing an int w/float
          raise TypeError, "Initialization Expression is: <Type:" + t.to_s + "> Expected was: <Type:" + type.to_s + ">"
        end
      end
      @node_type = type
      return type
    when "AssignmentExpression"
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
    when "AddExpression", "MinusExpression", "DivExpression", "MultExpression", "ParenExpression"
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
    else
      children {|child| type = child.type_check(nil)}
      return type
    end
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
