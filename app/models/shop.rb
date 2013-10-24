class Shop < ActiveRecord::Base
  has_many :sales
  has_many :shop_items
  has_many :items, through: :shop_items
  
  validates :s_id, :presence => {:message => "Shop ID can't be blank."}
  validates :country, :address, :postal_code, presence: true
  
  def delivery_time
    read_attribute(:delivery_time).strftime("%H:%M")
  end
end
