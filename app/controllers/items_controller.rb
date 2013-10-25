class ItemsController < ApplicationController
  def index
    respond_to do |format|
      format.html { @items = Item.all }
      format.json { render json: ItemsDatatable.new(view_context) }
    end
  end
  
end
