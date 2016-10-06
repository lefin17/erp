class CreateContactorproducttypes < ActiveRecord::Migration
  def self.up
    create_table 'contactorproducttypes' do |t|
      t.integer     'contractor_id'
      t.integer     'product_type_id'
      t.timestamps
    end
    add_column 'contractors', 'contactorproducttype_id', :integer
  end

  def self.down
    drop_table 'contactorproducttypes'
    remove_column('contractors','contactorproducttype_id')
  end
end
