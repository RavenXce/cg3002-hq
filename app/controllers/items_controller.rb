class ItemsController < ApplicationController
  def index
    respond_to do |format|
      format.html { @items = Item.all }
      format.json { render json: ItemsDatatable.new(view_context) }
    end
  end

  def create
    item = Item.new(create_params)
    begin
      item.save!
    rescue => e
      @errors = e.message
    end
    render :index
  end

  def sync
    shop = Shop.find_by_s_id(params[:s_id])
    items = ActiveSupport::JSON.decode(params[:shop_items])
    items.each do |item|
      shop_item = shop.shop_items.find_or_initialize_by_barcode(item.barcode)
      shop_item.update_attributes(:current_stock => item.current_stock)
    end
    updated_items = shop.shop_items.all()
    
    #TODO: recalculate price.
    
    respond_to do |format|
        format.html { render :index }
        format.json { render :json => {:shop_items => updated_items.to_json}, status: :ok }
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.soft_delete!
    respond_to do |format|
      format.html { @items = Item.all; render :index; }
      format.json { render :json => {success => true}, status: :ok }
    end
  end
  
  private

  def create_params
    params.permit(:barcode, :product_name, :manufacturer, :category, :cost_price, :bundle_unit, :minimum_stock)
  end

end
