class ShopDelivery < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :shop_deliveries, :dependent => :destroy
  has_many :shop_delivery_items, :inverse_of => :shop_delivery
  has_many :items, through: :shop_delivery_items
end
