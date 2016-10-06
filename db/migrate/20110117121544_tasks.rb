class Tasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer   'client_id',    :null => false
      t.integer   'person_id'
      t.integer   'user_id',      :null => false
      t.integer   'fromuser_id',  :null => false
      t.string    'FIO',          :limit => 250, :null => false
      t.integer   'relevance',    :default => 0, :null => false
      t.integer   'taskaction_id',:null => false
      t.string    'subject',      :limit => 500, :null => false
      t.string    'objection',    :limit => 500
      t.integer   'realized',     :default => 0
      t.string    'result',       :limit => 200
      t.datetime  'realized_at',  :null => false
      t.integer   'state',        :default => 0

      t.timestamps      
    end
  end

  def self.down
    drop_table('tasks')
  end
end
