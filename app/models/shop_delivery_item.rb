class ShopDeliveryItem < ActiveRecord::Base
  belongs_to :shop_delivery, :inverse_of => :shop_delivery_items, :dependent => :destroy
  belongs_to :item, :inverse_of => :shop_delivery_items, :dependent => :destroy
end
