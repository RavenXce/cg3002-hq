class ChangeBarcodeToString < ActiveRecord::Migration
  def change
    change_column :items, :barcode, :string
  end
end
