class ShopDeliveryItem < ActiveRecord::Base
  belongs_to :shop_delivery, :inverse_of => :shop_delivery_items
  belongs_to :item, :inverse_of => :shop_delivery_items
end
