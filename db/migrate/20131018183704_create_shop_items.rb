class CreateShopItems < ActiveRecord::Migration
  def change
    create_table :shop_items do |t|
      t.belongs_to :shop
      t.belongs_to :item
      t.integer :current_stock
      t.decimal :selling_price
      
      t.timestamps
    end
  end
end
