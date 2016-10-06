class AddCreatorToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :creator_id, :integer
    add_column :orders, :manager_id, :integer
    Order.find_each do |order|
      order.creator_id = order.order_steps.first.user_id
      order.manager_id = order.order_steps.first.user_id
      order.save
    end
  end

  def self.down
    remove_column :orders, :created_by
    remove_column :orders, :manager_id
  end
end
