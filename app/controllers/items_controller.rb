class ItemsController < ApplicationController
  def index
    offset = params[:offset]
    limit = params[:limit]
    offset ||= 0
    if limit
      @items = Item.all.offset(offset).limit(limit)
    else
      @items = Item.all.offset(offset)
    end
  end
end
