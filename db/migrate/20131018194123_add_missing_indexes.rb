class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :hq_deliveries, :supplier_id
    add_index :hq_delivery_items, :hq_delivery_id
    add_index :hq_delivery_items, :item_id
    add_index :shop_items, :shop_id
    add_index :shop_items, :item_id
  end
end
