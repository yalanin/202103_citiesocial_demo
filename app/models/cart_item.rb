class CartItem
  attr_reader :product_id, :quantity

  def initialize(product_id, quantity = 1)
    @product_id = product_id
    @quantity = quantity
  end

  def increment!(num = 1)
    @quantity += num
  end

  def product
    Product.find(product_id)
  end

  def total_price
    product.sell_price * @quantity
  end
end