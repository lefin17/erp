class CreateDumps < ActiveRecord::Migration
  def self.up
    create_table :dumps do |t|
      t.integer :user_id
      t.text :tables
      t.string :status, :default => 'new'
      t.string :filename
      t.timestamps
    end
  end

  def self.down
    drop_table :dumps
  end
end
