class Project < ActiveRecord::Base
  has_many :bugs, :dependent => :destroy
  belongs_to :admin, :class_name => "User"
  has_and_belongs_to_many :users
end
