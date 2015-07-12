class CombineItemsInCart < ActiveRecord::Migration
  def up
    #カート内に一つの商品に対して複数の品目があった場合は、ひとつの商品に置き換える
    Cart.all.each do |cart|
      #カート内の商品の数をカウントする
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          #個別の項目を削除する
          cart.line_items.where(product_id: product_id).delete_all

          #一つの品名に置き換える
          cart.line_items.create(product_id: product_id, quantity: quantity)
        end
      end
    end
  end

  def down
    #数量>1の商品を元に戻す
    LineItem.where("quantity>1").each do |line_item|
      #個別の品目を追加する
      line_item.quantity.times do
        LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
      end
      line_item.destroy
    end
  end
end
