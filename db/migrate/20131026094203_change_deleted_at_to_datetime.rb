class ChangeDeletedAtToDatetime < ActiveRecord::Migration
  def change
    change_column :items, :deleted_at, :datetime
  end
end
