class AddPaymentReceivedToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :payment_received, :float, :null => false, :default => 0
    add_column :orders, :location, :string
  end

  def self.down
    remove_column :orders, :payment_received
    remove_column :orders, :location
  end
end
