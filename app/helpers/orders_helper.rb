module OrdersHelper

def statuses_links(filter)
  Order::STATUSES.collect { |status|
    (status_title, status_code) = status
    orders_count = Order.count(:conditions => { :status => status_code })
    link_to_function "#{status_title} (#{orders_count})", "applyFilter({status: '#{status_code}'})"
  }.join('&nbsp;|&nbsp;')
end

end
