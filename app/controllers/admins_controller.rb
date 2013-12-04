class AdminsController < ApplicationController
  
  def new
    @admin ||= Admin.new
  end
  
  def create
    @admin = Admin.new(admin_params)
    begin
      @admin.save!
    rescue => e
      flash.now.alert = e.message
      render :new and return
    end
    redirect_to admins_url, :notice => "Succesfully added admin: " + @admin.login_code
  end

  def item_dump # XXX: move to items controller
    items = []
    stock = []
    item_lines = params[:items].lines.map(&:chomp)
    item_lines.each do |item|
      item_details = item.split(':')
      item = Item.new(
      :product_name => item_details[0],
      :category => item_details[1],
      :manufacturer => item_details[2],
      :barcode => item_details[3],
      :cost_price => item_details[4],
      :minimum_stock => item_details[6],
      :bundle_unit => item_details[7]
      )
      stock.push(item_details[5])
      items.push(item)
    end
    Item.transaction do
      items.each_with_index do |item, index|
        item.save!
        item.hq_items.create(:current_stock => stock[index])
      end
    end
    redirect_to '/admin'
  end
  
  private

  def admin_params
    params.require(:admin).permit(:login_code, :name, :password)
  end
  
end
