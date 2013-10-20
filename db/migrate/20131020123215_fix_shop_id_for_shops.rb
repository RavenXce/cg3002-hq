class FixShopIdForShops < ActiveRecord::Migration
  def change
     change_column :shops, :s_id, :integer, {:limit => nil, :unique => true}
  end
end
