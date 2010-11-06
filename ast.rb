class ASTTree
  attr_reader :value
  def initialize(value)
    @value = value
    @children = []
  end
  
  def <<(value)
    subtree = ASTTree.new(value)
    @children << subtree
    return subtree
  end
end