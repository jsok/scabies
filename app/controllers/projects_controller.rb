class ProjectsController < ApplicationController
  before_filter :login_required

  # GET /projects
  # GET /projects.xml
  def index
    @user = get_current_user
    @projects = @user.projects + Project.find_all_by_admin_id(@user)
    @projects.uniq!

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find_by_id(params[:id])
    @user = get_current_user

    respond_to do |format|
      if @project and @project.users.exists?(@user)
        @bugs = {:new => [], :open => [], :closed => []}
        @bugs[:new] = @project.bugs.find_all_by_status("new")
        @bugs[:open] = @project.bugs.find_all_by_status("open")
        @bugs[:closed] = @project.bugs.find_all_by_status("closed")

        format.html # show.html.erb
        format.xml  { render :xml => @project }
      else
        format.html { redirect_to(projects_url, :notice => 'Specified project does not exist') }
      end
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @user = get_current_user
    @project = Project.new
    @admin = @user
    @users = User.find_all_without_user(@user)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find_by_id(params[:id])
    @admin = get_current_user
    @users = User.find_all_without_user(@admin)
    if @project.nil?
      redirect_to(projects_url, :notice => 'Specified project does not exist')
    elsif @project.admin != @admin
      redirect_to(projects_url, :notice => 'You cannot edit this project')
    end
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @user = get_current_user
    @project.admin = @user
    @project.users << @user

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    if !params[:project][:user_ids]
      params[:project][:user_ids] = []
    end
    params[:project][:user_ids] << @project.admin.id

    @project.users.each do |u|
      if !params[:project][:user_ids].include?(u.id)
        u.projects.delete(@project)
      end
    end

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(project_url(@project), :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @user = get_current_user
    @project = Project.find_by_id(params[:id])

    respond_to do |format|
      if @project and @project.admin == @user
        @project.destroy
        format.html { redirect_to(projects_url) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(projects_url, :notice => 'Specified project does not exist') }
      end
    end
  end

end
