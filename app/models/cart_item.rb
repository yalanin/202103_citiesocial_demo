class CartItem
  attr_reader :product_id, :quantity, :sku_id

  def initialize(product_id, quantity = 1, sku_id)
    @product_id = product_id
    @sku_id = sku_id
    @quantity = quantity
  end

  def increment!(num = 1)
    @quantity += num
  end

  def product
    Product.friendly.find(product_id)
  end

  def total_price
    product.sell_price * @quantity.to_i
  end
end