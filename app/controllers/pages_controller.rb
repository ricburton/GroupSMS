class PagesController < ApplicationController
  def home
    @title = "Welcome"
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

end
