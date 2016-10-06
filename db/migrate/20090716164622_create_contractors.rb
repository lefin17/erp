class CreateContractors < ActiveRecord::Migration
  def self.up
    create_table :contractors do |t|
			t.column :name, :string, :limit => 32
			t.column :email, :string, :limit => 32
			t.column :phone, :string, :limit => 32

			# organization specific
			t.column :jur_name, :string
			t.column :jur_address, :string
			t.column :jur_inn, :string
			t.column :jur_kpp, :string
			t.column :jur_account, :string
			t.column :jur_bank, :string
			t.column :jur_bik, :string
			t.column :jur_korr_account, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :contractors
  end
end
