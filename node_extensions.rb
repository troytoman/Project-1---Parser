# In file node_extensions.rb
module Cparse
  
  class IntegerLiteral < Treetop::Runtime::SyntaxNode
    def to_array
      return self.text_value.to_i
    end
    def printout
      puts ' ' * @interval.first + self.text_value
      self.elements.map {|x| x.printout}
    end
  end
     
  class FloatLiteral < Treetop::Runtime::SyntaxNode
    def to_array
      return self.text_value.to_f
    end
      def printout
        puts ' ' * @interval.first + self.text_value
        self.elements.map {|x| x.printout}
      end
  end
     
  class Identifier < Treetop::Runtime::SyntaxNode
    def to_array
      return self.text_value
    end
      def printout
        puts ' ' * @interval.first + self.text_value
        self.elements.map {|x| x.printout}
      end
  end
     
  class Expression < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements[0].to_array
    end
      def printout
        puts ' ' * @interval.first + "Expression"
        self.elements.map {|x| x.printout}
      end
  end
     
  class Block < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
      def printout
        puts ' ' * @interval.first + "Block"
        self.elements.map {|x| x.printout}
      end
  end

  class Statement < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
      end
      def printout
        #puts ' ' * @interval.first + "Statement"
        self.elements.map {|x| x.printout}
      end
  end
 
  class VariableDeclaration < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
      def printout
        puts ' ' * @interval.first + "Variable Declaration"
        self.elements.map {|x| x.printout}
      end
  end

  class VariableListItem < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
      def printout
        #puts self.text_value
        self.elements.map {|x| x.printout}
      end
  end
   
  class TypeInt < Treetop::Runtime::SyntaxNode 
    def to_array
      return "int"
    end
      def printout
        puts ' ' * @interval.first + "int"
        self.elements.map {|x| x.printout}
      end
  end

  class TypeFloat < Treetop::Runtime::SyntaxNode 
    def to_array
      return "float"
    end
      def printout
        puts ' ' * @interval.first + "float"
#        self.elements.map {|x| x.printout}
      end
  end

  class Pointer < Treetop::Runtime::SyntaxNode
    def to_array
      return "*"
    end
      def printout
        puts ' ' * @interval.first + "*"
#        self.elements.map {|x| x.printout}
      end
  end

  class IfThenElse < Treetop::Runtime::SyntaxNode
    def to_array
      return "If-Then-Else"
    end
      def printout
        puts ' ' * @interval.first + "If-Then-Else"
        self.elements.map {|x| x.printout}
      end
  end

  class IfThen < Treetop::Runtime::SyntaxNode
    def to_array
      return "If-Then"
    end
      def printout
        puts ' ' * @interval.first + "If-Then"
        self.elements.map {|x| x.printout}
      end
  end

  class While < Treetop::Runtime::SyntaxNode
    def to_array
      return "While"
    end
      def printout
        puts ' ' * @interval.first + "While"
        self.elements.map {|x| x.printout}
      end
  end
  
  class VarList < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
    def printout
      puts ' ' * @interval.first + self.class.name
      self.elements.map {|x| x.printout}
    end
    def remove_if(classname)
      self.elements.map {|x| x.parent = self.parent} if self.class.name == classname
    end
  end
 
  class Assignment < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
      def printout
        puts ' ' * @interval.first + "DeclarationAssignment"
        self.elements.map {|x| x.printout}
      end
  end

  class AssignmentExpression < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
      def printout
        puts ' ' * @interval.first + "Assignment"
        self.elements.map {|x| x.printout}
      end
  end
  
  class Variable < Treetop::Runtime::SyntaxNode
    def to_array
      return self.text_value
    end
      def printout
        puts ' ' * @interval.first + self.text_value
        self.elements.map {|x| x.printout}
      end
  end
 
 class GTExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return ">"
   end
     def printout
       puts ' ' * @interval.first + ">"
       self.elements.map {|x| x.printout}
     end
 end
 
 class LTExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "<"
   end
     def printout
       puts ' ' * @interval.first + "<"
       self.elements.map {|x| x.printout}
     end
 end
 
 class EquateExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "=="
   end
     def printout
       puts ' ' * @interval.first + "=="
       self.elements.map {|x| x.printout}
     end
 end
 
 class AndExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "&&"
   end
     def printout
       puts ' ' * @interval.first + "&&"
       self.elements.map {|x| x.printout}
     end
 end
 
 class OrExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "||"
   end
     def printout
       puts ' ' * @interval.first + "||"
       self.elements.map {|x| x.printout}
     end
 end

 class AddExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "+"
   end
     def printout
       puts ' ' * @interval.first + "+"
       self.elements.map {|x| x.printout}
     end
 end

 class MinusExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "-"
   end
     def printout
       puts ' ' * @interval.first + "-"
       self.elements.map {|x| x.printout}
     end
 end

 class DivExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "/"
   end
     def printout
       puts ' ' * @interval.first + "/"
       self.elements.map {|x| x.printout}
     end
 end

 class MultExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "*"
   end
     def printout
       puts ' ' * @interval.first + "*"
       self.elements.map {|x| x.printout}
     end
 end

 class NotExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "!"
   end
     def printout
       puts ' ' * @interval.first + "!"
       self.elements.map {|x| x.printout}
     end
 end

 class ParenExpression < Treetop::Runtime::SyntaxNode
   def to_array
     return "="
   end
     def printout
       puts ' ' * @interval.first + "( )"
       self.elements.map {|x| x.printout}
     end
 end
 
end