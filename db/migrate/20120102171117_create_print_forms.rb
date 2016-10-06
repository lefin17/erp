class CreatePrintForms < ActiveRecord::Migration
  def self.up
    create_table :print_forms do |t|
      t.string :template_name, :null => false
      t.string :name, :null => false
      t.string :can_be_accessed_by
      t.string :printable_type
    end
  end

  def self.down
    drop_table :print_forms
  end
end
