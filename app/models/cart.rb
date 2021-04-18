class Cart
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(product_id, quantity = 1)
    found = @items.find { |item| item.product_id == product_id }
    found.nil? ? @items << CartItem.new(product_id, quantity) : found.increment!(quantity)
  end

  def empty?
    @items.empty?
  end
end