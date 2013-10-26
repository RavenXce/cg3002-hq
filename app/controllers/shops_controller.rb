class ShopsController < ApplicationController
  layout false, :only => [:edit]
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
    render :index
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

  def edit
    @shop = Shop.find(params[:id])
    render :edit
  end

  def update
    shop = Shop.find(params[:id])
    shop.update(edit_params)
    @shops = Shop.all
    render :index
  end

  private

  def create_params
    params.permit(:s_id, :country, :city, :address, :postal_code, :delivery_time)
  end

  def edit_params
    params.permit(:country, :city, :address, :postal_code, :delivery_time)
  end
end