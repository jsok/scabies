class AddProjectIdToBugs < ActiveRecord::Migration
  def self.up
    add_column :bugs, :project_id, :integer
  end

  def self.down
    remove_column :bugs, :project_id
  end
end
