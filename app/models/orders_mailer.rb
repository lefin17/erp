class OrdersMailer < ActionMailer::Base
# include ApplicationHelper	
add_template_helper ApplicationHelper
				

  def new_order_notification(order,user)
    recipients user.email
    from "no-reply@artpolygraf.ru"
    order_date = if order.date_order.nil?
      'дата не указана'
    else
      order.date_order.strftime('%d.%m.%Y %H:%M ')
    end
    subject "Заказ #{order.id.to_s} от #{order_date} - Продукция #{order.product_type.name} - Заказчик #{order.user.name}"
 # get_item_name_by_id(Order::STATUSES, order.status)
#   order.status.to_s
    body :order => order
  end
end
