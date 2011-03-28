class AddStateToBug < ActiveRecord::Migration
  def self.up
    add_column :bugs, :state, :string
  end

  def self.down
    drop_column :bugs, :state
  end
end
