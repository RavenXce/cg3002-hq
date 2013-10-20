class AddBundleUnitToItems < ActiveRecord::Migration
  def change
    add_column :items, :bundle_unit, :integer
  end
end
