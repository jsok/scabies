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

    event :reassign do
      assignee = nil
      transition :assigned => :new
      transition :opened => :new
    end

    event :open do
      transition :assigned => :opened
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
      transition :closed => :new
    end

    state :assigned do
      validates_presence_of :assignee
    end

  end

  def valid_events(user)
    valid = []

    # Ensure the project admin can always modify bug state
    if user == self.project.admin
      return self.state_transitions.collect { |t| t.event }
    end

    # Otherwise restrict events to relevant users
    self.state_transitions.each do |transition|
      case transition.event
      when :assign, :reassign
        valid << transition.event
      when :open, :resolve
        valid << transition.event if user == self.assignee
      when :close, :reject, :reopen
        valid << transition.event if user == self.creator
      end
    end
    valid
  end

  def verify_next_event(event_name)
    self.state_transitions.each do |transition|
      if transition.event.to_s == event_name
        return transition.event
      end
    end
    nil
  end

end
