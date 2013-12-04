class Sale < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :sales
  belongs_to :item, :inverse_of => :sales
end
