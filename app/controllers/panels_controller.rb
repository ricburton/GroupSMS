class PanelsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user
  def index
    @panels = Panel.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @panel = Panel.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @panel = Panel.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @panel = Panel.find(params[:id])
  end

  def create
    @panel = Panel.new(params[:panel])

    respond_to do |format|
      if @panel.save
        format.html { redirect_to(@panel, :notice => 'Panel was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @panel = Panel.find(params[:id])

    respond_to do |format|
      if @panel.update_attributes(params[:panel])
        format.html { redirect_to(panels_path, :notice => 'Panel was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @panel = Panel.find(params[:id])
    @panel.destroy

    respond_to do |format|
      format.html { redirect_to(panels_url) }
    end
  end
end
