class Supplier < ActiveRecord::Base
  #has_many :items
  has_many :hq_deliveries, :inverse_of => :supplier
end
