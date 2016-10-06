class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
   add_column :users, :user_site, :string, :limit => 50
   add_column :users, :adress_fact, :string
   add_column :users, :adress_delivery, :string
   add_column :users, :contact_fio, :string
  end

  def self.down
  remove_column(:users, :user_site)
  remove_column(:users, :adress_fact)
  remove_column(:users, :adress_delivery)
  remove_column(:users, :contact_fio)
  
  end
end
