class ContractTypes < ActiveRecord::Migration
  def self.up
    create_table 'contracttypes' do |t|
      t.string  'aname'
      t.boolean 'isdefault', :default => false
      t.timestamps      
    end

    create_table 'companyactions' do |t|
      t.string  'aname'
      t.boolean 'isdefault', :default => false
      t.timestamps
    end
    
    create_table 'userfroms' do |t|
      t.string  'aname'
      t.boolean 'isdefault', :default => false
      t.timestamps      
    end
  end

  def self.down
    drop_table 'contracttypes'
    drop_table 'companyactions'
    drop_table 'userfroms'
  end
end
