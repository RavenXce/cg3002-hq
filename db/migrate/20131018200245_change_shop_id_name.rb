class ChangeShopIdName < ActiveRecord::Migration
  def change
    rename_column :shops, :shop_id, :s_id
  end
end
