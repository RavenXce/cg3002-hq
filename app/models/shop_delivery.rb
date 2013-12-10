require "uri"
require "net/http"
class ShopDelivery < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :shop_deliveries
  has_many :shop_delivery_items, :inverse_of => :shop_delivery, :dependent => :destroy
  has_many :items, through: :shop_delivery_items
  before_update :send_push_notification
  
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
  
  def expected_at
    self[:eta]
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
  
  def send_push_notification
    if self.status == "dispatched" then
      params = {'message' => 'A new delivery has been dispatched!'}
      x = Net::HTTP.post_form(URI.parse('http://ec2-54-254-4-111.ap-southeast-1.compute.amazonaws.com/Push/push.php'), params)
      puts x.body
    end
  end
  
end
