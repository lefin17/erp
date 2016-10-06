class CreateOrderSteps < ActiveRecord::Migration
  def self.up
    create_table :order_steps do |t|
			t.column :order_id, :integer, :null => false
			t.column :user_id, :integer, :null => false										# step executor
			t.column :comment, :text, :default => ''
			t.column :status, :int, :default => OrderStep::STATUS_WAITING, :null => false
			t.column :is_deprived, :boolean, :default => false
			t.column :depriver_id, :integer
			t.column :viewed_at, :datetime

      t.timestamps
    end
  end

  def self.down
    drop_table :order_steps
  end
end
