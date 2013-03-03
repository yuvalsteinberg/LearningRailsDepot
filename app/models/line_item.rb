class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  attr_accessible :product, :product_id

  def total_price
    price * quantity
  end
end
