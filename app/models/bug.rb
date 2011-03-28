class Bug < ActiveRecord::Base
  belongs_to :project
  belongs_to :creator, :class_name => "User"
  belongs_to :assignee, :class_name => "User"
  has_and_belongs_to_many :watchers, :class_name => "User", :join_table => "users_watched_bugs"

  attr_protected :state_event
  state_machine :initial => :new do

    event :assign do
      transition :new => :assigned
    end

    event :open do
      transition :assigned => :opened
    end

    event :unassign do
      assignee = nil
      transition :opened => :new
    end

    event :resolve do
      transition :opened => :resolved
    end

    event :close do
      transition :resolved => :closed
    end

    event :reject do
      transition :resolved => :opened
    end

    event :reopen do
      transition :closed => :assigned
    end

    state :assigned do
      validates_presence_of :assignee
    end

  end

  def valid_transitions(user)
    valid = []
    self.state_transitions.each do |transition|
      logger.debug transition.human_event
      case transition.to_name
      when :closed
        valid << transition if user == self.creator
      when :opened
        valid << transition if user == self.assignee
        valid << transition if user == self.creator
      when :opened, :resolved, :new
        valid << transition if user == self.assignee
      else
        valid << transition
      end
    end
    valid
  end

end
