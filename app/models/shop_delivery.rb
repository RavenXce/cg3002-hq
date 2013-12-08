class ShopDelivery < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :shop_deliveries, :dependent => :destroy
  has_many :shop_delivery_items, :inverse_of => :shop_delivery
  has_many :items, through: :shop_delivery_items
  
  def eta
    if status == "pending"
      'Still processing shipment'
    elsif status == "delivered"
      'Shipment has arrived'
    elsif self[:eta].nil?
      'Not yet dispatched'
    else
      self[:eta]
    end
  end
  
  def dispatch_time
    if status == "pending"
      'Still processing shipment'
    elsif self[:dispatched_at].nil?
      'Not yet dispatched'
    else
      self[:dispatched_at]
    end
  end
  
end
