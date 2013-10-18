class CreateHqDeliveries < ActiveRecord::Migration
  def change
    create_table :hq_deliveries do |t|
      t.belongs_to :supplier
      t.string :status

      t.timestamps
    end
  end
end
