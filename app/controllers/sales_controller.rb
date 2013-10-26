class SalesController < ApplicationController
  def index
    @shops = Shop.all
  end
  
  def transaction_dump
    # txt
    if !(params.has_key[:transactions] && params.has_key[:s_id]) then
      @errors = "Invalid parameters"
      render :index
      return
    end
    shop = Shop.find_by_s_id(params[:s_id]);
    data_lines = params[:transactions].lines.map(&:chomp)
    data_lines.each do |transaction|
      transaction_details = transactions.split(':')
      # XXX: TBC
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
end