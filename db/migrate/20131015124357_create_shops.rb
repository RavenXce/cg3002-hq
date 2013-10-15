class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.integer :shop_id, {limit: 1}
      t.string :country
      t.string :city
      t.string :address
      t.string :postal_code
      t.datetime :delivery_time

      t.timestamps
    end
  end
end
