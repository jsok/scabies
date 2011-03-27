class CreateUsersWatchedBugsTable < ActiveRecord::Migration
  def self.up
    create_table :users_watched_bugs, :id => false do |t|
      t.references :user
      t.references :bug
    end
  end

  def self.down
    drop_table :users_watched_bugs
  end
end
