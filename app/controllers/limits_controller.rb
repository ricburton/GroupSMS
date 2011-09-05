class LimitsController < ApplicationController
  def index
    @limits = Limit.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @limit = Limit.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @limit = Limit.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @limit = Limit.find(params[:id])
  end

  def create
    @limit = Limit.new(params[:limit])

    respond_to do |format|
      if @limit.save
        format.html { redirect_to(@limit, :notice => 'Limit was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @limit = Limit.find(params[:id])

    respond_to do |format|
      if @limit.update_attributes(params[:limit])
        format.html { redirect_to(@limit, :notice => 'Limit was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @limit = Limit.find(params[:id])
    @limit.destroy

    respond_to do |format|
      format.html { redirect_to(limits_url) }
    end
  end
end
