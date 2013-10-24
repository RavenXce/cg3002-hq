class ChangePostalCodeToInteger < ActiveRecord::Migration
  def change
    change_column :shops, :postal_code, :integer
  end
end
