class ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:sync]
  layout false, :only => [:edit]
  
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
    begin      
      shop = Shop.find_by_s_id(params[:id])
      params[:shop_items].each do |item|
        item_data = Item.find_by_barcode!(item[:barcode])
        shop_item = shop.shop_items.find_or_initialize_by_item_id(item_data.id)
        new_price = active_pricing(item_data, item[:current_stock])
        shop_item.update_attributes(:current_stock => item[:current_stock], :selling_price => new_price)
      end
      updated_items = shop.shop_items.includes(:item).all      
    rescue => e
      render :json => {:success => false, :errors => e.message}, status: 422
    else
      render :json => {:success => true, :shop_items => updated_items.to_json}, status: :ok
    end    
  end
  
  def edit
    @item = Item.find(params[:id])
    render :edit
  end
  
  def update
    item = Item.find(params[:id])
    item.update(create_params)
    render :index
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

  def active_pricing (item, current_stock)
    base_profit = item.cost_price * 2 # TODO: allow control of this constant by admin
    #new_price = base_profit * ((item.minimum_stock / current_stock) + 0.5) + item.cost_price
    new_price = base_profit + item.cost_price
  end
end
