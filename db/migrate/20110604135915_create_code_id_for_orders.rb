class CreateCodeIdForOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :code_id, :integer, :default => 16000
  end

  def self.down
    remove_column :orders, :code_id
  end
end
