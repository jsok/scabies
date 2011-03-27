class BugsController < ApplicationController
  before_filter :login_required

  # GET projects/1/bugs
  # GET projects/1/bugs.xml
  def index
    redirect_to project_url(params[:project_id])
  end

  # GET projects/1/bugs/1
  # GET projects/1/bugs/1.xml
  def show
    @user = get_current_user
    @project = Project.find_by_id(params[:project_id])
    @bug = @project.bugs.find_by_id(params[:id])
    @users = User.all

    respond_to do |format|
      if @project and @bug and @project.users.exists?(@user)
        format.html # show.html.erb
        format.xml  { render :xml => @bug }
      else
        format.html { redirect_to(projects_url, :notice => 'Specified bug does not exist') }
      end
    end
  end

  # GET /projects/1/bugs/new
  # GET projects/1/bugs/new.xml
  def new
    @user = get_current_user
    @project = @user.projects.find_by_id(params[:project_id])
    @bug = Bug.new(:project => @project, :creator => @user)
    @bug.status = "new"

    respond_to do |format|
      if @project and @bug
        format.html # new.html.erb
        format.xml  { render :xml => @bug }
      else
        format.html { redirect_to(projects_url, :notice => 'Specified project does not exist') }
      end
    end
  end

  # GET /projects/1/bugs/1/edit
  def edit
    @project = Project.find_by_id(params[:project_id])
    @bug = Bug.find_by_id(params[:id])
    @user = get_current_user

    respond_to do |format|
      if @project and @bug and @project.users.exists?(@user)
        @users = @project.users
        format.html # edit.html.erb
      else
        format.html { redirect_to(projects_url, :notice => 'Specified bug does not exist') }
      end
    end
  end

  # POST /projects/1/bugs
  # POST /projects/1/bugs.xml
  def create
    @project = Project.find(params[:project_id])
    @bug = Bug.new(params[:bug])
    @bug.project = @project
    @bug.creator = get_current_user

    respond_to do |format|
      if @bug.save
        format.html { redirect_to(project_bug_url(@project, @bug),
                      :notice => 'Bug was successfully created.') }
        format.xml  { render :xml => @bug, :status => :created, :location => @bug }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bug.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT projects/1/bugs/1
  # PUT projects/1/bugs/1.xml
  def update
    @project = Project.find(params[:project_id])
    @bug = Bug.find(params[:id])

    respond_to do |format|
      if @bug.update_attributes(params[:bug])
        format.html { redirect_to(project_bug_url(@project, @bug),
                      :notice => 'Bug was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bug.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE projects/1/bugs/1
  # DELETE projects/1/bugs/1.xml
  def destroy
    @project = Project.find_by_id(params[:project_id])
    @bug = Bug.find_by_id(params[:id])

    respond_to do |format|
      if @project and @bug and @project.bugs.exists?(@bug)
        @bug.destroy
        format.html { redirect_to(project_url(@project)) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(projects_url, :notice => 'Specified bug does not exist') }
      end
    end
  end
end
