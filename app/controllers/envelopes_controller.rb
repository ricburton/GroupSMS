class EnvelopesController < ApplicationController
  before_filter :authenticate

  def index
    @envelopes = Envelope.all

    respond_to do |format|
      format.html
    end
  end

end