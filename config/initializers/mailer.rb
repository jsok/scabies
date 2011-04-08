ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :logger               => Rails.logger,
  :address              => "smtp.nsw.exemail.com.au",
  :port                 => 25,
  :domain               => 'soko.id.au',
  #:user_name            => 'sokoidau@exemail.com.au',
  #:password             => 'sokoidau',
  :authentication       => :login,
  :enable_starttls_auto => false
}
