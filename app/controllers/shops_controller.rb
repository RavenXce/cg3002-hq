class ShopsController < ApplicationController
  def index
    @shops = Shop.all
  end
  
  def create
    shop = Shop.new(create_params)
    begin
      shop.save!
    rescue => e
      @errors = e.message
    end
    @shops = Shop.all
    render 'index'
  end
  
  def destroy
    shop = Shop.find(params[:id])
    begin
      shop.delete #TODO: do a soft delete instead
    rescue => e
      render :json => {:success => false, :errors => [e.message]}, :status => 422
    end
      render :json => {:success => true}, :status => 200
  end
  
  private
  
  def create_params
    params.permit(:s_id, :country, :city, :address, :postal_code, :delivery_time)
  end
end