class CreateShopDeliveries < ActiveRecord::Migration
  def change
    create_table :shop_deliveries do |t|
      t.string :status
      t.belongs_to :shop, index: true

      t.timestamps
    end
  end
end
