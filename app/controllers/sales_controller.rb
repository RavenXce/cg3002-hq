class SalesController < ApplicationController
  before_filter :get_shops
  def index
  end

  def create
    respond_to do |format|
      format.html { render :index }
      format.json do
        begin
          params.require(:sales, :id)
          new_sales = ActiveSupport::JSON.decode(params[:sales])
          Sale.transaction do
            new_sales.each do |new_sale|
              item = Item.find_by_barcode(new_sale.barcode)
              Sale.create(:count => new_sale.quantity, :price => new_sale.price, :date => new_sale.date, :shop_id => params[:id], :item_id => item.id)
            end
          end
        rescue
          render :json => {:success => false}, status: 422
          return
        end
        render :json => {:success => true}, status: :ok
      end
    end
  end

  def transaction_dump
    if !(params.has_key?(:transactions) && params.has_key?(:shop_id)) then
      @errors = "Invalid parameters"
      render :index
    return
    end

    # txt
    shop = Shop.find(params[:shop_id]);
    if shop.nil?
      @errors = "Invalid shop ID: " + params[:shop_id]
      render :index
    return
    end

    data_lines = params[:transactions].read.lines.map(&:chomp)
    data_lines.each do |transaction|
      tdetails = transaction.split(':')
      item = Item.find_by_barcode(tdetails[3])
      if item.nil?
        @errors = "Invalid item barcode: " + tdetails[3]
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