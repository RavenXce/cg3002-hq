class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.datetime :delivery_time

      t.timestamps
    end
  end
end
