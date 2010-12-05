require 'graphviz'

class ControlFlowGraph
  attr_reader :graph_node

  def initialize
    puts "CREATING BLOCK"
    @statements = []
    @outbound_edges = []
    @inbound_edges = []
  end
  def <<(statement)
    puts "ADDING STATEMENT " + statement.to_s
    @statements << statement
  end
  def edge(block)
    @outbound_edges << block
    block.inboundedge(self)
    puts "CREATED EDGE FROM: " #+ self.to_s #+ " TO: " + block.to_s
  end
  def inboundedge(block)
    @inbound_edges << block
  end
  def remove_inbound(block)
    @inbound_edges.delete(block)
  end
  def move_edges(block)
    @outbound_edges.each do |e|
      e.remove_inbound(self)
      block.edge(e)
    end
    @outbound_edges = []
  end
  def to_s(nodes=[])

    puts "\nNEW BLOCK\n"
 
    if @statements.empty?
      puts "<End of Program>"
    else
      @statements.each {|stmt| puts stmt.to_s + "\n" } 
    end

    
    puts "OUTBOUND EDGE COUNT = " + @outbound_edges.length.to_s
    puts "INBOUND EDGE COUNT = " + @inbound_edges.length.to_s
    

    nodes<<self
    
    if @outbound_edges.empty?
      puts "<No Edges>"
    else
      @outbound_edges.each { |edge| edge.to_s(nodes) unless nodes.include?(edge) }
    end
    puts "\nEND BLOCK\n"
  end
  def to_dot(g, nodes=[])
    if @statements.empty?
      @graph_node = "<End of Program>"
    else
      @graph_node = ""
      @statements.each {|stmt| @graph_node = @graph_node + stmt.to_s + "\n" } 
    end
    
    puts "Adding dotfile node: " + @graph_node
    g.add_node(@graph_node).label = @graph_node
  
    nodes << self
    
    unless @outbound_edges.empty?
      @outbound_edges.each do |edge| 
        unless nodes.include?(edge)
          edge.to_dot(g,nodes) 
        end
          g.add_edge(@graph_node, edge.graph_node)
      end   
    end
  end
end
