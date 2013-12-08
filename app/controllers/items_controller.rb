class ItemsController < ApplicationController
  skip_before_action :authenticate_user, only: [:sync]
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
      flash.now.alert = e.message
    end
    render :index
  end

  def sync
      params.require(:shop_items)
      shop = Shop.find_by_s_id(params[:id])
      params[:shop_items].each do |shop_item|
        db_item = shop.shop_items.includes(:item).where(:barcode => shop_item[:barcode]).first
        if !db_item.nil? then
          db_item.current_stock = shop_item[:current_stock]
          db_item.updated_at = DateTime.now
        end
      end
      ShopItem.import updated_items, :on_duplicate_key_update => [ :current_stock, :updated_at ]
      updated_items = shop.shop_items.includes(:item).all
      render :json => {:success => true, :shop_items => updated_items.as_json(
        :only => [:current_stock, :selling_price],
        :include => {:item => { :except => [:created_at, :updated_at, :deleted_at, :id]}}
        )}, status: :ok
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
  
end
