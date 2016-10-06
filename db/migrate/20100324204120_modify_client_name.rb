class ModifyClientName < ActiveRecord::Migration
  def self.up
   change_column :users, :name, :string, :limit => 50
  end

  def self.down
  change_column :users, :name, :string, :limit => 32
  end
end
