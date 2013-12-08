class DeliveriesController < ApplicationController
  def index
    respond_to do |format|
      format.html { @deliveries = ShopDelivery.all }
      format.json { render json: DeliveriesDatatable.new(view_context) }
    end
  end
  
  
end
