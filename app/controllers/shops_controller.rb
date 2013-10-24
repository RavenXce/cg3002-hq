class ShopsController < ApplicationController
  def index
    @shops = Shop.all
  end
  
  def create
    shop = Shop.new(create_params)
    begin
      shop.save!
    rescue Exception => e
      query_string = {:errors => e.message}
    end
    if query_string[:errors]
      redirect_to '/stores&' + query_string.to_query
      return
    end
    redirect_to '/stores'
  end
  
  def destroy
    shop = Shop.find(params[:id])
    begin
      shop.delete #TODO: do a soft delete instead
    rescue Exception => e
      render :json => {:success => false, :errors => [e.message]}, :status => 422
    end
      render :json => {:success => true}, :status => 200
  end
  
  private
  
  def create_params
    params.permit(:s_id, :country, :city, :address, :postal_code, :delivery_time)
  end
end