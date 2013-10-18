class AddShopToSales < ActiveRecord::Migration
  def change
    add_reference :sales, :shop, index: true
  end
end
