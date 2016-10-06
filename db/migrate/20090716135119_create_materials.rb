class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
			t.column :name, :string
			t.column :density, :float, :default => 0
			t.column :w, :integer
			t.column :h, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :materials
  end
end
