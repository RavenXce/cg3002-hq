class SalesController < ApplicationController
  def index
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