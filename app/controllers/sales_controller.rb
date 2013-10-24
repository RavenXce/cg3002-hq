class SalesController < ApplicationController
  def index
    offset = params[:offset]
    limit = params[:limit]
    offset ||= 0
    limit ||= 5000
    @sales = Sale.all.order('date DESC').offset(offset).limit(limit)
  end
end