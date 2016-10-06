class AddFieldsDateOrder < ActiveRecord::Migration
  def self.up
  add_column :orders, :date_order, :datetime
  end

  def self.down
  remove_column(:orders, :date_order)
  end
end
