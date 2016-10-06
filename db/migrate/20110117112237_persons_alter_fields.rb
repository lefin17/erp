class PersonsAlterFields < ActiveRecord::Migration
  def self.up
    change_column_default(:persons, :user_id, 0)
    change_column :persons, :user_id, :integer, :null => true
  end

  def self.down
    change_column_default(:persons, :user_id, 0)
    change_column :persons, :user_id, :integer, :null => true
  end
end
