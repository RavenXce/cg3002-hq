class ShopDeliveryItem < ActiveRecord::Base
  belongs_to :shop_delivery
  belongs_to :item
end
