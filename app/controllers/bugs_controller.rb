class BugsController < ApplicationController
  before_filter :login_required

  # GET projects/1/bugs
  # GET projects/1/bugs.xml
  def index
    @project = Project.find_by_permalink(params[:project_id])
    @user = get_current_user

    respond_to do |format|
      if @project and @project.users.exists?(@user)

        params[:state] = "active" unless params[:state]
        @bugs = Bug.filter(params, {:project => @project})

        format.html # show.html.erb
        format.xml  { render :xml => @project }
      else
        format.html { redirect_to(projects_url, :notice => 'Specified project does not exist') }
      end
    end
  end

  # GET projects/1/bugs/1
  # GET projects/1/bugs/1.xml
  def show
    @user = get_current_user
    @project = Project.find_by_permalink(params[:project_id])
    @bug = @project.bugs.find_by_id(params[:id])
    @users = User.all
    @comments = @bug.comments.order("created_at DESC")
    @watchers = @bug.watchers
    @watcher = @bug.watchers.find_by_id(@user.id)

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
    @project = @user.projects.find_by_permalink(params[:project_id])
    @bug = Bug.new(:project => @project, :creator => @user)

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
    @project = Project.find_by_permalink(params[:project_id])
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
    @project = Project.find_by_permalink(params[:project_id])
    @bug = Bug.new(params[:bug])
    @bug.project = @project
    @bug.creator = get_current_user

    respond_to do |format|
      if @bug.save
        @bug.generate_state_comment(@bug.creator, nil, @bug.state)
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
    @project = Project.find_by_permalink(params[:project_id])
    @bug = Bug.find(params[:id])
    @user = get_current_user

    if params[:bug][:watcher_id]
      @watcher = @project.users.find_by_id(params[:bug][:watcher_id])
      params[:bug].delete :watcher_id

      if @bug.watchers.include?(@watcher)
        @bug.watchers.delete(@watcher)
      else
        @bug.watchers << @watcher unless @watcher.nil?
      end
    end

    if params[:bug][:comment]
      @comment = Comment.new()
      @comment.user = @user
      @comment.content = RedCloth.new(params[:bug][:comment][:content]).to_html
      @bug.comments << @comment
      params[:bug].delete :comment
    end

    if params[:bug][:state]
      if @bug.state != params[:bug][:state]
        render :action => "show"
        return
      else
        params[:bug].delete :state
      end
    end

    if params[:bug][:next_event]
      next_event = @bug.verify_next_event(params[:bug][:next_event], @user)
      if next_event.nil?
        render :action => "show"
        return
      end
      params[:bug].delete :next_event
    end

    if @bug.update_attributes(params[:bug])
      if next_event
        transition = @bug.state_transitions.find { |t| t if t.event == next_event }
        @bug.fire_events(next_event)
        @bug.generate_state_comment(@user, transition.from, transition.to)
      end

      redirect_to(project_bug_url(@project, @bug),
                  :notice => 'Bug was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE projects/1/bugs/1
  # DELETE projects/1/bugs/1.xml
  def destroy
    @project = Project.find_by_permalink(params[:project_id])
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
