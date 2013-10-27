class ItemsDatatable
  delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Item.count,
      iTotalDisplayRecords: items.total_entries,
      aaData: data
    }
  end

private

  def data
    items.map do |item| #XXX: Move standardized HTML to client-side view through jQuery DOM injection!
      [
        '<td class="center"><label>
              <input type="checkbox" class="ace" />
              <span class="lbl"></span></label>
         </td>',
        '<a href="#">'+item.barcode.to_s+'</a>',
        '<a href="#">'+item.product_name+'</a>',
        '<a href="#">'+item.manufacturer+'</a>',
        '<a href="#">'+item.category+'</a>',
        number_to_currency(item.cost_price),
        item.updated_at.strftime("%b %e, %Y"),
        '<div class="visible-md visible-lg hidden-sm hidden-xs action-buttons">
              <a class="blue" href="#"><i class="icon-zoom-in bigger-130"></i></a>
              <a class="green edit-item" href="#"><i class="icon-pencil bigger-130"></i></a>
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
            </div>',
         item.id
      ]
    end
  end

  def items
    @items ||= fetch_items
  end

  def fetch_items
    items = Item.order("#{sort_column} #{sort_direction}")
    items = items.page(page).per_page(per_page)
    if params[:sSearch].present?
      items = items.where("product_name like :search or manufacturer like :search or category like :search or barcode like :search", search: "%#{params[:sSearch]}%")
    end
    items
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id barcode product_name manufacturer category price updated_at] #id is unsortable
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end