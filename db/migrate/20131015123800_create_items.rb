class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :barcode, {limit: 1}
      t.string :product_name
      t.string :category
      t.string :manufacturer
      t.decimal :cost_price

      t.timestamps
    end
  end
end
