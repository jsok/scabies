class Bug < ActiveRecord::Base
  belongs_to :project
  belongs_to :creator, :class_name => "user"
  belongs_to :assignee, :class_name => "user"
end
