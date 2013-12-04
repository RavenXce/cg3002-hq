class HqDelivery < ActiveRecord::Base
  belongs_to :suppplier, :inverse_of => :hq_deliveries
  has_many :hq_delivery_items, :inverse_of => :hq_delivery
  has_many :items, through: :hq_delivery_items
end
