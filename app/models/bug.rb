class Bug < ActiveRecord::Base
  belongs_to :project
  belongs_to :creator, :class_name => "User"
  belongs_to :assignee, :class_name => "User"
  has_and_belongs_to_many :watchers, :class_name => "User", :join_table => "users_watched_bugs"
end
