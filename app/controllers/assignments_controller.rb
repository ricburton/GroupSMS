class AssignmentsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user, :only => [:index]
  def index
    @assignments = Assignment.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to(assignments_url) }
    end
  end

end