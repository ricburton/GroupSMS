class NumbersController < ApplicationController
  # GET /numbers
  # GET /numbers.xml
  def index
    @numbers = Number.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @numbers }
    end
  end

  # GET /numbers/1
  # GET /numbers/1.xml
  def show
    @number = Number.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @number }
    end
  end

  # GET /numbers/new
  # GET /numbers/new.xml
  def new
    @number = Number.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @number }
    end
  end

  # GET /numbers/1/edit
  def edit
    @number = Number.find(params[:id])
  end

  # POST /numbers
  # POST /numbers.xml
  def create
    @number = Number.new(params[:number])

    respond_to do |format|
      if @number.save
        format.html { redirect_to(@number, :notice => 'Number was successfully created.') }
        format.xml  { render :xml => @number, :status => :created, :location => @number }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @number.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /numbers/1
  # PUT /numbers/1.xml
  def update
    @number = Number.find(params[:id])

    respond_to do |format|
      if @number.update_attributes(params[:number])
        format.html { redirect_to(@number, :notice => 'Number was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @number.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /numbers/1
  # DELETE /numbers/1.xml
  def destroy
    @number = Number.find(params[:id])
    @number.destroy

    respond_to do |format|
      format.html { redirect_to(numbers_url) }
      format.xml  { head :ok }
    end
  end
end
