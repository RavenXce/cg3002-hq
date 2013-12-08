class AddArrivalTimeToShopDeliveries < ActiveRecord::Migration
  def change
    add_column :shop_deliveries, :eta, :datetime
  end
end
