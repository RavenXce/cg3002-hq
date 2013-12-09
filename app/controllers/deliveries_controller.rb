class DeliveriesController < ApplicationController
  skip_before_action :authenticate_user, only: [:api, :mark_dispatched]
  skip_before_action :verify_authenticity_token, only: [:mark_dispatched]
  
  def index
    respond_to do |format|
      format.html { @deliveries = ShopDelivery.all }
      format.json { render json: DeliveriesDatatable.new(view_context) }
    end
  end
  
  def show
    @delivery = ShopDelivery.find(params[:id])
    respond_to do |format|      
      format.json do
        page = params[:page].to_i
        limit = params[:rows].to_i
        sort_index = params[:sidx]
        sort_order = params[:sord]
        items = @delivery.shop_delivery_items.includes(:item)
        
        # calculate paging
        total_items = items.count
        if(total_items > 0 && limit > 0) then 
          total_pages = (total_items.to_f/limit).ceil 
        else
          total_pages = 1
        end 
        page = total_pages if page > total_pages
        
        # calculate start position
        start = limit * (page-1)
        start = 0 if start < 0
        
        items = items.order(sort_index + " " + sort_order).limit(limit).offset(start)
        result = {:page => page, :total => total_pages, :records => total_items}
        rows = []
        items.each do |item|
          rows << {:id => item.id, :cell => item.to_cell}
        end
        result[:rows] = rows
        render json: result
        return
      end
      format.html {}
    end
  end
  
  def approve
    @delivery = ShopDelivery.find(params[:id])
    @delivery.status = 'approved'
    @delivery.save
    flash.notice = 'Approved the delivery'
    redirect_to(:back) 
  end
  
  def mark_dispatched
    @delivery = ShopDelivery.find(params[:id])
    @delivery.status = 'dispatched'
    @delivery.dispatched_at = DateTime.now 
    @delivery.eta = DateTime.now + @delivery.shop.delivery_time[0..1].to_i.hours + @delivery.shop.delivery_time[3..4].to_i.minutes
    @delivery.save
    flash.notice = 'Delivery marked as on the way'
    redirect_to(:back) 
  end
  
  def mark_delivered
    @delivery = ShopDelivery.find(params[:id])
    render :json => {:errors => 'Invalid delivery ID.'}, :status => 422 and return if @delivery.nil?
    @delivery.status = 'delivered'
    @delivery.save
    render :json => {:success => true}, :status => 200
  end
  
  def destroy
    @delivery = ShopDelivery.find(params[:id])
    @delivery.destroy
    flash.notice = 'Delivery removed'
    redirect_to deliveries_path
  end
  
  def api
    shop = Shop.find(params[:id])
    shop_deliveries = shop.shop_deliveries.includes(:shop_delivery_items).where("status != 'delivered'")
    render :json => {:success => true, :shop_items => shop_deliveries.as_json(
      :only => [:status,:dispatched_at,:eta],
      :include => {:shop_delivery_items => { :only => [:quantity], :methods => [:barcode]}}
      )}, status: :ok
  end
  
  def edit
    # TODO: allow update ETA  
  end
  
end
