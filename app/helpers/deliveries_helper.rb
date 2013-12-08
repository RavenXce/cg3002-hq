module DeliveriesHelper
  def format_status status, small = false
    string = '<span class="label '
    string += small ? 'label-sm ' : ''
    case status
    when "pending"
      string +='label-warning arrowed">'
    when "delayed"
      string +='label-success arrowed">'
    when "delivered"
      string +='label-success">'
    else
      string += '">'
    end
    string += status.humanize + '</span>'
  end
end
