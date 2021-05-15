class Cart
  attr_reader :items

  def initialize(items = [])
    @items = items
  end

  def self.from_hash(hash = nil)
    if hash && hash['items']
      items = hash['items'].map { |item| CartItem.new(item['product_id'], item['quantity'], item['sku_id']) }
      Cart.new(items)
    else
      Cart.new
    end
  end

  def add_sku(product_id, quantity = 1, sku_id = nil)
    found = if sku_id
              @items.find { |item| item.sku_id == sku_id }
            else
              @items.find { |item| item.product_id == product_id }
            end
    found.nil? ? @items << CartItem.new(product_id, quantity, sku_id) : found.increment!(quantity)
  end

  def empty?
    @items.empty?
  end

  def total_price
    items.reduce(0) { |sum, item| sum + item.total_price }
  end

  def serialize
    items = @items.map { |item| { 'product_id' => item.product_id, 'quantity' => item.quantity, 'sku_id' => item.sku_id } }

    { 'items' => items }
  end
end