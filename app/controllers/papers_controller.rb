class PapersController < ApplicationController
  before_filter :get_project

  # GET /papers/1
  def view
    @paper = Paper.find(params[:id])
    get_file(@paper)
  end

  # GET /papers/1/download
  def download
    @paper = Paper.find(params[:id])
    get_file(@paper, true)
  end

  # GET /papers
  # GET /papers.xml
  def index
    @papers = Paper.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end

  # GET /papers/1
  # GET /papers/1.xml
  def show
    @paper = Paper.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/new
  # GET /papers/new.xml
  def new
    @paper = Paper.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/1/edit
  def edit
    @paper = Paper.find(params[:id])
  end

  # POST /papers
  # POST /papers.xml
  def create
    @paper = Paper.new(params[:paper])

    respond_to do |format|
      if @paper.save
        format.html { redirect_to(@paper, :notice => 'Paper was successfully created.') }
        format.xml  { render :xml => @paper, :status => :created, :location => @paper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /papers/1
  # PUT /papers/1.xml
  def update
    @paper = Paper.find(params[:id])

    respond_to do |format|
      if @paper.update_attributes(params[:paper])
        format.html { redirect_to(@paper, :notice => 'Paper was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /papers/1
  # DELETE /papers/1.xml
  def destroy
    @paper = Paper.find(params[:id])
    @paper.destroy

    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end

  def reference
    @paper = Paper.find(params[:id])
    if (@project.nil?)
      redirect_to(projects_url, :notice => 'Project ID must be specified in order to reference a paper.')
    else
      @project.papers << @paper
      redirect_to(@project, :notice => "Removed #{@paper.original_filename}")
    end
  end

  def remove
    @paper = Paper.find(params[:id])
    if (@project.nil?)
      redirect_to(projects_url, :notice => 'Project ID must be specified in order to remove a paper.')
    else
      @project.papers.delete @paper
      redirect_to(@project, :notice => "Referenced #{@paper.original_filename}")
    end
  end

  private
    def get_file attachment, download=false
      unless attachment.nil?
        if (download)
          send_file("#{::Rails.root}/data/attachments/#{attachment.filename}", :filename => attachment.original_filename, :type => attachment.content_type)
        else
          send_file("#{::Rails.root}/data/attachments/#{attachment.filename}", :type => attachment.content_type, :disposition => 'inline')
        end
      else
        head :not_found
      end
    end

    def get_project
      @project = params[:project_id].nil? ? nil : Project.find(params[:project_id])
    end
end
