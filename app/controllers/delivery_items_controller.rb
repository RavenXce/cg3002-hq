class DeliveryItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:edit]
  
  def edit # jqGrid is not RESTful =[
    @delivery = ShopDelivery.find(params[:delivery_id])
    if @delivery.nil? then
      render json: {:errors => "Invalid delivery ID"}, status: 422 and return
    end
    if @delivery.status != "approved" && @delivery.status != "pending" then
      render json: {:errors => "Shipment has already left."}, status: 422 and return
    end    
    operation = params[:oper]
    if operation == 'edit'
      update
    elsif operation == 'del'
      destroy
    elsif operation == 'add'
      create
    end
  end
  
  private
  
  def create
    item = ShopItem.includes(:item).where("items.barcode = ?", params["items.barcode"]).first
    if item.nil? then
      render json: {:errors => "Invalid item barcode."}, status: 422 and return
    end
    delivery_item = @delivery.shop_delivery_items.find_or_create_by_item_id(item.item_id)
    delivery_item.quantity ||= 0 
    delivery_item.quantity += params[:quantity].to_i
    delivery_item.save
    render json: {:message => "Item added successfully."}, status: 200
  end
  
  def update
    id = params[:id]
    ShopDeliveryItem.update(id, params.permit(:quantity))
    render json: {:message => "Updated quantity successfully."}, status: 200
  end
  
  def destroy
    ShopDeliveryItem.destroy(params[:id])
    render json: {:message => "Item removed from delivery."}, status: 200
  end
  
end
