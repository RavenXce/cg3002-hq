class SalesController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_filter :get_shops, except: [:create]
  def index
  end

  def create
    #begin
      shop = Shop.find_by_s_id(params[:id])
      sales = []      
      !params[:sales].nil? && params[:sales].each do |sale|
        item = Item.find_by_barcode(sale[:barcode])
        sales << Sale.new(:count => sale[:quantity], :price => sale[:price], :date => sale[:date], :shop_id => shop.id, :item_id => item.id)
      end
      Sale.import sales
    #rescue
    #  render :json => {:success => false}, status: 422
    #else
      render :json => {:success => true}, status: :ok
    #end
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

end