class ContractorAdd < ActiveRecord::Migration
  def self.up
    add_column 'contractors', 'contractorprintmethod_id', :integer
  end

  def self.down
    remove_column('contractors','contractorprintmethod_id')
  end
end
