class RemoveUniqueBarcode < ActiveRecord::Migration
  def change
    remove_index :items, :barcode
    add_index :items, :barcode
  end
end
