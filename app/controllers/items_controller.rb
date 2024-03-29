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
      shop = Shop.find_by_s_id(params[:id])
      updated_items = []
      delivery = ShopDelivery.new(:shop_id => shop.id, :status => "pending")
      delivery_items = []
      !params[:shop_items].nil? && params[:shop_items].each do |shop_item|
        db_item = shop.shop_items.includes(:item).where("items.barcode" => shop_item[:barcode]).first
        if !db_item.nil? then
          db_item.current_stock = shop_item[:current_stock]
          db_item.updated_at = DateTime.now
          db_item.selling_price = active_pricing db_item
          deficit = db_item.item.minimum_stock - db_item.current_stock
          if deficit > 0 then 
            delivery_items << delivery.shop_delivery_items.new(:item_id => db_item.id, :quantity => deficit)
          end
          updated_items << db_item
        end
      end
      ShopItem.import updated_items, :on_duplicate_key_update => [ :current_stock, :updated_at, :selling_price ]
      if !delivery_items.empty? then
        delivery.save
        ShopDeliveryItem.import delivery_items
      end
      all_items = shop.shop_items.includes(:item).all
      render :json => {:success => true, :shop_items => all_items.as_json(
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
  
  #TODO: allow constants to be adjustede by admin in settings
  BASE_PROFIT_RATIO = 0.25
  
  def active_pricing (shop_item)
    base_profit = shop_item.item.cost_price * BASE_PROFIT_RATIO
    adjusted_profit = base_profit + (base_profit * ((shop_item.item.minimum_stock - shop_item.current_stock)/shop_item.item.minimum_stock.to_f))
    selling_price = adjusted_profit + shop_item.item.cost_price
  end
  
end
