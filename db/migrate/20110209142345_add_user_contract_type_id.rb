class AddUserContractTypeId < ActiveRecord::Migration
  def self.up
    add_column 'users', 'contracttype_id', :integer
    add_column 'users', 'companyaction_id', :integer
    add_column 'users', 'userfrom_id', :integer
  end

  def self.down
    remove_column('users', 'contracttype_id')
    remove_column('users', 'companyaction_id')
    remove_column('users', 'userfrom_id')
  end
end
