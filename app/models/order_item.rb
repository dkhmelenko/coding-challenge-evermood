class OrderItem
  attr_reader :name, :size, :add, :remove

  def initialize(name:, size:, add:, remove:)
    @name = name
    @size = size
    @add = add
    @remove = remove
  end
end