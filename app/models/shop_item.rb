class ShopItem < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :shop_items, :dependent => :destroy
  belongs_to :item, :inverse_of => :shop_items, :dependent => :destroy
end
