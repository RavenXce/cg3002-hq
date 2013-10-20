class AddUniqueIndexes < ActiveRecord::Migration
  def change
    add_index :items, :barcode, :unique => true
    add_index :shops, :s_id, :unique => true
  end
end
