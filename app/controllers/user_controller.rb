class UserController < ApplicationController
  before_filter :login_required, :only=>['edit', 'update', 'destroy', 'show']

  # GET /user
  def index
    if logged_in?
      redirect_to dashboard_url
    else
      @user = User.new
    end
  end

  # GET /user/1
  def show
    @user = get_current_user()
    @bugs = Bug.filter(params, {:assignee => @user, :watcher => @user})
  end

  # GET /user/new
  def new
    if logged_in?
      redirect_to dashboard_url
    else
      @user = User.new
    end
  end

  # GET /user/1/edit
  def edit
    @user = get_current_user
  end

  # POST /user
  def create
    @user = User.new(params[:user])
    # Are we logging in?
    if !params[:user][:password_confirmation].present?
      @user = User.authenticate(@user.login, @user.password)
      if @user.nil?
        redirect_to(login_url, :notice => 'Login was unsuccessful.')
      else
        session[:user] = @user.login
        redirect_to_stored
      end

    # We are signing up a new account
    else
      if @user.save
        session[:user] = User.authenticate(@user.login, @user.password).login

        redirect_to(dashboard_url, :id => @user.id, :notice => 'Signup was successful.')
      else
        render :action => "new"
      end
    end
  end

  # PUT /user/1
  def update
    if logged_in?
      @user = User.authenticate(get_current_user.login, params[:user][:current_password])

      if params[:user][:password].empty? and params[:user][:password_confirmation].empty?
        params[:user][:password] = params[:user][:current_password]
        params[:user][:password_confirmation] = params[:user][:current_password]
      end
      params[:user].delete :current_password
    end

    if @user
      @user.update_attributes(params[:user])
      if @user.save
        redirect_to(dashboard_url, :id => @user.id,
                    :notice => 'Details updated successfully.')
      else
        render :action => "edit"
      end
    else
      render :action => "edit"
    end
  end

  # GET /user/logout
  def logout
    session[:user] = nil
    flash[:message] = 'Logged out'
    redirect_to login_url
  end

  # DELETE /user/1
  def destroy
    #@user = User.find(params[:id])

    #respond_to do |format|
    #  format.html { redirect_to(user_index) }
    #end
  end
end
