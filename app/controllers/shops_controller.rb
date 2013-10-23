class ShopsController < ApplicationController
  def index
    @shops = Shop.all
  end
  
  def create
    shop = Shop.new(create_params)
    shop.save
    redirect_to '/stores'
  end
  
  def delete
    shop = Shop.find_by_s_id(params[:s_id])
    shop.delete #TODO: do a soft delete instead
  end
  
  private
  
  def create_params
    params.permit(:s_id, :country, :city, :address, :postal_code, :delivery_time)
  end
end