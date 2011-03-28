class ApplicationController < ActionController::Base
  protect_from_forgery

  def login_required
    if session[:user]
      return true
    end
    flash[:warning]='Please login to continue'
    session[:return_to]=request.request_uri
    logger.debug "Expect redirect to #{request.request_uri.inspect}"
    redirect_to login_url
    return false
  end

  def get_current_user
    if logged_in?
      User.find_by_login(session[:user])
    else
      return nil
    end
  end

  def logged_in?
    return session[:user] ? true : false
  end
  helper_method :logged_in?

  def redirect_to_stored
    logger.debug "Redirecting to #{session[:return_to].inspect}"
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to return_to
    else
      redirect_to dashboard_url, :notice => 'Welcome back.'
    end
  end

end
