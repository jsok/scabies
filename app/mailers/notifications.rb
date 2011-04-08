class Notifications < ActionMailer::Base
  default :from => "scabies@soko.id.au"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.deliver_forgot_password.subject
  #
  def deliver_forgot_password(to, login, new_password)
    @login = login
    @new_password = new_password

    mail :to => to, :subject => "Scabies Bug Tracker - Password Reset"
  end
end
