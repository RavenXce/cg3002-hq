class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :count
      t.decimal :price
      t.timestamp :date

      t.timestamps
    end
  end
end
