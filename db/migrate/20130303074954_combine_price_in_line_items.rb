class CombinePriceInLineItems < ActiveRecord::Migration
  def up
    puts "UP Start"
    Cart.all.each do |cart|
      puts "Cart in progress..."
      cart.line_items.each do |line_item|
        line_item.price = line_item.product.price
        line_item.save
        puts "Line item in progress (price = #{line_item.price})"
      end
    end
  end

  def down
  end
end
