class ItemsController < ApplicationController
  def admin_dump
    items = []
    item_lines = params[:items].lines.map(&:chomp)
    item_lines.each do |item|
      item_details = item.split(':')
      item = Item.new(
      :product_name => item_details[0],
      :category => item_details[1],
      :manufacturer => item_details[2],
      :barcode => item_details[3],
      :cost_price => item_details[4]
      # what are [5] to [7] for?
      )
      items.push(item)
    end
    Item.transaction do
      items.each do |item|
        item.save
      end
    end
    redirect_to '/admin'
  end
end
