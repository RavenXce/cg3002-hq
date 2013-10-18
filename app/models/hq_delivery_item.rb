class HqDeliveryItem < ActiveRecord::Base
  belongs_to :hq_delivery
  belongs_to :item
end
