class HqDelivery < ActiveRecord::Base
  belongs_to :suppplier
  has_many :hq_delivery_items
  has_many :items, through: :hq_delivery_items
end
