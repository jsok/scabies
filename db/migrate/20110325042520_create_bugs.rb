class CreateBugs < ActiveRecord::Migration
  def self.up
    create_table :bugs do |t|
      t.string :name
      t.text :description
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :bugs
  end
end
