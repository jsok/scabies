class BugsController < ApplicationController
  # GET projects/1/bugs
  # GET projects/1/bugs.xml
  def index
    @project = Project.find(params[:project_id])
    @bugs = Bug.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bugs }
    end
  end

  # GET projects/1/bugs/1
  # GET projects/1/bugs/1.xml
  def show
    @project = Project.find(params[:project_id])
    @bug = Bug.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bug }
    end
  end

  # GET /projects/1/bugs/new
  # GET projects/1/bugs/new.xml
  def new
    @project = Project.find(params[:project_id])
    @bug = Bug.new(:project_id => params[:project_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bug }
    end
  end

  # GET /projects/1/bugs/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @bug = Bug.find(params[:id])
  end

  # POST /projects/1/bugs
  # POST /projects/1/bugs.xml
  def create
    @project = Project.find(params[:project_id])
    @bug = Bug.new(params[:bug])
    #@bug.project = @project

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
    @project = Project.find(params[:project_id])
    @bug = Bug.find(params[:id])
    @bug.destroy

    respond_to do |format|
      format.html { redirect_to(project_url(@project)) }
      format.xml  { head :ok }
    end
  end
end
