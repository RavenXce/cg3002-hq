require 'soft_deletion'
class Item < ActiveRecord::Base
  has_soft_deletion :default_scope => true
  has_many :sales, :inverse_of => :item
  has_many :hq_items, :inverse_of => :item, :dependent => :destroy
  has_many :shop_items, :inverse_of => :item, :dependent => :destroy
  has_many :shops, through: :shop_items
  has_many :hq_delivery_items, :inverse_of => :item, :dependent => :destroy
  has_many :hq_deliveries, through: :hq_delivery_items
  has_many :shop_delivery_items, :inverse_of => :item, :dependent => :destroy
  has_many :shop_deliveries, through: :shop_delivery_items
  
  validates :barcode, uniqueness: { scope: :deleted_at }, length: { is: 8 }
  validates :cost_price, :product_name, :manufacturer, :category, presence: true
  validates :barcode, :bundle_unit, :minimum_stock, numericality: { only_integer: true, message: 'can only accept integers'}
  validates :cost_price, numericality: { message: 'is not a valid price'}
  
end
