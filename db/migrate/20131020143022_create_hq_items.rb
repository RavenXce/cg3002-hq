class CreateHqItems < ActiveRecord::Migration
  def change
    create_table :hq_items do |t|
      t.integer :current_stock
      t.references :item, index: true

      t.timestamps
    end
  end
end
