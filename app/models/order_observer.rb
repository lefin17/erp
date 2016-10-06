class OrderObserver < ActiveRecord::Observer
  def before_create(o)
    o.code_id = (Order.all.map(&:id).max || 16000) + 1
  end
end
