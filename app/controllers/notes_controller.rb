class NotesController < ApplicationController
  before_filter :get_parent

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = @parent.notes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = @parent.notes.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = @parent.notes.find(params[:id])
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = @parent.notes.new(params[:note])

    respond_to do |format|
      if @note.save
        format.html { redirect_to(@parent, :notice => 'Note was successfully created.') }
        format.xml  { render :xml => @note, :status => :created, :location => @note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = @parent.notes.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to(@parent, :notice => 'Note was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = @parent.notes.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to(@parent) }
      format.xml  { head :ok }
    end
  end

  private
    def get_parent
      params.each do |k, v|
        if (k =~ /^(.+)_id$/)
          @parent = $1.classify.constantize.find(v)
          params[:notable_type] = $1
        end
      end
    end
end
