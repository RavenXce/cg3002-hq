class AddDeletedAtToItems < ActiveRecord::Migration
  def change
    add_column :items, :deleted_at, :time
  end
end
