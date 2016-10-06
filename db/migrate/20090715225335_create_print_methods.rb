class CreatePrintMethods < ActiveRecord::Migration
  def self.up
    create_table :print_methods do |t|
			t.column :name, :string, :default => '', :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :print_methods
  end
end
