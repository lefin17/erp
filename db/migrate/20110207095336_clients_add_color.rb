class ClientsAddColor < ActiveRecord::Migration
  def self.up
    add_column 'users', 'color', :string, :default => '#FFFFFF';
    add_column 'users', 'contract', :string, :default => 'нет';
  end

  def self.down
    remove_column('users', 'color')
    remove_column('users', 'contract')
  end
end
