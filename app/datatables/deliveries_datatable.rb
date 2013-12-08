class DeliveriesDatatable
  delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: ShopDelivery.count,
      iTotalDisplayRecords: deliveries.total_entries,
      aaData: data
    }
  end

  private

  def data
    deliveries.map do |delivery| #XXX: Move standardized HTML to client-side view through jQuery DOM injection!
      [
        '<td class="center"><label>
              <input type="checkbox" class="ace" />
              <span class="lbl"></span></label>
         </td>',
        '<a href="deliveries/'+delivery.id.to_s+'">'+delivery.id.to_s+'</a>',
        '<a href="#">'+ "%05d" % delivery.shop.s_id.to_s+'</a>', #TODO: link to shop products/stats page
        delivery.shop.country,
        delivery.shop.delivery_time,
        delivery.eta.nil? ? nil : 
        delivery.eta.to_formatted_s(:short),
        format_status(delivery.status),
        '<div class="visible-md visible-lg hidden-sm hidden-xs action-buttons">
              <a class="blue" href="deliveries/'+delivery.id.to_s+'"><i class="icon-zoom-in bigger-130"></i></a>
              <a class="green edit-item" href="deliveries/'+delivery.id.to_s+'" role="button" data-toggle="modal"><i class="icon-pencil bigger-130"></i></a>
              <a class="red delete-item" href="#"><i class="icon-trash bigger-130"></i></a>
            </div>
            <div class="visible-xs visible-sm hidden-md hidden-lg">
              <div class="inline position-relative">
                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown">
                  <i class="icon-caret-down icon-only bigger-120"></i>
                </button>
                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow pull-right dropdown-caret dropdown-close">
                  <li>
                    <a href="#" class="tooltip-info" data-rel="tooltip" title="View"><span class="blue"><i class="icon-zoom-in bigger-120"></i></span></a>
                  </li>
                  <li>
                    <a href="#" class="tooltip-success" data-rel="tooltip" title="Edit"><span class="green"><i class="icon-edit bigger-120"></i></span></a>
                  </li>
                  <li>
                    <a href="#" class="tooltip-error" data-rel="tooltip" title="Delete"><span class="red"><i class="icon-trash bigger-120"></i></span> </a>
                  </li>
                </ul>
              </div>
            </div>'
      ]
    end
  end

  def deliveries
    @sales ||= fetch_deliveries
  end

  def fetch_deliveries
    deliveries = ShopDelivery.includes(:shop).order("#{sort_column} #{sort_direction}").references(:shop)
    deliveries = deliveries.page(page).per_page(per_page)
    if params[:sSearch].present?
      deliveries = deliveries.where("shops.s_id like :search or status like :search", search: "%#{params[:sSearch]}%")
    end
    deliveries
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[delivery.id shop.s_id shop.country created_at delivery_time eta status] #first id is unsortable
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def format_status status
    string = ""
    case status
    when "pending"
      string +='<span class="label label-sm label-warning arrowed">'
    when "delayed"
      string +='<span class="label label-sm label-success arrowed">'
    when "delivered"
      string +='<span class="label label-sm label-success">'
    end
    string += status + '</span>'
  end
end