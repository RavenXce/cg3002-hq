class Shop < ActiveRecord::Base
  has_many :sales
  has_many :shop_items
  has_many :items, through: :shop_items
  
  def delivery_time
    read_attribute(:delivery_time).strftime("%H:%M")
  end
end
