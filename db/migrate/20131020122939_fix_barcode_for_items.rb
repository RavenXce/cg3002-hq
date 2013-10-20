class FixBarcodeForItems < ActiveRecord::Migration
  def change
    change_column :items, :barcode, :integer, :limit => nil, :unique => true
  end
end
