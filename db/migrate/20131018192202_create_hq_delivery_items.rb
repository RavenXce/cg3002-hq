class CreateHqDeliveryItems < ActiveRecord::Migration
  def change
    create_table :hq_delivery_items do |t|
      t.belongs_to :hq_delivery
      t.belongs_to :item
      t.integer :quantity

      t.timestamps
    end
  end
end
