class ItemsController < ApplicationController
  def admin_dump
    item_lines = params[:items].lines.map(&:chomp)
    item_lines.each do |item|
      item_details = item.split(':')
      item = Item.create(
      :name => item_details[0],
      :category => item_details[1],
      :manufacturer => item_details[2],
      :barcode => item_details[3],
      :cost_price => item_details[4].to_i
      # what are [5] to [7] for?
      )
      item.save
    end    
    render :index
  end
end
