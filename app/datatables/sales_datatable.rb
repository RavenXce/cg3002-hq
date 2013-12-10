class SalesDatatable
  delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Sale.count,
      iTotalDisplayRecords: sales.total_entries,
      aaData: data
    }
  end

private

  def data
    sales.map do |sale| #XXX: Move standardized HTML to client-side view through jQuery DOM injection!
      [
        '<td class="center"><label>
              <input type="checkbox" class="ace" />
              <span class="lbl"></span></label>
         </td>',
        sale.date.strftime("%b %e, %Y"),
        sale.shop.nil? ? 'OLD (' + "%05d" % sale.shop_id.to_s + ')' :
        '<a href="#">'+ "%05d" % sale.shop.s_id.to_s+'</a>',
        '<a href="#">'+sale.item.product_name+'</a>',
        '<a href="#">'+sale.item.barcode+'</a>',
        sale.count,
        number_to_currency(sale.price)
      ]
    end
  end

  def sales
    @sales ||= fetch_sales
  end

  def fetch_sales
    sales = Sale.includes(:item, :shop).order("#{sort_column} #{sort_direction}").references(:item, :shop)
    sales = sales.page(page).per_page(per_page)
    if params[:sSearch].present?
      sales = sales.where("items.product_name like :search or items.barcode like :search or shops.s_id like :search", search: "%#{params[:sSearch]}%")
    end
    sales
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id date shop_id items.product_name items.barcode count price] #id is unsortable
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end