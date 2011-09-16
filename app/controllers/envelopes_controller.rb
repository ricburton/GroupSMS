class EnvelopesController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user, :only => [:index]
  def index
    @envelopes = Envelope.all

    respond_to do |format|
      format.html
    end
  end

end