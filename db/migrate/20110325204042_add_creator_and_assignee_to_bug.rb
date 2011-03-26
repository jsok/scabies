class AddCreatorAndAssigneeToBug < ActiveRecord::Migration
  def self.up
    add_column :bugs, :creator_id, :integer
    add_column :bugs, :assignee_id, :integer
  end

  def self.down
    remove_column :bugs, :creator_id
    remove_column :bugs, :assignee_id
  end
end
