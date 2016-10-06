class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
			t.column :order_id, :integer, :null => false
			t.column :summ, :decimal, :precision => 10, :scale => 2, :null => false

			# тип источника получения денег:
			# - электронные деньги
			# - банковский счет
			# - наличка
			# - положили на телефон
			# - etc
			t.column :payment_source_type, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
