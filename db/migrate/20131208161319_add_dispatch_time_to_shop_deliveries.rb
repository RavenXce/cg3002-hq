class AddDispatchTimeToShopDeliveries < ActiveRecord::Migration
  def change
    add_column :shop_deliveries, :dispatched_at, :datetime
  end
end
