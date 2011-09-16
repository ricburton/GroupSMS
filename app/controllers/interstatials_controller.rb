class InterstatialsController < ApplicationController
  
  def show
    @test_text = "booya"
  end
  
  def test
    @test_text = "Test succeeded!"
  end
  
end