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
    @bugs = {:created => [], :assigned => []}
    @bugs[:created] = Bug.find_all_by_creator_id(@user)
    @bugs[:assigned] = Bug.find_all_by_assignee_id(@user)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /user/new
  def new
    if logged_in?
      redirect_to dashboard_url
    else
      @user = User.new

      respond_to do |format|
        format.html # new.html.erb
      end
    end
  end

  # GET /user/1/edit
  def edit
    #@user = User.find(params[:id])
  end

  # POST /user
  def create
    @user = User.new(params[:user])
    # Are we signing up a new user?
    if !params[:user][:password_confirmation].present?
      @user = User.authenticate(@user.email, @user.password)
      respond_to do |format|
        if @user.nil?
          format.html { redirect_to(login_url,
                                    :notice => 'Login was unsuccessful.') }
        else
          session[:user_email] = @user.email
          format.html { redirect_to_stored }
        end
      end
    else
      respond_to do |format|
        if @user.save
          session[:user_email] = User.authenticate(@user.email, @user.password).email

          format.html { redirect_to(dashboard_url, :id => @user.id,
                                    :notice => 'Signup was successful.') }
        else
          format.html { redirect_to(signup_url,
                                    :notice => 'Signup was unsuccessful.') }
        end
      end
    end
  end

  # PUT /user/1
  def update
    #@user = User.find(params[:id])

    #respond_to do |format|
    #  if @user.update_attributes(params[:user])
    #    format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
    #  else
    #    format.html { render :action => "edit" }
    #  end
    #end
  end

  # GET /user/logout
  def logout
    session[:user_email] = nil
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
