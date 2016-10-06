class UsersAddUserOwner < ActiveRecord::Migration
  def self.up
    add_column 'users', 'owner_id', :integer
  end

  def self.down
    remove_column('users', 'owner_id')
  end
end
