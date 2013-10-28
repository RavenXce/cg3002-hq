class ShopItemsController < ApplicationController
  
  # TODO: enable all switch.
  # TODO: change shop id to a string (like barcode). length of 6! 
  def batch_add

    if params[:item_ids].empty? || params[:shop_ids].empty? then
      @errors = "Did not have a valid selection to add to"
      render 'items/index'
    return
    end

    begin
      item_ids = params[:item_ids].split(', ')
      shop_ids = params[:shop_ids].split(', ')
      new_items = []
      shop_ids.each do |shop_id|
        shop = Shop.find_by_s_id(shop_id)
        if shop.nil? then
          @warnings = "Some of the shop IDs were invalid"
        next
        end
        item_ids.each do |item_id|
          new_item = shop.shop_items.find_or_initialize_by(:item_id => item_id)
          new_item.selling_price = 1
          new_item.current_stock = 0
          new_items << new_item
        end
      end
      ShopItem.import new_items
    rescue => e
      @errors = "Encountered an error while trying to add items to shops."
    else
      if(new_items.empty?) then
        @errors = "No valid shop ID was entered"
      else
        @messages = "Succesfully added items to shops"
      end
    end
    render 'items/index'
  end

end
