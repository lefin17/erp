require 'digest'

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
			t.column :user_type, :integer, :null => false
			t.column :login, :string, :default => '', :null => false
			t.column :password, :string, :limit => 32, :null => false
			t.column :comment, :text

			# дополнительная информация о пользователе
			t.column :name, :string, :limit => 32
			t.column :email, :string, :limit => 32
			t.column :phone, :string, :limit => 32
			t.column :phone_mobile, :string, :limit => 32

			# organization specific
			t.column :jur_name, :string
			t.column :jur_address, :string
			t.column :jur_inn, :string
			t.column :jur_kpp, :string
			t.column :jur_account, :string
			t.column :jur_bank, :string
			t.column :jur_bik, :string
			t.column :jur_korr_account, :string

			# учитывать пользователя в расчетах? а может он в отпуске?
			t.column :is_inactive, :boolean, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
