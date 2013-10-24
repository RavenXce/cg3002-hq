# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131024174804) do

  create_table "hq_deliveries", force: true do |t|
    t.integer  "supplier_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hq_deliveries", ["supplier_id"], name: "index_hq_deliveries_on_supplier_id", using: :btree

  create_table "hq_delivery_items", force: true do |t|
    t.integer  "hq_delivery_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hq_delivery_items", ["hq_delivery_id"], name: "index_hq_delivery_items_on_hq_delivery_id", using: :btree
  add_index "hq_delivery_items", ["item_id"], name: "index_hq_delivery_items_on_item_id", using: :btree

  create_table "hq_items", force: true do |t|
    t.integer  "current_stock"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hq_items", ["item_id"], name: "index_hq_items_on_item_id", using: :btree

  create_table "items", force: true do |t|
    t.integer  "barcode"
    t.string   "product_name"
    t.string   "category"
    t.string   "manufacturer"
    t.decimal  "cost_price",    precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bundle_unit"
    t.integer  "minimum_stock"
  end

  add_index "items", ["barcode"], name: "index_items_on_barcode", unique: true, using: :btree

  create_table "sales", force: true do |t|
    t.decimal  "price",      precision: 10, scale: 2
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
    t.integer  "shop_id"
    t.integer  "item_id"
  end

  add_index "sales", ["item_id"], name: "index_sales_on_item_id", using: :btree
  add_index "sales", ["shop_id"], name: "index_sales_on_shop_id", using: :btree

  create_table "shop_deliveries", force: true do |t|
    t.string   "status"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shop_deliveries", ["shop_id"], name: "index_shop_deliveries_on_shop_id", using: :btree

  create_table "shop_delivery_items", force: true do |t|
    t.integer  "quantity"
    t.integer  "shop_delivery_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shop_delivery_items", ["item_id"], name: "index_shop_delivery_items_on_item_id", using: :btree
  add_index "shop_delivery_items", ["shop_delivery_id"], name: "index_shop_delivery_items_on_shop_delivery_id", using: :btree

  create_table "shop_items", force: true do |t|
    t.integer  "shop_id"
    t.integer  "item_id"
    t.integer  "current_stock"
    t.decimal  "selling_price", precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shop_items", ["item_id"], name: "index_shop_items_on_item_id", using: :btree
  add_index "shop_items", ["shop_id"], name: "index_shop_items_on_shop_id", using: :btree

  create_table "shops", force: true do |t|
    t.integer  "s_id"
    t.string   "country"
    t.string   "city"
    t.string   "address"
    t.integer  "postal_code"
    t.datetime "delivery_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["s_id"], name: "index_shops_on_s_id", unique: true, using: :btree

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.datetime "delivery_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
