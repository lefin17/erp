class AddFieldsUserMPayment < ActiveRecord::Migration
  def self.up
   add_column :orders, :user_l_payment, :string
  end

  def self.down
   remove_column(:orders, :user_id_payment)
  end
end
