class Sales < ActiveRecord::Base
  belongs_to :shop
  has_one :item
end
