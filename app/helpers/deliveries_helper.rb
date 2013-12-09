module DeliveriesHelper
  include ActionView::Helpers::NumberHelper
  def format_status status, small = false
    string = '<span class="label '
    string += small ? 'label-sm ' : ''
    case status
    when "pending"
      string +='label-warning arrowed">'
    when "approved"
      string +='label-info arrowed-in">'
    when "dispatched"
      string +='label-success arrowed-right">'
    when "delayed"
      string +='label-danger arrowed-in arrowed-in-right">'
    when "delivered"
      string +='label-inverse">'
    else
      string += 'label-info">'
    end
    string += status.humanize + '</span>'
  end
  
  def format_action id, status
    case status
    when "pending"
      string = '<a class="green" href="deliveries/'+id.to_s+'/approve" rel="nofollow" data-method="post"><i class="icon-ok bigger-130"></i></a>'
    when "approved"
      string = '<a class="green" href="deliveries/'+id.to_s+'/dispatch" rel="nofollow" data-method="post"><i class="icon-share-alt bigger-130"></i></a>'
    else
      string = ''
    end
    string
  end
    
  def to_cell delivery_item
    item = delivery_item.item
    ['', item.barcode, item.product_name, item.manufacturer, item.category, 
     number_to_currency(item.cost_price), delivery_item.quantity]
  end  
end
