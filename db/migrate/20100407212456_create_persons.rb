class CreatePersons < ActiveRecord::Migration
  def self.up
    create_table :persons do |t|

			t.column :user_id, :integer, :null => false
			t.column :login, :string, :default => '', :null => false
			t.column :password, :string, :limit => 32, :null => false
			t.column :fio, :string, :default => '', :null => false
			t.column :email, :string, :limit => 32
			t.column :phone, :string, :limit => 32
			t.column :phone_mobile, :string, :limit => 32
			t.column :comment, :text
		  t.timestamps
	end	  
  end

  def self.down
        drop_table :persons
  end
end
