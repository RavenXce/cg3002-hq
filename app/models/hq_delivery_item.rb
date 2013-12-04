class HqDeliveryItem < ActiveRecord::Base
  belongs_to :hq_delivery, :inverse_of => :hq_delivery_items
  belongs_to :item, :inverse_of => :hq_delivery_items
end
