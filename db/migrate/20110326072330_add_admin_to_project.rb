class AddAdminToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :admin_id, :integer
  end

  def self.down
    remove_column :projects, :admin_id
  end
end
