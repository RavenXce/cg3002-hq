class HqItem < ActiveRecord::Base
  belongs_to :item, :inverse_of => :hq_items
end
