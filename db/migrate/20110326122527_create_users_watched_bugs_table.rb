class CreateUsersWatchedBugsTable < ActiveRecord::Migration
  def self.up
    create_table :users_watched_bugs, :id => false do |t|
      t.references :watcher
      t.references :watched_bug
    end
  end

  def self.down
    drop_table :users_watched_bugs
  end
end
