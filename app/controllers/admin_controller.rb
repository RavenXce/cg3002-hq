class AdminController < ApplicationController
  def item_dump
    items = []
    stock = []
    item_lines = params[:items].lines.map(&:chomp)
    item_lines.each do |item|
      item_details = item.split(':')
      item = Item.new(
      :product_name => item_details[0],
      :category => item_details[1],
      :manufacturer => item_details[2],
      :barcode => item_details[3],
      :cost_price => item_details[4],
      :bundle_unit => item_details[7]
      )
      stock.push(item_details[5])
      items.push(item)
      #ignore [6], minstock
    end
    Item.transaction do
      items.each_with_index do |item, index|
        item.save
        item.hq_items.create(:current_stock => stock[index])
      end
    end
    redirect_to '/admin'
  end
end
