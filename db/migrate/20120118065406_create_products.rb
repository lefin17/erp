class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :product_id
      t.integer :product_type_id
      t.integer :print_method_id
      t.integer :width
      t.integer :height
      t.string  :colors
      t.integer :material_id
      t.float   :material_density
      t.string  :model
      t.boolean :proofing
      t.integer :price
      t.integer :package_type_id
      t.timestamps
    end

    create_table :deliveries do |t|
      t.integer :order_id
      t.text    :address
      t.string  :comment
      t.timestamps
    end

    create_table :invoices do |t|
      t.integer :order_id
      t.string  :number
      t.date    :date
      t.string  :state
      t.string  :total
      t.timestamps
    end

    create_table :product_post_prints do |t|
      t.integer :product_id
      t.integer :post_print_id
      t.string  :params
      t.timestamps
    end

    create_table :post_prints do |t|
      t.string :name
      t.boolean :has_params, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :products
    drop_table :product_post_prints
    drop_table :post_prints
    drop_table :deliveries
    drop_table :invoices
  end
end
