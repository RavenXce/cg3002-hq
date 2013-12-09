class DeliveryItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:edit]
  
  def edit # jqGrid is not RESTful =[
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
    delivery = ShopDelivery.find(params[:delivery_id])
    item = Item.find_by_barcode(params["items.barcode"])
    if item.nil? || delivery.nil?
      render json: {:message => "Invalid item barcode."}, status: 422 and return
    end
    delivery_item = delivery.shop_delivery_items.find_or_create_by_item_id(item.id)
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
