class ShopDelivery < ActiveRecord::Base
  belongs_to :shop
  has_many :shop_delivery_items
  has_many :items, through: :shop_delivery_items
end
