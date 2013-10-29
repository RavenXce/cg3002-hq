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
      params.require(:shop_items)
      shop = Shop.find_by_s_id(params[:id])
      updated_items = []
      shop.shop_items.includes(:item).find_each do |db_item|
        params[:shop_items].each do |shop_item|
          if shop_item[:barcode] == db_item.item[:barcode].to_i then
            db_item.current_stock = shop_item[:current_stock]
            db_item.selling_price = active_pricing(db_item.item, shop_item[:current_stock])
            db_item.updated_at = DateTime.now 
            updated_items << db_item
            next
          end
        end
      end
      ShopItem.import updated_items, :on_duplicate_key_update=> [ :current_stock, :selling_price, :updated_at ]
      updated_items = shop.shop_items.includes(:item).load
    rescue => e
      render :json => {:success => false, :errors => e.message}, status: 422
    else
      render :json => {:success => true, :shop_items => updated_items.as_json(
        :only => [:current_stock, :selling_price],
        :include => {:item => { :except => [:created_at, :updated_at, :deleted_at, :id]}}
        )}, status: :ok
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
    base_profit = item[:cost_price] * 2 * (item[:minimum_stock] / (current_stock + 10)) # TODO: allow control of this constant by admin
    #new_price = base_profit * ((item.minimum_stock / current_stock) + 0.5) + item.cost_price
    new_price = base_profit + item[:cost_price]
  end
  
end
