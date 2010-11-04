# In file node_extensions.rb
module Cparse
  
  class IntegerLiteral < Treetop::Runtime::SyntaxNode
    def to_array
      puts self.text_value
      return self.text_value.to_i
    end
  end
     
  class FloatLiteral < Treetop::Runtime::SyntaxNode
    def to_array
      return self.text_value.to_f
    end
  end
     
  class Identifier < Treetop::Runtime::SyntaxNode
    def to_array
      return self.text_value
    end
  end
     
  class Expression < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements[0].to_array
    end
  end
     
  class Block < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
  end

  class Body < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
  end
 
  class VariableDeclaration < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
  end

  class VariableListItem < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
  end
   
  class TypeInt < Treetop::Runtime::SyntaxNode 
    def to_array
      return "int"
    end
  end

  class TypeFloat < Treetop::Runtime::SyntaxNode 
    def to_array
      return "float"
    end
  end

  class Pointer < Treetop::Runtime::SyntaxNode
    def to_array
      return "*"
    end
  end

  class IfThenElse < Treetop::Runtime::SyntaxNode
    def to_array
      return "If-Then-Else"
    end
  end

  class IfThen < Treetop::Runtime::SyntaxNode
    def to_array
      return "If-Then"
    end
  end

  class While < Treetop::Runtime::SyntaxNode
    def to_array
      return "While"
    end
  end
  
  class VarList < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
  end
 
  class Assignment < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
  end

  class Variable < Treetop::Runtime::SyntaxNode
    def to_array
      return self.text_value
    end
  end
 
 class GTExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return ">"
   end
 end
 
 class LTExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "<"
   end
 end
 
 class EquateExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "=="
   end
 end
 
 class AndExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "&&"
   end
 end
 
 class OrExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "||"
   end
 end

 class AddExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "+"
   end
 end

 class MinusExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "-"
   end
 end

 class DivExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "/"
   end
 end

 class MultExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "*"
   end
 end

 class NotExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "!"
   end
 end

 class ParenExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "="
   end
 end
 
end