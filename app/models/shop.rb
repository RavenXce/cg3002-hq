class Shop < ActiveRecord::Base
  has_many :sales
  has_many :shop_items
  has_many :items, through: :shop_items
  
  validates :s_id, uniqueness: true
  validates :s_id, :country, :address, :postal_code, presence: true
  
  def delivery_time
    read_attribute(:delivery_time).strftime("%H:%M")
  end
end
