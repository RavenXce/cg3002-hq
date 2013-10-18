class CreateShopDeliveryItems < ActiveRecord::Migration
  def change
    create_table :shop_delivery_items do |t|
      t.integer :quantity
      t.belongs_to :shop_delivery, index: true
      t.references :item, index: true

      t.timestamps
    end
  end
end
