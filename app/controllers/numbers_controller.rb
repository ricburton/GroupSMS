class NumbersController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user, :only => [:index, :create, :show, :destroy, :edit]
  def index
    @numbers = Number.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @number = Number.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @number = Number.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @number = Number.find(params[:id])
  end

  def create
    @number = Number.new(params[:number])

    respond_to do |format|
      if @number.save
        format.html { redirect_to(@number, :notice => 'Number was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @number = Number.find(params[:id])

    respond_to do |format|
      if @number.update_attributes(params[:number])
        format.html { redirect_to(@number, :notice => 'Number was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @number = Number.find(params[:id])
    @number.destroy

    respond_to do |format|
      format.html { redirect_to(numbers_url) }
    end
  end
end
