class Shop < ActiveRecord::Base
  has_many :sales, :inverse_of => :shop
  has_many :shop_items, :inverse_of => :shop
  has_many :shop_deliveries, :inverse_of => :shop
  has_many :items, through: :shop_items
  
  validates :s_id, uniqueness: true
  validates :s_id, :country, :address, :postal_code, presence: true
  
  def delivery_time
    read_attribute(:delivery_time).strftime("%H Hours %M Mins")
  end
end
