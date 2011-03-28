class Project < ActiveRecord::Base
  validates_presence_of :name, :permalink
  validates_uniqueness_of :permalink
  validates_format_of :permalink, :with => /^[a-z0-9\-_]+$/

  has_many :bugs, :dependent => :destroy
  belongs_to :admin, :class_name => "User"
  has_and_belongs_to_many :users

  def to_param
    return permalink unless permalink.blank?
  end

end
