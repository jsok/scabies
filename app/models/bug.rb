gem 'RedCloth'

class Bug < ActiveRecord::Base
  belongs_to :project
  belongs_to :creator, :class_name => "User"
  belongs_to :assignee, :class_name => "User"
  has_and_belongs_to_many :watchers, :class_name => "User", :join_table => "users_watched_bugs"
  has_many :comments, :dependent => :destroy

  attr_protected :state_event
  state_machine :initial => :new do

    event :assign do
      transition :new => :assigned
    end
    state :assigned do
      validates_presence_of :assignee
    end

    event :reassign do
      transition :assigned => :new
      transition :opened => :new
    end
    after_transition :to => :new do |bug, transition|
      bug.assignee = nil
      bug.save
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

  def verify_next_event(event_name, user)
    events = valid_events(user)
    events.each do |event|
      if event.to_s == event_name
        return event
      end
    end
    nil
  end

  def generate_state_comment(user, from, to)
    if from.nil?
      text = "*#{user.login}* created *#{to}* bug _#{self.name}_."
    else
      text = "*#{user.login}* changed bug state from *#{from}* to *#{to}*."
    end

    comment = Comment.new(:user_id => user.id, :bug_id => self.id)
    comment.content = RedCloth.new(text).to_html
    self.comments << comment
  end

end
