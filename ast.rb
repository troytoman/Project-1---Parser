class ASTTree
  include Enumerable

  attr_reader :name
  attr_reader :node_type
  attr_accessor :content
  attr_reader   :parent


  def initialize(name, node_type = nil, content = nil)
    raise ArgumentError, "Node name is required!" if name == nil
    @name, @content = name, content
    @node_type = node_type.split("::").last

    self.set_as_root!
    @children_hash = Hash.new

    @children = []
  end

  def to_s
    "Node Name: #{@name}" +
      " Node Type: " + (@node_type || "<Empty>") +
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

  def type_check(type = nil)
    case @node_type
    when "TypeInt", "TypeFloat"
      puts "TYPE FOUND: " + @content
      return @content
    when "IntegerLiteral"
      puts "Found Int Literal"
      return "int"
    when "FloatLiteral"
      puts "Found Float Literal"
      return "float"
    when "Variable"
      content_hash = @content.split("[").first
      if type
        $symbol_table[content_hash] = type
      end
      puts "Variable: " + (@content.to_s || " <Empty> ") + " Hash: " + content_hash + " " + $symbol_table[@content].to_s
      if !($symbol_table[content_hash])
        puts "Undeclared Variable: " + @content.to_s
        raise "Undeclared Variable"
      end
      return $symbol_table[content_hash]
    when "VariableDeclaration"
      children {|child| type = child.type_check(type)}
      return type
    when "Init"
      children.each do |child|
        t = child.type_check(nil)
        if ((type == "int") && (type != t))
          puts "Initialization error: Value is " + t.to_s + " Expected: " + type.to_s
          raise "TYPE ERROR"
        end
      end
      puts "Init Type:" + (type.to_s || " <Empty>")
      return type
    when "AddExpression", "MinusExpression", "DivExpression", "MultExpression", "ParenExpression"
      children.each do |child|
        t = child.type_check(nil)
        puts "Element of " + @node_type.to_s + " T: " + t.to_s
        if ((type == "float") || (t == "float"))
          type = "float"
        else
          type = t
        end
        puts "Expression " + @node_type.to_s + " Type: " + type.to_s
        return type
      end
    else
      children {|child| type = child.type_check(nil)}
      return type
    end
  end

  def print_tree(level = 0)
    if is_root?
      print "*"
    else
      print "|" unless parent.is_root?
      print(' ' * (level - 1) * 4)
      print(is_root? ? "+" : "|")
      print "---"
      print(has_children? ? "+" : ">")
    end

    puts " #{content}"

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
  def to_json(*a)
    begin
      require 'json'

      json_hash = {
        "name"         => name,
        "content"      => content,
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

  def self.json_create(json_hash)
    begin
      require 'json'

      node = new(json_hash["name"], json_hash["content"])

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
