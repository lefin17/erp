class ContragentsAddNotes < ActiveRecord::Migration
  def self.up
    add_column 'contractors', 'notes', :string, :limit => 250
  end

  def self.down
    remove_column('contractors', 'notes')
  end
end
