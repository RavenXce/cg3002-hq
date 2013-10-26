require 'soft_deletion'
class Item < ActiveRecord::Base
  has_soft_deletion :default_scope => true
  has_many :sales
  has_many :hq_items
  has_many :shop_items
  has_many :shops, through: :shop_items
  has_many :hq_delivery_items
  has_many :hq_deliveries, through: :hq_delivery_items
  has_many :shop_delivery_items
  has_many :shop_deliveries, through: :shop_delivery_items
end
