class DefinitionsController < ApplicationController
  before_filter :get_term
  # GET /definitions/new
  # GET /definitions/new.xml
  def new
    @definition = @term.definitions.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @definition }
    end
  end

  # GET /definitions/1/edit
  def edit
    @definition = @term.definitions.find(params[:id])
  end

  # POST /definitions
  # POST /definitions.xml
  def create
    @definition = @term.definitions.new(params[:definition])

    respond_to do |format|
      if @definition.save
        format.html { redirect_to(term_path(@term.name), :notice => 'Definition was successfully created.') }
        format.xml  { render :xml => @definition, :status => :created, :location => @definition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /definitions/1
  # PUT /definitions/1.xml
  def update
    @definition = @term.definitions.find(params[:id])

    respond_to do |format|
      if @definition.update_attributes(params[:definition])
        format.html { redirect_to(term_path(@term.name), :notice => 'Definition was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /definitions/1
  # DELETE /definitions/1.xml
  def destroy
    @definition = @term.definitions.find(params[:id])
    @definition.destroy

    respond_to do |format|
      format.html { redirect_to(term_path(@definition.term.name)) }
      format.xml  { head :ok }
    end
  end

  private
    def get_term
      @term = Term.find_by_name(params[:term_id])
    end
end
