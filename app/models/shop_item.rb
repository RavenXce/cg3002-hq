class ShopItem < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :shop_items
  belongs_to :item, :inverse_of => :shop_items
end
