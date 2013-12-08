class SalesController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_filter :get_shops, except: [:create]
  def index
  end

  def create
    begin
      shop = Shop.find(params[:id])
      params.require(:sales)
      sales = []
      updated_items = []
      params[:sales].each do |sale|
        item = Item.find_by_barcode(sale[:barcode])
        shop_item = shop.shop_items.find_by_barcode(sale[:barcode]).first
        updated_items << active_pricing(shop_item, sale[:quantity])
        sales << Sale.new(:count => sale[:quantity], :price => sale[:price], :date => sale[:date], :shop_id => params[:id], :item_id => item.id)
      end
      Sale.import sales
      ShopItem.import updated_items
    rescue
      render :json => {:success => false}, status: 422
    else
      render :json => {:success => true}, status: :ok
    end
  end

  def transaction_dump
    if !(params.has_key?(:transactions) && params.has_key?(:shop_id)) then
      flash.now.alert = "Invalid parameters"
      render :index
    return
    end

    # txt
    shop = Shop.find(params[:shop_id]);
    if shop.nil?
      flash.now.alert = "Invalid shop ID: " + params[:shop_id]
      render :index
    return
    end
    # TODO: Do batch import
    data_lines = params[:transactions].read.lines.map(&:chomp)
    data_lines.each do |transaction|
      tdetails = transaction.split(':')
      item = Item.find_by_barcode(tdetails[3])
      if item.nil?
        flash.now.alert = "Invalid item barcode: " + tdetails[3]
        render :index
      return
      end
      sale = Sale.find_by_item_id_and_date(item.id, tdetails[5])
      if !sale.nil?
        sale.increment(:count, tdetails[4])
      else
        shop.sales.create(:price => item.cost_price, :date => tdetails[5], :count => tdetails[4], :item_id => item.id)
      end
    end
  end

  def all
    respond_to do |format|
      format.html { render :all }
      format.json { render json: SalesDatatable.new(view_context) }
    end
  end

  def stats

  end

  private

  def get_shops
    @shops = Shop.all
  end
  
  #TODO: allow constants to be adjustede by admin in settings
  BASE_PROFIT_RATIO = 0.75
  MINIMUM_PROFIT_RATIO = 0.50
  SALES_PROFIT_RATIO = 2.00
  
  def active_pricing (shop_item, sales)
    base_profit = shop_item.item.cost_price * BASE_PROFIT_RATIO
    adjusted_profit = base_profit * (MINIMUM_PROFIT_RATIO + ((sales.to_f / shop_item.minimum_stock) * SALES_PROFIT_RATIO))
    shop_item.selling_price = adjusted_profit + shop_item.item.cost_price
    shop_item
  end

end