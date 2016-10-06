class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
			t.column :order_id, :integer

			# TODO: надо продумать работы, станки, материалы и пр.
			# в процессе

      t.timestamps
    end
  end

  def self.down
    drop_table :order_items
  end
end
