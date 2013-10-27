class SalesController < ApplicationController
  before_filter :get_shops
  def index
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
    offset = params[:offset]
    limit = params[:limit]
    offset ||= 0
    limit ||= 5000
    @sales = Sale.all.order('date DESC').offset(offset).limit(limit)
    render :all
  end

  def stats

  end

  private

  def get_shops
    @shops = Shop.all
  end

end