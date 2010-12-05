# In file node_extensions.rb
module Cparse
  require './ast.rb'  

  class Treetop::Runtime::SyntaxNode
    
    # This method generates an AST node for a parse tree node.
    # It is sometimes replaced by certain nodes that do not need to be in the AST
    def to_ast(ast_subtree = nil)
      if !ast_subtree
        ast_subtree = ASTTree.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      end
      self.elements.each do |node|
        child = node.to_ast
        if child.kind_of?(Array)
          child.each {|node| ast_subtree<<node}
        else
          ast_subtree<<child
        end
      end
      ast_subtree
    end
  end

  class IntegerLiteral < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = self.text_value
    end
    def to_array
      return self.text_value.to_i
    end
    def printout
      puts ' ' * @interval.first + self.text_value
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = IntegerLiteral_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class FloatLiteral < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = self.text_value
    end
    def to_array
      return self.text_value.to_f
    end
    def printout
      puts ' ' * @interval.first + self.text_value
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = FloatLiteral_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class Expression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "Expression"
    end
    def to_array
      return self.elements[0].to_array
    end
    def printout
      puts ' ' * @interval.first + "Expression"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = ASTTree.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class Block < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "Block"
    end
    def to_array
      return self.elements.map {|x| x.to_array}
    end
    def printout
      puts ' ' * @interval.first + "Block"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Block_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class Statement < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "Statement"
    end
    def to_array
      return self.elements.map {|x| x.to_array}
    end
    def printout
      #puts ' ' * @interval.first + "Statement"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = ASTTree.new(self.class.name, @nodedisplay)
      self.elements.each do |node|
        child = node.to_ast
        if child.kind_of?(Array)
          child.each {|node| ast_subtree<<node}
        else
          ast_subtree<<child
        end
      end
      ast_subtree.children
    end
  end

  class VariableDeclaration < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "Variable Declaration"
    end
    def to_array
      return self.elements.map {|x| x.to_array}
    end
    def printout
      puts ' ' * @interval.first + "Variable Declaration"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Declaration_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class VariableListItem < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = self.text_value
    end
    def to_array
      return self.elements.map {|x| x.to_array}
    end
    def printout
      #puts self.text_value
      self.elements.map {|x| x.printout}
    end
    def to_ast 
      ast_subtree = ASTTree.new(self.class.name, @nodedisplay)
      self.elements.each do |node|
        child = node.to_ast
        if child.kind_of?(Array)
          child.each {|node| ast_subtree<<node}
        else
          ast_subtree<<child
        end
      end
      ast_subtree.children
    end
  end

  class TypeInt < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "int"
    end
    def to_array
      return "int"
    end
    def printout
      puts ' ' * @interval.first + "int"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Type_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class TypeFloat < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "float"
    end
    def to_array
      return "float"
    end
    def printout
      puts ' ' * @interval.first + "float"
    end
    def to_ast
      ast_subtree = Type_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class Pointer < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "pointer"
    end
    def to_array
      return "pointer"
    end
    def printout
      puts ' ' * @interval.first + "pointer"
    end
    def to_ast
      ast_subtree = ASTTree.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class IfThenElse < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "If-Then-Else"
    end
    def to_array
      return "If-Then-Else"
    end
    def printout
      puts ' ' * @interval.first + "If-Then-Else"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = IfThenElse_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class IfThen < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "If-Then"
    end
    def to_array
      return "If-Then"
    end
    def printout
      puts ' ' * @interval.first + "If-Then"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = IfThen_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class While < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "While"
    end
    def to_array
      return "While"
    end
    def printout
      puts ' ' * @interval.first + "While"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = While_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class VarList < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "VarList"
    end
    def to_array
      return self.elements.map {|x| x.to_array}
    end
    def printout
      puts ' ' * @interval.first + self.class.name
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = ASTTree.new("remove", "remove")
      self.elements.each do |node|
        child = node.to_ast
        if child.kind_of?(Array)
          child.each {|node| ast_subtree<<node}
        else
          ast_subtree<<child
        end
      end
      ast_subtree.children
    end
  end

  class Init < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "Init"
    end
    def to_array
      return self.elements.map {|x| x.to_array}
    end
    def printout
      puts ' ' * @interval.first + "DeclarationAssignment"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Init_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class AssignmentExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "Assignment"
    end
    def to_array
      return self.elements.map {|x| x.to_array}
    end
    def printout
      puts ' ' * @interval.first + "Assignment"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Assignment_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class Variable < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = self.text_value
    end
    def to_array
      return self.text_value
    end
    def printout
      puts ' ' * @interval.first + self.text_value
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Variable_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class ArrayVariableIndex < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = self.text_value.gsub!(/[\[\]]/, '')
    end
    def to_array
      return self.text_value
    end
    def printout
      puts ' ' * @interval.first + self.text_value
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = ASTTree.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end
  
  class GTExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = ">"
    end
    def to_array
      return ">"
    end
    def printout
      puts ' ' * @interval.first + ">"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = ASTTree.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class LTExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "<"
    end
    def to_array
      return "<"
    end
    def printout
      puts ' ' * @interval.first + "<"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = ASTTree.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class EquateExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "=="
    end
    def to_array
      return "=="
    end
    def printout
      puts ' ' * @interval.first + "=="
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = EquateExpression_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class AndExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "&&"
    end
    def to_array
      return "&&"
    end
    def printout
      puts ' ' * @interval.first + "&&"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = ASTTree.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class OrExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "||"
    end
    def to_array
      return "||"
    end
    def printout
      puts ' ' * @interval.first + "||"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = ASTTree.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class AddExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "+"
    end
    def to_array
      return "+"
    end
    def printout
      puts ' ' * @interval.first + "+"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Operator_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class MinusExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "-"
    end
    def to_array
      return "-"
    end
    def printout
      puts ' ' * @interval.first + "-"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Operator_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class DivExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "/"
    end
    def to_array
      return "/"
    end
    def printout
      puts ' ' * @interval.first + "/"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Operator_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class MultExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "*"
    end
    def to_array
      return "*"
    end
    def printout
      puts ' ' * @interval.first + "*"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Operator_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class NotExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "!"
    end
    def to_array
      return "!"
    end
    def printout
      puts ' ' * @interval.first + "!"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = NotExpression_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

  class ParenExpression < Treetop::Runtime::SyntaxNode
    def initialize(input, interval, elements = nil)
      super(input, interval, elements)
      @nodedisplay = "( )"
    end
    def to_array
      return "="
    end
    def printout
      puts ' ' * @interval.first + "( )"
      self.elements.map {|x| x.printout}
    end
    def to_ast
      ast_subtree = Operator_AST_Node.new(self.class.name+@interval.first.to_s, self.class.name, @nodedisplay)
      super(ast_subtree)
    end
  end

end
