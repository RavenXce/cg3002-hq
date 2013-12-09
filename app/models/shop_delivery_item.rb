class ShopDeliveryItem < ActiveRecord::Base
  belongs_to :shop_delivery, :inverse_of => :shop_delivery_items
  belongs_to :item, :inverse_of => :shop_delivery_items
  
  def to_cell
    ['', self.item.barcode, self.item.product_name, self.item.manufacturer, self.item.category, 
     self.item.cost_price, self.quantity]
  end
  
end
