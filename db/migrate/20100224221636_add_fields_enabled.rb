class AddFieldsEnabled < ActiveRecord::Migration
  def self.up
  add_column :materials, :enabled, :boolean, :default => true
  end

  def self.down
  remove_column(:materials, :enabled)
  end
end
