class CreateProductTypes < ActiveRecord::Migration
  def self.up
    create_table :product_types do |t|
			t.column :name, :string, :default => '', :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :product_types
  end
end
