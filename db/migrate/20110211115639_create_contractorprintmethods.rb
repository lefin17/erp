class CreateContractorprintmethods < ActiveRecord::Migration
  def self.up
    create_table 'contractorprintmethods' do |t|
      t.integer     'contractor_id'
      t.integer     'print_method_id'
      t.timestamps
    end
  end

  def self.down
    drop_table('contractorprintmethods')
  end
end
